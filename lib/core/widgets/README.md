# FlutterToastX

A Flutter toast library inspired by react-toastify, providing elegant and customizable toast notifications.

## Features

- 🎨 **4 Toast Types**: Success, Error, Warning, Info
- 🎯 **6 Positions**: Top/Bottom × Left/Center/Right
- ⏱️ **Auto Dismiss**: Configurable auto-dismiss timer
- 🔧 **Highly Customizable**: Colors, icons, positions, animations
- 📱 **Responsive**: Works on mobile and desktop
- 🎭 **Smooth Animations**: Slide and fade transitions
- 🎪 **Progress Bar**: Visual countdown indicator

## Quick Start

### 1. Add ToastContainer to your app

In your main app widget, wrap your MaterialApp with a Stack and add the ToastContainer:

```dart
import 'package:electricity/core/widgets/flutter_toast_x.dart';

// In your main app build method:
return Stack(
  children: [
    MaterialApp.router(
      // your app configuration
    ),
    const ToastContainer(), // Add this for toasts to display
  ],
);
```

### 2. Show toasts anywhere in your app

```dart
import 'package:electricity/core/widgets/flutter_toast_x.dart';

// Success toast
FlutterToastX.success('House created successfully!');

// Error toast
FlutterToastX.error('Failed to save data');

// Warning toast
FlutterToastX.warning('Please fill all required fields');

// Info toast
FlutterToastX.info('Loading data...');
```

## Advanced Usage

### Custom Configuration

```dart
FlutterToastX.success(
  'Custom toast!',
  config: const ToastConfig(
    autoClose: Duration(seconds: 6),
    position: ToastPosition.bottomLeft,
    hideProgressBar: true,
    closeOnClick: false,
  ),
);
```

### Custom Icons

```dart
FlutterToastX.success(
  'Custom icon toast!',
  icon: const Icon(Icons.celebration, color: Colors.white),
);
```

### Manual Dismiss

```dart
// Get toast ID for manual control
String toastId = FlutterToastX.info('Processing...');

// Later, dismiss specific toast
FlutterToastX.dismiss(toastId);

// Or dismiss all toasts
FlutterToastX.dismissAll();
```

## Configuration Options

### ToastConfig

```dart
ToastConfig(
  autoClose: Duration(seconds: 4),     // Auto dismiss time
  hideProgressBar: false,              // Show/hide progress bar
  closeOnClick: true,                  // Dismiss on click
  pauseOnHover: true,                  // Pause timer on hover
  draggable: true,                     // Allow drag to dismiss
  position: ToastPosition.topRight,    // Toast position
  transition: Duration(milliseconds: 300), // Animation duration
)
```

### Toast Positions

- `ToastPosition.topLeft`
- `ToastPosition.topCenter`
- `ToastPosition.topRight`
- `ToastPosition.bottomLeft`
- `ToastPosition.bottomCenter`
- `ToastPosition.bottomRight`

## Examples

### Form Validation

```dart
Future<void> _createHouse() async {
  if (!_isFormValid()) {
    FlutterToastX.warning('Please fix the form errors before submitting.');
    return;
  }

  try {
    await _submitForm();
    FlutterToastX.success('House created successfully!');
  } catch (e) {
    FlutterToastX.error('Failed to create house: ${e.toString()}');
  }
}
```

### Loading States

```dart
String loadingToastId = FlutterToastX.info('Loading data...');

try {
  await loadData();
  FlutterToastX.dismiss(loadingToastId);
  FlutterToastX.success('Data loaded successfully!');
} catch (e) {
  FlutterToastX.dismiss(loadingToastId);
  FlutterToastX.error('Failed to load data');
}
```

## Comparison with react-toastify

| Feature      | FlutterToastX         | react-toastify     |
| ------------ | --------------------- | ------------------ |
| Toast Types  | ✅ 4 types            | ✅ 4 types         |
| Positions    | ✅ 6 positions        | ✅ 6 positions     |
| Auto Dismiss | ✅ Configurable       | ✅ Configurable    |
| Progress Bar | ✅ With animation     | ✅ With animation  |
| Custom Icons | ✅ Widget based       | ✅ Component based |
| Stacking     | ✅ Multiple toasts    | ✅ Multiple toasts |
| Responsive   | ✅ Flutter responsive | ✅ CSS responsive  |

## API Reference

### Static Methods

- `FlutterToastX.success(message, {config, icon, onClose})` → `String`
- `FlutterToastX.error(message, {config, icon, onClose})` → `String`
- `FlutterToastX.warning(message, {config, icon, onClose})` → `String`
- `FlutterToastX.info(message, {config, icon, onClose})` → `String`
- `FlutterToastX.show(message, {type, config, icon, onClose})` → `String`
- `FlutterToastX.dismiss(toastId)` → `void`
- `FlutterToastX.dismissAll()` → `void`

### Widgets

- `ToastContainer({position})` - Main container widget
- `ToastWidget({toast, onRemove})` - Individual toast widget (internal)

## Integration in Electricity Tracker

This toast system is fully integrated into the Electricity Tracker app and is used for:

- ✅ Form validation feedback
- ✅ Success confirmations for CRUD operations
- ✅ Error handling and user-friendly error messages
- ✅ Loading state notifications
- ✅ General user feedback throughout the app

The toasts replace traditional SnackBars and provide a more modern, react-toastify-like experience for Flutter apps.
