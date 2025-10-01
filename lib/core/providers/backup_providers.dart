import 'package:electricity/data/repositories/supabase_backup_repository.dart';
import 'package:electricity/domain/repositories/backup_repository.dart';
import 'package:electricity/domain/usecases/backup_usecases.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Provider for Supabase client
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Provider for backup repository
final backupRepositoryProvider = Provider<BackupRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return SupabaseBackupRepository(supabase);
});

/// Auth state provider
final authStateProvider = StreamProvider<AuthState>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return supabase.auth.onAuthStateChange;
});

/// Current user provider
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.maybeWhen(
    data: (state) => state.session?.user,
    orElse: () => null,
  );
});

/// Use case providers
final signInUseCaseProvider = Provider<SignInUseCase>((ref) {
  return SignInUseCase(ref.watch(backupRepositoryProvider));
});

final signUpUseCaseProvider = Provider<SignUpUseCase>((ref) {
  return SignUpUseCase(ref.watch(backupRepositoryProvider));
});

final signOutUseCaseProvider = Provider<SignOutUseCase>((ref) {
  return SignOutUseCase(ref.watch(backupRepositoryProvider));
});

final backupDataUseCaseProvider = Provider<BackupDataUseCase>((ref) {
  return BackupDataUseCase(ref.watch(backupRepositoryProvider));
});

final restoreDataUseCaseProvider = Provider<RestoreDataUseCase>((ref) {
  return RestoreDataUseCase(ref.watch(backupRepositoryProvider));
});

final getBackupMetadataUseCaseProvider = Provider<GetBackupMetadataUseCase>((
  ref,
) {
  return GetBackupMetadataUseCase(ref.watch(backupRepositoryProvider));
});

final deleteBackupDataUseCaseProvider = Provider<DeleteBackupDataUseCase>((
  ref,
) {
  return DeleteBackupDataUseCase(ref.watch(backupRepositoryProvider));
});
