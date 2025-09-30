import 'package:electricity/data/database/database.dart';

/// Data source for sync tracking operations
abstract class SyncTrackingDataSource {
  /// Get items that need synchronization
  Future<List<House>> getHousesNeedingSync();
  Future<List<Cycle>> getCyclesNeedingSync();
  Future<List<ElectricityReading>> getReadingsNeedingSync();

  /// Mark items as synced
  Future<void> markHousesAsSynced(List<String> houseIds);
  Future<void> markCyclesAsSynced(List<String> cycleIds);
  Future<void> markReadingsAsSynced(List<String> readingIds);

  /// Mark items as needing sync
  Future<void> markHousesAsNeedingSync(List<String> houseIds);
  Future<void> markCyclesAsNeedingSync(List<String> cycleIds);
  Future<void> markReadingsAsNeedingSync(List<String> readingIds);

  /// Check if any items have been synced before
  Future<bool> hasAnySyncedItems();

  /// Mark all items as synced
  Future<void> markAllItemsAsSynced();
}
