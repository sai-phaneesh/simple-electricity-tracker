import 'package:electricity/data/database/app_database.dart';

/// Abstract interface for houses data operations
abstract class HousesDataSource {
  // Basic CRUD operations
  Future<List<House>> getAllHouses();
  Future<House?> getHouseById(String id);

  // Stream operations for reactive UI
  Stream<List<House>> watchAllHouses();
  Stream<House?> watchHouseById(String id);
  Stream<List<House>> watchHousesNeedingSync();
  Future<String> createHouse(HousesTableCompanion house);
  Future<void> updateHouse(HousesTableCompanion house);
  Future<void> deleteHouse(String id);

  // Sync-related operations
  Future<List<House>> getHousesNeedingSync();
  Future<List<House>> getDeletedHouses();
  Future<void> markHouseAsSynced(String id);
  Future<void> markHouseAsNeedingSync(String id);
  Future<void> updateSyncStatus(
    String id,
    String status, {
    DateTime? lastSyncAt,
  });

  // Search and filter operations
  Future<List<House>> searchHouses(String query);
  Future<List<House>> getHousesByStatus({bool? isDeleted, bool? needsSync});

  // Batch operations
  Future<void> batchInsertHouses(List<HousesTableCompanion> houses);
  Future<void> batchUpdateHouses(List<HousesTableCompanion> houses);
  Future<void> batchDeleteHouses(List<String> ids);

  // Utility operations
  Future<int> getHousesCount({bool includeDeleted = false});
  Future<DateTime?> getLastSyncTime();

  // Backup and Restore operations
  Future<List<Map<String, dynamic>>> exportAllHousesAsJson({
    bool includeDeleted = false,
    bool includeSyncFields = true,
  });
  Future<Map<String, dynamic>> exportHouseAsJson(
    String id, {
    bool includeSyncFields = true,
  });
  Future<void> importHousesFromJson(
    List<Map<String, dynamic>> jsonData, {
    bool replaceExisting = false,
    bool preserveIds = true,
    bool skipInvalid = true,
  });
  Future<String> importHouseFromJson(
    Map<String, dynamic> jsonData, {
    bool replaceExisting = false,
    bool preserveId = true,
  });

  // Bulk backup operations
  Future<void> clearAllHouses({bool includeSyncData = false});
  Future<void> restoreFromBackup(
    List<Map<String, dynamic>> backupData, {
    bool clearExisting = false,
    bool preserveIds = true,
  });
  Future<List<House>> getAllHousesRaw({bool includeDeleted = true});

  // Validation helpers
  Future<bool> validateHouseData(Map<String, dynamic> data);
  Future<List<String>> getDataIntegrityIssues();
  Future<Map<String, int>> getBackupStatistics();
}
