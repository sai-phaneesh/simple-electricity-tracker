import 'package:drift/drift.dart';

import 'tables/houses_table.dart';
import 'tables/cycles_table.dart';
import 'tables/electricity_readings_table.dart';
import 'database_migrations.dart';
import 'connection/connection.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [HousesTable, CyclesTable, ElectricityReadingsTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());
  AppDatabase.fromExecutor(super.executor);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => DatabaseMigrations.migrationStrategy;

  // Houses operations
  Future<List<House>> getAllHouses() async {
    return await select(housesTable).get();
  }

  Future<House?> getHouseById(String id) async {
    return await (select(
      housesTable,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertHouse(HousesTableCompanion house) async {
    return await into(housesTable).insert(house);
  }

  Future<bool> updateHouse(HousesTableCompanion house) async {
    return await update(housesTable).replace(house);
  }

  Future<int> deleteHouse(String id) async {
    return await (delete(housesTable)..where((tbl) => tbl.id.equals(id))).go();
  }

  // Cycles operations
  Future<List<Cycle>> getCyclesByHouseId(String houseId) async {
    return await (select(
      cyclesTable,
    )..where((tbl) => tbl.houseId.equals(houseId))).get();
  }

  Future<Cycle?> getCycleById(String id) async {
    return await (select(
      cyclesTable,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertCycle(CyclesTableCompanion cycle) async {
    return await into(cyclesTable).insert(cycle);
  }

  Future<bool> updateCycle(CyclesTableCompanion cycle) async {
    return await update(cyclesTable).replace(cycle);
  }

  Future<int> deleteCycle(String id) async {
    return await (delete(cyclesTable)..where((tbl) => tbl.id.equals(id))).go();
  }

  // Electricity readings operations
  Future<List<ElectricityReading>> getReadingsByCycleId(String cycleId) async {
    return await (select(electricityReadingsTable)
          ..where((tbl) => tbl.cycleId.equals(cycleId))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.date)]))
        .get();
  }

  Future<List<ElectricityReading>> getReadingsByHouseId(String houseId) async {
    return await (select(electricityReadingsTable)
          ..where((tbl) => tbl.houseId.equals(houseId))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.date)]))
        .get();
  }

  Future<ElectricityReading?> getReadingById(String id) async {
    return await (select(
      electricityReadingsTable,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertReading(ElectricityReadingsTableCompanion reading) async {
    return await into(electricityReadingsTable).insert(reading);
  }

  Future<bool> updateReading(ElectricityReadingsTableCompanion reading) async {
    return await update(electricityReadingsTable).replace(reading);
  }

  Future<int> deleteReading(String id) async {
    return await (delete(
      electricityReadingsTable,
    )..where((tbl) => tbl.id.equals(id))).go();
  }

  // Get latest reading for a cycle
  Future<ElectricityReading?> getLatestReadingForCycle(String cycleId) async {
    return await (select(electricityReadingsTable)
          ..where((tbl) => tbl.cycleId.equals(cycleId))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.date)])
          ..limit(1))
        .getSingleOrNull();
  }

  // Get readings count for a cycle
  Future<int> getReadingsCountForCycle(String cycleId) async {
    final countExp = electricityReadingsTable.id.count();
    final query = selectOnly(electricityReadingsTable)
      ..where(electricityReadingsTable.cycleId.equals(cycleId))
      ..addColumns([countExp]);

    final result = await query.getSingle();
    return result.read(countExp) ?? 0;
  }
}
