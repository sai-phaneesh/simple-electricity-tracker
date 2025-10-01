import 'package:electricity/data/database/app_database.dart';

/// Abstract interface for electricity readings data operations
abstract class ElectricityReadingsDataSource {
  // Basic CRUD operations
  Future<List<ElectricityReading>> getAllReadings();
  Future<List<ElectricityReading>> getReadingsByHouseId(String houseId);
  Future<List<ElectricityReading>> getReadingsByCycleId(String cycleId);
  Future<ElectricityReading?> getReadingById(String id);

  // Stream operations for reactive UI
  Stream<List<ElectricityReading>> watchAllReadings();
  Stream<List<ElectricityReading>> watchReadingsByHouseId(String houseId);
  Stream<List<ElectricityReading>> watchReadingsByCycleId(String cycleId);
  Stream<ElectricityReading?> watchReadingById(String id);
  Stream<List<ElectricityReading>> watchReadingsNeedingSync();
  Future<String> createReading(ElectricityReadingsTableCompanion reading);
  Future<void> updateReading(ElectricityReadingsTableCompanion reading);
  Future<void> deleteReading(String id);

  // Sync-related operations
  Future<List<ElectricityReading>> getReadingsNeedingSync();
  Future<List<ElectricityReading>> getDeletedReadings();
  Future<void> markReadingAsSynced(String id);
  Future<void> markReadingAsNeedingSync(String id);
  Future<void> updateSyncStatus(
    String id,
    String status, {
    DateTime? lastSyncAt,
  });

  // Business logic operations
  Future<ElectricityReading?> getLatestReadingForCycle(String cycleId);
  Future<ElectricityReading?> getLatestReadingForHouse(String houseId);
  Future<List<ElectricityReading>> getReadingsByDateRange(
    DateTime startDate,
    DateTime endDate,
  );
  Future<List<ElectricityReading>> getReadingsByMeterRange(
    int minReading,
    int maxReading,
  );

  // Search and filter operations
  Future<List<ElectricityReading>> searchReadings(String query);
  Future<List<ElectricityReading>> getReadingsByStatus({
    bool? isDeleted,
    bool? needsSync,
  });
  Future<List<ElectricityReading>> getReadingsWithNotes();

  // Analytics operations
  Future<double> getTotalConsumptionForCycle(String cycleId);
  Future<double> getTotalCostForCycle(String cycleId);
  Future<double> getAverageConsumptionForHouse(String houseId);
  Future<Map<String, double>> getMonthlyConsumption(String houseId, int year);

  // Batch operations
  Future<void> batchInsertReadings(
    List<ElectricityReadingsTableCompanion> readings,
  );
  Future<void> batchUpdateReadings(
    List<ElectricityReadingsTableCompanion> readings,
  );
  Future<void> batchDeleteReadings(List<String> ids);

  // Utility operations
  Future<int> getReadingsCount({
    String? houseId,
    String? cycleId,
    bool includeDeleted = false,
  });
  Future<DateTime?> getLastSyncTime();
  Future<ElectricityReading?> getPreviousReading(
    String cycleId,
    DateTime currentDate,
  );

  // Backup and Restore operations
  Future<List<Map<String, dynamic>>> exportAllReadingsAsJson({
    String? houseId,
    String? cycleId,
    DateTime? fromDate,
    DateTime? toDate,
    bool includeDeleted = false,
    bool includeSyncFields = true,
  });
  Future<Map<String, dynamic>> exportReadingAsJson(
    String id, {
    bool includeSyncFields = true,
  });
  Future<void> importReadingsFromJson(
    List<Map<String, dynamic>> jsonData, {
    bool replaceExisting = false,
    bool preserveIds = true,
    bool skipInvalid = true,
  });
  Future<String> importReadingFromJson(
    Map<String, dynamic> jsonData, {
    bool replaceExisting = false,
    bool preserveId = true,
  });

  // Bulk backup operations
  Future<void> clearAllReadings({
    String? houseId,
    String? cycleId,
    bool includeSyncData = false,
  });
  Future<void> restoreFromBackup(
    List<Map<String, dynamic>> backupData, {
    bool clearExisting = false,
    bool preserveIds = true,
    String? filterByHouseId,
    String? filterByCycleId,
  });
  Future<List<ElectricityReading>> getAllReadingsRaw({
    bool includeDeleted = true,
  });

  // Validation helpers
  Future<bool> validateReadingData(Map<String, dynamic> data);
  Future<List<String>> getDataIntegrityIssues();
  Future<Map<String, int>> getBackupStatistics();
}
