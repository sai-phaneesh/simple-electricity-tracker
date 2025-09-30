// ignore_for_file: unnecessary_cast

import 'dart:io';

import 'package:electricity/core/config/supabase_config.dart';
import 'package:electricity/domain/entities/backup_metadata.dart';
import 'package:electricity/domain/repositories/backup_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class SupabaseBackupRepository implements BackupRepository {
  final SupabaseClient _supabase;

  SupabaseBackupRepository(this._supabase);

  @override
  User? get currentUser => _supabase.auth.currentUser;

  @override
  Future<void> signInWithEmail(String email, String password) async {
    try {
      await _supabase.auth.signInWithPassword(email: email, password: password);
    } on AuthException catch (e) {
      throw Exception('Login failed: ${e.message}');
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  @override
  Future<void> signUpWithEmail(String email, String password) async {
    try {
      await _supabase.auth.signUp(email: email, password: password);
    } on AuthException catch (e) {
      throw Exception('Sign up failed: ${e.message}');
    } catch (e) {
      throw Exception('Sign up failed: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }

  @override
  Future<BackupMetadata> backupData({
    required List<Map<String, dynamic>> houses,
    required List<Map<String, dynamic>> cycles,
    required List<Map<String, dynamic>> readings,
  }) async {
    final user = currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    try {
      // Delete existing backup data for this user
      await Future.wait([
        _supabase
            .from(SupabaseConfig.housesTable)
            .delete()
            .eq('user_id', user.id),
        _supabase
            .from(SupabaseConfig.cyclesTable)
            .delete()
            .eq('user_id', user.id),
        _supabase
            .from(SupabaseConfig.readingsTable)
            .delete()
            .eq('user_id', user.id),
      ]);

      // Add user_id to all records
      final housesWithUserId = houses
          .map((h) => {...h, 'user_id': user.id})
          .toList();
      final cyclesWithUserId = cycles
          .map((c) => {...c, 'user_id': user.id})
          .toList();
      final readingsWithUserId = readings
          .map((r) => {...r, 'user_id': user.id})
          .toList();

      // Insert new data
      if (housesWithUserId.isNotEmpty) {
        await _supabase
            .from(SupabaseConfig.housesTable)
            .insert(housesWithUserId);
      }
      if (cyclesWithUserId.isNotEmpty) {
        await _supabase
            .from(SupabaseConfig.cyclesTable)
            .insert(cyclesWithUserId);
      }
      if (readingsWithUserId.isNotEmpty) {
        await _supabase
            .from(SupabaseConfig.readingsTable)
            .insert(readingsWithUserId);
      }

      // Create backup metadata
      final metadata = BackupMetadata(
        id: const Uuid().v4(),
        userId: user.id,
        createdAt: DateTime.now(),
        housesCount: houses.length,
        cyclesCount: cycles.length,
        readingsCount: readings.length,
        deviceInfo: Platform.operatingSystem,
      );

      await _supabase
          .from(SupabaseConfig.backupMetadataTable)
          .insert(metadata.toJson());

      return metadata;
    } catch (e) {
      throw Exception('Backup failed: $e');
    }
  }

  @override
  Future<Map<String, List<Map<String, dynamic>>>> restoreData() async {
    final user = currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    try {
      final results = await Future.wait([
        _supabase
            .from(SupabaseConfig.housesTable)
            .select()
            .eq('user_id', user.id),
        _supabase
            .from(SupabaseConfig.cyclesTable)
            .select()
            .eq('user_id', user.id),
        _supabase
            .from(SupabaseConfig.readingsTable)
            .select()
            .eq('user_id', user.id),
      ]);

      // Remove user_id from records before returning
      final houses = (results[0] as List)
          .map((h) => Map<String, dynamic>.from(h)..remove('user_id'))
          .toList();
      final cycles = (results[1] as List)
          .map((c) => Map<String, dynamic>.from(c)..remove('user_id'))
          .toList();
      final readings = (results[2] as List)
          .map((r) => Map<String, dynamic>.from(r)..remove('user_id'))
          .toList();

      return {'houses': houses, 'cycles': cycles, 'readings': readings};
    } catch (e) {
      throw Exception('Restore failed: $e');
    }
  }

  @override
  Future<BackupMetadata?> getLatestBackupMetadata() async {
    final user = currentUser;
    if (user == null) {
      return null;
    }

    try {
      final response = await _supabase
          .from(SupabaseConfig.backupMetadataTable)
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false)
          .limit(1);

      if (response.isEmpty) {
        return null;
      }

      return BackupMetadata.fromJson(response.first);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> deleteBackupData() async {
    final user = currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    try {
      await Future.wait([
        _supabase
            .from(SupabaseConfig.housesTable)
            .delete()
            .eq('user_id', user.id),
        _supabase
            .from(SupabaseConfig.cyclesTable)
            .delete()
            .eq('user_id', user.id),
        _supabase
            .from(SupabaseConfig.readingsTable)
            .delete()
            .eq('user_id', user.id),
        _supabase
            .from(SupabaseConfig.backupMetadataTable)
            .delete()
            .eq('user_id', user.id),
      ]);
    } catch (e) {
      throw Exception('Delete backup failed: $e');
    }
  }
}
