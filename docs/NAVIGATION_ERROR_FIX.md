# Navigation Error Fix - Flushbar during Build Phase

## Issue Description

### Error Message

```
'package:flutter/src/widgets/navigator.dart': Failed assertion: line 5044 pos 12: '!_debugLocked': is not true.
```

### Root Cause

The error occurs when trying to show a Flushbar (toast notification) during the widget's build phase. This happens because:

1. Flushbar uses `Navigator.push()` to display the notification
2. During the build phase, the Navigator is "locked" and cannot accept new routes
3. Attempting to push a route while locked causes the assertion error

### When It Happens

- **Hot reload/save**: Error appears on hot reload when validation fails or errors occur during form submission
- **Error handling**: Particularly in catch blocks that try to show error messages immediately
- **Build-time navigation**: Any attempt to navigate or show overlays during `build()`

## Solution

### Using `addPostFrameCallback`

The fix is to defer the Flushbar display until after the current frame/build completes using `WidgetsBinding.instance.addPostFrameCallback`:

```dart
Future<void> _showMessage(
  String message, {
  FlushbarColor background = FlushbarColor.info,
}) async {
  if (!context.mounted) return;

  // Schedule the flushbar to show after the current frame completes
  // This prevents navigation errors during build phase
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!context.mounted) return;
    context.showFlushbar(message, backgroundColor: background);
  });
}
```

### Key Changes

**Before (Problematic):**

```dart
Future<void> _showMessage(
  String message, {
  FlushbarColor background = FlushbarColor.info,
}) async {
  if (!context.mounted) return;
  await context.showFlushbar(message, backgroundColor: background); // ❌ Immediate call
}
```

**After (Fixed):**

```dart
Future<void> _showMessage(
  String message, {
  FlushbarColor background = FlushbarColor.info,
}) async {
  if (!context.mounted) return;

  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!context.mounted) return;
    context.showFlushbar(message, backgroundColor: background); // ✅ Deferred call
  });
}
```

### Additional Error Handling Improvements

Also improved error handling to reset state before showing messages:

**Before:**

```dart
} on ArgumentError catch (error) {
  await _showMessage(error.message, background: FlushbarColor.warning);
} catch (error) {
  await _showMessage('Failed to save', background: FlushbarColor.error);
} finally {
  if (mounted) {
    setState(() => _isSubmitting = false);
  }
}
```

**After:**

```dart
} on ArgumentError catch (error) {
  if (mounted) {
    setState(() => _isSubmitting = false); // ✅ Reset state first
  }
  await _showMessage(error.message, background: FlushbarColor.warning);
} catch (error) {
  if (mounted) {
    setState(() => _isSubmitting = false); // ✅ Reset state first
  }
  await _showMessage('Failed to save', background: FlushbarColor.error);
} finally {
  if (mounted) {
    setState(() => _isSubmitting = false);
  }
}
```

## How `addPostFrameCallback` Works

```dart
WidgetsBinding.instance.addPostFrameCallback((_) {
  // This code runs AFTER the current frame finishes building
  // Navigator is no longer locked at this point
  context.showFlushbar(...);
});
```

**Frame Lifecycle:**

1. Build phase starts → Navigator locked
2. Widget tree is built
3. Build phase completes → Navigator unlocked
4. `addPostFrameCallback` callbacks execute ✅
5. Flushbar can safely be shown

## Files Fixed

### CreateConsumptionScreen

- File: `lib/presentation/mobile/features/consumptions/presentation/create_consumption_screen.dart`
- Changes:
  - Updated `_showMessage()` to use `addPostFrameCallback`
  - Improved error handling to reset state before showing messages

## Testing

### Test Scenarios

1. **Hot Reload with Validation Error**

   - Enter invalid meter reading
   - Save file (hot reload)
   - Expected: No red screen, validation message shows correctly

2. **Form Submission Error**

   - Trigger an error during submission
   - Expected: Error message displays without navigation errors

3. **Network/Database Errors**

   - Simulate backend failures
   - Expected: Error messages display gracefully

4. **Rapid State Changes**
   - Submit form multiple times quickly
   - Expected: No race conditions or navigation errors

### Manual Testing Checklist

- [ ] Hot reload with invalid input doesn't crash
- [ ] Error messages display correctly
- [ ] Success messages display correctly
- [ ] App remains responsive during errors
- [ ] No red screen on hot reload
- [ ] State resets properly after errors

## Best Practices

### When to Use `addPostFrameCallback`

✅ **Use it when:**

- Showing dialogs, bottom sheets, or snackbars in response to state changes
- Navigating after a build completes
- Showing error messages from async operations
- Any UI change that requires navigation during/after build

❌ **Don't need it for:**

- User-initiated actions (button presses)
- Gestures (taps, swipes)
- Direct event handlers
- Actions that don't involve navigation

### Pattern for Safe Navigation

```dart
// Safe pattern for showing messages/navigation after build
void _showMessageSafely(String message) {
  if (!mounted) return;

  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!mounted) return;
    // Show message, navigate, etc.
  });
}
```

### Pattern for Error Handling

```dart
try {
  // Async operation
} catch (error) {
  // 1. Reset state first (if needed)
  if (mounted) {
    setState(() => _isLoading = false);
  }

  // 2. Show message safely
  if (mounted) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.showFlushbar(error.toString());
    });
  }
}
```

## Other Screens to Check

The following screens also use Flushbar and should be reviewed:

1. **CreateCycleScreen**

   - File: `lib/presentation/mobile/features/cycles/presentation/screens/create_cycle_screen.dart`
   - Lines: 63, 320, 331, 356, 388, 410
   - Status: ⚠️ Needs review (some calls might be in build context)

2. **Dashboard Screens**

   - Check delete confirmations
   - Check any error handlers

3. **Any Screen with Forms**
   - Validation error displays
   - Submission error handling

## Prevention

### Code Review Checklist

When adding Flushbar/Dialog/Navigation:

- [ ] Is this called during build phase?
- [ ] Is this in a setState callback?
- [ ] Is this in a catch block after setState?
- [ ] If yes to any: Use `addPostFrameCallback`

### IDE Snippet

Create a snippet for safe message display:

```dart
// safeMessage
if (!mounted) return;
WidgetsBinding.instance.addPostFrameCallback((_) {
  if (!mounted) return;
  context.showFlushbar($MESSAGE$);
});
```

## Related Documentation

- [Flutter Navigator Documentation](https://api.flutter.dev/flutter/widgets/Navigator-class.html)
- [WidgetsBinding Documentation](https://api.flutter.dev/flutter/widgets/WidgetsBinding-class.html)
- [addPostFrameCallback](https://api.flutter.dev/flutter/scheduler/SchedulerBinding/addPostFrameCallback.html)
- [Flushbar Package](https://pub.dev/packages/another_flushbar)

## Summary

The navigation error during hot reload is caused by attempting to show a Flushbar while the Navigator is locked during the build phase. The solution is to defer the Flushbar display using `WidgetsBinding.instance.addPostFrameCallback()`, which ensures the notification is shown after the build completes and the Navigator is available.

This pattern should be applied consistently across the app wherever UI navigation (dialogs, snackbars, routes) needs to happen in response to state changes or errors during the build cycle.
