import 'package:drift/drift.dart';

@DataClassName('House')
class HousesTable extends Table {
  @override
  String get tableName => 'houses';

  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get address => text().nullable()();
  // Meter number for the house's electricity meter (optional)
  // Stored as a string to support alphanumeric meter IDs.
  TextColumn get meterNumber => text().nullable()();
  RealColumn get defaultPricePerUnit => real()();
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
    // Index for timestamp-based queries (most common)
    'CREATE INDEX IF NOT EXISTS houses_updated_at_idx ON houses (updated_at DESC)',
    'CREATE INDEX IF NOT EXISTS houses_created_at_idx ON houses (created_at)',

    // Index for sync status queries
    'CREATE INDEX IF NOT EXISTS houses_sync_status_idx ON houses (needs_sync, sync_status)',
    'CREATE INDEX IF NOT EXISTS houses_deleted_idx ON houses (is_deleted)',

    // Composite index for active houses needing sync
    'CREATE INDEX IF NOT EXISTS houses_active_sync_idx ON houses (is_deleted, needs_sync, updated_at DESC)',
  ];
}
