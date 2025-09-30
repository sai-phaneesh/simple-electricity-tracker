-- ============================================================================
-- Supabase Schema Update - Add Missing Columns
-- ============================================================================
-- Run this SQL in your Supabase SQL Editor to add missing columns to match
-- the local database schema
-- ============================================================================

-- Add missing columns to houses table
ALTER TABLE public.houses 
ADD COLUMN IF NOT EXISTS meter_number TEXT,
ADD COLUMN IF NOT EXISTS default_price_per_unit DOUBLE PRECISION NOT NULL DEFAULT 0.0,
ADD COLUMN IF NOT EXISTS notes TEXT,
ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW();

-- Add missing columns to cycles table  
ALTER TABLE public.cycles
ADD COLUMN IF NOT EXISTS notes TEXT,
ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW();

-- Add missing columns to electricity_readings table
ALTER TABLE public.electricity_readings
ADD COLUMN IF NOT EXISTS notes TEXT,
ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW();

-- ============================================================================
-- Optional: Add sync tracking columns (if you want to track sync status in Supabase)
-- ============================================================================

-- Uncomment below if you want sync tracking in Supabase as well:

-- ALTER TABLE public.houses
-- ADD COLUMN IF NOT EXISTS is_deleted BOOLEAN NOT NULL DEFAULT FALSE,
-- ADD COLUMN IF NOT EXISTS needs_sync BOOLEAN NOT NULL DEFAULT TRUE,
-- ADD COLUMN IF NOT EXISTS last_sync_at TIMESTAMP WITH TIME ZONE,
-- ADD COLUMN IF NOT EXISTS sync_status TEXT NOT NULL DEFAULT 'pending';

-- ALTER TABLE public.cycles
-- ADD COLUMN IF NOT EXISTS is_deleted BOOLEAN NOT NULL DEFAULT FALSE,
-- ADD COLUMN IF NOT EXISTS needs_sync BOOLEAN NOT NULL DEFAULT TRUE,
-- ADD COLUMN IF NOT EXISTS last_sync_at TIMESTAMP WITH TIME ZONE,
-- ADD COLUMN IF NOT EXISTS sync_status TEXT NOT NULL DEFAULT 'pending';

-- ALTER TABLE public.electricity_readings
-- ADD COLUMN IF NOT EXISTS is_deleted BOOLEAN NOT NULL DEFAULT FALSE,
-- ADD COLUMN IF NOT EXISTS needs_sync BOOLEAN NOT NULL DEFAULT TRUE,
-- ADD COLUMN IF NOT EXISTS last_sync_at TIMESTAMP WITH TIME ZONE,
-- ADD COLUMN IF NOT EXISTS sync_status TEXT NOT NULL DEFAULT 'pending';

-- ============================================================================
-- Verification Queries
-- ============================================================================

-- Run these to verify columns were added:

-- SELECT column_name, data_type, is_nullable, column_default
-- FROM information_schema.columns
-- WHERE table_name = 'houses'
-- ORDER BY ordinal_position;

-- SELECT column_name, data_type, is_nullable, column_default
-- FROM information_schema.columns  
-- WHERE table_name = 'cycles'
-- ORDER BY ordinal_position;

-- SELECT column_name, data_type, is_nullable, column_default
-- FROM information_schema.columns
-- WHERE table_name = 'electricity_readings'
-- ORDER BY ordinal_position;
