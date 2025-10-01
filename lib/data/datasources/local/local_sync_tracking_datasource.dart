import 'package:drift/drift.dart';
import 'package:electricity/data/database/database.dart';
import 'package:electricity/data/datasources/sync_tracking_datasource.dart';

/// Local implementation of sync tracking data source using Drift
class LocalSyncTrackingDataSource implements SyncTrackingDataSource {
  final AppDatabase _db;

  LocalSyncTrackingDataSource(this._db);

  @override
  Future<List<House>> getHousesNeedingSync() async {
    final houses = await (_db.select(
      _db.housesTable,
    )..where((tbl) => tbl.needsSync.equals(true))).get();

    // Filter out soft-deleted items
    return houses.where((h) => !h.isDeleted).toList();
  }

  @override
  Future<List<Cycle>> getCyclesNeedingSync() async {
    final cycles = await (_db.select(
      _db.cyclesTable,
    )..where((tbl) => tbl.needsSync.equals(true))).get();

    return cycles.where((c) => !c.isDeleted).toList();
  }

  @override
  Future<List<ElectricityReading>> getReadingsNeedingSync() async {
    final readings = await (_db.select(
      _db.electricityReadingsTable,
    )..where((tbl) => tbl.needsSync.equals(true))).get();

    return readings.where((r) => !r.isDeleted).toList();
  }

  @override
  Future<void> markHousesAsSynced(List<String> houseIds) async {
    if (houseIds.isEmpty) return;

    final now = DateTime.now();
    for (final id in houseIds) {
      await (_db.update(
        _db.housesTable,
      )..where((tbl) => tbl.id.equals(id))).write(
        HousesTableCompanion(
          needsSync: const Value(false),
          lastSyncAt: Value(now),
          syncStatus: const Value('synced'),
        ),
      );
    }
  }

  @override
  Future<void> markCyclesAsSynced(List<String> cycleIds) async {
    if (cycleIds.isEmpty) return;

    final now = DateTime.now();
    for (final id in cycleIds) {
      await (_db.update(
        _db.cyclesTable,
      )..where((tbl) => tbl.id.equals(id))).write(
        CyclesTableCompanion(
          needsSync: const Value(false),
          lastSyncAt: Value(now),
          syncStatus: const Value('synced'),
        ),
      );
    }
  }

  @override
  Future<void> markReadingsAsSynced(List<String> readingIds) async {
    if (readingIds.isEmpty) return;

    final now = DateTime.now();
    for (final id in readingIds) {
      await (_db.update(
        _db.electricityReadingsTable,
      )..where((tbl) => tbl.id.equals(id))).write(
        ElectricityReadingsTableCompanion(
          needsSync: const Value(false),
          lastSyncAt: Value(now),
          syncStatus: const Value('synced'),
        ),
      );
    }
  }

  @override
  Future<void> markHousesAsNeedingSync(List<String> houseIds) async {
    if (houseIds.isEmpty) return;

    for (final id in houseIds) {
      await (_db.update(
        _db.housesTable,
      )..where((tbl) => tbl.id.equals(id))).write(
        const HousesTableCompanion(
          needsSync: Value(true),
          syncStatus: Value('pending'),
        ),
      );
    }
  }

  @override
  Future<void> markCyclesAsNeedingSync(List<String> cycleIds) async {
    if (cycleIds.isEmpty) return;

    for (final id in cycleIds) {
      await (_db.update(
        _db.cyclesTable,
      )..where((tbl) => tbl.id.equals(id))).write(
        const CyclesTableCompanion(
          needsSync: Value(true),
          syncStatus: Value('pending'),
        ),
      );
    }
  }

  @override
  Future<void> markReadingsAsNeedingSync(List<String> readingIds) async {
    if (readingIds.isEmpty) return;

    for (final id in readingIds) {
      await (_db.update(
        _db.electricityReadingsTable,
      )..where((tbl) => tbl.id.equals(id))).write(
        const ElectricityReadingsTableCompanion(
          needsSync: Value(true),
          syncStatus: Value('pending'),
        ),
      );
    }
  }

  @override
  Future<bool> hasAnySyncedItems() async {
    final result =
        await (_db.select(_db.housesTable)
              ..where((tbl) => tbl.lastSyncAt.isNotNull())
              ..limit(1))
            .get();

    return result.isNotEmpty;
  }

  @override
  Future<void> markAllItemsAsSynced() async {
    await _db.transaction(() async {
      final now = DateTime.now();

      // Update all houses that need sync
      await (_db.update(
        _db.housesTable,
      )..where((tbl) => tbl.needsSync.equals(true))).write(
        HousesTableCompanion(
          needsSync: const Value(false),
          lastSyncAt: Value(now),
          syncStatus: const Value('synced'),
        ),
      );

      // Update all cycles that need sync
      await (_db.update(
        _db.cyclesTable,
      )..where((tbl) => tbl.needsSync.equals(true))).write(
        CyclesTableCompanion(
          needsSync: const Value(false),
          lastSyncAt: Value(now),
          syncStatus: const Value('synced'),
        ),
      );

      // Update all readings that need sync
      await (_db.update(
        _db.electricityReadingsTable,
      )..where((tbl) => tbl.needsSync.equals(true))).write(
        ElectricityReadingsTableCompanion(
          needsSync: const Value(false),
          lastSyncAt: Value(now),
          syncStatus: const Value('synced'),
        ),
      );
    });
  }
}
