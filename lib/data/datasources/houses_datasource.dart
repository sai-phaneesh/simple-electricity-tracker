import 'package:electricity/domain/entities/house.dart';

/// Abstract interface for houses data operations
abstract class HousesDataSource {
  // Basic CRUD operations
  Future<List<House>> getAllHouses();
  Future<House?> getHouseById(String id);

  // Stream operations for reactive UI
  Stream<List<House>> watchAllHouses();
  Stream<House?> watchHouseById(String id);

  Future<void> createHouse(House house);
  Future<void> updateHouse(House house);
  Future<void> deleteHouse(String id);

  // Search and filter operations
  Future<List<House>> searchHouses(String query);

  // Utility operations
  Future<int> getHousesCount();
}
