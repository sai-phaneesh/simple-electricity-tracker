import 'package:electricity/features/houses/domain/entities/house.dart';
import 'package:electricity/features/houses/domain/repositories/houses_repository.dart';
import 'package:electricity/features/houses/data/datasources/houses_local_data_source.dart';
import 'package:electricity/features/houses/data/models/house_model.dart';

class HousesRepositoryImpl implements HousesRepository {
  final HousesLocalDataSource localDataSource;

  HousesRepositoryImpl(this.localDataSource);

  @override
  Future<List<House>> getHouses({
    String searchQuery = '',
    String? houseType,
    String? ownershipType,
  }) async {
    final houseModels = await localDataSource.getHouses(
      searchQuery: searchQuery,
      houseType: houseType,
      ownershipType: ownershipType,
    );
    return houseModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<House?> getHouseById(String id) async {
    final houseModel = await localDataSource.getHouseById(id);
    return houseModel?.toEntity();
  }

  @override
  Future<void> addHouse(House house) async {
    final houseModel = HouseModel.fromEntity(house);
    await localDataSource.addHouse(houseModel);
  }

  @override
  Future<void> updateHouse(House house) async {
    final houseModel = HouseModel.fromEntity(house);
    await localDataSource.updateHouse(houseModel);
  }

  @override
  Future<void> deleteHouse(String id) async {
    await localDataSource.deleteHouse(id);
  }

  @override
  Future<List<House>> searchHouses(String query) async {
    final houseModels = await localDataSource.searchHouses(query);
    return houseModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<House>> filterHouses({
    String? houseType,
    String? ownershipType,
  }) async {
    final houseModels = await localDataSource.filterHouses(
      houseType: houseType,
      ownershipType: ownershipType,
    );
    return houseModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<House>> getFilteredHouses({
    String searchQuery = '',
    String? houseType,
    String? ownershipType,
  }) async {
    // Delegate to the new getHouses method
    return getHouses(
      searchQuery: searchQuery,
      houseType: houseType,
      ownershipType: ownershipType,
    );
  }
}
