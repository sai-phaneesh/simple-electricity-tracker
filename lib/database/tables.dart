import 'package:drift/drift.dart';

// Cycles table - represents billing cycles
class Cycles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get driftId => text().unique()(); // Maps to your current UUID
  TextColumn get name => text()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  RealColumn get meterReading => real()();
  RealColumn get maxUnits => real()();
  DateTimeColumn get createdOn => dateTime()();
  DateTimeColumn get updatedOn => dateTime()();
}

// Consumptions table - represents meter readings
class Consumptions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get driftId => text().unique()(); // Maps to your current UUID
  IntColumn get cycleId =>
      integer().references(Cycles, #id, onDelete: KeyAction.cascade)();
  RealColumn get meterReading => real()();
  DateTimeColumn get date => dateTime()();
  RealColumn get unitsConsumed => real()();
}
