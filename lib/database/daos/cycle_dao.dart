import 'package:drift/drift.dart';
import '../database.dart';
import '../tables.dart';

part 'cycle_dao.g.dart';

@DriftAccessor(tables: [Cycles, Consumptions])
class CycleDao extends DatabaseAccessor<AppDatabase> with _$CycleDaoMixin {
  CycleDao(super.db);

  // Get all cycles
  Future<List<Cycle>> getAllCycles() {
    return select(cycles).get();
  }

  // Get cycle by drift ID (UUID)
  Future<Cycle?> getCycleByDriftId(String driftId) {
    return (select(
      cycles,
    )..where((c) => c.driftId.equals(driftId))).getSingleOrNull();
  }

  // Create a new cycle
  Future<int> createCycle(CyclesCompanion cycle) {
    return into(cycles).insert(cycle);
  }

  // Update a cycle
  Future<bool> updateCycle(Cycle cycle) {
    return update(cycles).replace(cycle);
  }

  // Delete a cycle (consumptions will be cascade deleted)
  Future<int> deleteCycleByDriftId(String driftId) {
    return (delete(cycles)..where((c) => c.driftId.equals(driftId))).go();
  }

  // Get cycle with its consumptions
  Future<List<CycleWithConsumptions>> getCyclesWithConsumptions() {
    final query = select(cycles).join([
      leftOuterJoin(consumptions, consumptions.cycleId.equalsExp(cycles.id)),
    ]);

    return query.map((row) {
      final cycle = row.readTable(cycles);
      final consumption = row.readTableOrNull(consumptions);
      return CycleWithConsumptions(cycle: cycle, consumption: consumption);
    }).get();
  }
}

// Helper class to represent cycle with consumptions
class CycleWithConsumptions {
  final Cycle cycle;
  final Consumption? consumption;

  CycleWithConsumptions({required this.cycle, this.consumption});
}
