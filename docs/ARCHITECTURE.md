# Architecture Documentation

## Overview

Electricity Tracker follows clean architecture principles with clear separation between UI, business logic, and data layers. The app uses Riverpod for state management and Drift for local database operations.

## Layer Architecture

```
┌─────────────────────────────────────────────┐
│         Presentation Layer (UI)              │
│  • Screens, Widgets, Components              │
│  • Consumer Widgets (Riverpod)               │
└──────────────┬──────────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────────┐
│      State Management (Riverpod)             │
│  • Providers (State, Stream, Future)         │
│  • Controllers (Business Logic)              │
│  • Notifiers (Mutable State)                 │
└──────────────┬──────────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────────┐
│           Data Layer                         │
│  • Repositories (Abstract Interfaces)        │
│  • Data Sources (Drift, Local)               │
│  • Database (Drift Tables & DAOs)            │
└─────────────────────────────────────────────┘
```

## Core Components

### 1. Presentation Layer

Located in `lib/presentation/`

#### Structure

```
presentation/
├── mobile/
│   └── features/
│       ├── dashboard/
│       │   ├── components/
│       │   │   ├── cycle_picker_strip.dart
│       │   │   ├── cycle_summary_card.dart
│       │   │   └── consumptions_list_view.dart
│       │   └── screens/
│       │       └── dashboard.dart
│       ├── cycles/
│       │   └── screens/
│       │       └── create_cycle_screen.dart
│       ├── consumptions/
│       │   └── screens/
│       │       └── create_consumption_screen.dart
│       └── settings/
└── shared/
    └── widgets/
        ├── app_drawer.dart
        ├── actions.dart
        └── text_fields/
```

#### Key Principles

- **Feature-based organization**: Each feature has its own folder
- **Component reusability**: Shared widgets in `shared/`
- **Separation of concerns**: Screens orchestrate, components render
- **ConsumerWidget usage**: Widgets read providers reactively

### 2. State Management (Riverpod)

Located in `lib/core/providers/app_providers.dart`

#### Provider Types

```dart
// Stream providers (reactive data)
final housesStreamProvider = StreamProvider<List<House>>(...);
final cyclesForSelectedHouseStreamProvider = StreamProvider<List<Cycle>>(...);
final readingsForSelectedCycleStreamProvider = StreamProvider<List<ElectricityReading>>(...);

// State providers (selected IDs)
final selectedHouseIdProvider = StateNotifierProvider<SelectedHouseIdNotifier, String?>(...);
final selectedCycleIdProvider = StateNotifierProvider<SelectedCycleIdNotifier, String?>(...);

// Computed providers (derived state)
final selectedHouseProvider = StreamProvider<House?>(...);
final selectedCycleProvider = StreamProvider<Cycle?>(...);

// Controller providers (business logic)
final housesControllerProvider = Provider<HousesController>(...);
final cyclesControllerProvider = Provider<CyclesController>(...);
final electricityReadingsControllerProvider = Provider<ElectricityReadingsController>(...);
```

#### State Flow

```
User Action
    ↓
UI Component (ConsumerWidget)
    ↓
ref.read(controllerProvider).method()
    ↓
Controller delegates to Repository
    ↓
Repository calls DataSource
    ↓
DataSource executes Drift query
    ↓
Stream emits new data
    ↓
StreamProvider rebuilds
    ↓
UI updates automatically
```

### 3. Data Layer

#### Repository Pattern

```dart
// Abstract interface
abstract class CyclesRepository {
  Future<String> createCycle({...});
  Future<void> updateCycle({...});
  Future<void> deleteCycle(String id);
  Stream<List<Cycle>> watchCyclesByHouseId(String houseId);
  Future<Cycle?> getCycleById(String id);
}

// Implementation
class CyclesRepositoryImpl implements CyclesRepository {
  final CyclesDataSource _dataSource;

  CyclesRepositoryImpl(this._dataSource);

  @override
  Future<String> createCycle({...}) {
    return _dataSource.createCycle(...);
  }
  // ...
}
```

#### Data Source (Drift)

```dart
class LocalCyclesDataSource implements CyclesDataSource {
  final AppDatabase _database;

  @override
  Stream<List<Cycle>> watchCyclesByHouseId(String houseId) {
    return (_database.select(_database.cyclesTable)
      ..where((tbl) =>
        tbl.houseId.equals(houseId) &
        tbl.isDeleted.equals(false)
      )
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.startDate)]))
    .watch();
  }
}
```

### 4. Navigation (GoRouter)

Located in `lib/core/router/app_router.dart`

#### Route Structure

```dart
GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) => DashboardShell(child: child),
      routes: [
        GoRoute(path: '/', name: 'dashboard', ...),
      ],
    ),
    GoRoute(path: '/create-cycle', name: 'create-cycle', ...),
    GoRoute(path: '/edit-cycle/:cycleId', name: 'edit-cycle', ...),
    GoRoute(path: '/create-consumption', name: 'create-consumption', ...),
    GoRoute(path: '/settings', name: 'settings', ...),
  ],
)
```

#### Navigation Patterns

**Declarative navigation**:

```dart
context.pushNamed('edit-cycle', pathParameters: {'cycleId': id});
```

**Provider-aware shell**:

```dart
class DashboardShell extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final house = ref.watch(selectedHouseProvider).valueOrNull;
    final cycle = ref.watch(selectedCycleProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(...),
      drawer: AppDrawer(),
      body: child,
      floatingActionButton: house != null && cycle != null
        ? FloatingActionButton(...) : null,
    );
  }
}
```

## Database Schema

### Tables

**Houses**

```sql
CREATE TABLE houses (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  address TEXT,
  notes TEXT,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  is_deleted INTEGER NOT NULL DEFAULT 0,
  needs_sync INTEGER NOT NULL DEFAULT 1,
  last_sync_at INTEGER,
  sync_status TEXT NOT NULL DEFAULT 'pending'
);
```

**Cycles**

```sql
CREATE TABLE cycles (
  id TEXT PRIMARY KEY,
  house_id TEXT NOT NULL,
  name TEXT NOT NULL,
  start_date INTEGER NOT NULL,
  end_date INTEGER NOT NULL,
  initial_meter_reading INTEGER NOT NULL,
  max_units INTEGER NOT NULL,
  price_per_unit REAL NOT NULL,
  notes TEXT,
  is_active INTEGER NOT NULL DEFAULT 0,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  is_deleted INTEGER NOT NULL DEFAULT 0,
  needs_sync INTEGER NOT NULL DEFAULT 1,
  last_sync_at INTEGER,
  sync_status TEXT NOT NULL DEFAULT 'pending',
  FOREIGN KEY (house_id) REFERENCES houses(id)
);
```

**ElectricityReadings**

```sql
CREATE TABLE electricity_readings (
  id TEXT PRIMARY KEY,
  house_id TEXT NOT NULL,
  cycle_id TEXT NOT NULL,
  date INTEGER NOT NULL,
  meter_reading INTEGER NOT NULL,
  units_consumed INTEGER NOT NULL,
  total_cost REAL NOT NULL,
  notes TEXT,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  is_deleted INTEGER NOT NULL DEFAULT 0,
  needs_sync INTEGER NOT NULL DEFAULT 1,
  last_sync_at INTEGER,
  sync_status TEXT NOT NULL DEFAULT 'pending',
  FOREIGN KEY (house_id) REFERENCES houses(id),
  FOREIGN KEY (cycle_id) REFERENCES cycles(id)
);
```

### Indexes

Indexes are defined in the migration strategy for performance:

- `idx_cycles_house_id`: Fast cycle lookups by house
- `idx_readings_cycle_id`: Fast reading lookups by cycle
- `idx_cycles_dates`: Fast date-range queries

## Design Patterns

### 1. Repository Pattern

**Purpose**: Abstract data source details from business logic

**Benefits**:

- Testability (mock repositories)
- Flexibility (swap data sources)
- Clean separation

### 2. Provider Pattern (Riverpod)

**Purpose**: Dependency injection and state management

**Benefits**:

- Compile-time safety
- Easy testing
- Automatic disposal
- Provider composition

### 3. MVVM-inspired Architecture

```
View (Widget)
  ↓ reads
Provider (ViewModel)
  ↓ uses
Controller (Business Logic)
  ↓ calls
Repository
  ↓ uses
DataSource (Model)
```

### 4. Reactive Streams

**Purpose**: Real-time UI updates

**How it works**:

1. Drift queries return `Stream<T>`
2. Repository exposes streams
3. `StreamProvider` wraps streams
4. `ConsumerWidget` rebuilds on new data

### 5. Soft Delete Pattern

All entities have `isDeleted` flag instead of hard deletion:

- Allows undo functionality
- Sync-friendly (mark as deleted, sync, then purge)
- Maintains referential integrity

## Key Decisions

### Why Riverpod over Bloc?

- **Type safety**: Compile-time checked dependencies
- **Less boilerplate**: No events/states scaffolding
- **Better composition**: Combine providers easily
- **Easier testing**: Mock providers directly

### Why Drift over sqflite?

- **Type safety**: Compile-time SQL validation
- **Reactive queries**: Built-in stream support
- **Cross-platform**: Web, mobile, desktop
- **Migrations**: Version management built-in

### Why ShellRoute for navigation?

- **Persistent UI**: AppBar and drawer across routes
- **Nested layouts**: Dashboard shell with child routes
- **Cleaner code**: Less repetition

### Ordering Decision: Cycles by startDate DESC

**Location**: `local_cycles_datasource.dart:watchCyclesByHouseId`

**Query**:

```dart
..orderBy([(tbl) => OrderingTerm.desc(tbl.startDate)])
```

**Result**: Most recently started cycle appears **first** in the list.

**Rationale**:

- Users typically work with recent cycles
- Newest-first is intuitive for chronological data
- Matches common billing systems

**Alternative**: To show oldest first, use `OrderingTerm.asc(tbl.startDate)`.

## Performance Considerations

### Database

- **Indexes**: Critical fields indexed
- **Soft deletes**: Filtered in queries (`isDeleted = false`)
- **Batch operations**: Use Drift's `batch` API for bulk ops

### UI

- **Lazy loading**: ListView.builder for long lists
- **Stream providers**: Only rebuild affected widgets
- **Const constructors**: Static widgets marked `const`

### Web

- **WASM option**: Better performance than IndexedDB
- **Service workers**: Cache assets for offline use
- **Code splitting**: Lazy-load routes (future)

## Testing Strategy

### Unit Tests

```dart
test('createCycle adds cycle to repository', () async {
  final mockRepo = MockCyclesRepository();
  final controller = CyclesController(mockRef, mockRepo);

  when(mockRepo.createCycle(...)).thenAnswer((_) async => 'cycle-id');

  final id = await controller.createCycle(...);

  expect(id, 'cycle-id');
  verify(mockRepo.createCycle(...)).called(1);
});
```

### Widget Tests

```dart
testWidgets('Dashboard shows cycle summary when cycle selected', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        selectedCycleProvider.overrideWithValue(
          AsyncValue.data(testCycle),
        ),
      ],
      child: MaterialApp(home: Dashboard()),
    ),
  );

  expect(find.byType(CycleSummaryCard), findsOneWidget);
  expect(find.text(testCycle.name), findsOneWidget);
});
```

### Integration Tests

```dart
testWidgets('End-to-end: Create house, cycle, and reading', (tester) async {
  await tester.pumpWidget(MyApp());

  // Open drawer and create house
  await tester.tap(find.byIcon(Icons.menu));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Create House'));
  // ... continue flow
});
```

## Future Improvements

- [ ] Add use case layer between controllers and repositories
- [ ] Implement offline-first sync mechanism
- [ ] Add analytics/logging infrastructure
- [ ] Introduce feature flags system
- [ ] Performance monitoring integration
