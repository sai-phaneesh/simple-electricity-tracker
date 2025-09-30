import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:electricity/data/database/database.dart';
import 'package:electricity/data/datasources/datasource_locator.dart';
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

    // Business logic: Validate date is within cycle range
    // if (date.isBefore(cycle.startDate) || date.isAfter(cycle.endDate)) {
    //   throw ArgumentError('Reading date must be within cycle date range');
    // }

    await _dataSources.electricityReadings.createReading(
      ElectricityReadingsTableCompanion(
        id: Value(id),
        houseId: Value(houseId),
        cycleId: Value(cycleId),
        date: Value(date),
        meterReading: Value(meterReading),
        unitsConsumed: Value(unitsConsumed),
        totalCost: Value(totalCost),
        notes: Value(notes),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
    );

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
    // Business logic: If date is being updated, validate it's within cycle range
    if (date != null) {
      final reading = await getReadingById(id);
      if (reading != null) {
        final cycle = await _dataSources.cycles.getCycleById(reading.cycleId);
        if (cycle != null &&
            (date.isBefore(cycle.startDate) || date.isAfter(cycle.endDate))) {
          throw ArgumentError('Reading date must be within cycle date range');
        }
      }
    }

    await _dataSources.electricityReadings.updateReading(
      ElectricityReadingsTableCompanion(
        id: Value(id),
        date: date != null ? Value(date) : const Value.absent(),
        meterReading: meterReading != null
            ? Value(meterReading)
            : const Value.absent(),
        unitsConsumed: unitsConsumed != null
            ? Value(unitsConsumed)
            : const Value.absent(),
        totalCost: totalCost != null ? Value(totalCost) : const Value.absent(),
        notes: notes != null ? Value(notes) : const Value.absent(),
        updatedAt: Value(DateTime.now()),
      ),
    );
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
  Future<List<ElectricityReading>> getReadingsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    return await _dataSources.electricityReadings.getReadingsByDateRange(
      startDate,
      endDate,
    );
  }

  @override
  Future<List<ElectricityReading>> searchReadings(String query) async {
    return await _dataSources.electricityReadings.searchReadings(query);
  }

  @override
  Future<int> getReadingsCount({String? houseId, String? cycleId}) async {
    return await _dataSources.electricityReadings.getReadingsCount(
      houseId: houseId,
      cycleId: cycleId,
    );
  }

  @override
  Future<List<ElectricityReading>> getReadingsNeedingSync() async {
    return await _dataSources.electricityReadings.getReadingsNeedingSync();
  }

  @override
  Future<void> markReadingAsSynced(String id) async {
    await _dataSources.electricityReadings.markReadingAsSynced(id);
  }

  @override
  Future<bool> hasDataNeedingSync() async {
    final readings = await getReadingsNeedingSync();
    return readings.isNotEmpty;
  }

  @override
  Future<DateTime?> getLastSyncTime() async {
    return await _dataSources.electricityReadings.getLastSyncTime();
  }

  @override
  Future<double> getTotalConsumptionForCycle(String cycleId) async {
    return await _dataSources.electricityReadings.getTotalConsumptionForCycle(
      cycleId,
    );
  }

  @override
  Future<double> getTotalCostForCycle(String cycleId) async {
    return await _dataSources.electricityReadings.getTotalCostForCycle(cycleId);
  }

  @override
  Future<double> getAverageConsumptionForHouse(String houseId) async {
    return await _dataSources.electricityReadings.getAverageConsumptionForHouse(
      houseId,
    );
  }

  @override
  Future<Map<String, double>> getMonthlyConsumption(
    String houseId,
    int year,
  ) async {
    return await _dataSources.electricityReadings.getMonthlyConsumption(
      houseId,
      year,
    );
  }

  @override
  Future<Map<String, dynamic>> getReadingStatistics(String cycleId) async {
    // Business logic: Aggregate comprehensive statistics
    final readings = await getReadingsByCycleId(cycleId);
    final totalConsumption = await getTotalConsumptionForCycle(cycleId);
    final totalCost = await getTotalCostForCycle(cycleId);
    final averageDaily = await getDailyAverageConsumption(cycleId);

    if (readings.isEmpty) {
      return {
        'total_readings': 0,
        'total_consumption': 0.0,
        'total_cost': 0.0,
        'average_daily_consumption': 0.0,
        'min_reading': 0,
        'max_reading': 0,
        'first_reading_date': null,
        'last_reading_date': null,
      };
    }

    readings.sort((a, b) => a.date.compareTo(b.date));
    final minReading = readings
        .map((r) => r.meterReading)
        .reduce((a, b) => a < b ? a : b);
    final maxReading = readings
        .map((r) => r.meterReading)
        .reduce((a, b) => a > b ? a : b);

    return {
      'total_readings': readings.length,
      'total_consumption': totalConsumption,
      'total_cost': totalCost,
      'average_daily_consumption': averageDaily,
      'min_reading': minReading,
      'max_reading': maxReading,
      'first_reading_date': readings.first.date,
      'last_reading_date': readings.last.date,
    };
  }

  @override
  Future<double> getDailyAverageConsumption(String cycleId) async {
    final readings = await getReadingsByCycleId(cycleId);
    if (readings.length < 2) return 0.0;

    readings.sort((a, b) => a.date.compareTo(b.date));
    final first = readings.first;
    final last = readings.last;

    final totalConsumption = (last.meterReading - first.meterReading)
        .toDouble();
    final daysDifference = last.date.difference(first.date).inDays;

    if (daysDifference == 0) return 0.0;
    return totalConsumption / daysDifference;
  }

  @override
  Future<List<Map<String, dynamic>>> getConsumptionTrend(
    String houseId,
    int days,
  ) async {
    // Business logic: Calculate consumption trend over specified days
    final endDate = DateTime.now();
    final startDate = endDate.subtract(Duration(days: days));

    final readings = await _dataSources.electricityReadings
        .getReadingsByDateRange(startDate, endDate);
    final houseReadings = readings.where((r) => r.houseId == houseId).toList();

    houseReadings.sort((a, b) => a.date.compareTo(b.date));

    final trend = <Map<String, dynamic>>[];

    for (int i = 0; i < houseReadings.length - 1; i++) {
      final current = houseReadings[i];
      final next = houseReadings[i + 1];

      final consumption = next.meterReading - current.meterReading;
      final daysDiff = next.date.difference(current.date).inDays;
      final dailyAverage = daysDiff > 0
          ? consumption / daysDiff
          : consumption.toDouble();

      trend.add({
        'date': current.date,
        'consumption': consumption,
        'daily_average': dailyAverage,
        'cost': current.totalCost,
      });
    }

    return trend;
  }
}
