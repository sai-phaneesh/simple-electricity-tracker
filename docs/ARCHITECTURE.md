# 📐 Electricity Tracker - Technical Architecture

## 🏗️ **Application Architecture**

### **Architecture Pattern: Clean Architecture + BLoC + GetIt DI** ✅ **IMPLEMENTED**

```
Presentation Layer (UI)
    ↓
Business Logic Layer (BLoC)
    ↓
Use Cases (Domain Logic)
    ↓
Repository Interfaces (Domain)
    ↓
Repository Implementations (Data)
    ↓
Data Sources (Local: Drift Database)
    ↓
Database Layer (SQLite + IndexedDB for Web)
```

### **Dependency Injection** ✅ **IMPLEMENTED**

- **GetIt**: Service locator for dependency management
- **Injectable**: Code generation for type-safe DI
- **Module-based Registration**: Centralized DI configuration in `register_module.dart`

### **Directory Structure** ✅ **IMPLEMENTED**

```
lib/
├── core/                           # Core utilities and DI
│   ├── di/                         # ✅ Dependency injection setup
│   │   ├── service_locator_new.dart
│   │   └── register_module.dart
│   ├── constants/
│   ├── errors/
│   └── utils/
├── features/                       # Feature-based modules
│   ├── houses/                     # ✅ COMPLETED
│   │   ├── data/
│   │   │   ├── datasources/        # ✅ Local database datasource
│   │   │   │   └── database/       # ✅ Drift database with web support
│   │   │   ├── models/             # ✅ Data models
│   │   │   └── repositories/       # ✅ Repository implementations
│   │   ├── domain/
│   │   │   ├── entities/           # ✅ Domain entities
│   │   │   ├── repositories/       # ✅ Repository interfaces
│   │   │   └── usecases/           # ✅ Business logic use cases
│   │   └── presentation/
│   │       ├── bloc/               # ✅ State management
│   │       ├── screens/            # ✅ UI screens
│   │       └── widgets/            # ✅ Reusable widgets
│   ├── cycles/                     # 📝 NEXT
│   ├── readings/                   # 📋 PENDING
│   ├── analytics/                  # 📋 PENDING
│   └── settings/                   # 📋 PENDING
├── shared/                         # Shared components
│   ├── widgets/                    # ✅ Common UI components
│   ├── themes/
│   └── extensions/
└── main.dart                       # ✅ App initialization with DI
```

│ ├── daos/
│ └── migrations/
└── main.dart

````

## 🗂️ **Data Models**

### **House Entity**

```dart
class House {
  final String id;
  final String name;
  final String meterNumber;
  final double defaultPricePerUnit;
  final double freeUnitsPerMonth;
  final double warningLimitUnits;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isArchived;
  final String? photoPath;
  final String? notes;

  // Computed properties
  Cycle? get activeCycle;
  double get totalConsumption;
  double get currentMonthSavings;
}
````

### **Cycle Entity**

```dart
class Cycle {
  final String id;
  final String houseId;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final double startMeterReading;
  final bool isActive;
  final bool isArchived;

  // Overridable from house
  final double pricePerUnit;
  final double freeUnitsForCycle;
  final double warningLimit;

  final DateTime createdAt;
  final DateTime updatedAt;

  // Computed properties
  List<MeterReading> get readings;
  double get totalUnitsConsumed;
  double get totalCost;
  double get moneySaved;
  double get averagePerDay;
  CycleStatus get status;
}
```

### **Meter Reading Entity**

```dart
class MeterReading {
  final String id;
  final String cycleId;
  final double reading;
  final DateTime timestamp;
  final double unitsConsumed;
  final double costCalculated;
  final String? notes;
  final String? photoPath;
  final DateTime createdAt;

  // Computed properties
  double get unitsSinceLastReading;
  bool get isWarningLevel;
}
```

### **User Entity**

```dart
class User {
  final String id;
  final String email;
  final String displayName;
  final String? photoURL;
  final SubscriptionType subscriptionType;
  final DateTime? subscriptionExpiresAt;
  final DateTime createdAt;
  final DateTime lastLoginAt;

  // Settings
  final UserPreferences preferences;
  final NotificationSettings notifications;
}
```

## 🔄 **State Management**

### **BLoC Structure per Feature**

#### **Houses BLoC**

```dart
// Events
abstract class HousesEvent {}
class LoadHouses extends HousesEvent {}
class CreateHouse extends HousesEvent {}
class UpdateHouse extends HousesEvent {}
class DeleteHouse extends HousesEvent {}
class ArchiveHouse extends HousesEvent {}
class SearchHouses extends HousesEvent {}

// States
abstract class HousesState {}
class HousesInitial extends HousesState {}
class HousesLoading extends HousesState {}
class HousesLoaded extends HousesState {}
class HousesError extends HousesState {}
```

#### **Cycles BLoC**

```dart
// Events
abstract class CyclesEvent {}
class LoadCycles extends CyclesEvent {}
class CreateCycle extends CyclesEvent {}
class ActivateCycle extends CyclesEvent {}
class DeactivateCycle extends CyclesEvent {}
class ArchiveCycle extends CyclesEvent {}

// States
abstract class CyclesState {}
class CyclesInitial extends CyclesState {}
class CyclesLoading extends CyclesState {}
class CyclesLoaded extends CyclesState {}
class CycleActivated extends CyclesState {}
class CyclesError extends CyclesState {}
```

## 🗄️ **Database Design**

### **Tables Schema**

```sql
-- Houses Table
CREATE TABLE houses (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  name TEXT NOT NULL,
  meter_number TEXT UNIQUE NOT NULL,
  default_price_per_unit REAL NOT NULL DEFAULT 0.0,
  free_units_per_month REAL NOT NULL DEFAULT 0.0,
  warning_limit_units REAL NOT NULL DEFAULT 200.0,
  photo_path TEXT,
  notes TEXT,
  is_archived BOOLEAN NOT NULL DEFAULT FALSE,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL
);

-- Cycles Table
CREATE TABLE cycles (
  id TEXT PRIMARY KEY,
  house_id TEXT NOT NULL,
  name TEXT NOT NULL,
  start_date INTEGER NOT NULL,
  end_date INTEGER NOT NULL,
  start_meter_reading REAL NOT NULL,
  is_active BOOLEAN NOT NULL DEFAULT FALSE,
  is_archived BOOLEAN NOT NULL DEFAULT FALSE,
  price_per_unit REAL NOT NULL,
  free_units_for_cycle REAL NOT NULL,
  warning_limit REAL NOT NULL,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  FOREIGN KEY (house_id) REFERENCES houses (id) ON DELETE CASCADE
);

-- Meter Readings Table
CREATE TABLE meter_readings (
  id TEXT PRIMARY KEY,
  cycle_id TEXT NOT NULL,
  reading REAL NOT NULL,
  timestamp INTEGER NOT NULL,
  units_consumed REAL NOT NULL,
  cost_calculated REAL NOT NULL,
  notes TEXT,
  photo_path TEXT,
  created_at INTEGER NOT NULL,
  FOREIGN KEY (cycle_id) REFERENCES cycles (id) ON DELETE CASCADE
);

-- Users Table (for premium features)
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  display_name TEXT NOT NULL,
  photo_url TEXT,
  subscription_type TEXT NOT NULL DEFAULT 'FREE',
  subscription_expires_at INTEGER,
  created_at INTEGER NOT NULL,
  last_login_at INTEGER NOT NULL
);
```

### **Indexes for Performance**

```sql
CREATE INDEX idx_houses_user_id ON houses(user_id);
CREATE INDEX idx_houses_meter_number ON houses(meter_number);
CREATE INDEX idx_cycles_house_id ON cycles(house_id);
CREATE INDEX idx_cycles_active ON cycles(is_active);
CREATE INDEX idx_readings_cycle_id ON meter_readings(cycle_id);
CREATE INDEX idx_readings_timestamp ON meter_readings(timestamp);
```

## 🚦 **Navigation Structure**

### **GoRouter Configuration**

```dart
final router = GoRouter(
  initialLocation: '/houses',
  routes: [
    // Bottom Navigation Routes
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/houses',
          builder: (context, state) => HousesScreen(),
          routes: [
            GoRoute(
              path: '/:houseId',
              builder: (context, state) => HouseDetailsScreen(
                houseId: state.pathParameters['houseId']!,
              ),
              routes: [
                GoRoute(
                  path: '/cycles/:cycleId',
                  builder: (context, state) => CycleDetailsScreen(),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: '/analytics',
          builder: (context, state) => AnalyticsScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => ProfileScreen(),
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => SettingsScreen(),
            ),
          ],
        ),
      ],
    ),

    // Auth Routes
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(),
    ),

    // Onboarding
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => OnboardingScreen(),
    ),
  ],
);
```

## 🔐 **Authentication Flow**

### **Authentication States**

```dart
enum AuthStatus {
  initial,
  authenticated,
  unauthenticated,
  loading,
}

class AuthState {
  final AuthStatus status;
  final User? user;
  final String? error;

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isGuest => user == null && status == AuthStatus.unauthenticated;
}
```

### **Social Login Providers**

- **Google Sign-In** (All platforms)
- **Apple Sign-In** (iOS/macOS required)
- **Facebook Login** (Optional)
- **Anonymous Mode** (Guest users)

## 💾 **Data Persistence Strategy**

### **Local Storage (Drift)**

- Primary data storage
- Offline-first approach
- Local caching for performance

### **Cloud Sync (Premium)**

- Real-time synchronization
- Conflict resolution
- Cross-device support

### **Backup/Export**

- JSON export for free users
- Cloud backup for premium users
- Manual backup to device storage

## 📊 **Analytics Implementation**

### **Chart Types**

- **Line Charts**: Consumption over time
- **Bar Charts**: Monthly comparisons
- **Pie Charts**: Cost breakdown
- **Heatmaps**: Calendar consumption view

### **Analytics Data Points**

- Daily/Weekly/Monthly consumption
- Cost analysis with savings
- Efficiency metrics
- Peak usage identification
- Trends and predictions

## 🔄 **Business Logic Rules**

### **House Rules**

1. Meter number must be unique across all houses
2. Default settings can be overridden at cycle level
3. Only one active cycle per house at any time
4. Archived houses retain all historical data

### **Cycle Rules**

1. Start reading must be >= last cycle's end reading
2. End date must be after start date
3. Creating new cycle auto-deactivates previous
4. Active cycles cannot be deleted, only archived

### **Reading Rules**

1. New reading must be >= previous reading
2. Significant jumps trigger validation warnings
3. Cost calculated based on free units and pricing tiers
4. Readings can only be added to active cycles

## 🎯 **Performance Targets**

### **App Performance**

- Cold start: < 2 seconds
- Database queries: < 50ms
- UI responsiveness: 60fps
- Memory usage: < 100MB

### **User Experience**

- Crash rate: < 0.1%
- ANR rate: < 0.1%
- Network success rate: > 99%
- Offline functionality: Full CRUD operations

---

_This architecture supports scalability, maintainability, and performance across all target platforms._
