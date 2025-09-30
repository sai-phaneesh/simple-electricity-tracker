import 'package:electricity/features/houses/domain/entities/house.dart';

abstract class HousesRepository {
  /// Load houses from storage with optional filtering
  Future<List<House>> getHouses({
    String searchQuery = '',
    String? houseType,
    String? ownershipType,
  });

  /// Get a house by ID
  Future<House?> getHouseById(String id);

  /// Add a new house
  Future<void> addHouse(House house);

  /// Update an existing house
  Future<void> updateHouse(House house);

  /// Delete a house by ID
  Future<void> deleteHouse(String id);

  /// Search houses by query (legacy - use getHouses with searchQuery instead)
  @Deprecated('Use getHouses with searchQuery parameter instead')
  Future<List<House>> searchHouses(String query);

  /// Filter houses by type and ownership (legacy - use getHouses with filters instead)
  @Deprecated('Use getHouses with filter parameters instead')
  Future<List<House>> filterHouses({String? houseType, String? ownershipType});

  /// Get filtered houses (legacy - use getHouses instead)
  @Deprecated('Use getHouses with filter parameters instead')
  Future<List<House>> getFilteredHouses({
    String searchQuery = '',
    String? houseType,
    String? ownershipType,
  });
}
