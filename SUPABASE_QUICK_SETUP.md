# Quick Setup: Supabase Configuration

## ⚠️ Important: Configure Supabase Credentials

Before you can sign up or sign in, you need to configure your Supabase credentials.

### Step 1: Get Your Supabase Credentials

1. Go to [https://supabase.com](https://supabase.com) and create a free account
2. Create a new project
3. Go to **Project Settings** → **API**
4. Copy:
   - **Project URL** (looks like `https://xxxxx.supabase.co`)
   - **anon/public key** (long string starting with `eyJ...`)

### Step 2: Update Configuration

Open `lib/core/config/supabase_config.dart` and replace:

```dart
static const String supabaseUrl = 'YOUR_SUPABASE_URL_HERE';
static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY_HERE';
```

With your actual credentials:

```dart
static const String supabaseUrl = 'https://your-project.supabase.co';
static const String supabaseAnonKey = 'eyJhbGc...your-actual-key...';
```

### Step 3: Set Up Database Tables

Run the SQL from `SUPABASE_SQL_SETUP.sql` in your Supabase SQL Editor to create the required tables.

### Step 4: Run the App

```bash
fvm flutter run
```

## Security Note

⚠️ **IMPORTANT**: The anon key is safe to use in client apps (it's public), but make sure to:

- Enable Row Level Security (RLS) in Supabase
- Set up proper authentication policies
- Never commit your actual keys to public repositories

For production apps, consider using environment variables or a secure configuration system.
