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
  RealColumn get initialMeterReading => real()();
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
  List<String> get customConstraints => const <String>[];
}
