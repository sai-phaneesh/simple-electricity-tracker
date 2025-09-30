import 'package:electricity/domain/entities/pending_backup_counts.dart';

/// Repository interface for sync tracking operations
abstract class SyncTrackingRepository {
  /// Get pending backup counts
  Future<PendingBackupCounts> getPendingBackupCounts();

  /// Mark all items as synced after successful backup
  Future<void> markAllItemsAsSynced();

  /// Mark specific items as needing sync
  Future<void> markItemsAsNeedingSync({
    List<String>? houseIds,
    List<String>? cycleIds,
    List<String>? readingIds,
  });
}
