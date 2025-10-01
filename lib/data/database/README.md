# Drift Database Setup

This project uses Drift as the database solution for both mobile and web platforms.

## Features

- **Cross-platform**: Works on iOS, Android, and Web
- **Type-safe**: Compile-time checked queries
- **Schema migration**: Built-in migration support
- **Auto-generated code**: Database access code is generated automatically

## Database Structure

### Tables

1. **houses** - Store house/property information

   - id (Primary Key)
   - name
   - address
   - defaultPricePerUnit
   - notes
   - createdAt, updatedAt

2. **cycles** - Store billing cycles

   - id (Primary Key)
   - houseId (Foreign Key to houses)
   - name
   - startDate, endDate
   - initialMeterReading
   - maxUnits
   - pricePerUnit
   - notes
   - isActive
   - createdAt, updatedAt

3. **electricity_readings** - Store meter readings
   - id (Primary Key)
   - houseId (Foreign Key to houses)
   - cycleId (Foreign Key to cycles)
   - date
   - meterReading
   - unitsConsumed
   - totalCost
   - notes
   - createdAt, updatedAt

## Usage

### Initialize Database

```dart
import 'package:electricity/core/database/database.dart';

// Initialize database (call once at app startup)
await DatabaseInitializer.initialize();

// Get database instance
final database = DatabaseProvider.database;
```

### Basic Operations

```dart
// Get all houses
final houses = await database.getAllHouses();

// Insert a new house
await database.insertHouse(HousesTableCompanion(
  id: Value('house-id'),
  name: Value('My House'),
  defaultPricePerUnit: Value(5.50),
  createdAt: Value(DateTime.now()),
  updatedAt: Value(DateTime.now()),
));

// Get cycles for a house
final cycles = await database.getCyclesByHouseId('house-id');

// Get readings for a cycle
final readings = await database.getReadingsByCycleId('cycle-id');
```

## Code Generation

When you modify table definitions, run:

```bash
dart run build_runner build
```

Or for continuous building:

```bash
dart run build_runner watch
```

## Web Support

The database automatically works on web using IndexedDB through Drift's web support.

## Migration

Schema migrations are handled in `database_migrations.dart`. When you need to update the schema:

1. Increment `schemaVersion` in `AppDatabase`
2. Add migration logic in `DatabaseMigrations.migrationStrategy`

## Seeding

Sample data is automatically seeded on first run via `DatabaseSeeder.seedDatabase()`.

## Clean Build

If you encounter issues with generated code:

```bash
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```
