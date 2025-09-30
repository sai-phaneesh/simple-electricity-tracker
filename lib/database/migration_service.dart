import 'package:drift/drift.dart';
import 'package:electricity/bloc/dashboard_bloc.dart' as bloc_models;
import 'package:electricity/database/database.dart';
import 'package:electricity/database/database_service.dart';

class MigrationService {
  static final AppDatabase _db = DatabaseService.database;

  /// Migrate existing HydratedBloc data to Drift database
  static Future<void> migrateFromHydratedBloc(
    List<bloc_models.Cycle> blocCycles,
  ) async {
    for (final blocCycle in blocCycles) {
      await _migrateCycle(blocCycle);
    }
  }

  /// Migrate a single cycle and its consumptions
  static Future<void> _migrateCycle(bloc_models.Cycle blocCycle) async {
    // Check if cycle already exists
    final existingCycle = await _db.cycleDao.getCycleByDriftId(blocCycle.id);
    if (existingCycle != null) {
      return; // Already migrated
    }

    // Insert cycle
    final cycleId = await _db.cycleDao.createCycle(
      CyclesCompanion(
        driftId: Value(blocCycle.id),
        name: Value(blocCycle.name),
        startDate: Value(blocCycle.startDate),
        endDate: Value(blocCycle.endDate),
        meterReading: Value(blocCycle.meterReading),
        maxUnits: Value(blocCycle.maxUnits),
        createdOn: Value(blocCycle.createdOn),
        updatedOn: Value(blocCycle.updatedOn),
      ),
    );

    // Insert consumptions
    for (final blocConsumption in blocCycle.consumptions) {
      await _db.consumptionDao.createConsumption(
        ConsumptionsCompanion(
          driftId: Value(blocConsumption.id),
          cycleId: Value(cycleId),
          meterReading: Value(blocConsumption.meterReading),
          date: Value(blocConsumption.date),
          unitsConsumed: Value(blocConsumption.unitsConsumed),
        ),
      );
    }
  }

  /// Convert Drift cycles back to bloc models (for compatibility during transition)
  static Future<List<bloc_models.Cycle>>
  convertDriftCyclesToBlocModels() async {
    final driftCycles = await _db.cycleDao.getAllCycles();
    final List<bloc_models.Cycle> blocCycles = [];

    for (final driftCycle in driftCycles) {
      final consumptions = await _db.consumptionDao.getConsumptionsForCycle(
        driftCycle.id,
      );

      final blocConsumptions = consumptions
          .map(
            (c) => bloc_models.Consumption(
              id: c.driftId,
              meterReading: c.meterReading,
              date: c.date,
              unitsConsumed: c.unitsConsumed,
            ),
          )
          .toList();

      final blocCycle = bloc_models.Cycle(
        id: driftCycle.driftId,
        name: driftCycle.name,
        startDate: driftCycle.startDate,
        endDate: driftCycle.endDate,
        meterReading: driftCycle.meterReading,
        maxUnits: driftCycle.maxUnits,
        createdOn: driftCycle.createdOn,
        updatedOn: driftCycle.updatedOn,
        consumptions: blocConsumptions,
      );

      blocCycles.add(blocCycle);
    }

    return blocCycles;
  }

  /// Create a new cycle using Drift
  static Future<bloc_models.Cycle> createCycleInDrift({
    required String id,
    required String name,
    required DateTime startDate,
    required DateTime endDate,
    required double meterReading,
    required double maxUnits,
  }) async {
    final now = DateTime.now();

    final cycleId = await _db.cycleDao.createCycle(
      CyclesCompanion(
        driftId: Value(id),
        name: Value(name),
        startDate: Value(startDate),
        endDate: Value(endDate),
        meterReading: Value(meterReading),
        maxUnits: Value(maxUnits),
        createdOn: Value(now),
        updatedOn: Value(now),
      ),
    );

    // Create initial consumption
    await _db.consumptionDao.createConsumption(
      ConsumptionsCompanion(
        driftId: Value('${id}_initial'),
        cycleId: Value(cycleId),
        meterReading: Value(meterReading),
        date: Value(now),
        unitsConsumed: const Value(0),
      ),
    );

    // Return as bloc model for compatibility
    return bloc_models.Cycle(
      id: id,
      name: name,
      startDate: startDate,
      endDate: endDate,
      meterReading: meterReading,
      maxUnits: maxUnits,
      createdOn: now,
      updatedOn: now,
      consumptions: [
        bloc_models.Consumption(
          id: '${id}_initial',
          meterReading: meterReading,
          date: now,
          unitsConsumed: 0,
        ),
      ],
    );
  }

  /// Add consumption using Drift
  static Future<bloc_models.Consumption> addConsumptionInDrift({
    required String cycleId,
    required String consumptionId,
    required double meterReading,
  }) async {
    final cycle = await _db.cycleDao.getCycleByDriftId(cycleId);
    if (cycle == null) {
      throw Exception('Cycle not found');
    }

    final now = DateTime.now();
    final unitsConsumed = meterReading - cycle.meterReading;

    await _db.consumptionDao.createConsumption(
      ConsumptionsCompanion(
        driftId: Value(consumptionId),
        cycleId: Value(cycle.id),
        meterReading: Value(meterReading),
        date: Value(now),
        unitsConsumed: Value(unitsConsumed),
      ),
    );

    return bloc_models.Consumption(
      id: consumptionId,
      meterReading: meterReading,
      date: now,
      unitsConsumed: unitsConsumed,
    );
  }

  /// Delete cycle using Drift
  static Future<void> deleteCycleInDrift(String cycleId) async {
    await _db.cycleDao.deleteCycleByDriftId(cycleId);
  }

  /// Delete consumption using Drift
  static Future<void> deleteConsumptionInDrift(String consumptionId) async {
    await _db.consumptionDao.deleteConsumptionByDriftId(consumptionId);
  }
}
