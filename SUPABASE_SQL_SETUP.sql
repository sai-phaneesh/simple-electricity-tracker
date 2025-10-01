-- ============================================================================
-- SUPABASE DATABASE SETUP - Run this in Supabase SQL Editor
-- ============================================================================
-- Go to: https://supabase.com/dashboard/project/qllihzwtdnvkecswzypi/sql/new
-- Copy and paste ALL of this SQL and click "RUN"
-- ============================================================================

-- Step 1: Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Step 2: Create Tables
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

-- Step 3: Create Indexes for Performance
CREATE INDEX idx_houses_user_id ON houses(user_id);
CREATE INDEX idx_cycles_user_id ON cycles(user_id);
CREATE INDEX idx_electricity_readings_user_id ON electricity_readings(user_id);
CREATE INDEX idx_backup_metadata_user_id ON backup_metadata(user_id);
CREATE INDEX idx_backup_metadata_created_at ON backup_metadata(created_at DESC);

-- Step 4: Enable Row Level Security (RLS)
ALTER TABLE houses ENABLE ROW LEVEL SECURITY;
ALTER TABLE cycles ENABLE ROW LEVEL SECURITY;
ALTER TABLE electricity_readings ENABLE ROW LEVEL SECURITY;
ALTER TABLE backup_metadata ENABLE ROW LEVEL SECURITY;

-- Step 5: Create RLS Policies for Houses
CREATE POLICY "Users can view their own houses" ON houses
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own houses" ON houses
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own houses" ON houses
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own houses" ON houses
  FOR DELETE USING (auth.uid() = user_id);

-- Step 6: Create RLS Policies for Cycles
CREATE POLICY "Users can view their own cycles" ON cycles
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own cycles" ON cycles
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own cycles" ON cycles
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own cycles" ON cycles
  FOR DELETE USING (auth.uid() = user_id);

-- Step 7: Create RLS Policies for Electricity Readings
CREATE POLICY "Users can view their own readings" ON electricity_readings
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own readings" ON electricity_readings
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own readings" ON electricity_readings
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own readings" ON electricity_readings
  FOR DELETE USING (auth.uid() = user_id);

-- Step 8: Create RLS Policies for Backup Metadata
CREATE POLICY "Users can view their own backup metadata" ON backup_metadata
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own backup metadata" ON backup_metadata
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own backup metadata" ON backup_metadata
  FOR DELETE USING (auth.uid() = user_id);

-- ============================================================================
-- Setup Complete! 
-- ============================================================================
-- You should see "Success. No rows returned" if everything worked correctly.
-- Now you can use the backup/restore feature in the app!
-- ============================================================================
