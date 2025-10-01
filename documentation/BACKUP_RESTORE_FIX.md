# Backup/Restore Fix - Missing Fields Error

## Problem Identified

When attempting to restore data from Supabase, the app was throwing an error with the `HousesTableCompanion` (and likely Cycles and Readings as well).

### Root Cause

**Mismatch between Supabase backup data and local database schema:**

#### Supabase Data Structure (from backup):

```json
{
  "id": "...",
  "user_id": "...", // Supabase-specific, not in local schema
  "name": "350/1",
  "address": "Champaka Nilaya",
  "created_at": "2025-10-01T02:59:53+00:00"
  // Missing: meter_number, default_price_per_unit, notes, updated_at
}
```

#### Local Schema Requirements (HousesTable):

- `id` - ✅ Present
- `name` - ✅ Present
- `address` - ✅ Present (nullable)
- `meterNumber` - ❌ Missing (nullable)
- `defaultPricePerUnit` - ❌ **Missing (REQUIRED!)** ← Main error
- `notes` - ❌ Missing (nullable)
- `createdAt` - ✅ Present
- `updatedAt` - ❌ **Missing (REQUIRED!)**
- Sync fields: `isDeleted`, `needsSync`, `lastSyncAt`, `syncStatus` - ❌ All missing

The error occurred because the restore was trying to create a `HousesTableCompanion` without providing required fields like `defaultPricePerUnit` and `updatedAt`.

## Solution Implemented

### 1. **Updated Export (Backup)**

Now exports ALL fields from local database to Supabase:

```dart
// Houses export - NOW INCLUDES ALL FIELDS
'houses': houses.map((h) => {
  'id': h.id,
  'name': h.name,
  'address': h.address,
  'meter_number': h.meterNumber,              // ✅ Added
  'default_price_per_unit': h.defaultPricePerUnit,  // ✅ Added
  'notes': h.notes,                           // ✅ Added
  'created_at': h.createdAt.toIso8601String(),
  'updated_at': h.updatedAt.toIso8601String(), // ✅ Added
}).toList(),
```

Same updates applied to Cycles and Readings exports.

### 2. **Updated Import (Restore)**

Now handles ALL fields with proper null checks and defaults:

```dart
// Houses import - HANDLES ALL FIELDS
HousesTableCompanion(
  id: Value(house['id'] as String),
  name: Value(house['name'] as String),
  address: house['address'] != null
      ? Value(house['address'] as String?)
      : const Value(null),
  meterNumber: house['meter_number'] != null
      ? Value(house['meter_number'] as String?)
      : const Value(null),
  defaultPricePerUnit: Value(
    house['default_price_per_unit'] != null
        ? (house['default_price_per_unit'] is int
            ? (house['default_price_per_unit'] as int).toDouble()
            : house['default_price_per_unit'] as double)
        : 0.0,  // ✅ Default value for missing field
  ),
  notes: house['notes'] != null
      ? Value(house['notes'] as String?)
      : const Value(null),
  createdAt: Value(DateTime.parse(house['created_at'] as String)),
  updatedAt: Value(
    house['updated_at'] != null
        ? DateTime.parse(house['updated_at'] as String)
        : DateTime.now(),  // ✅ Default to now if missing
  ),
  // Sync fields - mark restored data as already synced
  isDeleted: const Value(false),
  needsSync: const Value(false),
  lastSyncAt: Value(DateTime.now()),
  syncStatus: const Value('synced'),
)
```

### 3. **Type Conversion Handling**

Supabase may return integers where the app expects doubles (e.g., `price_per_unit: 8` instead of `8.0`). The fix handles this:

```dart
pricePerUnit: Value(
  cycle['price_per_unit'] is int
      ? (cycle['price_per_unit'] as int).toDouble()
      : cycle['price_per_unit'] as double,
),
```

### 4. **Sync Status Management**

Restored data is automatically marked as synced to prevent re-uploading:

```dart
isDeleted: const Value(false),
needsSync: const Value(false),
lastSyncAt: Value(DateTime.now()),
syncStatus: const Value('synced'),
```

## What Changed

### Before (Broken):

```dart
// Only handled basic fields
HousesTableCompanion(
  id: Value(house['id'] as String),
  name: Value(house['name'] as String),
  address: Value(house['address'] as String),
  createdAt: Value(DateTime.parse(house['created_at'] as String)),
  // ❌ Missing required fields!
)
```

### After (Fixed):

```dart
// Handles ALL fields with proper defaults
HousesTableCompanion(
  id: Value(house['id'] as String),
  name: Value(house['name'] as String),
  address: house['address'] != null ? Value(...) : const Value(null),
  meterNumber: house['meter_number'] != null ? Value(...) : const Value(null),
  defaultPricePerUnit: Value(house['default_price_per_unit'] ?? 0.0),  // ✅ Default
  notes: house['notes'] != null ? Value(...) : const Value(null),
  createdAt: Value(DateTime.parse(house['created_at'] as String)),
  updatedAt: Value(house['updated_at'] ?? DateTime.now()),  // ✅ Default
  // ✅ Sync fields added
  isDeleted: const Value(false),
  needsSync: const Value(false),
  lastSyncAt: Value(DateTime.now()),
  syncStatus: const Value('synced'),
)
```

## Files Modified

1. **`lib/manager/backup_service.dart`**
   - Updated `exportAllData()` to include all fields
   - Updated `importAllData()` to handle all fields with proper defaults
   - Added type conversion for int→double
   - Added sync status fields during restore

## Testing Recommendations

### 1. **Test New Backup**

- Create houses/cycles/readings with ALL fields populated
- Perform backup
- Verify Supabase has all fields including `default_price_per_unit`, `meter_number`, `notes`, `updated_at`

### 2. **Test Restore with Old Backup Data**

- Use existing Supabase backup (missing fields)
- Perform restore
- Should succeed with defaults:
  - `defaultPricePerUnit` → 0.0
  - `updatedAt` → current time
  - `meterNumber` → null
  - `notes` → null

### 3. **Test Restore with New Backup Data**

- Create new backup with all fields
- Perform restore
- All fields should restore correctly

### 4. **Verify Sync Status**

- After restore, check Settings
- Should show "0 items pending" (not trying to re-sync restored data)

## Breaking Changes

⚠️ **Important:** Old backups missing `default_price_per_unit` will restore with a default value of `0.0`. Users should:

1. Perform a new backup after this update
2. Old backups will still work but may have `0.0` for price per unit
3. Users can manually update the price after restore if needed

## Compilation Status

✅ **`flutter analyze` - No issues found!**

The restore functionality should now work correctly with both old and new backup data formats.
