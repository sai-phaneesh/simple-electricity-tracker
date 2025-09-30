import 'package:electricity/domain/entities/pending_backup_counts.dart';
import 'package:electricity/domain/repositories/sync_tracking_repository.dart';

/// Use case for getting pending backup counts
class GetPendingBackupCountsUseCase {
  final SyncTrackingRepository _repository;

  GetPendingBackupCountsUseCase(this._repository);

  Future<PendingBackupCounts> execute() async {
    return await _repository.getPendingBackupCounts();
  }
}

/// Use case for marking all items as synced
class MarkAllItemsAsSyncedUseCase {
  final SyncTrackingRepository _repository;

  MarkAllItemsAsSyncedUseCase(this._repository);

  Future<void> execute() async {
    await _repository.markAllItemsAsSynced();
  }
}

/// Use case for marking items as needing sync
class MarkItemsAsNeedingSyncUseCase {
  final SyncTrackingRepository _repository;

  MarkItemsAsNeedingSyncUseCase(this._repository);

  Future<void> execute({
    List<String>? houseIds,
    List<String>? cycleIds,
    List<String>? readingIds,
  }) async {
    await _repository.markItemsAsNeedingSync(
      houseIds: houseIds,
      cycleIds: cycleIds,
      readingIds: readingIds,
    );
  }
}
