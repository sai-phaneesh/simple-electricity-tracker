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

# Sync Tracking & Pending Backup Feature

## Overview

The app now tracks and displays what data changes are pending backup using database-level sync flags, not just count differences. This provides **true change tracking** for all modifications.

## What It Shows

### 1. **First Time Users** (No backup yet)

- Shows all current data as "Ready to backup"
- Example: `Ready to backup: 3 houses, 5 cycles, 42 readings`

### 2. **Existing Backups** (Track actual changes)

- Shows only items marked as `needsSync = true`
- Example: `Pending changes: 1 houses, 2 cycles, 15 readings`
- Includes: **New items + Modified items + Deleted items**

### 3. **Nothing Pending**

- Indicator doesn't show if everything is synced
- Clean UI when backup is up to date

## Database-Level Sync Tracking

### Sync Fields in All Tables

Each table (`houses`, `cycles`, `electricity_readings`) has these fields:

- `needsSync` - Boolean flag (true = needs backup)
- `lastSyncAt` - DateTime of last successful sync
- `syncStatus` - Status: 'pending', 'synced', 'error'
- `isDeleted` - Soft delete flag

### When Items Are Marked for Sync

Items get `needsSync = true` when:

- ✅ **Created** - New items automatically need sync
- ✅ **Updated** - Modified items are marked for sync
- ✅ **Deleted** - Soft deleted items need sync (to remove from cloud)

### When Items Are Marked as Synced

After successful backup:

- ✅ `needsSync = false`
- ✅ `lastSyncAt = now()`
- ✅ `syncStatus = 'synced'`

## How It Works

### Provider: `_pendingBackupProvider`

```dart
// Queries items where needsSync = true
final housesNeedingSync = await (db.select(db.housesTable)
      ..where((tbl) => tbl.needsSync.equals(true)))
    .get();

// Filters out soft-deleted items
final housesCount = housesNeedingSync.where((h) => !h.isDeleted).length;
```

### Backup Service Methods

1. **`markAllAsSynced()`** - Called after successful backup
2. **`markAsNeedingSync()`** - Called when data is modified
3. **`exportAllData()`** - Exports only items needing sync

## Visual Design

### Container Style

- Background: `tertiaryContainer` color
- Border radius: 8px
- Padding: 12px horizontal, 8px vertical

### Text Changes

- First backup: `Ready to backup: X houses, Y cycles, Z readings`
- Changes pending: `Pending changes: X houses, Y cycles, Z readings`

### Icons

- 📤 `cloud_upload_outlined` - First backup
- 🔄 `sync_outlined` - Pending changes

## Technical Implementation

### Files Modified

1. `lib/presentation/mobile/features/settings/pages/settings_screen.dart`

   - Updated `_pendingBackupProvider` to use sync flags
   - Updated `_performBackup()` to mark items as synced
   - Changed UI text to "Pending changes"

2. `lib/manager/backup_service.dart`

   - Added `markAllAsSynced()` method
   - Added `markAsNeedingSync()` method

3. Database tables already had sync fields:
   - `lib/data/database/tables/houses_table.dart`
   - `lib/data/database/tables/cycles_table.dart`
   - `lib/data/database/tables/electricity_readings_table.dart`

### Key Methods

#### Mark Items as Synced

```dart
Future<void> markAllAsSynced() async {
  await _db.transaction(() async {
    // Update all tables where needsSync = true
    await (_db.update(_db.housesTable)
          ..where((tbl) => tbl.needsSync.equals(true)))
        .write(HousesTableCompanion(
          needsSync: const Value(false),
          lastSyncAt: Value(DateTime.now()),
          syncStatus: const Value('synced'),
        ));
    // ... similar for cycles and readings
  });
}
```

#### Track Modifications

```dart
Future<void> markAsNeedingSync({
  List<String>? houseIds,
  List<String>? cycleIds,
  List<String>? readingIds,
}) async {
  // Mark specific items as needing sync when modified
}
```

## Example States

### State 1: No Backup Yet

```
┌─────────────────────────────────────────┐
│ 📤 Ready to backup:                     │
│    3 houses, 5 cycles, 42 readings      │
└─────────────────────────────────────────┘
```

### State 2: Pending Changes (True Changes)

```
┌─────────────────────────────────────────┐
│ 🔄 Pending changes:                     │
│    1 houses, 2 cycles, 5 readings       │
└─────────────────────────────────────────┘
```

### State 3: All Synced

```
(Indicator hidden - no changes to sync)
```

## Benefits Over Count-Based Approach

✅ **True Change Tracking** - Detects actual modifications, not just count differences
✅ **Handles Updates** - Modified items are properly tracked
✅ **Handles Deletes** - Soft deleted items are synced (to remove from cloud)
✅ **Database Integrity** - Sync state persists across app restarts
✅ **Accurate Counts** - No false positives from count differences
✅ **Granular Control** - Can track sync status per item
✅ **Error Recovery** - Can retry failed syncs for specific items

## Migration Notes

**Breaking Change**: This replaces the previous count-based approach with proper database-level sync tracking. All new/modified items will automatically be marked for sync, providing accurate change detection.

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
