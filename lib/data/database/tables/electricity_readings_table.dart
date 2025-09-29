import 'package:drift/drift.dart';
import 'houses_table.dart';
import 'cycles_table.dart';

@DataClassName('ElectricityReading')
class ElectricityReadingsTable extends Table {
  @override
  String get tableName => 'electricity_readings';

  TextColumn get id => text()();
  TextColumn get houseId => text().references(HousesTable, #id)();
  TextColumn get cycleId => text().references(CyclesTable, #id)();
  DateTimeColumn get date => dateTime()();
  IntColumn get meterReading => integer()();
  IntColumn get unitsConsumed => integer()();
  RealColumn get totalCost => real()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  // Sync status fields
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  BoolColumn get needsSync => boolean().withDefault(const Constant(true))();
  DateTimeColumn get lastSyncAt => dateTime().nullable()();
  TextColumn get syncStatus => text().withDefault(
    const Constant('pending'),
  )(); // 'pending', 'synced', 'error'

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>>? get uniqueKeys => null;

  // Indexes for performance optimization
  @override
  List<String> get customConstraints => [
    // Index for house-based queries
    'CREATE INDEX IF NOT EXISTS readings_house_id_idx ON electricity_readings (house_id)',

    // Index for cycle-based queries (very common)
    'CREATE INDEX IF NOT EXISTS readings_cycle_id_idx ON electricity_readings (cycle_id)',

    // Index for timestamp-based queries (most common pattern)
    'CREATE INDEX IF NOT EXISTS readings_date_idx ON electricity_readings (date DESC)',
    'CREATE INDEX IF NOT EXISTS readings_updated_at_idx ON electricity_readings (updated_at DESC)',

    // Index for sync status queries
    'CREATE INDEX IF NOT EXISTS readings_sync_status_idx ON electricity_readings (needs_sync, sync_status)',
    'CREATE INDEX IF NOT EXISTS readings_deleted_idx ON electricity_readings (is_deleted)',

    // Composite indexes for common query patterns
    'CREATE INDEX IF NOT EXISTS readings_cycle_date_idx ON electricity_readings (cycle_id, date DESC, is_deleted)',
    'CREATE INDEX IF NOT EXISTS readings_house_date_idx ON electricity_readings (house_id, date DESC, is_deleted)',
    'CREATE INDEX IF NOT EXISTS readings_cycle_sync_idx ON electricity_readings (cycle_id, needs_sync, updated_at DESC)',
    'CREATE INDEX IF NOT EXISTS readings_house_sync_idx ON electricity_readings (house_id, needs_sync, updated_at DESC)',

    // Index for date range queries
    'CREATE INDEX IF NOT EXISTS readings_date_range_idx ON electricity_readings (date DESC, is_deleted)',

    // Index for latest reading queries
    'CREATE INDEX IF NOT EXISTS readings_latest_idx ON electricity_readings (cycle_id, is_deleted, date DESC)',
  ];
}
