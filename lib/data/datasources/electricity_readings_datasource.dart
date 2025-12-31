import 'package:electricity/domain/entities/electricity_reading.dart';

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

  Future<void> createReading(ElectricityReading reading);
  Future<void> updateReading(ElectricityReading reading);
  Future<void> deleteReading(String id);

  // Business logic operations
  Future<ElectricityReading?> getLatestReadingForCycle(String cycleId);
  Future<ElectricityReading?> getLatestReadingForHouse(String houseId);

  // Utility operations
  Future<int> getReadingsCount({String? houseId, String? cycleId});
  Future<ElectricityReading?> getPreviousReading(
    String cycleId,
    DateTime currentDate,
  );
}
