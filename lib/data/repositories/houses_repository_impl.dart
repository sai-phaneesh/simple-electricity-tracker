import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:electricity/data/database/database.dart';
import 'package:electricity/data/datasources/houses_datasource.dart';
import 'package:electricity/data/datasources/cycles_datasource.dart';
import 'package:electricity/data/datasources/electricity_readings_datasource.dart';
import 'package:electricity/domain/repositories/houses_repository.dart';

/// Concrete implementation of HousesRepository
/// Coordinates between datasources and implements business logic
class HousesRepositoryImpl implements HousesRepository {
  final HousesDataSource _housesDataSource;
  final CyclesDataSource _cyclesDataSource;
  final ElectricityReadingsDataSource _readingsDataSource;
  static const _uuid = Uuid();

  HousesRepositoryImpl(
    this._housesDataSource,
    this._cyclesDataSource,
    this._readingsDataSource,
  );

  @override
  Future<List<House>> getAllHouses() async {
    return await _housesDataSource.getAllHouses();
  }

  @override
  Future<House?> getHouseById(String id) async {
    return await _housesDataSource.getHouseById(id);
  }

  @override
  Future<String> createHouse({
    required String name,
    String? address,
    String? meterNumber,
    required double defaultPricePerUnit,
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now();

    await _housesDataSource.createHouse(
      HousesTableCompanion(
        id: Value(id),
        name: Value(name),
        address: Value(address),
        meterNumber: Value(meterNumber),
        defaultPricePerUnit: Value(defaultPricePerUnit),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
    );

    return id;
  }

  @override
  Future<void> updateHouse({
    required String id,
    String? name,
    String? address,
    String? meterNumber,
    double? defaultPricePerUnit,
  }) async {
    await _housesDataSource.updateHouse(
      HousesTableCompanion(
        id: Value(id),
        name: name != null ? Value(name) : const Value.absent(),
        address: address != null ? Value(address) : const Value.absent(),
        meterNumber: meterNumber != null
            ? Value(meterNumber)
            : const Value.absent(),
        defaultPricePerUnit: defaultPricePerUnit != null
            ? Value(defaultPricePerUnit)
            : const Value.absent(),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<void> deleteHouse(String id) async {
    // Business logic: Also delete all cycles and readings for this house
    final cycles = await _cyclesDataSource.getCyclesByHouseId(id);
    for (final cycle in cycles) {
      await _cyclesDataSource.deleteCycle(cycle.id);
    }

    final readings = await _readingsDataSource.getReadingsByHouseId(id);
    for (final reading in readings) {
      await _readingsDataSource.deleteReading(reading.id);
    }

    await _housesDataSource.deleteHouse(id);
  }

  @override
  Future<List<House>> searchHouses(String query) async {
    return await _housesDataSource.searchHouses(query);
  }

  @override
  Future<int> getHousesCount() async {
    return await _housesDataSource.getHousesCount();
  }

  @override
  Future<House?> getHouseWithActiveContacts() async {
    // Business logic: Find house with active cycles
    final allHouses = await getAllHouses();
    for (final house in allHouses) {
      final activeCycle = await _cyclesDataSource.getActiveCycleForHouse(
        house.id,
      );
      if (activeCycle != null) {
        return house;
      }
    }
    return null;
  }

  @override
  Future<List<House>> getHousesNeedingSync() async {
    return await _housesDataSource.getHousesNeedingSync();
  }

  @override
  Future<void> markHouseAsSynced(String id) async {
    await _housesDataSource.markHouseAsSynced(id);
  }

  @override
  Future<bool> hasDataNeedingSync() async {
    final houses = await getHousesNeedingSync();
    return houses.isNotEmpty;
  }

  @override
  Future<DateTime?> getLastSyncTime() async {
    return await _housesDataSource.getLastSyncTime();
  }

  @override
  Future<Map<String, dynamic>> getHouseStatistics(String houseId) async {
    // Business logic: Aggregate statistics from multiple datasources
    final house = await getHouseById(houseId);
    final cycles = await _cyclesDataSource.getCyclesByHouseId(houseId);
    final readings = await _readingsDataSource.getReadingsByHouseId(houseId);

    final activeCycles = cycles.where((c) => c.isActive).length;
    final totalReadings = readings.length;
    final totalCost = readings.fold(
      0.0,
      (sum, reading) => sum + reading.totalCost,
    );

    return {
      'house': house,
      'total_cycles': cycles.length,
      'active_cycles': activeCycles,
      'total_readings': totalReadings,
      'total_cost': totalCost,
      'average_cost_per_reading': totalReadings > 0
          ? totalCost / totalReadings
          : 0.0,
    };
  }

  @override
  Future<double> getTotalCostForHouse(String houseId) async {
    final readings = await _readingsDataSource.getReadingsByHouseId(houseId);
    double totalCost = 0.0;
    for (final reading in readings) {
      totalCost += reading.totalCost;
    }
    return totalCost;
  }

  @override
  Future<Map<String, double>> getMonthlySpendingForHouse(
    String houseId,
    int year,
  ) async {
    return await _readingsDataSource.getMonthlyConsumption(houseId, year);
  }
}
