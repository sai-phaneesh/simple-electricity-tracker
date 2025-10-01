# Supabase Backup & Restore Setup

This document outlines the Supabase integration for backup and restore functionality following Clean Architecture principles.

## Architecture Overview

### Layers

1. **Domain Layer** (`lib/domain/`)

   - `entities/backup_metadata.dart` - Backup metadata entity
   - `repositories/backup_repository.dart` - Repository interface
   - `usecases/backup_usecases.dart` - Use cases for all backup operations

2. **Data Layer** (`lib/data/`)

   - `repositories/supabase_backup_repository.dart` - Supabase implementation

3. **Manager Layer** (`lib/manager/`)

   - `backup_service.dart` - Local database export/import service

4. **Presentation Layer** (`lib/presentation/`)

   - `mobile/features/settings/pages/settings_screen.dart` - UI for backup/restore

5. **Core Layer** (`lib/core/`)
   - `config/supabase_config.dart` - Supabase configuration
   - `providers/backup_providers.dart` - Riverpod providers

## Supabase Setup

### 1. Create Supabase Project

1. Go to [https://supabase.com](https://supabase.com)
2. Create a new project
3. Get your project URL and anon key from Settings > API

### 2. Update Configuration

Edit `.env` file in the project root:

```
SUPABASE_URL=your_supabase_project_url_here
SUPABASE_ANON_KEY=your_supabase_anon_key_here
```

⚠️ **IMPORTANT**: Make sure `.env` file exists and has your actual Supabase credentials!

### 3. Create Database Tables (REQUIRED!)

**You MUST run this SQL in Supabase to create the tables, or you'll get "no public table found" error!**

Go to your Supabase Dashboard → SQL Editor → New Query, then run this:

Run the following SQL in your Supabase SQL editor:

```sql
-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Houses table
CREATE TABLE houses (
  id TEXT PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  address TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL
);

-- Cycles table
CREATE TABLE cycles (
  id TEXT PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  house_id TEXT NOT NULL,
  name TEXT NOT NULL,
  start_date TIMESTAMP WITH TIME ZONE NOT NULL,
  end_date TIMESTAMP WITH TIME ZONE NOT NULL,
  max_units INTEGER NOT NULL,
  price_per_unit REAL NOT NULL,
  initial_meter_reading REAL NOT NULL,
  is_active BOOLEAN NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL
);

-- Electricity readings table
CREATE TABLE electricity_readings (
  id TEXT PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  house_id TEXT NOT NULL,
  cycle_id TEXT NOT NULL,
  date TIMESTAMP WITH TIME ZONE NOT NULL,
  meter_reading REAL NOT NULL,
  units_consumed REAL NOT NULL,
  total_cost REAL NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL
);

-- Backup metadata table
CREATE TABLE backup_metadata (
  id TEXT PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  houses_count INTEGER NOT NULL,
  cycles_count INTEGER NOT NULL,
  readings_count INTEGER NOT NULL,
  device_info TEXT NOT NULL
);

-- Create indexes
CREATE INDEX idx_houses_user_id ON houses(user_id);
CREATE INDEX idx_cycles_user_id ON cycles(user_id);
CREATE INDEX idx_electricity_readings_user_id ON electricity_readings(user_id);
CREATE INDEX idx_backup_metadata_user_id ON backup_metadata(user_id);
CREATE INDEX idx_backup_metadata_created_at ON backup_metadata(created_at DESC);
```

### 4. Set Up Row Level Security (RLS)

```sql
-- Enable RLS
ALTER TABLE houses ENABLE ROW LEVEL SECURITY;
ALTER TABLE cycles ENABLE ROW LEVEL SECURITY;
ALTER TABLE electricity_readings ENABLE ROW LEVEL SECURITY;
ALTER TABLE backup_metadata ENABLE ROW LEVEL SECURITY;

-- Policies for houses
CREATE POLICY "Users can view their own houses" ON houses
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own houses" ON houses
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own houses" ON houses
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own houses" ON houses
  FOR DELETE USING (auth.uid() = user_id);

-- Policies for cycles
CREATE POLICY "Users can view their own cycles" ON cycles
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own cycles" ON cycles
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own cycles" ON cycles
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own cycles" ON cycles
  FOR DELETE USING (auth.uid() = user_id);

-- Policies for electricity_readings
CREATE POLICY "Users can view their own readings" ON electricity_readings
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own readings" ON electricity_readings
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own readings" ON electricity_readings
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own readings" ON electricity_readings
  FOR DELETE USING (auth.uid() = user_id);

-- Policies for backup_metadata
CREATE POLICY "Users can view their own backup metadata" ON backup_metadata
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own backup metadata" ON backup_metadata
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own backup metadata" ON backup_metadata
  FOR DELETE USING (auth.uid() = user_id);
```

## Features

### Authentication

- Sign up with email/password
- Sign in with email/password
- Sign out
- Email verification (automatic via Supabase)

### Backup

- Exports all houses, cycles, and electricity readings from local database
- Uploads to Supabase (replaces existing backup)
- Creates backup metadata with counts and timestamp
- Shows last backup time and data counts

### Restore

- Downloads all data from Supabase
- Replaces local database (with confirmation dialog)
- Shows success/error messages

## Usage

1. Open Settings screen
2. Click "Sign In" button
3. Enter email and password (or create account)
4. Click "Backup Now" to backup data
5. Click "Restore Data" to restore from backup

## Data Flow

### Backup Flow

```
Local DB → BackupService.exportAllData() →
Supabase → BackupRepository.backupData() →
Creates BackupMetadata → UI shows success
```

### Restore Flow

```
Supabase → BackupRepository.restoreData() →
BackupService.importAllData() → Local DB →
UI shows success
```

## Security

- All data is user-scoped via Row Level Security
- Users can only access their own data
- Data is deleted when user account is deleted (CASCADE)
- Authentication handled by Supabase Auth

## Testing

Before deploying:

1. Create test account
2. Add sample data
3. Perform backup
4. Clear local data
5. Perform restore
6. Verify all data matches

## Troubleshooting

### "User not authenticated"

- Sign out and sign in again
- Check Supabase dashboard for active session

### "Backup failed"

- Check Supabase URL and anon key
- Verify tables exist in Supabase
- Check RLS policies are correct

### "Restore failed"

- Ensure you have backed up data
- Check network connection
- Verify table schemas match

## Future Enhancements

- [ ] Automatic periodic backups
- [ ] Selective restore (choose what to restore)
- [ ] Multiple backup versions
- [ ] Backup encryption
- [ ] Backup to other cloud providers
- [ ] Conflict resolution for concurrent edits
- [ ] Offline queue for backup when network unavailable
