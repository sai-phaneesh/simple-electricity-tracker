import 'package:electricity/data/database/app_database.dart';

/// Abstract interface for cycles data operations
abstract class CyclesDataSource {
  // Basic CRUD operations
  Future<List<Cycle>> getAllCycles();
  Future<List<Cycle>> getCyclesByHouseId(String houseId);
  Future<Cycle?> getCycleById(String id);

  // Stream operations for reactive UI
  Stream<List<Cycle>> watchAllCycles();
  Stream<List<Cycle>> watchCyclesByHouseId(String houseId);
  Stream<Cycle?> watchCycleById(String id);
  Stream<Cycle?> watchActiveCycleForHouse(String houseId);
  Stream<List<Cycle>> watchCyclesNeedingSync();
  Future<String> createCycle(CyclesTableCompanion cycle);
  Future<void> updateCycle(CyclesTableCompanion cycle);
  Future<void> deleteCycle(String id);

  // Sync-related operations
  Future<List<Cycle>> getCyclesNeedingSync();
  Future<List<Cycle>> getDeletedCycles();
  Future<void> markCycleAsSynced(String id);
  Future<void> markCycleAsNeedingSync(String id);
  Future<void> updateSyncStatus(
    String id,
    String status, {
    DateTime? lastSyncAt,
  });

  // Business logic operations
  Future<Cycle?> getActiveCycleForHouse(String houseId);
  Future<List<Cycle>> getCyclesByDateRange(
    DateTime startDate,
    DateTime endDate,
  );
  Future<List<Cycle>> getCyclesByStatus({
    bool? isActive,
    bool? isDeleted,
    bool? needsSync,
  });

  // Search and filter operations
  Future<List<Cycle>> searchCycles(String query);
  Future<List<Cycle>> getCyclesByPriceRange(double minPrice, double maxPrice);

  // Batch operations
  Future<void> batchInsertCycles(List<CyclesTableCompanion> cycles);
  Future<void> batchUpdateCycles(List<CyclesTableCompanion> cycles);
  Future<void> batchDeleteCycles(List<String> ids);

  // Utility operations
  Future<int> getCyclesCount({String? houseId, bool includeDeleted = false});
  Future<DateTime?> getLastSyncTime();
  Future<void> deactivateOtherCycles(String houseId, String activeCycleId);

  // Backup and Restore operations
  Future<List<Map<String, dynamic>>> exportAllCyclesAsJson({
    String? houseId,
    bool includeDeleted = false,
    bool includeSyncFields = true,
  });
  Future<Map<String, dynamic>> exportCycleAsJson(
    String id, {
    bool includeSyncFields = true,
  });
  Future<void> importCyclesFromJson(
    List<Map<String, dynamic>> jsonData, {
    bool replaceExisting = false,
    bool preserveIds = true,
    bool skipInvalid = true,
  });
  Future<String> importCycleFromJson(
    Map<String, dynamic> jsonData, {
    bool replaceExisting = false,
    bool preserveId = true,
  });

  // Bulk backup operations
  Future<void> clearAllCycles({String? houseId, bool includeSyncData = false});
  Future<void> restoreFromBackup(
    List<Map<String, dynamic>> backupData, {
    bool clearExisting = false,
    bool preserveIds = true,
    String? filterByHouseId,
  });
  Future<List<Cycle>> getAllCyclesRaw({bool includeDeleted = true});

  // Validation helpers
  Future<bool> validateCycleData(Map<String, dynamic> data);
  Future<List<String>> getDataIntegrityIssues();
  Future<Map<String, int>> getBackupStatistics();
}
