# 🔌 Electricity Tracker

A comprehensive Flutter application for tracking electricity consumption across multiple billing cycles. Monitor your meter readings, calculate consumption patterns, and manage billing cycles with ease.

## ✨ Features

### 📊 **Cycle Management**

- Create and manage multiple electricity billing cycles
- Set start and end dates for each cycle
- Define maximum units and initial meter readings
- Track consumption duration in days

### 📈 **Consumption Tracking**

- Record meter readings with timestamps
- Automatic calculation of units consumed
- Historical consumption data visualization
- Real-time consumption monitoring

### 🎨 **User Experience**

- Clean, Material Design 3 interface
- Dark and light theme support with system preference detection
- Responsive design for various screen sizes
- Intuitive navigation with drawer-based cycle selection

### 💾 **Data Persistence**

- **Drift Database**: Cross-platform SQLite database with web support via IndexedDB
- **Local Storage**: Persistent data storage across all platforms (mobile, desktop, web)
- **Automatic State Management**: HydratedBloc for UI state persistence
- **Database Migrations**: Structured schema versioning and data integrity

### 🏗️ **Architecture**

- **Clean Architecture**: Separation of concerns with domain, data, and presentation layers
- **Dependency Injection**: GetIt service locator with Injectable code generation
- **BLoC Pattern**: Reactive state management with proper event handling
- **Repository Pattern**: Abstract data layer with multiple data source support

### 📱 **Platform Support**

- ✅ **Android** (Primary)
- ✅ **iOS**
- ✅ **Web** (Full IndexedDB persistence support)
- ✅ **macOS**
- ✅ **Linux**
- ✅ **Windows**

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.32.5 or higher
- Dart 3.8.0 or higher
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/sai-phaneesh/simple-electricity-tracker.git
   cd simple-electricity-tracker/electricity
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Generate code and run the application**

   ```bash
   # Generate database and DI code
   dart run build_runner build --delete-conflicting-outputs

   # Run the application
   flutter run
   ```

### Running on Web

For web development with hot reload:

```bash
flutter run -d chrome --web-port 8080 --web-experimental-hot-reload
```

### Building for Release

**Android APK:**

```bash
flutter build apk --release
```

**Android App Bundle:**

```bash
flutter build appbundle --release
```

**Web:**

```bash
flutter build web --release
```

## 🏗️ Architecture

The app follows **Clean Architecture** principles with **BLoC (Business Logic Component)** pattern and **Dependency Injection**:

```
lib/
├── bloc/                    # Legacy state management
│   ├── dashboard_bloc.dart
│   ├── dashboard_event.dart
│   ├── dashboard_state.dart
│   └── models.dart
├── core/                    # Core application infrastructure
│   ├── di/                  # Dependency injection setup
│   │   ├── service_locator_new.dart
│   │   ├── register_module.dart
│   │   └── service_locator_new.config.dart
│   └── router/              # Application routing
├── features/                # Feature-based modules (Clean Architecture)
│   └── houses/              # Houses feature
│       ├── data/            # Data layer
│       │   ├── datasources/ # Local and remote data sources
│       │   ├── models/      # Data models
│       │   └── repositories/ # Repository implementations
│       ├── domain/          # Domain layer
│       │   ├── entities/    # Business entities
│       │   ├── repositories/ # Repository contracts
│       │   └── usecases/    # Business use cases
│       └── presentation/    # Presentation layer
│           ├── bloc/        # Feature-specific BLoCs
│           ├── screens/     # UI screens
│           └── widgets/     # UI components
├── shared/                  # Shared utilities and widgets
│   ├── theme/              # App theming
│   ├── widgets/            # Reusable widgets
│   └── utils/              # Utility functions
└── utils/                   # Helper utilities
    ├── extensions/
    ├── formatters/
    └── helpers/
```

### Key Components

- **Clean Architecture**: Domain-driven design with clear separation of business logic
- **GetIt + Injectable**: Type-safe dependency injection with code generation
- **Drift Database**: Cross-platform SQLite database with web IndexedDB support
- **BLoC Pattern**: Reactive state management for UI components
- **Repository Pattern**: Abstract data access with multiple data source support
- **Use Cases**: Encapsulated business logic operations
- **HydratedBloc**: Automatic state persistence for UI preferences

## 📦 Dependencies

### Core Dependencies

- **flutter_bloc** (^9.1.1): State management
- **hydrated_bloc** (^10.1.1): State persistence
- **equatable** (^2.0.7): Value equality
- **uuid** (^4.5.1): Unique identifier generation
- **go_router** (^16.0.0): Declarative navigation

### Database & Storage

- **drift** (^2.16.0): Cross-platform database toolkit
- **drift_flutter** (^0.2.5): Flutter-specific Drift integration with web support
- **sqlite3_flutter_libs** (^0.5.0): SQLite native libraries
- **shared_preferences** (^2.5.3): Local preferences
- **path_provider** (^2.1.5): File system paths

### Dependency Injection

- **get_it** (^8.0.0): Service locator pattern
- **injectable** (^2.5.0): Code generation annotations

### UI & UX

- **google_fonts** (^6.2.1): Typography
- **another_flushbar** (^1.12.30): Toast notifications
- **intl** (^0.20.2): Internationalization

### Development

- **flutter_lints** (^6.0.0): Code quality
- **flutter_test**: Testing framework
- **drift_dev** (^2.16.0): Database code generation
- **build_runner** (^2.4.7): Code generation runner
- **injectable_generator** (^2.6.2): DI code generation

## 📋 Usage Guide

### 1. Creating Your First Cycle

1. Open the app and tap **"Select a cycle"**
2. In the drawer, tap **"Create Cycle"**
3. Fill in the cycle details:
   - **Name**: Billing cycle identifier (e.g., "January 2025")
   - **Start Date**: Cycle start date
   - **End Date**: Cycle end date
   - **Initial Reading**: Current meter reading
   - **Max Units**: Maximum units for the cycle
4. Tap **"Submit"**

### 2. Recording Consumption

1. Select a cycle from the drawer
2. Tap the **"+"** floating action button
3. Enter the current meter reading
4. Tap **"Submit"**

The app automatically calculates:

- Units consumed since last reading
- Total consumption for the cycle
- Consumption timeline

### 3. Managing Data

- **Switch Cycles**: Use the drawer to switch between different cycles
- **Delete Cycle**: Long-press a cycle in the drawer
- **Delete Reading**: Long-press a consumption entry
- **Theme Toggle**: Use the theme switcher in the drawer

## 🎨 Screenshots

### Dashboard

- Cycle summary with total consumption
- Historical consumption timeline
- Quick access to add new readings

### Cycle Management

- Easy cycle creation and selection
- Visual cycle duration display
- Consumption tracking per cycle

### Settings

- Theme preference management
- About screen with app information

## 🔧 Configuration

### Android Configuration

- **compileSdk**: 34
- **minSdk**: 21
- **targetSdk**: 34
- **NDK Version**: 27.0.12077973
- **Java Version**: 11

### Theme Configuration

- **Primary Color**: Custom seed color
- **Font Family**: Poppins (Google Fonts)
- **Design System**: Material Design 3
- **Theme Modes**: Light, Dark, System

## 🧪 Testing

Run tests using:

```bash
flutter test
```

### Test Coverage

- Widget tests for UI components
- Unit tests for business logic
- Integration tests for user workflows

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines

- Follow Flutter/Dart style guide
- Write tests for new features
- Update documentation as needed
- Use conventional commit messages

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🏷️ Version History

- **v1.1.0**: Architecture overhaul and web support
  - ✅ Clean Architecture implementation
  - ✅ GetIt dependency injection with Injectable
  - ✅ Drift database with full web support (IndexedDB)
  - ✅ Cross-platform data persistence
  - ✅ Houses management feature
  - ✅ Improved project structure
- **v1.0.0**: Initial release with core functionality
  - Cycle management
  - Consumption tracking
  - Theme support
  - Data persistence

## 🙋‍♂️ Support

For support, questions, or feature requests:

- Create an [Issue](https://github.com/sai-phaneesh/simple-electricity-tracker/issues)
- Reach out via [Discussions](https://github.com/sai-phaneesh/simple-electricity-tracker/discussions)

## 🎯 Roadmap

### Recently Completed ✅

- **Clean Architecture**: Full domain-driven design implementation
- **Dependency Injection**: GetIt with Injectable code generation
- **Web Support**: Full web compatibility with IndexedDB persistence
- **Database Modernization**: Drift database replacing legacy storage
- **Houses Management**: Complete CRUD operations for houses

### Future Enhancements

- [ ] Electricity consumption tracking per house
- [ ] Data export functionality (CSV, PDF)
- [ ] Consumption analytics and charts
- [ ] Bill estimation and notifications
- [ ] Multi-user support
- [ ] Cloud synchronization
- [ ] Consumption prediction using ML
- [ ] Widget support for quick readings
- [ ] Offline-first architecture improvements

---

**Built with ❤️ using Flutter**

_Happy tracking! 🔌📊_

---

## 🤖 Machine-Readable Project Status (For Automation / Copilot Assist)

```
project:
   name: electricity_tracker
   sdk:
      flutter: ">=3.32.5"
      dart: ">=3.9.0 <4.0.0"
   architecture:
      patterns:
         - clean_architecture
         - bloc
         - repository_pattern
         - drift_database
      di: get_it + injectable
   persistence:
      local: drift (sqlite / indexeddb web)
      state: hydrated_bloc (planned selective usage)
   features:
      houses:
         status: implemented
         filter: bloc + HousesFilter (persist planned via hydrated bloc)
      cycles:
         status: planned (not implemented fully)
      meter_readings:
         status: planned
      analytics:
         status: planned
      auth_sync:
         status: planned (firebase target)
      notifications:
         status: planned
      ads:
         status: planned
      payments:
         status: planned
   premium_tiers:
      free:
         limits:
            houses: unlimited (current) # may change
      premium:
         planned: remove_ads, unlimited_backup_restore, 2_devices
      diamond:
         planned: realtime_sync_multi_device_unlimited
   recent_changes:
      - refactored houses bloc to single filter object
      - added FocusWrapper widget for global unfocus on tap
      - added DeviceInfoService + DI registration
      - roadmap updated with auth/sync/ads/payments tiers
   next_actions:
      - scaffold auth repository interface
      - add firebase_core & firebase_auth dependencies
      - implement HydratedBloc for HousesFilter persistence
      - design cycle & reading entities + migrations
   technical_debt:
      - legacy dashboard bloc folder (candidate for removal)
      - missing tests for houses bloc & database migrations
      - no error boundary / global exception handling
   automation_notes:
      codegen: build_runner (drift + injectable)
      run_generate: dart run build_runner build --delete-conflicting-outputs
      lint: flutter analyze
      test: flutter test
```
