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
  RealColumn get meterReading => real()();
  RealColumn get unitsConsumed => real()();
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
  List<String> get customConstraints => const <String>[];
}
