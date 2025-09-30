# Supabase Backup Error Fix - Missing Columns

## Problem: Backup Failing with Supabase Error

When trying to backup data to Supabase, you're getting an error about missing columns.

### Root Cause

**Schema Mismatch between Local Database and Supabase:**

#### Local Database Schema (Current):

```dart
Houses Table:
- id, name, address
- meter_number ✅ NEW
- default_price_per_unit ✅ NEW
- notes ✅ NEW
- created_at
- updated_at ✅ NEW
- (+ sync tracking fields)

Cycles Table:
- id, house_id, name, start_date, end_date
- max_units, price_per_unit, initial_meter_reading, is_active
- notes ✅ NEW
- created_at
- updated_at ✅ NEW
- (+ sync tracking fields)

Readings Table:
- id, house_id, cycle_id, date
- meter_reading, units_consumed, total_cost
- notes ✅ NEW
- created_at
- updated_at ✅ NEW
- (+ sync tracking fields)
```

#### Supabase Database Schema (Old - From your data):

```sql
houses:
- id, user_id, name, address, created_at
❌ Missing: meter_number, default_price_per_unit, notes, updated_at

cycles:
- id, user_id, house_id, name, start_date, end_date
- max_units, price_per_unit, initial_meter_reading, is_active, created_at
❌ Missing: notes, updated_at

readings:
- id, user_id, house_id, cycle_id, date
- meter_reading, units_consumed, total_cost, created_at
❌ Missing: notes, updated_at
```

### The Error

When `BackupService.exportAllData()` sends data with fields like:

```dart
'default_price_per_unit': h.defaultPricePerUnit,
'meter_number': h.meterNumber,
'notes': h.notes,
'updated_at': h.updatedAt.toIso8601String(),
```

Supabase rejects the insert because these columns don't exist in the Supabase tables.

## Solution: Update Supabase Schema

### Step 1: Run SQL in Supabase

1. **Open Supabase Dashboard**
2. **Go to SQL Editor**
3. **Run the SQL from `SUPABASE_SCHEMA_UPDATE.sql`**

The SQL will add these columns:

**Houses Table:**

```sql
ALTER TABLE public.houses
ADD COLUMN IF NOT EXISTS meter_number TEXT,
ADD COLUMN IF NOT EXISTS default_price_per_unit DOUBLE PRECISION NOT NULL DEFAULT 0.0,
ADD COLUMN IF NOT EXISTS notes TEXT,
ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW();
```

**Cycles Table:**

```sql
ALTER TABLE public.cycles
ADD COLUMN IF NOT EXISTS notes TEXT,
ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW();
```

**Readings Table:**

```sql
ALTER TABLE public.electricity_readings
ADD COLUMN IF NOT EXISTS notes TEXT,
ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW();
```

### Step 2: Verify Columns Were Added

Run this in Supabase SQL Editor:

```sql
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'houses'
ORDER BY ordinal_position;
```

You should now see the new columns listed!

### Step 3: Test Backup

1. **Go to Settings in your app**
2. **Click "Backup Now"**
3. **Should succeed!** ✅

## Alternative: Modify Backup to Only Send Existing Columns

If you don't want to update Supabase schema, you can modify the backup service to only send columns that exist in Supabase:

```dart
// In lib/manager/backup_service.dart - exportAllData()

'houses': houses.map((h) => {
  'id': h.id,
  'name': h.name,
  'address': h.address,
  'created_at': h.createdAt.toIso8601String(),
  // Don't send: meter_number, default_price_per_unit, notes, updated_at
}).toList(),
```

**⚠️ Warning:** This means you'll lose the new data when restoring!

## Recommended Approach

**✅ Update Supabase schema** (run the SQL) - This is the proper solution because:

1. All data is backed up properly
2. Restore will work with all fields
3. Future-proof for new columns
4. No data loss

## After Updating Supabase Schema

### Your Supabase Tables Will Have:

**houses:**

- id, user_id, name, address, created_at
- ✅ meter_number, default_price_per_unit, notes, updated_at

**cycles:**

- id, user_id, house_id, name, start_date, end_date
- max_units, price_per_unit, initial_meter_reading, is_active, created_at
- ✅ notes, updated_at

**electricity_readings:**

- id, user_id, house_id, cycle_id, date
- meter_reading, units_consumed, total_cost, created_at
- ✅ notes, updated_at

### Backup Flow Will Work:

1. **Export from local DB** → includes all fields ✅
2. **Send to Supabase** → all columns exist ✅
3. **Insert succeeds** → backup complete ✅

### Restore Flow Will Work:

1. **Fetch from Supabase** → gets all fields ✅
2. **Import to local DB** → all fields map correctly ✅
3. **Data restored** → with all information ✅

## Existing Data Handling

**Old houses in Supabase (before SQL update):**

- Will have `NULL` for: meter_number, notes
- Will have `0.0` for: default_price_per_unit
- Will have `NOW()` for: updated_at

**New backups (after SQL update):**

- Will include all actual values from local database ✅

## Optional: Sync Tracking in Supabase

If you want to track sync status in Supabase as well (advanced), uncomment the sync tracking section in the SQL file:

```sql
ALTER TABLE public.houses
ADD COLUMN IF NOT EXISTS is_deleted BOOLEAN NOT NULL DEFAULT FALSE,
ADD COLUMN IF NOT EXISTS needs_sync BOOLEAN NOT NULL DEFAULT TRUE,
ADD COLUMN IF NOT EXISTS last_sync_at TIMESTAMP WITH TIME ZONE,
ADD COLUMN IF NOT EXISTS sync_status TEXT NOT NULL DEFAULT 'pending';
```

This would allow:

- Soft deletes in cloud
- Track which items need re-sync
- Sync status monitoring
- Conflict resolution

## Summary

**Problem:** Supabase missing columns that local database has
**Solution:** Run SQL to add missing columns to Supabase tables
**File:** `docs/SUPABASE_SCHEMA_UPDATE.sql`
**Result:** Backup and restore will work with all fields ✅

Run the SQL now and your backup should work!
