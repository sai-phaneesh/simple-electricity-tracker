# Database Migration Fix - Schema Version 2

## Problem Identified

When attempting to backup, the error "no default_price_per_unit found" occurred.

### Root Cause

The `HousesTable` definition was updated to include new columns:

- `meterNumber` (nullable)
- `defaultPricePerUnit` (required)
- `notes` (nullable)
- `updatedAt` (required)
- Sync tracking fields: `isDeleted`, `needsSync`, `lastSyncAt`, `syncStatus`

However, the **database schema version was not incremented**, and **no migration was provided**.

This means:

- New installations create tables with all columns ✅
- **Existing databases still have the old schema** ❌
- When backup tries to read `defaultPricePerUnit` from old data, the column doesn't exist!

## Solution Implemented

### 1. **Bumped Schema Version**

```dart
// app_database.dart
@override
int get schemaVersion => 2;  // Was 1, now 2
```

### 2. **Added Migration Logic**

Created a proper migration from version 1 to version 2 that adds all missing columns:

```dart
onUpgrade: (Migrator migrator, int from, int to) async {
  if (from == 1 && to == 2) {
    final db = migrator.database as AppDatabase;

    // Houses table - add 8 new columns
    await migrator.addColumn(db.housesTable, db.housesTable.meterNumber);
    await migrator.addColumn(db.housesTable, db.housesTable.defaultPricePerUnit);
    await migrator.addColumn(db.housesTable, db.housesTable.notes);
    await migrator.addColumn(db.housesTable, db.housesTable.updatedAt);
    await migrator.addColumn(db.housesTable, db.housesTable.isDeleted);
    await migrator.addColumn(db.housesTable, db.housesTable.needsSync);
    await migrator.addColumn(db.housesTable, db.housesTable.lastSyncAt);
    await migrator.addColumn(db.housesTable, db.housesTable.syncStatus);

    // Cycles table - add 6 new columns
    await migrator.addColumn(db.cyclesTable, db.cyclesTable.notes);
    await migrator.addColumn(db.cyclesTable, db.cyclesTable.updatedAt);
    // ... sync fields

    // Readings table - add 6 new columns
    await migrator.addColumn(db.electricityReadingsTable, db.electricityReadingsTable.notes);
    await migrator.addColumn(db.electricityReadingsTable, db.electricityReadingsTable.updatedAt);
    // ... sync fields
  }
}
```

## What Happens Next

### When You Run the App:

1. **Drift detects schema version change**: 1 → 2
2. **Migration runs automatically**:
   - Adds `meterNumber` column to houses (defaults to NULL)
   - Adds `defaultPricePerUnit` column to houses (defaults to 0.0)
   - Adds `notes` column to all tables (defaults to NULL)
   - Adds `updatedAt` column to all tables (defaults to current time via column default)
   - Adds all sync tracking columns with their defaults
3. **Existing data is preserved**
4. **New columns get default values**

### After Migration:

- ✅ Backup will work - all columns exist
- ✅ Restore will work - all columns can be populated
- ✅ Existing houses/cycles/readings are preserved
- ⚠️ Old houses will have `defaultPricePerUnit = 0.0` (you'll need to update them)

## Important Notes

### Default Values After Migration

**Houses:**

- `meterNumber` → `NULL` (can be updated later)
- `defaultPricePerUnit` → `0.0` ⚠️ **You should update this!**
- `notes` → `NULL`
- `updatedAt` → Current timestamp
- `isDeleted` → `false`
- `needsSync` → `true` (will be marked for backup)
- `syncStatus` → `'pending'`

**Cycles & Readings:**

- Similar defaults for new columns

### Action Required

After the migration runs, you should:

1. **Edit each existing house** to set the correct `defaultPricePerUnit`
2. **Optionally add meter numbers** if you have them
3. **Perform a backup** to save the updated data to Supabase

## Migration Timeline

```
Before:
- Houses table: id, name, address, created_at (4 columns)
- Schema version: 1

After:
- Houses table: id, name, address, meter_number, default_price_per_unit,
                notes, created_at, updated_at, is_deleted, needs_sync,
                last_sync_at, sync_status (12 columns)
- Schema version: 2
```

## Testing Steps

1. **Run the app** - Migration executes automatically
2. **Check existing houses** - They should still be there
3. **Edit a house** - Update the price per unit
4. **Try backup** - Should work without errors
5. **Try restore** - Should work with all fields

## Files Modified

1. **`lib/data/database/app_database.dart`**

   - Changed `schemaVersion` from 1 to 2

2. **`lib/data/database/database_migrations.dart`**
   - Added import for `app_database.dart`
   - Implemented migration from version 1 to 2
   - Added all missing columns to all three tables

## Compilation Status

✅ **`flutter analyze` - No issues found!**

The migration is ready and will run automatically when you start the app.

## Troubleshooting

If you still have issues:

1. **Clear app data and reinstall** (will lose local data, but backup/restore will work)
2. **Check console for migration logs** - Should see "Database migrated from version 1 to 2"
3. **Verify migration ran**: Try to backup - if it works, migration succeeded

## Future Schema Changes

When adding new columns in the future:

1. Increment `schemaVersion` (e.g., 2 → 3)
2. Add migration logic in `onUpgrade`
3. Use `migrator.addColumn()` to add new columns
4. Document default values and required user actions
