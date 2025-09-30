import 'package:electricity/features/houses/data/models/house_model.dart';

abstract class HousesLocalDataSource {
  /// Get houses with optional filtering
  Future<List<HouseModel>> getHouses({
    String searchQuery = '',
    String? houseType,
    String? ownershipType,
  });

  Future<HouseModel?> getHouseById(String id);
  Future<void> addHouse(HouseModel house);
  Future<void> updateHouse(HouseModel house);
  Future<void> deleteHouse(String id);

  /// Legacy methods - kept for backward compatibility
  @Deprecated('Use getHouses with searchQuery parameter instead')
  Future<List<HouseModel>> searchHouses(String query);

  @Deprecated('Use getHouses with filter parameters instead')
  Future<List<HouseModel>> filterHouses({
    String? houseType,
    String? ownershipType,
  });

  @Deprecated('Use getHouses instead')
  Future<List<HouseModel>> getFilteredHouses({
    String searchQuery = '',
    String? houseType,
    String? ownershipType,
  });

  // Debug method
  Future<void> debugDatabaseState();
}
