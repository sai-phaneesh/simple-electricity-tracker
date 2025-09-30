import 'package:drift/drift.dart';
import '../database.dart';
import '../tables.dart';

part 'consumption_dao.g.dart';

@DriftAccessor(tables: [Consumptions])
class ConsumptionDao extends DatabaseAccessor<AppDatabase>
    with _$ConsumptionDaoMixin {
  ConsumptionDao(super.db);

  // Get all consumptions for a cycle
  Future<List<Consumption>> getConsumptionsForCycle(int cycleId) {
    return (select(consumptions)
          ..where((c) => c.cycleId.equals(cycleId))
          ..orderBy([(c) => OrderingTerm.desc(c.date)]))
        .get();
  }

  // Get consumption by drift ID (UUID)
  Future<Consumption?> getConsumptionByDriftId(String driftId) {
    return (select(
      consumptions,
    )..where((c) => c.driftId.equals(driftId))).getSingleOrNull();
  }

  // Create a new consumption
  Future<int> createConsumption(ConsumptionsCompanion consumption) {
    return into(consumptions).insert(consumption);
  }

  // Update a consumption
  Future<bool> updateConsumption(Consumption consumption) {
    return update(consumptions).replace(consumption);
  }

  // Delete a consumption
  Future<int> deleteConsumptionByDriftId(String driftId) {
    return (delete(consumptions)..where((c) => c.driftId.equals(driftId))).go();
  }
}
