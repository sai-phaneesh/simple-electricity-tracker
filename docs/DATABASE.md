# Database Schema Documentation

## Overview

Electricity Tracker uses [Drift](https://drift.simonbinder.eu/), a reactive persistence library for Flutter and Dart, built on top of SQLite.

## Database Structure

### Entity Relationship Diagram

```
┌─────────────┐
│   Houses    │
│─────────────│
│ id (PK)     │──┐
│ name        │  │
│ address     │  │
│ notes       │  │
│ ...         │  │
└─────────────┘  │
                 │
                 │ 1:N
                 │
┌────────────────▼──┐
│     Cycles        │
│───────────────────│
│ id (PK)           │──┐
│ house_id (FK)     │  │
│ name              │  │
│ start_date        │  │
│ end_date          │  │
│ initial_reading   │  │
│ max_units         │  │
│ price_per_unit    │  │
│ is_active         │  │
│ ...               │  │
└───────────────────┘  │
                       │ 1:N
                       │
┌──────────────────────▼───┐
│  ElectricityReadings     │
│──────────────────────────│
│ id (PK)                  │
│ house_id (FK)            │
│ cycle_id (FK)            │
│ date                     │
│ meter_reading            │
│ units_consumed           │
│ total_cost               │
│ notes                    │
│ ...                      │
└──────────────────────────┘
```

## Table Definitions

### Houses Table

**Purpose**: Store property/location information

| Column         | Type    | Constraints                 | Description                                |
| -------------- | ------- | --------------------------- | ------------------------------------------ |
| `id`           | TEXT    | PRIMARY KEY                 | UUID                                       |
| `name`         | TEXT    | NOT NULL                    | House name (e.g., "Main House")            |
| `address`      | TEXT    | NULLABLE                    | Physical address                           |
| `notes`        | TEXT    | NULLABLE                    | Additional notes                           |
| `created_at`   | INTEGER | NOT NULL                    | Unix timestamp (ms)                        |
| `updated_at`   | INTEGER | NOT NULL                    | Unix timestamp (ms)                        |
| `is_deleted`   | INTEGER | NOT NULL, DEFAULT 0         | Soft delete flag (0/1)                     |
| `needs_sync`   | INTEGER | NOT NULL, DEFAULT 1         | Pending sync flag                          |
| `last_sync_at` | INTEGER | NULLABLE                    | Last successful sync time                  |
| `sync_status`  | TEXT    | NOT NULL, DEFAULT 'pending' | Sync status ('pending', 'synced', 'error') |

**Drift Definition** (lib/data/database/tables.dart):

```dart
@DataClassName('House')
class HousesTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get address => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  BoolColumn get needsSync => boolean().withDefault(const Constant(true))();
  DateTimeColumn get lastSyncAt => dateTime().nullable()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}
```

### Cycles Table

**Purpose**: Store billing period information

| Column                  | Type    | Constraints                 | Description                   |
| ----------------------- | ------- | --------------------------- | ----------------------------- |
| `id`                    | TEXT    | PRIMARY KEY                 | UUID                          |
| `house_id`              | TEXT    | NOT NULL, FK                | References houses(id)         |
| `name`                  | TEXT    | NOT NULL                    | Cycle name (e.g., "Jan 2025") |
| `start_date`            | INTEGER | NOT NULL                    | Cycle start (Unix timestamp)  |
| `end_date`              | INTEGER | NOT NULL                    | Cycle end (Unix timestamp)    |
| `initial_meter_reading` | INTEGER | NOT NULL                    | Starting meter value          |
| `max_units`             | INTEGER | NOT NULL                    | Unit allocation               |
| `price_per_unit`        | REAL    | NOT NULL                    | Cost per kWh                  |
| `notes`                 | TEXT    | NULLABLE                    | Additional notes              |
| `is_active`             | INTEGER | NOT NULL, DEFAULT 0         | Active cycle flag             |
| `created_at`            | INTEGER | NOT NULL                    | Created timestamp             |
| `updated_at`            | INTEGER | NOT NULL                    | Updated timestamp             |
| `is_deleted`            | INTEGER | NOT NULL, DEFAULT 0         | Soft delete flag              |
| `needs_sync`            | INTEGER | NOT NULL, DEFAULT 1         | Pending sync flag             |
| `last_sync_at`          | INTEGER | NULLABLE                    | Last sync time                |
| `sync_status`           | TEXT    | NOT NULL, DEFAULT 'pending' | Sync status                   |

**Drift Definition**:

```dart
@DataClassName('Cycle')
class CyclesTable extends Table {
  TextColumn get id => text()();
  TextColumn get houseId => text().references(HousesTable, #id)();
  TextColumn get name => text()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  IntColumn get initialMeterReading => integer()();
  IntColumn get maxUnits => integer()();
  RealColumn get pricePerUnit => real()();
  TextColumn get notes => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  BoolColumn get needsSync => boolean().withDefault(const Constant(true))();
  DateTimeColumn get lastSyncAt => dateTime().nullable()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}
```

### ElectricityReadings Table

**Purpose**: Store individual meter readings

| Column           | Type    | Constraints                 | Description              |
| ---------------- | ------- | --------------------------- | ------------------------ |
| `id`             | TEXT    | PRIMARY KEY                 | UUID                     |
| `house_id`       | TEXT    | NOT NULL, FK                | References houses(id)    |
| `cycle_id`       | TEXT    | NOT NULL, FK                | References cycles(id)    |
| `date`           | INTEGER | NOT NULL                    | Reading timestamp        |
| `meter_reading`  | INTEGER | NOT NULL                    | Meter value              |
| `units_consumed` | INTEGER | NOT NULL                    | Units since last reading |
| `total_cost`     | REAL    | NOT NULL                    | Cost for this reading    |
| `notes`          | TEXT    | NULLABLE                    | Additional notes         |
| `created_at`     | INTEGER | NOT NULL                    | Created timestamp        |
| `updated_at`     | INTEGER | NOT NULL                    | Updated timestamp        |
| `is_deleted`     | INTEGER | NOT NULL, DEFAULT 0         | Soft delete flag         |
| `needs_sync`     | INTEGER | NOT NULL, DEFAULT 1         | Pending sync flag        |
| `last_sync_at`   | INTEGER | NULLABLE                    | Last sync time           |
| `sync_status`    | TEXT    | NOT NULL, DEFAULT 'pending' | Sync status              |

**Drift Definition**:

```dart
@DataClassName('ElectricityReading')
class ElectricityReadingsTable extends Table {
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
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  BoolColumn get needsSync => boolean().withDefault(const Constant(true))();
  DateTimeColumn get lastSyncAt => dateTime().nullable()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}
```

## Indexes

Indexes improve query performance for frequently accessed data:

```dart
// In migration strategy (lib/data/database/database.dart)
onCreate: (m) async {
  await m.createAll();

  // Index for cycle lookups by house
  await m.customStatement(
    'CREATE INDEX idx_cycles_house_id ON cycles(house_id)'
  );

  // Index for reading lookups by cycle
  await m.customStatement(
    'CREATE INDEX idx_readings_cycle_id ON electricity_readings(cycle_id)'
  );

  // Index for date-range queries on cycles
  await m.customStatement(
    'CREATE INDEX idx_cycles_dates ON cycles(start_date, end_date)'
  );
}
```

## Common Queries

### Get All Non-Deleted Houses

```dart
Stream<List<House>> watchAllHouses() {
  return (select(housesTable)
    ..where((tbl) => tbl.isDeleted.equals(false))
    ..orderBy([(tbl) => OrderingTerm.asc(tbl.name)]))
  .watch();
}
```

### Get Cycles for a House

```dart
Stream<List<Cycle>> watchCyclesByHouseId(String houseId) {
  return (select(cyclesTable)
    ..where((tbl) =>
      tbl.houseId.equals(houseId) &
      tbl.isDeleted.equals(false)
    )
    ..orderBy([(tbl) => OrderingTerm.desc(tbl.startDate)]))
  .watch();
}
```

**Order**: Most recent cycle first (by `startDate DESC`)

### Get Readings for a Cycle

```dart
Stream<List<ElectricityReading>> watchReadingsByCycleId(String cycleId) {
  return (select(electricityReadingsTable)
    ..where((tbl) =>
      tbl.cycleId.equals(cycleId) &
      tbl.isDeleted.equals(false)
    )
    ..orderBy([(tbl) => OrderingTerm.desc(tbl.date)]))
  .watch();
}
```

### Create a Cycle

```dart
Future<String> createCycle(CyclesTableCompanion cycle) async {
  final id = cycle.id.present ? cycle.id.value : uuid.v4();
  final now = DateTime.now();

  final cycleWithDefaults = cycle.copyWith(
    id: Value(id),
    createdAt: cycle.createdAt.present ? cycle.createdAt : Value(now),
    updatedAt: Value(now),
    needsSync: const Value(true),
    syncStatus: const Value('pending'),
    isDeleted: const Value(false),
  );

  await into(cyclesTable).insert(cycleWithDefaults);
  return id;
}
```

### Update a Cycle

```dart
Future<void> updateCycle(CyclesTableCompanion cycle) async {
  final updatedCycle = cycle.copyWith(
    updatedAt: Value(DateTime.now()),
    needsSync: const Value(true),
    syncStatus: const Value('pending'),
  );

  await (update(cyclesTable)
    ..where((tbl) => tbl.id.equals(cycle.id.value)))
  .write(updatedCycle);
}
```

### Soft Delete

```dart
Future<void> deleteCycle(String id) async {
  await (update(cyclesTable)
    ..where((tbl) => tbl.id.equals(id)))
  .write(
    CyclesTableCompanion(
      isDeleted: const Value(true),
      needsSync: const Value(true),
      syncStatus: const Value('pending'),
      updatedAt: Value(DateTime.now()),
    ),
  );
}
```

## Migrations

Drift handles schema versioning automatically. Migrations are defined in `lib/data/database/database.dart`:

```dart
@DriftDatabase(
  tables: [HousesTable, CyclesTable, ElectricityReadingsTable],
  include: {'database.drift'},
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
      // Create indexes
      await m.customStatement('CREATE INDEX ...');
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // Handle version upgrades
      if (from < 2) {
        // Add new column
        await m.addColumn(cyclesTable, cyclesTable.notes);
      }
    },
  );
}
```

### Adding a New Column

1. Update table definition in `tables.dart`
2. Increment `schemaVersion` in `database.dart`
3. Add migration logic in `onUpgrade`:

```dart
if (from < 2) {
  await m.addColumn(cyclesTable, cyclesTable.notes);
}
```

4. Run code generation:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Soft Delete Pattern

All tables use soft deletion (`is_deleted` flag) instead of hard deletion:

### Benefits

- **Data recovery**: Deleted items can be restored
- **Sync-friendly**: Propagate deletions to remote servers
- **Audit trail**: Maintain history of changes
- **Referential integrity**: No orphaned foreign keys

### Implementation

```dart
// Instead of:
await delete(cyclesTable).where((tbl) => tbl.id.equals(id)).go();

// Use:
await (update(cyclesTable)
  ..where((tbl) => tbl.id.equals(id)))
.write(
  CyclesTableCompanion(
    isDeleted: const Value(true),
    updatedAt: Value(DateTime.now()),
  ),
);
```

### Filtering in Queries

Always filter out soft-deleted records:

```dart
// Good
select(cyclesTable)
  ..where((tbl) => tbl.isDeleted.equals(false));

// Bad (includes deleted records)
select(cyclesTable);
```

## Sync Fields

Each table has sync-related fields for future cloud sync:

- `needs_sync`: Flag for pending changes
- `last_sync_at`: Last successful sync timestamp
- `sync_status`: Current sync state ('pending', 'synced', 'error')

### Sync Workflow (Future)

1. **Local change**: Set `needs_sync = true`, `sync_status = 'pending'`
2. **Sync process**: Upload changed records to server
3. **Success**: Set `needs_sync = false`, `sync_status = 'synced'`, `last_sync_at = now`
4. **Error**: Set `sync_status = 'error'`

## Data Types

| Drift Type       | SQLite Type | Dart Type | Notes               |
| ---------------- | ----------- | --------- | ------------------- |
| `TextColumn`     | TEXT        | String    |                     |
| `IntColumn`      | INTEGER     | int       |                     |
| `RealColumn`     | REAL        | double    | Floating point      |
| `BoolColumn`     | INTEGER     | bool      | Stored as 0/1       |
| `DateTimeColumn` | INTEGER     | DateTime  | Unix timestamp (ms) |
| `BlobColumn`     | BLOB        | Uint8List | Binary data         |

## Performance Tips

1. **Use indexes**: For frequently queried columns
2. **Batch operations**: Use `batch()` for bulk inserts/updates
3. **Limit results**: Use `limit()` for large datasets
4. **Select specific columns**: Don't always select all columns
5. **Async/Stream queries**: Use `watch()` for reactive UI

## Tools & Commands

### Generate Drift Code

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Watch for Changes

```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

### Inspect Database (Development)

Use Drift's [built-in inspector](https://drift.simonbinder.eu/docs/advanced-features/migrations/#verifying-migrations) or third-party tools like [DB Browser for SQLite](https://sqlitebrowser.org/).

## References

- [Drift Documentation](https://drift.simonbinder.eu/)
- [SQLite Documentation](https://www.sqlite.org/docs.html)
- [Drift GitHub](https://github.com/simolus3/drift)
