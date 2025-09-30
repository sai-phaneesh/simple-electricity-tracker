import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Supabase configuration
///
/// To use this app with Supabase:
/// 1. Create a project at https://supabase.com
/// 2. Get your project URL and anon key from project settings
/// 3. Replace the values below
class SupabaseConfig {
  static final String supabaseUrl = dotenv.env['SUPABASE_URL']!;
  static final String supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY']!;

  // Table names for backup
  static const String housesTable = 'houses';
  static const String cyclesTable = 'cycles';
  static const String readingsTable = 'electricity_readings';
  static const String backupMetadataTable = 'backup_metadata';
}
