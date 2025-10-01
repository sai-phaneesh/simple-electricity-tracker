import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

class DatabaseMigrations {
  static MigrationStrategy get migrationStrategy => MigrationStrategy(
    onCreate: (Migrator m) async {
      // Create all tables first
      await m.createAll();
    },

    onUpgrade: (Migrator migrator, int from, int to) async {
      // Add migration logic here when schema changes
      if (from == 1 && to == 2) {
        // Example migration for future versions
        // await migrator.addColumn(housesTable, housesTable.newColumn);
      }
    },

    beforeOpen: (OpeningDetails details) async {
      // Database initialization logic
      if (details.wasCreated) {
        debugPrint('Database created successfully');
      }
    },
  );
}
