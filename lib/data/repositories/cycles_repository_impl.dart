import 'package:electricity/data/database/database.dart';
import 'package:electricity/data/datasources/cycles_datasource.dart';
import 'package:electricity/data/datasources/electricity_readings_datasource.dart';
import 'package:electricity/domain/repositories/cycles_repository.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';

class CyclesRepositoryImpl implements CyclesRepository {
  final CyclesDataSource _cyclesDataSource;
  final ElectricityReadingsDataSource _readingsDataSource;

  CyclesRepositoryImpl(this._cyclesDataSource, this._readingsDataSource);

  @override
  Future<List<Cycle>> getAllCycles() async {
    return await _cyclesDataSource.getAllCycles();
  }

  @override
  Future<List<Cycle>> getCyclesByHouseId(String houseId) async {
    return await _cyclesDataSource.getCyclesByHouseId(houseId);
  }

  @override
  Future<Cycle?> getCycleById(String id) async {
    return await _cyclesDataSource.getCycleById(id);
  }

  @override
  Future<String> createCycle({
    required String houseId,
    required String name,
    required DateTime startDate,
    required DateTime endDate,
    required double initialMeterReading,
    required int maxUnits,
    required double pricePerUnit,
    bool isActive = false,
    String? notes,
  }) async {
    final id = const Uuid().v4();
    final now = DateTime.now();

    if (isActive) {
      // If this is an active cycle, deactivate other active cycles for the house
      await _cyclesDataSource.deactivateOtherCycles(houseId, id);
    }

    await _cyclesDataSource.createCycle(
      CyclesTableCompanion.insert(
        id: id,
        houseId: houseId,
        name: name,
        startDate: startDate,
        endDate: endDate,
        initialMeterReading: initialMeterReading,
        maxUnits: maxUnits,
        pricePerUnit: pricePerUnit,
        isActive: Value(isActive),
        notes: Value(notes),
        createdAt: now,
        updatedAt: now,
      ),
    );

    return id;
  }

  @override
  Future<void> updateCycle({
    required String id,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    double? initialMeterReading,
    int? maxUnits,
    double? pricePerUnit,
    bool? isActive,
    String? notes,
  }) async {
    final cycle = await getCycleById(id);
    if (cycle == null) {
      throw Exception('Cycle not found');
    }

    if (isActive == true) {
      // If making this cycle active, deactivate other active cycles for the house
      await _cyclesDataSource.deactivateOtherCycles(cycle.houseId, id);
    }

    // Check if we need to recalculate readings (when pricePerUnit or initialMeterReading changes)
    final needsRecalculation =
        pricePerUnit != null || initialMeterReading != null;

    await _cyclesDataSource.updateCycle(
      CyclesTableCompanion(
        id: Value(id),
        name: name != null ? Value(name) : const Value.absent(),
        startDate: startDate != null ? Value(startDate) : const Value.absent(),
        endDate: endDate != null ? Value(endDate) : const Value.absent(),
        initialMeterReading: initialMeterReading != null
            ? Value(initialMeterReading)
            : const Value.absent(),
        maxUnits: maxUnits != null ? Value(maxUnits) : const Value.absent(),
        pricePerUnit: pricePerUnit != null
            ? Value(pricePerUnit)
            : const Value.absent(),
        isActive: isActive != null ? Value(isActive) : const Value.absent(),
        notes: notes != null ? Value(notes) : const Value.absent(),
        updatedAt: Value(DateTime.now()),
        needsSync: const Value(true),
        syncStatus: const Value('pending'),
      ),
    );

    // Recalculate all readings for this cycle if price or initial reading changed
    if (needsRecalculation) {
      await _recalculateReadingsForCycle(id);
    }
  }

  /// Recalculates unitsConsumed and totalCost for all readings in a cycle
  /// This is needed when pricePerUnit or initialMeterReading is updated
  Future<void> _recalculateReadingsForCycle(String cycleId) async {
    // Get the updated cycle data
    final cycle = await getCycleById(cycleId);
    if (cycle == null) return;

    // Get all readings for this cycle ordered by date
    final readings = await _readingsDataSource.getReadingsByCycleId(cycleId);
    if (readings.isEmpty) return;

    // Recalculate each reading
    double previousReading = cycle.initialMeterReading;

    for (final reading in readings) {
      final unitsConsumed = reading.meterReading - previousReading;
      final totalCost = unitsConsumed * cycle.pricePerUnit;

      await _readingsDataSource.updateReading(
        ElectricityReadingsTableCompanion(
          id: Value(reading.id),
          unitsConsumed: Value(unitsConsumed),
          totalCost: Value(totalCost),
          updatedAt: Value(DateTime.now()),
          needsSync: const Value(true),
          syncStatus: const Value('pending'),
        ),
      );

      // Update previousReading for next iteration
      previousReading = reading.meterReading;
    }
  }

  @override
  Future<void> deleteCycle(String id) async {
    // First, delete all associated electricity readings
    final readings = await _readingsDataSource.getReadingsByCycleId(id);
    for (final reading in readings) {
      await _readingsDataSource.deleteReading(reading.id);
    }

    await _cyclesDataSource.deleteCycle(id);
  }

  @override
  Future<Cycle?> getActiveCycleForHouse(String houseId) async {
    return await _cyclesDataSource.getActiveCycleForHouse(houseId);
  }

  @override
  Future<void> setActiveCycle(String houseId, String cycleId) async {
    await _cyclesDataSource.deactivateOtherCycles(houseId, cycleId);
  }

  @override
  Future<List<Cycle>> getCyclesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    return await _cyclesDataSource.getCyclesByDateRange(startDate, endDate);
  }

  @override
  Future<List<Cycle>> searchCycles(String query) async {
    return await _cyclesDataSource.searchCycles(query);
  }

  @override
  Future<int> getCyclesCount({String? houseId}) async {
    return await _cyclesDataSource.getCyclesCount(houseId: houseId);
  }

  @override
  Future<List<Cycle>> getCyclesNeedingSync() async {
    return await _cyclesDataSource.getCyclesNeedingSync();
  }

  @override
  Future<void> markCycleAsSynced(String id) async {
    await _cyclesDataSource.markCycleAsSynced(id);
  }

  @override
  Future<bool> hasDataNeedingSync() async {
    final cycles = await getCyclesNeedingSync();
    return cycles.isNotEmpty;
  }

  @override
  Future<DateTime?> getLastSyncTime() async {
    return await _cyclesDataSource.getLastSyncTime();
  }

  @override
  Future<Map<String, dynamic>> getCycleStatistics(String cycleId) async {
    final cycle = await getCycleById(cycleId);
    if (cycle == null) {
      throw Exception('Cycle not found');
    }

    final readings = await _readingsDataSource.getReadingsByCycleId(cycleId);
    final totalConsumption = await _readingsDataSource
        .getTotalConsumptionForCycle(cycleId);
    final totalCost = totalConsumption * cycle.pricePerUnit;

    return {
      'cycleId': cycleId,
      'totalConsumption': totalConsumption,
      'totalCost': totalCost,
      'remainingUnits': (cycle.maxUnits - totalConsumption.toInt()).clamp(
        0,
        cycle.maxUnits,
      ),
      'averageDailyConsumption': readings.isNotEmpty
          ? totalConsumption / readings.length
          : 0.0,
      'projectedMonthlyConsumption': readings.isNotEmpty
          ? (totalConsumption / readings.length) * 30
          : 0.0,
      'efficiencyPercentage': cycle.maxUnits > 0
          ? ((cycle.maxUnits - totalConsumption) / cycle.maxUnits * 100).clamp(
              0.0,
              100.0,
            )
          : 0.0,
    };
  }

  @override
  Future<double> getCycleProgress(String cycleId) async {
    final cycle = await getCycleById(cycleId);
    if (cycle == null) return 0.0;

    final totalConsumption = await _readingsDataSource
        .getTotalConsumptionForCycle(cycleId);
    return cycle.maxUnits > 0
        ? (totalConsumption / cycle.maxUnits * 100).clamp(0.0, 100.0)
        : 0.0;
  }

  @override
  Future<int> getRemainingUnits(String cycleId) async {
    final cycle = await getCycleById(cycleId);
    if (cycle == null) return 0;

    final totalConsumption = await _readingsDataSource
        .getTotalConsumptionForCycle(cycleId);
    return (cycle.maxUnits - totalConsumption.toInt()).clamp(0, cycle.maxUnits);
  }

  @override
  Future<double> getEstimatedCost(String cycleId) async {
    final cycle = await getCycleById(cycleId);
    if (cycle == null) return 0.0;

    final totalConsumption = await _readingsDataSource
        .getTotalConsumptionForCycle(cycleId);
    return totalConsumption * cycle.pricePerUnit;
  }
}
