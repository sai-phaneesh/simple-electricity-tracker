import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

class DatabaseMigrations {
  static MigrationStrategy get migrationStrategy => MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
      // Add migration logic here when schema changes
      // For now, we'll just handle the initial creation
      if (from == 1 && to == 2) {
        // Example migration for future versions
        // await migrator.addColumn(housesTable, housesTable.newColumn);
      }
    },
    beforeOpen: (details) async {
      // Database initialization logic
      if (details.wasCreated) {
        // Database was created, we can initialize with default data if needed
        debugPrint('Database created successfully');
      }
    },
  );
}
