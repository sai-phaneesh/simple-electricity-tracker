# Electricity Tracker

A cross-platform Flutter application for tracking household electricity consumption across multiple houses and billing cycles.

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue)
![Dart](https://img.shields.io/badge/Dart-3.9+-blue)

## 📱 Overview

Electricity Tracker helps you manage and monitor electricity usage for multiple properties. Track billing cycles, record meter readings, and analyze consumption patterns over time.

### Key Features

- 🏠 **Multi-House Management**: Track multiple properties independently
- 🔄 **Billing Cycles**: Organize consumption by custom billing periods
- 📊 **Consumption Tracking**: Record meter readings and calculate usage automatically
- ✏️ **Edit Support**: Edit cycles and consumptions with ease
- 💾 **Local Storage**: All data stored locally using Drift (SQLite)
- 🌐 **Cross-Platform**: Works on iOS, Android, Web, Windows, macOS, and Linux
- 🎨 **Modern UI**: Material Design 3 with dark/light theme support

## Project snapshot

| Feature                                                           | Status     |
| ----------------------------------------------------------------- | ---------- |
| Riverpod state management for houses, cycles, readings            | ✅         |
| Drift database (mobile + web executors)                           | ✅         |
| Nested routing with GoRouter (`/houses/:houseId/cycles/:cycleId`) | ✅         |
| Dashboard with horizontal cycle picker and consumption list       | ✅         |
| Drawer-driven house selection & quick actions                     | ✅         |
| Theme switching & settings/about placeholders                     | ✅         |
| Export/backup flows                                               | 🔄 Planned |

## 📖 Documentation

### Quick Access

- **[User Guide](docs/USER_GUIDE.md)** - How to use the application
- **[Architecture](docs/ARCHITECTURE.md)** - Technical architecture and design patterns
- **[Database Schema](docs/DATABASE.md)** - Database structure and relationships
- **[Development Guide](docs/DEVELOPMENT.md)** - Setup and contribution guidelines
- **[API Reference](docs/API.md)** - Code documentation

## 🏗️ Architecture Overview

```
lib/
├── core/                    # Core functionality
│   ├── providers/          # Riverpod providers and controllers
│   ├── router/            # Navigation (GoRouter)
│   └── utils/             # Utilities and helpers
├── data/                   # Data layer
│   ├── database/          # Drift database tables
│   ├── datasources/       # Data sources (local)
│   └── repositories/      # Repository implementations
├── presentation/          # UI layer
│   ├── mobile/           # Mobile-specific UI
│   │   └── features/     # Feature-based organization
│   └── shared/           # Shared widgets
└── main.dart             # App entry point
```

### Tech Stack

- **State Management**: Riverpod
- **Database**: Drift (SQLite)
- **Navigation**: GoRouter
- **Dependency Injection**: GetIt + Riverpod
- **UI**: Material Design 3

### Routes

- `/` – Dashboard (shows selected house/cycle)
- `/create-cycle` – Create or edit billing cycle
- `/edit-cycle/:cycleId` – Edit existing cycle
- `/create-consumption` – Record meter reading
- `/about` – About screen
- `/settings` – App settings

## 🚀 Quick Start

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.9.0+)
- [Dart SDK](https://dart.dev/get-dart) (3.9.0+)

### Installation

```bash
# Clone the repository
git clone https://github.com/sai-phaneesh/simple-electricity-tracker.git
cd simple-electricity-tracker/electricity

# Install dependencies
flutter pub get

# Run the app
flutter run              # Default device
flutter run -d chrome    # Web
flutter run -d macos     # macOS (or windows/linux)
```

### Building for Production

```bash
# Mobile
flutter build apk --release      # Android
flutter build ios --release      # iOS

# Desktop
flutter build macos --release
flutter build windows --release
flutter build linux --release

# Web
flutter build web --release
```

> **Note**: Web builds use IndexedDB by default. For better performance, generate WASM worker files and configure COOP/COEP headers (see [Web Deployment Guide](docs/WEB_DEPLOYMENT.md)).

## 🎯 Features in Detail

### House Management

- Create and manage multiple properties
- Select active house for tracking
- View house-specific consumption history

### Billing Cycles

- Define custom billing periods (start/end dates)
- Set initial meter readings and pricing
- Track maximum unit allocations
- **Edit cycles** via the edit button on cycle summary card
- View cycle summaries with total consumption and costs
- Delete cycles when no longer needed

### Consumption Records

- Record meter readings with timestamps
- Automatic unit and cost calculation
- Visual consumption history
- Edit or delete individual readings

## 📈 Recent Updates (September 2025)

- ✅ **Edit Cycle Feature**: Added edit button to cycle summary card
- ✅ **Improved Navigation**: Streamlined routes with ShellRoute
- ✅ **Cycle Picker**: Horizontal scrollable cycle selector with shimmer loading
- ✅ **Material Buttons**: Updated to use FilledButton/OutlinedButton patterns
- ✅ **State Management**: Migrated from Bloc to Riverpod
- ✅ **Documentation**: Comprehensive docs with organized structure

## 🗺️ Roadmap

- [ ] Data export/import (CSV, JSON)
- [ ] Cloud sync support
- [ ] Advanced analytics and charts
- [ ] Cost predictions based on usage
- [ ] Multi-rate pricing support
- [ ] Notifications for billing cycles
- [ ] Widget support

## 🤝 Contributing

Contributions are welcome! See [CONTRIBUTING.md](docs/CONTRIBUTING.md) for guidelines.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License.

## 💬 Support

- 🐛 **Issues**: [GitHub Issues](https://github.com/sai-phaneesh/simple-electricity-tracker/issues)
- 💬 **Discussions**: [GitHub Discussions](https://github.com/sai-phaneesh/simple-electricity-tracker/discussions)

---

**Built with ❤️ using Flutter**
