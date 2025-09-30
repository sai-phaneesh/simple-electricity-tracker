import 'package:drift/drift.dart';
import 'package:electricity/features/houses/data/datasources/houses_local_data_source.dart';
import 'package:electricity/features/houses/data/models/house_model.dart';
import 'package:electricity/features/houses/data/datasources/database/app_database.dart';

class HousesLocalDataSourceImpl implements HousesLocalDataSource {
  final AppDatabase database;

  HousesLocalDataSourceImpl(this.database);

  @override
  Future<List<HouseModel>> getHouses({
    String searchQuery = '',
    String? houseType,
    String? ownershipType,
  }) async {
    final query = database.select(database.houses);

    // Apply search filter if provided
    if (searchQuery.isNotEmpty) {
      final searchPattern = '%${searchQuery.toLowerCase()}%';
      query.where(
        (tbl) =>
            tbl.name.lower().like(searchPattern) |
            tbl.address.lower().like(searchPattern) |
            tbl.houseType.lower().like(searchPattern) |
            tbl.ownershipType.lower().like(searchPattern) |
            tbl.notes.lower().like(searchPattern),
      );
    }

    // Apply house type filter if provided
    if (houseType != null) {
      query.where((tbl) => tbl.houseType.equals(houseType));
    }

    // Apply ownership type filter if provided
    if (ownershipType != null) {
      query.where((tbl) => tbl.ownershipType.equals(ownershipType));
    }

    final houses = await query.get();

    if (searchQuery.isNotEmpty || houseType != null || ownershipType != null) {
      print(
        'DEBUG: Filtered houses - Query: "$searchQuery", Type: $houseType, Ownership: $ownershipType, Results: ${houses.length}',
      );
    } else {
      print(
        'DEBUG: Loading all houses from database, found ${houses.length} houses',
      );
    }

    for (var house in houses) {
      print('DEBUG: House found - ID: ${house.id}, Name: ${house.name}');
    }

    return houses.map(_houseFromData).toList();
  }

  @override
  Future<HouseModel?> getHouseById(String id) async {
    final house = await (database.select(
      database.houses,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
    return house != null ? _houseFromData(house) : null;
  }

  @override
  Future<void> addHouse(HouseModel house) async {
    print('DEBUG: Adding house to database: ${house.name}');
    await database.into(database.houses).insert(_houseToCompanion(house));
    print('DEBUG: House added successfully');
  }

  @override
  Future<void> updateHouse(HouseModel house) async {
    await (database.update(
      database.houses,
    )..where((tbl) => tbl.id.equals(house.id))).write(_houseToCompanion(house));
  }

  @override
  Future<void> deleteHouse(String id) async {
    await (database.delete(
      database.houses,
    )..where((tbl) => tbl.id.equals(id))).go();
  }

  @override
  Future<List<HouseModel>> searchHouses(String query) async {
    final searchQuery = '%${query.toLowerCase()}%';
    final houses =
        await (database.select(database.houses)..where(
              (tbl) =>
                  tbl.name.lower().like(searchQuery) |
                  tbl.address.lower().like(searchQuery) |
                  tbl.houseType.lower().like(searchQuery) |
                  tbl.ownershipType.lower().like(searchQuery) |
                  tbl.notes.lower().like(searchQuery),
            ))
            .get();
    return houses.map(_houseFromData).toList();
  }

  @override
  Future<List<HouseModel>> filterHouses({
    String? houseType,
    String? ownershipType,
  }) async {
    final query = database.select(database.houses);

    if (houseType != null) {
      query.where((tbl) => tbl.houseType.equals(houseType));
    }

    if (ownershipType != null) {
      query.where((tbl) => tbl.ownershipType.equals(ownershipType));
    }

    final houses = await query.get();
    return houses.map(_houseFromData).toList();
  }

  @override
  Future<List<HouseModel>> getFilteredHouses({
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

  @override
  Future<void> debugDatabaseState() async {
    try {
      final count = await database
          .customSelect('SELECT COUNT(*) as count FROM houses')
          .getSingle();
      print('DEBUG: Total houses in database: ${count.data['count']}');

      final allHouses = await database.select(database.houses).get();
      print('DEBUG: All houses in database:');
      for (var house in allHouses) {
        print('  - ${house.id}: ${house.name} (${house.address})');
      }
    } catch (e) {
      print('DEBUG: Error inspecting database: $e');
    }
  }

  HouseModel _houseFromData(HouseDbModel houseData) {
    return HouseModel(
      id: houseData.id,
      name: houseData.name,
      address: houseData.address,
      houseType: houseData.houseType,
      ownershipType: houseData.ownershipType,
      notes: houseData.notes,
      createdAt: houseData.createdAt,
      updatedAt: houseData.updatedAt,
      isActive: houseData.isActive,
      meterNumber: houseData.meterNumber,
      defaultPricePerUnit: houseData.defaultPricePerUnit,
      freeUnitsPerMonth: houseData.freeUnitsPerMonth,
      warningLimitUnits: houseData.warningLimitUnits,
      isArchived: houseData.isArchived,
    );
  }

  HousesCompanion _houseToCompanion(HouseModel house) {
    return HousesCompanion(
      id: Value(house.id),
      name: Value(house.name),
      address: Value(house.address),
      houseType: Value(house.houseType),
      ownershipType: Value(house.ownershipType),
      notes: Value(house.notes),
      createdAt: Value(house.createdAt),
      updatedAt: Value(house.updatedAt),
      isActive: Value(house.isActive),
      meterNumber: Value(house.meterNumber),
      defaultPricePerUnit: Value(house.defaultPricePerUnit),
      freeUnitsPerMonth: Value(house.freeUnitsPerMonth),
      warningLimitUnits: Value(house.warningLimitUnits),
      isArchived: Value(house.isArchived),
    );
  }
}
