import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:electricity/features/houses/data/datasources/database/tables/houses_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Houses])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        // Add new columns for version 2 with fallback values for existing data
        Future<void> tryAddColumn(Future<void> Function() addColumn) async {
          try {
            await addColumn();
          } catch (e) {
            // Ignore duplicate column errors
            if (!(e.toString().contains('duplicate column name'))) {
              rethrow;
            }
          }
        }

        await tryAddColumn(() => m.addColumn(houses, houses.isActive));
        await tryAddColumn(() => m.addColumn(houses, houses.meterNumber));
        await tryAddColumn(
          () => m.addColumn(houses, houses.defaultPricePerUnit),
        );
        await tryAddColumn(() => m.addColumn(houses, houses.freeUnitsPerMonth));
        await tryAddColumn(() => m.addColumn(houses, houses.warningLimitUnits));
        await tryAddColumn(() => m.addColumn(houses, houses.isArchived));

        // Set default meter numbers for existing houses
        await customStatement('''
          UPDATE houses 
          SET meter_number = 'METER-' || SUBSTR(id, 1, 8)
          WHERE meter_number IS NULL OR meter_number = '';
        ''');
      }
    },
  );

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'electricity_tracker',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    );
  }
}
