import 'package:electricity/database/database_service.dart';
import 'package:electricity/database/database.dart';
import 'package:drift/drift.dart';

class DriftUsageExample {
  static final _db = DatabaseService.database;

  /// Example: Create a new cycle
  static Future<Cycle> createCycle({
    required String name,
    required DateTime startDate,
    required DateTime endDate,
    required double meterReading,
    required double maxUnits,
  }) async {
    final cycleId = await _db.cycleDao.createCycle(
      CyclesCompanion(
        driftId: Value('cycle_${DateTime.now().millisecondsSinceEpoch}'),
        name: Value(name),
        startDate: Value(startDate),
        endDate: Value(endDate),
        meterReading: Value(meterReading),
        maxUnits: Value(maxUnits),
        createdOn: Value(DateTime.now()),
        updatedOn: Value(DateTime.now()),
      ),
    );

    // Return the created cycle
    final cycles = await _db.select(_db.cycles).get();
    return cycles.firstWhere((c) => c.id == cycleId);
  }

  /// Example: Get all cycles
  static Future<List<Cycle>> getAllCycles() async {
    return await _db.cycleDao.getAllCycles();
  }

  /// Example: Get cycle with consumptions (simplified)
  static Future<Map<Cycle, List<Consumption>>>
  getCyclesWithConsumptions() async {
    final cycles = await _db.cycleDao.getAllCycles();
    final Map<Cycle, List<Consumption>> result = {};

    for (final cycle in cycles) {
      final consumptions = await _db.consumptionDao.getConsumptionsForCycle(
        cycle.id,
      );
      result[cycle] = consumptions;
    }

    return result;
  }

  /// Example: Add consumption to a cycle
  static Future<Consumption> addConsumption({
    required String cycleId,
    required double meterReading,
  }) async {
    final cycle = await _db.cycleDao.getCycleByDriftId(cycleId);
    if (cycle == null) throw Exception('Cycle not found');

    final consumptionId = await _db.consumptionDao.createConsumption(
      ConsumptionsCompanion(
        driftId: Value('consumption_${DateTime.now().millisecondsSinceEpoch}'),
        cycleId: Value(cycle.id),
        meterReading: Value(meterReading),
        date: Value(DateTime.now()),
        unitsConsumed: Value(meterReading - cycle.meterReading),
      ),
    );

    final consumptions = await _db.select(_db.consumptions).get();
    return consumptions.firstWhere((c) => c.id == consumptionId);
  }

  /// Example: Update a cycle
  static Future<void> updateCycle(Cycle cycle) async {
    await _db.cycleDao.updateCycle(cycle);
  }

  /// Example: Delete a cycle
  static Future<void> deleteCycle(String driftId) async {
    await _db.cycleDao.deleteCycleByDriftId(driftId);
  }

  /// Example: Stream of cycles (reactive)
  static Stream<List<Cycle>> watchAllCycles() {
    return _db.select(_db.cycles).watch();
  }

  /// Example: Stream of consumptions for a cycle
  static Stream<List<Consumption>> watchConsumptionsForCycle(int cycleId) {
    return (_db.select(_db.consumptions)
          ..where((c) => c.cycleId.equals(cycleId))
          ..orderBy([(c) => OrderingTerm.desc(c.date)]))
        .watch();
  }

  /// Example: Complex query - get cycles with total consumption
  static Future<List<CycleWithTotalConsumption>>
  getCyclesWithTotalConsumption() async {
    final query = _db.select(_db.cycles).join([
      leftOuterJoin(
        _db.consumptions,
        _db.consumptions.cycleId.equalsExp(_db.cycles.id),
      ),
    ]);

    final results = await query.get();
    final Map<int, CycleWithTotalConsumption> cycleMap = {};

    for (final row in results) {
      final cycle = row.readTable(_db.cycles);
      final consumption = row.readTableOrNull(_db.consumptions);

      if (cycleMap.containsKey(cycle.id)) {
        if (consumption != null) {
          cycleMap[cycle.id]!.totalUnits += consumption.unitsConsumed;
        }
      } else {
        cycleMap[cycle.id] = CycleWithTotalConsumption(
          cycle: cycle,
          totalUnits: consumption?.unitsConsumed ?? 0,
        );
      }
    }

    return cycleMap.values.toList();
  }

  /// Example: Transaction - create cycle with initial consumption
  static Future<Cycle> createCycleWithInitialConsumption({
    required String name,
    required DateTime startDate,
    required DateTime endDate,
    required double meterReading,
    required double maxUnits,
  }) async {
    return await _db.transaction(() async {
      final cycleId = await _db.cycleDao.createCycle(
        CyclesCompanion(
          driftId: Value('cycle_${DateTime.now().millisecondsSinceEpoch}'),
          name: Value(name),
          startDate: Value(startDate),
          endDate: Value(endDate),
          meterReading: Value(meterReading),
          maxUnits: Value(maxUnits),
          createdOn: Value(DateTime.now()),
          updatedOn: Value(DateTime.now()),
        ),
      );

      await _db.consumptionDao.createConsumption(
        ConsumptionsCompanion(
          driftId: Value('initial_${DateTime.now().millisecondsSinceEpoch}'),
          cycleId: Value(cycleId),
          meterReading: Value(meterReading),
          date: Value(DateTime.now()),
          unitsConsumed: const Value(0),
        ),
      );

      final cycles = await _db.select(_db.cycles).get();
      return cycles.firstWhere((c) => c.id == cycleId);
    });
  }
}

class CycleWithTotalConsumption {
  final Cycle cycle;
  double totalUnits;

  CycleWithTotalConsumption({required this.cycle, required this.totalUnits});
}
