import 'package:uuid/uuid.dart';
import 'package:electricity/data/datasources/datasource_locator.dart';
import 'package:electricity/domain/entities/electricity_reading.dart';
import 'package:electricity/domain/repositories/electricity_readings_repository.dart';

/// Concrete implementation of ElectricityReadingsRepository
/// Coordinates between datasources and implements business logic
class ElectricityReadingsRepositoryImpl
    implements ElectricityReadingsRepository {
  final DataSourceLocator _dataSources;
  static const _uuid = Uuid();

  ElectricityReadingsRepositoryImpl(this._dataSources);

  @override
  Future<List<ElectricityReading>> getAllReadings() async {
    return await _dataSources.electricityReadings.getAllReadings();
  }

  @override
  Future<List<ElectricityReading>> getReadingsByHouseId(String houseId) async {
    return await _dataSources.electricityReadings.getReadingsByHouseId(houseId);
  }

  @override
  Future<List<ElectricityReading>> getReadingsByCycleId(String cycleId) async {
    return await _dataSources.electricityReadings.getReadingsByCycleId(cycleId);
  }

  @override
  Future<ElectricityReading?> getReadingById(String id) async {
    return await _dataSources.electricityReadings.getReadingById(id);
  }

  @override
  Future<String> createReading({
    required String houseId,
    required String cycleId,
    required DateTime date,
    required double meterReading,
    required double unitsConsumed,
    required double totalCost,
    String? notes,
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now();

    // Business logic: Validate that the cycle exists and belongs to the house
    final cycle = await _dataSources.cycles.getCycleById(cycleId);
    if (cycle == null || cycle.houseId != houseId) {
      throw ArgumentError('Invalid cycle or house ID');
    }

    final reading = ElectricityReading(
      id: id,
      houseId: houseId,
      cycleId: cycleId,
      date: date,
      meterReading: meterReading,
      unitsConsumed: unitsConsumed,
      totalCost: totalCost,
      notes: notes,
      createdAt: now,
      updatedAt: now,
    );

    await _dataSources.electricityReadings.createReading(reading);

    return id;
  }

  @override
  Future<void> updateReading({
    required String id,
    DateTime? date,
    double? meterReading,
    double? unitsConsumed,
    double? totalCost,
    String? notes,
  }) async {
    final existingReading = await getReadingById(id);
    if (existingReading == null) return;

    final updatedReading = existingReading.copyWith(
      date: date,
      meterReading: meterReading,
      unitsConsumed: unitsConsumed,
      totalCost: totalCost,
      notes: notes,
      updatedAt: DateTime.now(),
    );

    await _dataSources.electricityReadings.updateReading(updatedReading);
  }

  @override
  Future<void> deleteReading(String id) async {
    await _dataSources.electricityReadings.deleteReading(id);
  }

  @override
  Future<ElectricityReading?> getLatestReadingForCycle(String cycleId) async {
    return await _dataSources.electricityReadings.getLatestReadingForCycle(
      cycleId,
    );
  }

  @override
  Future<ElectricityReading?> getLatestReadingForHouse(String houseId) async {
    return await _dataSources.electricityReadings.getLatestReadingForHouse(
      houseId,
    );
  }

  @override
  Future<int> getReadingsCount({String? houseId, String? cycleId}) async {
    return await _dataSources.electricityReadings.getReadingsCount(
      houseId: houseId,
      cycleId: cycleId,
    );
  }

  @override
  Future<double> getTotalConsumptionForCycle(String cycleId) async {
    final readings = await getReadingsByCycleId(cycleId);
    if (readings.isEmpty) return 0.0;

    final cycle = await _dataSources.cycles.getCycleById(cycleId);
    if (cycle == null) return 0.0;

    return readings.first.meterReading - cycle.initialMeterReading;
  }

  @override
  Future<double> getTotalCostForCycle(String cycleId) async {
    final consumption = await getTotalConsumptionForCycle(cycleId);
    final cycle = await _dataSources.cycles.getCycleById(cycleId);
    if (cycle == null) return 0.0;

    return consumption * cycle.pricePerUnit;
  }

  @override
  Future<double> getAverageConsumptionForHouse(String houseId) async {
    final readings = await getReadingsByHouseId(houseId);
    if (readings.isEmpty) return 0.0;

    double totalConsumption = 0;
    for (final reading in readings) {
      totalConsumption += reading.unitsConsumed;
    }
    return totalConsumption / readings.length;
  }

  @override
  Future<Map<String, dynamic>> getReadingStatistics(String cycleId) async {
    final totalConsumption = await getTotalConsumptionForCycle(cycleId);
    final totalCost = await getTotalCostForCycle(cycleId);
    final readings = await getReadingsByCycleId(cycleId);

    return {
      'totalConsumption': totalConsumption,
      'totalCost': totalCost,
      'readingsCount': readings.length,
    };
  }

  @override
  Future<double> getDailyAverageConsumption(String cycleId) async {
    final readings = await getReadingsByCycleId(cycleId);
    if (readings.isEmpty) return 0.0;

    final cycle = await _dataSources.cycles.getCycleById(cycleId);
    if (cycle == null) return 0.0;

    final days = DateTime.now().difference(cycle.startDate).inDays;
    if (days <= 0) return 0.0;

    final totalConsumption = await getTotalConsumptionForCycle(cycleId);
    return totalConsumption / days;
  }
}
