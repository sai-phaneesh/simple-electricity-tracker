import 'package:electricity/domain/entities/backup_metadata.dart';
import 'package:electricity/domain/repositories/backup_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Use case for backing up data to Supabase
class BackupDataUseCase {
  final BackupRepository _repository;

  BackupDataUseCase(this._repository);

  Future<BackupMetadata> execute({
    required List<Map<String, dynamic>> houses,
    required List<Map<String, dynamic>> cycles,
    required List<Map<String, dynamic>> readings,
  }) async {
    return await _repository.backupData(
      houses: houses,
      cycles: cycles,
      readings: readings,
    );
  }
}

/// Use case for restoring data from Supabase
class RestoreDataUseCase {
  final BackupRepository _repository;

  RestoreDataUseCase(this._repository);

  Future<Map<String, List<Map<String, dynamic>>>> execute() async {
    return await _repository.restoreData();
  }
}

/// Use case for getting backup metadata
class GetBackupMetadataUseCase {
  final BackupRepository _repository;

  GetBackupMetadataUseCase(this._repository);

  Future<BackupMetadata?> execute() async {
    return await _repository.getLatestBackupMetadata();
  }
}

/// Use case for authentication
class SignInUseCase {
  final BackupRepository _repository;

  SignInUseCase(this._repository);

  Future<void> execute(String email, String password) async {
    return await _repository.signInWithEmail(email, password);
  }
}

class SignUpUseCase {
  final BackupRepository _repository;

  SignUpUseCase(this._repository);

  Future<void> execute(String email, String password) async {
    return await _repository.signUpWithEmail(email, password);
  }
}

class SignOutUseCase {
  final BackupRepository _repository;

  SignOutUseCase(this._repository);

  Future<void> execute() async {
    return await _repository.signOut();
  }
}

/// Use case for getting current user
class GetCurrentUserUseCase {
  final BackupRepository _repository;

  GetCurrentUserUseCase(this._repository);

  User? execute() {
    return _repository.currentUser;
  }
}

/// Use case for deleting backup data
class DeleteBackupDataUseCase {
  final BackupRepository _repository;

  DeleteBackupDataUseCase(this._repository);

  Future<void> execute() async {
    return await _repository.deleteBackupData();
  }
}
