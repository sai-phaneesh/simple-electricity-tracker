import 'package:electricity/domain/entities/backup_metadata.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Repository interface for backup operations
abstract class BackupRepository {
  /// Get current authenticated user
  User? get currentUser;

  /// Sign in with email
  Future<void> signInWithEmail(String email, String password);

  /// Sign up with email
  Future<void> signUpWithEmail(String email, String password);

  /// Sign out
  Future<void> signOut();

  /// Backup all data to Supabase
  Future<BackupMetadata> backupData({
    required List<Map<String, dynamic>> houses,
    required List<Map<String, dynamic>> cycles,
    required List<Map<String, dynamic>> readings,
  });

  /// Restore data from Supabase
  Future<Map<String, List<Map<String, dynamic>>>> restoreData();

  /// Get backup metadata
  Future<BackupMetadata?> getLatestBackupMetadata();

  /// Delete all backup data
  Future<void> deleteBackupData();
}
