import 'package:drift/drift.dart';
import 'package:electricity/data/database/database.dart';
import 'package:electricity/domain/repositories/sync_tracking_repository.dart';

/// Service for handling local database operations related to backup/restore
class BackupService {
  final AppDatabase _db;
  final SyncTrackingRepository _syncRepository;

  BackupService(this._db, this._syncRepository);

  /// Export all data for backup
  Future<Map<String, List<Map<String, dynamic>>>> exportAllData() async {
    final houses = await _db.select(_db.housesTable).get();
    final cycles = await _db.select(_db.cyclesTable).get();
    final readings = await _db.select(_db.electricityReadingsTable).get();

    return {
      'houses': houses
          .map(
            (h) => {
              'id': h.id,
              'name': h.name,
              'address': h.address,
              'meter_number': h.meterNumber,
              'default_price_per_unit': h.defaultPricePerUnit,
              'notes': h.notes,
              'created_at': h.createdAt.toIso8601String(),
              'updated_at': h.updatedAt.toIso8601String(),
            },
          )
          .toList(),
      'cycles': cycles
          .map(
            (c) => {
              'id': c.id,
              'house_id': c.houseId,
              'name': c.name,
              'start_date': c.startDate.toIso8601String(),
              'end_date': c.endDate.toIso8601String(),
              'max_units': c.maxUnits,
              'price_per_unit': c.pricePerUnit,
              'initial_meter_reading': c.initialMeterReading,
              'is_active': c.isActive,
              'notes': c.notes,
              'created_at': c.createdAt.toIso8601String(),
              'updated_at': c.updatedAt.toIso8601String(),
            },
          )
          .toList(),
      'readings': readings
          .map(
            (r) => {
              'id': r.id,
              'house_id': r.houseId,
              'cycle_id': r.cycleId,
              'date': r.date.toIso8601String(),
              'meter_reading': r.meterReading,
              'units_consumed': r.unitsConsumed,
              'total_cost': r.totalCost,
              'notes': r.notes,
              'created_at': r.createdAt.toIso8601String(),
              'updated_at': r.updatedAt.toIso8601String(),
            },
          )
          .toList(),
    };
  }

  /// Import data from backup (clear existing data first)
  Future<void> importAllData({
    required List<Map<String, dynamic>> houses,
    required List<Map<String, dynamic>> cycles,
    required List<Map<String, dynamic>> readings,
  }) async {
    await _db.transaction(() async {
      // Clear existing data
      await _db.delete(_db.electricityReadingsTable).go();
      await _db.delete(_db.cyclesTable).go();
      await _db.delete(_db.housesTable).go();

      // Insert houses
      for (final house in houses) {
        await _db
            .into(_db.housesTable)
            .insert(
              HousesTableCompanion(
                id: Value(house['id'] as String),
                name: Value(house['name'] as String),
                address: house['address'] != null
                    ? Value(house['address'] as String?)
                    : const Value(null),
                meterNumber: house['meter_number'] != null
                    ? Value(house['meter_number'] as String?)
                    : const Value(null),
                defaultPricePerUnit: Value(
                  house['default_price_per_unit'] != null
                      ? (house['default_price_per_unit'] is int
                            ? (house['default_price_per_unit'] as int)
                                  .toDouble()
                            : house['default_price_per_unit'] as double)
                      : 0.0, // Default value if missing
                ),
                notes: house['notes'] != null
                    ? Value(house['notes'] as String?)
                    : const Value(null),
                createdAt: Value(DateTime.parse(house['created_at'] as String)),
                updatedAt: Value(
                  house['updated_at'] != null
                      ? DateTime.parse(house['updated_at'] as String)
                      : DateTime.now(),
                ),
                // Set sync fields to indicate restored data is already synced
                isDeleted: const Value(false),
                needsSync: const Value(false),
                lastSyncAt: Value(DateTime.now()),
                syncStatus: const Value('synced'),
              ),
              mode: InsertMode.replace,
            );
      }

      // Insert cycles
      for (final cycle in cycles) {
        await _db
            .into(_db.cyclesTable)
            .insert(
              CyclesTableCompanion(
                id: Value(cycle['id'] as String),
                houseId: Value(cycle['house_id'] as String),
                name: Value(cycle['name'] as String),
                startDate: Value(DateTime.parse(cycle['start_date'] as String)),
                endDate: Value(DateTime.parse(cycle['end_date'] as String)),
                maxUnits: Value(cycle['max_units'] as int),
                pricePerUnit: Value(
                  cycle['price_per_unit'] is int
                      ? (cycle['price_per_unit'] as int).toDouble()
                      : cycle['price_per_unit'] as double,
                ),
                initialMeterReading: Value(
                  cycle['initial_meter_reading'] is int
                      ? (cycle['initial_meter_reading'] as int).toDouble()
                      : cycle['initial_meter_reading'] as double,
                ),
                isActive: Value(cycle['is_active'] as bool),
                notes: cycle['notes'] != null
                    ? Value(cycle['notes'] as String?)
                    : const Value(null),
                createdAt: Value(DateTime.parse(cycle['created_at'] as String)),
                updatedAt: Value(
                  cycle['updated_at'] != null
                      ? DateTime.parse(cycle['updated_at'] as String)
                      : DateTime.now(),
                ),
                // Set sync fields
                isDeleted: const Value(false),
                needsSync: const Value(false),
                lastSyncAt: Value(DateTime.now()),
                syncStatus: const Value('synced'),
              ),
              mode: InsertMode.replace,
            );
      }

      // Insert readings
      for (final reading in readings) {
        await _db
            .into(_db.electricityReadingsTable)
            .insert(
              ElectricityReadingsTableCompanion(
                id: Value(reading['id'] as String),
                houseId: Value(reading['house_id'] as String),
                cycleId: Value(reading['cycle_id'] as String),
                date: Value(DateTime.parse(reading['date'] as String)),
                meterReading: Value(
                  reading['meter_reading'] is int
                      ? (reading['meter_reading'] as int).toDouble()
                      : reading['meter_reading'] as double,
                ),
                unitsConsumed: Value(
                  reading['units_consumed'] is int
                      ? (reading['units_consumed'] as int).toDouble()
                      : reading['units_consumed'] as double,
                ),
                totalCost: Value(
                  reading['total_cost'] is int
                      ? (reading['total_cost'] as int).toDouble()
                      : reading['total_cost'] as double,
                ),
                notes: reading['notes'] != null
                    ? Value(reading['notes'] as String?)
                    : const Value(null),
                createdAt: Value(
                  DateTime.parse(reading['created_at'] as String),
                ),
                updatedAt: Value(
                  reading['updated_at'] != null
                      ? DateTime.parse(reading['updated_at'] as String)
                      : DateTime.now(),
                ),
                // Set sync fields
                isDeleted: const Value(false),
                needsSync: const Value(false),
                lastSyncAt: Value(DateTime.now()),
                syncStatus: const Value('synced'),
              ),
              mode: InsertMode.replace,
            );
      }
    });
  }

  /// Mark all items as synced after successful backup
  Future<void> markAllAsSynced() async {
    await _syncRepository.markAllItemsAsSynced();
  }

  /// Mark items as needing sync (called when data is modified)
  Future<void> markAsNeedingSync({
    List<String>? houseIds,
    List<String>? cycleIds,
    List<String>? readingIds,
  }) async {
    await _syncRepository.markItemsAsNeedingSync(
      houseIds: houseIds,
      cycleIds: cycleIds,
      readingIds: readingIds,
    );
  }

  /// Clears all local data (use with caution)
  Future<void> clearAllData({bool includeSyncData = false}) async {
    await _db.transaction(() async {
      await _db.delete(_db.electricityReadingsTable).go();
      await _db.delete(_db.cyclesTable).go();
      await _db.delete(_db.housesTable).go();
    });
    // Optionally, clear or reset any sync tracking if necessary
    if (includeSyncData) {
      await _syncRepository.markAllItemsAsSynced();
    }
  }
}
