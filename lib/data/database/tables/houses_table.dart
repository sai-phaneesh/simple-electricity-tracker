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
  List<String> get customConstraints => const <String>[];
}
