import 'package:electricity/domain/entities/electricity_reading.dart';

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
  Future<int> getReadingsCount({String? houseId, String? cycleId});

  // Analytics operations
  Future<double> getTotalConsumptionForCycle(String cycleId);
  Future<double> getTotalCostForCycle(String cycleId);
  Future<double> getAverageConsumptionForHouse(String houseId);
  Future<Map<String, dynamic>> getReadingStatistics(String cycleId);
  Future<double> getDailyAverageConsumption(String cycleId);
}
