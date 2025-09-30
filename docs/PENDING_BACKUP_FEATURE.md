# Pending Backup Tracking Feature

## Overview
The app now tracks and displays what data is pending backup, not just what has been backed up.

## What It Shows

### 1. **First Time Users** (No backup yet)
- Shows all current data as "Ready to backup"
- Example: `Ready to backup: 3 houses, 5 cycles, 42 readings`

### 2. **Existing Backups** (Incremental changes)
- Shows only new items added since last backup
- Example: `Pending backup: 1 houses, 2 cycles, 15 readings`

### 3. **Nothing Pending**
- Indicator doesn't show if everything is backed up
- Clean UI when backup is up to date

## How It Works

### Provider: `_pendingBackupProvider`
```dart
- Compares current local database counts with last backup metadata
- Calculates difference: currentCount - backupCount
- Returns PendingBackupCounts with houses, cycles, readings counts
```

### UI Component: `_PendingBackupIndicator`
- Displays a colored container with pending counts
- Icon changes based on state:
  - 📤 `cloud_upload_outlined` - First backup
  - 🔄 `sync_outlined` - Incremental backup
- Uses tertiary color scheme for visual distinction

## Visual Design

### Container Style
- Background: `tertiaryContainer` color
- Border radius: 8px
- Padding: 12px horizontal, 8px vertical

### Text Style
- Color: `onTertiaryContainer`
- Font: `bodySmall` with medium weight (500)

### Location
- Positioned below the "Last backup" metadata
- Above the "Restore Data" button

## Behavior

### Auto-Updates
- Invalidates after successful backup
- Recalculates when backup metadata changes
- Uses FutureProvider for efficient caching

### Error Handling
- Gracefully hides on error
- Shows loading state briefly

## Example States

### State 1: No Backup Yet
```
┌─────────────────────────────────────────┐
│ 📤 Ready to backup:                     │
│    3 houses, 5 cycles, 42 readings      │
└─────────────────────────────────────────┘
```

### State 2: Pending Changes
```
┌─────────────────────────────────────────┐
│ 🔄 Pending backup:                      │
│    1 houses, 2 cycles, 15 readings      │
└─────────────────────────────────────────┘
```

### State 3: All Backed Up
```
(Indicator hidden - nothing to show)
```

## Technical Implementation

### Files Modified
- `lib/presentation/mobile/features/settings/pages/settings_screen.dart`

### New Components
1. `_pendingBackupProvider` - FutureProvider for calculations
2. `PendingBackupCounts` - Data class for pending counts
3. `_PendingBackupIndicator` - Widget for UI display

### Dependencies
- Uses Drift queries: `db.select(db.tableName).get()`
- Integrates with existing backup metadata system
- Works with Riverpod state management

## Benefits

✅ **User Awareness** - Users know exactly what needs backup
✅ **Motivation** - Visual reminder to backup new data
✅ **Transparency** - Clear distinction between backed up vs pending
✅ **Smart UI** - Only shows when there's something to communicate
✅ **Performance** - Efficient caching with FutureProvider
