import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables.dart';
import 'daos/cycle_dao.dart';
import 'daos/consumption_dao.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Cycles, Consumptions], daos: [CycleDao, ConsumptionDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // Future migrations will go here
      // Example for version 2:
      // if (from == 1) {
      //   await m.addColumn(cycles, cycles.someNewColumn);
      // }
    },
    beforeOpen: (details) async {
      // Enable foreign keys
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'electricity_tracker');
}
