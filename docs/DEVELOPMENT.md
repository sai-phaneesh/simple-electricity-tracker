# 🔧 Electricity Tracker - Developer Guide

## 🚀 **Quick Start**

### **Prerequisites**

- Flutter SDK 3.32.5 or higher
- Dart SDK 3.8.0 or higher
- VS Code with Flutter extensions
- Android Studio (for Android development)
- Xcode (for iOS development - macOS only)

### **Installation**

```bash
# Clone the repository
git clone <repository-url>
cd electricity_tracker

# Install dependencies
flutter pub get

# Run code generation for Drift and Injectable
dart run build_runner build

# Run the app (supports web, mobile, desktop)
flutter run
flutter run -d chrome  # For web development
```

### **Current Implementation Status** ✅

- **Clean Architecture**: ✅ Fully implemented
- **Dependency Injection**: ✅ GetIt + Injectable working
- **Database**: ✅ Drift with cross-platform support (SQLite + IndexedDB)
- **Houses Management**: ✅ Complete CRUD operations
- **Web Support**: ✅ Full web compatibility with data persistence

## 🏗️ **Development Workflow**

### **Code Generation** ✅ **CONFIGURED**

This project uses code generation for:

- **Drift**: Database tables and DAOs ✅ Working
- **Injectable**: Dependency injection ✅ Working
- **json_annotation**: Model serialization (when needed)

```bash
# Generate once
dart run build_runner build

# Watch for changes (recommended during development)
dart run build_runner watch --delete-conflicting-outputs
```

### **Dependency Injection** ✅ **IMPLEMENTED**

The app uses GetIt with Injectable for type-safe dependency injection:

```dart
// Registration is handled automatically in register_module.dart
// Access dependencies using:
final repository = GetIt.instance<HousesRepository>();
final useCase = GetIt.instance<GetAllHousesUseCase>();
```

### **State Management (BLoC Pattern)** ✅ **IMPLEMENTED**

#### **Creating a New Feature**

1. Create feature directory in `lib/features/`
2. Implement data layer (models, repositories)
3. Create domain layer (entities, use cases)
4. Build presentation layer (BLoC, UI)

#### **BLoC Implementation Example**

```dart
// 1. Define Events
abstract class HousesEvent extends Equatable {
  const HousesEvent();

  @override
  List<Object> get props => [];
}

class LoadHouses extends HousesEvent {}

class CreateHouse extends HousesEvent {
  final House house;
  const CreateHouse(this.house);

  @override
  List<Object> get props => [house];
}

// 2. Define States
abstract class HousesState extends Equatable {
  const HousesState();

  @override
  List<Object> get props => [];
}

class HousesInitial extends HousesState {}

class HousesLoading extends HousesState {}

class HousesLoaded extends HousesState {
  final List<House> houses;
  const HousesLoaded(this.houses);

  @override
  List<Object> get props => [houses];
}

// 3. Implement BLoC
class HousesBloc extends Bloc<HousesEvent, HousesState> {
  final HousesRepository repository;

  HousesBloc({required this.repository}) : super(HousesInitial()) {
    on<LoadHouses>(_onLoadHouses);
    on<CreateHouse>(_onCreateHouse);
  }

  Future<void> _onLoadHouses(
    LoadHouses event,
    Emitter<HousesState> emit,
  ) async {
    emit(HousesLoading());
    try {
      final houses = await repository.getAllHouses();
      emit(HousesLoaded(houses));
    } catch (error) {
      emit(HousesError(error.toString()));
    }
  }
}
```

### **Database Operations (Drift)**

#### **Adding a New Table**

1. Define table in `lib/database/tables/`

```dart
class Houses extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get meterNumber => text().unique()();
  RealColumn get defaultPricePerUnit => real().withDefault(const Constant(0.0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
```

2. Create corresponding DAO in `lib/database/daos/`

```dart
@DriftAccessor(tables: [Houses])
class HousesDao extends DatabaseAccessor<AppDatabase> with _$HousesDaoMixin {
  HousesDao(AppDatabase db) : super(db);

  Future<List<House>> getAllHouses() => select(houses).get();

  Future<House> getHouseById(String id) =>
      (select(houses)..where((h) => h.id.equals(id))).getSingle();

  Future<int> insertHouse(HousesCompanion house) =>
      into(houses).insert(house);

  Future<bool> updateHouse(HousesCompanion house) =>
      update(houses).replace(house);

  Stream<List<House>> watchAllHouses() => select(houses).watch();
}
```

3. Register DAO in main database class

```dart
@DriftDatabase(
  tables: [Houses, Cycles, MeterReadings],
  daos: [HousesDao, CyclesDao, ReadingsDao],
)
class AppDatabase extends _$AppDatabase {
  // Implementation
}
```

#### **Database Migrations**

```dart
@override
MigrationStrategy get migration => MigrationStrategy(
  onCreate: (Migrator m) async {
    await m.createAll();
  },
  onUpgrade: (Migrator m, int from, int to) async {
    if (from < 2) {
      // Migration from version 1 to 2
      await m.addColumn(houses, houses.photoPath);
    }
    if (from < 3) {
      // Migration from version 2 to 3
      await m.createTable(users);
    }
  },
);
```

## 🎨 **UI Development**

### **Theme Configuration**

```dart
class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF2196F3),
      brightness: Brightness.light,
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF2196F3),
      brightness: Brightness.dark,
    ),
  );
}
```

### **Responsive Design**

```dart
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    Key? key,
    required this.mobile,
    this.tablet,
    this.desktop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return mobile;
        } else if (constraints.maxWidth < 1100) {
          return tablet ?? mobile;
        } else {
          return desktop ?? tablet ?? mobile;
        }
      },
    );
  }
}
```

### **Custom Widgets**

#### **Meter Reading Card**

```dart
class MeterReadingCard extends StatelessWidget {
  final MeterReading reading;
  final VoidCallback? onTap;

  const MeterReadingCard({
    Key? key,
    required this.reading,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${reading.reading} kWh',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text(
                    '₹${reading.costCalculated.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                DateFormat('MMM dd, yyyy • hh:mm a').format(reading.timestamp),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              if (reading.notes?.isNotEmpty == true) ...[
                const SizedBox(height: 8),
                Text(
                  reading.notes!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
```

## 🧪 **Testing Strategy**

### **Unit Tests**

```dart
// test/features/houses/bloc/houses_bloc_test.dart
void main() {
  group('HousesBloc', () {
    late HousesBloc housesBloc;
    late MockHousesRepository mockRepository;

    setUp(() {
      mockRepository = MockHousesRepository();
      housesBloc = HousesBloc(repository: mockRepository);
    });

    test('initial state is HousesInitial', () {
      expect(housesBloc.state, equals(HousesInitial()));
    });

    blocTest<HousesBloc, HousesState>(
      'emits [HousesLoading, HousesLoaded] when LoadHouses is added',
      build: () {
        when(() => mockRepository.getAllHouses())
            .thenAnswer((_) async => [testHouse]);
        return housesBloc;
      },
      act: (bloc) => bloc.add(LoadHouses()),
      expect: () => [
        HousesLoading(),
        HousesLoaded([testHouse]),
      ],
    );
  });
}
```

### **Widget Tests**

```dart
// test/features/houses/presentation/widgets/house_card_test.dart
void main() {
  testWidgets('HouseCard displays house information correctly', (tester) async {
    const testHouse = House(
      id: '1',
      name: 'Test House',
      meterNumber: '12345',
      // ... other properties
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HouseCard(house: testHouse),
        ),
      ),
    );

    expect(find.text('Test House'), findsOneWidget);
    expect(find.text('12345'), findsOneWidget);
  });
}
```

### **Integration Tests**

```dart
// integration_test/app_test.dart
void main() {
  group('App Integration Tests', () {
    testWidgets('complete house creation flow', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to house creation
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Fill house form
      await tester.enterText(find.byType(TextFormField).first, 'Test House');
      await tester.enterText(find.byType(TextFormField).at(1), '12345');

      // Submit form
      await tester.tap(find.text('Create House'));
      await tester.pumpAndSettle();

      // Verify house appears in list
      expect(find.text('Test House'), findsOneWidget);
    });
  });
}
```

## 🔍 **Debugging**

### **Common Issues**

#### **Database Issues**

```bash
# Clear database during development
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

#### **Code Generation Issues**

```bash
# Force regenerate all files
dart run build_runner build --delete-conflicting-outputs
```

#### **Performance Profiling**

```bash
# Run with profiling enabled
flutter run --profile
```

### **Debugging Tools**

#### **Drift Inspector**

```dart
// Add to main.dart for development
if (kDebugMode) {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
}
```

#### **BLoC Observer**

```dart
class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    log('Created: ${bloc.runtimeType}');
  }

  @override
  void onEvent(BlocBase bloc, Object? event) {
    super.onEvent(bloc, event);
    log('Event: ${bloc.runtimeType} - $event');
  }

  @override
  void onTransition(BlocBase bloc, Transition transition) {
    super.onTransition(bloc, transition);
    log('Transition: ${bloc.runtimeType} - $transition');
  }
}
```

## 📦 **Build & Deployment**

### **Android Build**

```bash
# Debug build
flutter build apk --debug

# Release build
flutter build apk --release

# App Bundle for Play Store
flutter build appbundle --release
```

### **iOS Build**

```bash
# Debug build
flutter build ios --debug

# Release build
flutter build ios --release
```

### **Web Build**

```bash
# Development build
flutter build web

# Production build with optimization
flutter build web --release --web-renderer canvaskit
```

### **Environment Configuration**

```dart
// lib/core/config/app_config.dart
class AppConfig {
  static const String appName = String.fromEnvironment(
    'APP_NAME',
    defaultValue: 'Electricity Tracker',
  );

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.example.com',
  );

  static const bool enableAnalytics = bool.fromEnvironment(
    'ENABLE_ANALYTICS',
    defaultValue: true,
  );
}
```

## 🔐 **Security Best Practices**

### **Data Protection**

- Encrypt sensitive data in local storage
- Use secure key storage for API keys
- Implement certificate pinning for API calls
- Validate all user inputs

### **Authentication Security**

```dart
class SecureStorage {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainItemAccessibility.first_unlock_this_device,
    ),
  );

  static Future<void> storeToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }
}
```

## 📈 **Performance Optimization**

### **Database Optimization**

- Use proper indexes on frequently queried columns
- Implement pagination for large datasets
- Use streams for real-time updates
- Cache frequently accessed data

### **UI Performance**

- Use `const` constructors where possible
- Implement lazy loading for lists
- Optimize image loading and caching
- Use `AutomaticKeepAliveClientMixin` for expensive widgets

### **Memory Management**

```dart
class OptimizedListView extends StatefulWidget {
  @override
  _OptimizedListViewState createState() => _OptimizedListViewState();
}

class _OptimizedListViewState extends State<OptimizedListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return const ListTile(
          // Use const constructors
          leading: Icon(Icons.home),
          title: Text('House'),
        );
      },
      // Set item extent for better performance
      itemExtent: 72.0,
    );
  }
}
```

---

_This guide covers the essential development patterns and practices for the Electricity Tracker app. Follow these guidelines for consistent, maintainable code._
