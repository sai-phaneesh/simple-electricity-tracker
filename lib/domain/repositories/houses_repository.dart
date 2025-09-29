import 'package:electricity/data/database/database.dart';

/// Abstract repository interface for house operations
/// Repositories coordinate between multiple datasources and implement business logic
abstract class HousesRepository {
  // Basic CRUD operations
  Future<List<House>> getAllHouses();
  Future<House?> getHouseById(String id);
  Future<String> createHouse({
    required String name,
    String? address,
    String? meterNumber,
    required double defaultPricePerUnit,
  });
  Future<void> updateHouse({
    required String id,
    String? name,
    String? address,
    String? meterNumber,
    double? defaultPricePerUnit,
  });
  Future<void> deleteHouse(String id);

  // Business logic operations
  Future<List<House>> searchHouses(String query);
  Future<int> getHousesCount();
  Future<House?> getHouseWithActiveContacts();

  // Sync operations
  Future<List<House>> getHousesNeedingSync();
  Future<void> markHouseAsSynced(String id);
  Future<bool> hasDataNeedingSync();
  Future<DateTime?> getLastSyncTime();

  // Analytics operations
  Future<Map<String, dynamic>> getHouseStatistics(String houseId);
  Future<double> getTotalCostForHouse(String houseId);
  Future<Map<String, double>> getMonthlySpendingForHouse(
    String houseId,
    int year,
  );
}
