# Cycle Menu Button Implementation

## Feature Added

Added a popup menu button to the Cycle Summary Card that provides Edit and Delete options, replacing the standalone edit button.

## Implementation Details

### UI Changes

**Before:**

- Single edit icon button (pencil icon)
- Only edit functionality available

**After:**

- Three-dot menu button (vertical ellipsis)
- Popup menu with two options:
  - ✏️ **Edit** - Navigate to edit cycle screen
  - 🗑️ **Delete** - Delete cycle with confirmation

### Component Structure

#### `_CycleMenuButton` Widget (ConsumerWidget)

- **Location**: `cycle_summary_card.dart`
- **Type**: Private ConsumerWidget
- **Props**:
  - `cycleId: String` - ID of the cycle
  - `cycleName: String` - Name of the cycle (for confirmation dialog)

#### Menu Actions

1. **Edit Action**

   - Uses GoRouter navigation
   - Route: `'edit-cycle'` with `cycleId` path parameter
   - No confirmation required

2. **Delete Action**
   - Shows confirmation dialog before deletion
   - Warning message includes cycle name
   - Mentions that associated readings will also be deleted
   - Uses `cyclesControllerProvider` to delete
   - Shows success/error snackbar

### Delete Confirmation Dialog

```dart
AlertDialog(
  title: 'Delete Cycle?',
  content: 'Are you sure you want to delete "$cycleName"?
           This will also delete all associated readings.
           This action cannot be undone.',
  actions: [Cancel, Delete (red button)]
)
```

### Sync Integration

✅ **Automatic Sync Tracking**

- When a cycle is deleted via `cyclesControllerProvider.deleteCycle()`:
  1. Cycle is marked as deleted in database
  2. `markItemsAsNeedingSyncUseCase` is automatically called
  3. `pendingBackupCountsProvider` is invalidated
  4. Pending backup indicator updates immediately

No additional sync code needed in the UI!

### Visual Design

**Menu Button:**

- Icon: `Icons.more_vert` (three vertical dots)
- Color: `onSurfaceVariant`
- Padding: Zero (compact)
- Shape: Rounded corners (12px radius)

**Menu Items:**

- **Edit**:
  - Icon: `Icons.edit_outlined`
  - Color: Default `onSurface`
- **Delete**:
  - Icon: `Icons.delete_outline`
  - Color: Error color (red)
  - Text color: Error color

**Delete Button in Dialog:**

- Background: Error color
- Emphasizes destructive action

### User Flow

1. **User clicks three-dot menu** on cycle card
2. **Popup menu appears** with Edit/Delete options
3. **User selects action**:

   **If Edit:**

   - Navigates to edit cycle screen
   - Can modify cycle details
   - Returns to dashboard when done

   **If Delete:**

   - Confirmation dialog appears
   - Shows cycle name and warning
   - User can cancel or confirm
   - If confirmed:
     - Cycle is deleted from database
     - Associated readings are deleted (cascade)
     - Cycle is marked for sync
     - Success message shown
     - UI updates automatically (cycle card disappears)
   - If cancelled:
     - Dialog closes, no changes

### Error Handling

**Delete Failure:**

```dart
try {
  await ref.read(cyclesControllerProvider).deleteCycle(cycleId);
  // Success snackbar
} catch (e) {
  // Error snackbar with message
}
```

Shows user-friendly error message if deletion fails.

### Code Location

**File**: `lib/presentation/mobile/features/dashboard/presentation/components/cycle_summary_card.dart`

**Changes Made:**

1. Removed standalone `IconButton` for edit
2. Added `_CycleMenuButton` widget with popup menu
3. Added `_CycleAction` enum (edit, delete)
4. Added delete confirmation dialog
5. Integrated with `cyclesControllerProvider`

### Testing Checklist

- [x] Menu button appears on cycle card
- [x] Menu opens on click
- [x] Edit option navigates to edit screen
- [x] Delete shows confirmation dialog
- [x] Cancel in dialog closes without deleting
- [x] Confirm deletes cycle
- [x] Success message appears after deletion
- [x] Cycle card disappears from UI
- [x] Associated readings are deleted
- [x] Pending backup count increases (sync tracking)
- [x] Error handling works if deletion fails

### Consistency with Consumption Card

✅ **Similar Implementation:**

- Both use `PopupMenuButton` with `Icons.more_vert`
- Both have Edit/Delete options
- Both show confirmation for delete
- Both use error color for delete option
- Both handle errors with snackbars

✅ **Design Consistency:**

- Same menu styling
- Same icon choices
- Same confirmation pattern
- Same user experience

### Future Enhancements

Potential improvements:

- [ ] Add undo functionality for deletions
- [ ] Add bulk delete (select multiple cycles)
- [ ] Add archive instead of delete
- [ ] Add duplicate cycle option
- [ ] Add export cycle data option

## Files Modified

1. **`cycle_summary_card.dart`**
   - Added `_CycleMenuButton` widget
   - Added `_CycleAction` enum
   - Replaced edit button with menu button
   - Added delete confirmation dialog
   - Integrated sync tracking

## Compilation Status

✅ **`flutter analyze` - No issues found!**

The implementation is complete and ready to use!
