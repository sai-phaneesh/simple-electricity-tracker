import 'package:electricity/data/datasources/sync_tracking_datasource.dart';
import 'package:electricity/domain/entities/pending_backup_counts.dart';
import 'package:electricity/domain/repositories/sync_tracking_repository.dart';

/// Implementation of sync tracking repository
class SyncTrackingRepositoryImpl implements SyncTrackingRepository {
  final SyncTrackingDataSource _dataSource;

  SyncTrackingRepositoryImpl(this._dataSource);

  @override
  Future<PendingBackupCounts> getPendingBackupCounts() async {
    final houses = await _dataSource.getHousesNeedingSync();
    final cycles = await _dataSource.getCyclesNeedingSync();
    final readings = await _dataSource.getReadingsNeedingSync();
    final hasAnySynced = await _dataSource.hasAnySyncedItems();

    return PendingBackupCounts(
      houses: houses.length,
      cycles: cycles.length,
      readings: readings.length,
      isFirstBackup: !hasAnySynced,
    );
  }

  @override
  Future<void> markAllItemsAsSynced() async {
    await _dataSource.markAllItemsAsSynced();
  }

  @override
  Future<void> markItemsAsNeedingSync({
    List<String>? houseIds,
    List<String>? cycleIds,
    List<String>? readingIds,
  }) async {
    if (houseIds != null && houseIds.isNotEmpty) {
      await _dataSource.markHousesAsNeedingSync(houseIds);
    }
    if (cycleIds != null && cycleIds.isNotEmpty) {
      await _dataSource.markCyclesAsNeedingSync(cycleIds);
    }
    if (readingIds != null && readingIds.isNotEmpty) {
      await _dataSource.markReadingsAsNeedingSync(readingIds);
    }
  }
}
