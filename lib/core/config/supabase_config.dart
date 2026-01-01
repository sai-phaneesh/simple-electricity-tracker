/// Supabase configuration
///
/// To use this app with Supabase:
/// 1. Create a project at https://supabase.com
/// 2. Get your project URL and anon key from project settings
/// 3. Replace the values below with your actual credentials
///
/// IMPORTANT: In production, use environment variables or a secure config file
class SupabaseConfig {
  static const String supabaseUrl = 'https://qllihzwtdnvkecswzypi.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFsbGloend0ZG52a2Vjc3d6eXBpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTkyNTU0OTMsImV4cCI6MjA3NDgzMTQ5M30.P3mRtY31kn4DqH3_99KgY7XSQqUsn12QfiWniROoWPM'; // Your anon/public key

  // Table names for backup
  static const String housesTable = 'houses';
  static const String cyclesTable = 'cycles';
  static const String readingsTable = 'electricity_readings';
  static const String backupMetadataTable = 'backup_metadata';
}
