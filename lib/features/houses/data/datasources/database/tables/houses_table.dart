import 'package:drift/drift.dart';

@DataClassName('HouseDbModel')
@TableIndex(name: 'houses_type_idx', columns: {#houseType})
@TableIndex(name: 'houses_ownership_idx', columns: {#ownershipType})
@TableIndex(name: 'houses_name_idx', columns: {#name})
@TableIndex(name: 'houses_created_idx', columns: {#createdAt})
@TableIndex(name: 'houses_type_created_idx', columns: {#houseType, #createdAt})
@TableIndex(
  name: 'houses_ownership_created_idx',
  columns: {#ownershipType, #createdAt},
)
@TableIndex(name: 'houses_meter_idx', columns: {#meterNumber})
class Houses extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get address => text().withLength(min: 1, max: 255)();
  TextColumn get houseType => text().withLength(min: 1, max: 50)();
  TextColumn get ownershipType => text().withLength(min: 1, max: 50)();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  // Electricity tracking fields
  TextColumn get meterNumber => text()
      .withLength(min: 1, max: 50)
      .withDefault(const Constant('METER-DEFAULT'))();
  RealColumn get defaultPricePerUnit =>
      real().withDefault(const Constant(0.0))();
  RealColumn get freeUnitsPerMonth => real().withDefault(const Constant(0.0))();
  RealColumn get warningLimitUnits =>
      real().withDefault(const Constant(1000.0))();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
