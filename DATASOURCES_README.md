# Electricity Tracker - Offline-First Architecture

This project now implements a complete offline-first architecture with repositories, datasources, and sync status tracking. All data operations work locally first, with the ability to sync to Firebase later.

## 🏗️ Architecture Overview

### Database Layer

- **SQLite** for mobile platforms
- **IndexedDB** for web platforms
- **Drift ORM** for type-safe database operations
- **Cross-platform compatibility** with single codebase

### Datasource Layer (Offline-First)

- **Local Datasources**: Primary data operations (SQLite/IndexedDB)
- **Remote Datasources**: Future Firebase integration for sync
- **Sync Status Tracking**: Every record tracks sync state
- **Service Locator**: Dependency injection for datasources

### Repository Layer (Business Logic)

- **Houses Repository**: Manages house operations and aggregations
- **Cycles Repository**: Handles billing cycles with business rules
- **Electricity Readings Repository**: Manages readings with validation
- **Dependency Container**: Clean Architecture dependency injection

## 📊 Database Tables

All tables include sync status fields:

- `isDeleted`: Soft delete flag
- `needsSync`: Indicates if item needs to be synced
- `lastSyncAt`: Timestamp of last successful sync
- `syncStatus`: 'pending', 'synced', or 'error'

### Houses Table

```dart
TextColumn get id => text()();
TextColumn get name => text()();
TextColumn get address => text().nullable()();
RealColumn get defaultPricePerUnit => real()();
DateTimeColumn get createdAt => dateTime()();
DateTimeColumn get updatedAt => dateTime()();
// + sync status fields
```

### Cycles Table

```dart
TextColumn get id => text()();
TextColumn get houseId => text().references(HousesTable, #id)();
TextColumn get name => text()();
DateTimeColumn get startDate => dateTime()();
DateTimeColumn get endDate => dateTime()();
IntColumn get initialMeterReading => integer()();
IntColumn get maxUnits => integer()();
RealColumn get pricePerUnit => real()();
BoolColumn get isActive => boolean()();
TextColumn get notes => text().nullable()();
DateTimeColumn get createdAt => dateTime()();
DateTimeColumn get updatedAt => dateTime()();
// + sync status fields
```

### Electricity Readings Table

```dart
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
// + sync status fields
```

## 🔧 Datasource Interfaces

### HousesDataSource

- Basic CRUD operations
- Search and filtering
- Sync status management
- Batch operations

### CyclesDataSource

- Basic CRUD operations
- House-specific cycles
- Active cycle management
- Date range queries
- Sync status management

### ElectricityReadingsDataSource

- Basic CRUD operations
- Cycle and house-specific readings
- Date range queries
- Consumption analytics
- Monthly statistics
- Sync status management

## �️ Clean Architecture Pattern

```dart
// Initialize the database and dependency injection containers
final database = await DatabaseProvider.instance.database;
final dataSources = DataSourceLocator(database);
final repositories = RepositoryContainer(dataSources);

// Access repositories (recommended for business logic)
final houses = await repositories.houses.getAllHouses();
final cycles = await repositories.cycles.getCyclesByHouseId(houseId);
final readings = await repositories.electricityReadings.getReadingsByCycleId(cycleId);

// Direct datasource access (for advanced use cases)
final housesData = await dataSources.houses.getAllHouses();
```

## 📱 Usage in Your App

### 1. Initialize dependency containers in your app

```dart
// In your main.dart or dependency injection setup
final database = await DatabaseProvider.instance.database;
final dataSources = DataSourceLocator(database);
final repositories = RepositoryContainer(dataSources);
```

### 2. Use repositories for business operations

```dart
// Create a house (with business logic)
final houseId = await repositories.houses.createHouse(
  name: 'My House',
  address: '123 Main St',
  defaultPricePerUnit: 0.15,
);

// Create a cycle (automatically handles activation logic)
final cycleId = await repositories.cycles.createCycle(
  houseId: houseId,
  name: 'January 2024',
  startDate: DateTime(2024, 1, 1),
  endDate: DateTime(2024, 1, 31),
  initialMeterReading: 1000,
  maxUnits: 500,
  pricePerUnit: 0.15,
  isActive: true, // Automatically deactivates other cycles
);

// Create readings (with validation)
await repositories.electricityReadings.createReading(
  houseId: houseId,
  cycleId: cycleId,
  date: DateTime.now(),
  meterReading: 1100,
  unitsConsumed: 100,
  totalCost: 15.0,
);
```

### 3. Get comprehensive statistics

```dart
// House statistics with aggregated data
final houseStats = await repositories.houses.getHouseStatistics(houseId);
print('Total cost: ${houseStats['total_cost']}');

// Cycle progress and analytics
final cycleStats = await repositories.cycles.getCycleStatistics(cycleId);
print('Progress: ${cycleStats['progress_percentage']}%');

// Reading trends and patterns
final readingStats = await repositories.electricityReadings.getReadingStatistics(cycleId);
print('Daily average: ${readingStats['average_daily_consumption']}');
```

### 4. Check sync status across all data

```dart
// Get comprehensive sync statistics
final syncStats = await repositories.getAllSyncStatistics();
print('Total items needing sync: ${syncStats['total_needing_sync']}');
print('Has data needing sync: ${syncStats['has_data_needing_sync']}');
```

## 🔄 Sync Workflow

### Local Operations (Always Work)

```dart
// All operations work offline and are automatically marked for sync
await dataSources.houses.createHouse(houseData);
await dataSources.cycles.updateCycle(cycleData);
await dataSources.electricityReadings.deleteReading(readingId);
```

### Sync to Firebase (Future)

```dart
// Get all data needing sync
final housesNeedingSync = await dataSources.houses.getHousesNeedingSync();
final cyclesNeedingSync = await dataSources.cycles.getCyclesNeedingSync();
final readingsNeedingSync = await dataSources.electricityReadings.getReadingsNeedingSync();

// After successful Firebase upload
await dataSources.houses.markHouseAsSynced(houseId);
await dataSources.cycles.markCycleAsSynced(cycleId);
await dataSources.electricityReadings.markReadingAsSynced(readingId);
```

## 🎯 Key Benefits

### ✅ Offline-First

- All operations work without internet
- Data persists across app restarts
- Immediate UI feedback

### ✅ Sync Ready

- Every item tracks sync status
- Easy to identify what needs syncing
- Support for sync error handling

### ✅ Type Safety

- Drift generates type-safe database classes
- Compile-time error checking
- Auto-completion in IDE

### ✅ Cross-Platform

- Same code works on mobile and web
- SQLite on mobile, IndexedDB on web
- Consistent API across platforms

### ✅ Scalable Architecture

- Clean separation of concerns
- Easy to add new datasources
- Testable components

## 🛠️ Available Operations

### CRUD Operations

- Create, Read, Update, Delete for all entities
- Batch operations for performance
- Soft delete with recovery options

### Filtering & Search

- Date range queries
- Text search across fields
- Status-based filtering
- Complex query support

### Analytics

- Monthly consumption statistics
- Average usage calculations
- Cost analysis
- Usage trend data

### Sync Management

- Track sync status per item
- Batch sync operations
- Error handling and retry logic
- Last sync time tracking

## 🎯 Repository Benefits

### ✅ Business Logic Separation

- Validation and business rules in repositories
- Clean separation from data access layer
- Reusable business operations

### ✅ Data Coordination

- Combines multiple datasources for complex operations
- Handles cascading operations (e.g., delete house → delete cycles → delete readings)
- Maintains data consistency

### ✅ Advanced Analytics

- Cross-entity statistics and reporting
- Trend analysis and consumption patterns
- Progress tracking and forecasting

## 🚀 Next Steps

1. **BLoC Integration**: Connect repositories to your existing BLoC architecture
2. **Firebase Sync**: Implement remote datasources for Firebase integration
3. **Offline Indicators**: Add UI to show sync status and offline mode
4. **Background Sync**: Implement periodic sync when app is backgrounded
5. **Advanced Analytics**: Build dashboards using repository analytics methods

The foundation is now complete with a robust, offline-first electricity tracking application featuring a complete repository and datasource architecture!
