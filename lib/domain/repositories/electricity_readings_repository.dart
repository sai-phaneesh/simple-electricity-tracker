import 'package:electricity/data/database/database.dart';

/// Abstract repository interface for electricity readings operations
/// Repositories coordinate between multiple datasources and implement business logic
abstract class ElectricityReadingsRepository {
  // Basic CRUD operations
  Future<List<ElectricityReading>> getAllReadings();
  Future<List<ElectricityReading>> getReadingsByHouseId(String houseId);
  Future<List<ElectricityReading>> getReadingsByCycleId(String cycleId);
  Future<ElectricityReading?> getReadingById(String id);
  Future<String> createReading({
    required String houseId,
    required String cycleId,
    required DateTime date,
    required double meterReading,
    required double unitsConsumed,
    required double totalCost,
    String? notes,
  });
  Future<void> updateReading({
    required String id,
    DateTime? date,
    double? meterReading,
    double? unitsConsumed,
    double? totalCost,
    String? notes,
  });
  Future<void> deleteReading(String id);

  // Business logic operations
  Future<ElectricityReading?> getLatestReadingForCycle(String cycleId);
  Future<ElectricityReading?> getLatestReadingForHouse(String houseId);
  Future<List<ElectricityReading>> getReadingsByDateRange(
    DateTime startDate,
    DateTime endDate,
  );
  Future<List<ElectricityReading>> searchReadings(String query);
  Future<int> getReadingsCount({String? houseId, String? cycleId});

  // Sync operations
  Future<List<ElectricityReading>> getReadingsNeedingSync();
  Future<void> markReadingAsSynced(String id);
  Future<bool> hasDataNeedingSync();
  Future<DateTime?> getLastSyncTime();

  // Analytics operations
  Future<double> getTotalConsumptionForCycle(String cycleId);
  Future<double> getTotalCostForCycle(String cycleId);
  Future<double> getAverageConsumptionForHouse(String houseId);
  Future<Map<String, double>> getMonthlyConsumption(String houseId, int year);
  Future<Map<String, dynamic>> getReadingStatistics(String cycleId);
  Future<double> getDailyAverageConsumption(String cycleId);
  Future<List<Map<String, dynamic>>> getConsumptionTrend(
    String houseId,
    int days,
  );
}
