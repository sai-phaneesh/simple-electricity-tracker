import 'package:drift/drift.dart';
import 'houses_table.dart';

@DataClassName('Cycle')
class CyclesTable extends Table {
  @override
  String get tableName => 'cycles';

  TextColumn get id => text()();
  TextColumn get houseId => text().references(HousesTable, #id)();
  TextColumn get name => text()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  IntColumn get initialMeterReading => integer()();
  IntColumn get maxUnits => integer()();
  RealColumn get pricePerUnit => real()();
  TextColumn get notes => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
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
    // Index for house-based queries (very common)
    'CREATE INDEX IF NOT EXISTS cycles_house_id_idx ON cycles (house_id)',

    // Index for timestamp-based queries
    'CREATE INDEX IF NOT EXISTS cycles_updated_at_idx ON cycles (updated_at DESC)',
    'CREATE INDEX IF NOT EXISTS cycles_start_date_idx ON cycles (start_date DESC)',

    // Index for active cycle queries per house
    'CREATE INDEX IF NOT EXISTS cycles_active_idx ON cycles (house_id, is_active, is_deleted)',

    // Index for sync status queries
    'CREATE INDEX IF NOT EXISTS cycles_sync_status_idx ON cycles (needs_sync, sync_status)',
    'CREATE INDEX IF NOT EXISTS cycles_deleted_idx ON cycles (is_deleted)',

    // Composite indexes for common query patterns
    'CREATE INDEX IF NOT EXISTS cycles_house_active_idx ON cycles (house_id, is_deleted, is_active, start_date DESC)',
    'CREATE INDEX IF NOT EXISTS cycles_house_sync_idx ON cycles (house_id, needs_sync, updated_at DESC)',
    'CREATE INDEX IF NOT EXISTS cycles_date_range_idx ON cycles (start_date, end_date, is_deleted)',
  ];
}
