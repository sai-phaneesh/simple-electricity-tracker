# Quick Reference Guide

## Project Structure

```
lib/
├── core/
│   ├── providers/app_providers.dart    # All Riverpod providers
│   ├── router/app_router.dart          # Navigation routes
│   └── utils/                          # Helper functions
├── data/
│   ├── database/                       # Drift tables & database
│   ├── datasources/                    # Data sources (local)
│   └── repositories/                   # Repository implementations
├── presentation/
│   ├── mobile/features/               # Feature screens
│   └── shared/widgets/                # Reusable widgets
└── main.dart
```

## Key Files

| File                                    | Purpose                |
| --------------------------------------- | ---------------------- |
| `lib/main.dart`                         | App entry point        |
| `lib/core/providers/app_providers.dart` | State management setup |
| `lib/core/router/app_router.dart`       | Route definitions      |
| `lib/data/database/database.dart`       | Drift database setup   |
| `lib/data/database/tables.dart`         | Table schemas          |

## Common Commands

### Development

```bash
# Get dependencies
flutter pub get

# Run app
flutter run                    # Default device
flutter run -d chrome          # Web
flutter run -d macos           # Desktop

# Code generation (Drift)
flutter pub run build_runner build --delete-conflicting-outputs

# Watch for changes
flutter pub run build_runner watch --delete-conflicting-outputs

# Format code
dart format lib/

# Analyze code
flutter analyze

# Run tests
flutter test
```

### Building

```bash
# Android
flutter build apk --release
flutter build appbundle --release

# iOS
flutter build ios --release

# Web
flutter build web --release

# Desktop
flutter build macos --release
flutter build windows --release
flutter build linux --release
```

## Providers Quick Reference

### State Providers

```dart
// Selected IDs
selectedHouseIdProvider          # String?
selectedCycleIdProvider          # String?

// Computed State
selectedHouseProvider            # AsyncValue<House?>
selectedCycleProvider            # AsyncValue<Cycle?>
```

### Stream Providers

```dart
housesStreamProvider                        # Stream<List<House>>
cyclesForSelectedHouseStreamProvider        # Stream<List<Cycle>>
readingsForSelectedCycleStreamProvider      # Stream<List<ElectricityReading>>
```

### Controller Providers

```dart
housesControllerProvider
cyclesControllerProvider
electricityReadingsControllerProvider
```

## Common Patterns

### Read Provider

```dart
// In build method
final houses = ref.watch(housesStreamProvider);

houses.when(
  data: (data) => ListView(...),
  loading: () => CircularProgressIndicator(),
  error: (err, stack) => Text('Error: $err'),
);
```

### Call Controller Method

```dart
// One-time action
ref.read(cyclesControllerProvider).createCycle(...);
```

### Update State

```dart
ref.read(selectedHouseIdProvider.notifier).setHouse(houseId);
```

### Navigation

```dart
// Push named route
context.pushNamed('edit-cycle', pathParameters: {'cycleId': id});

// Pop back
context.pop();
```

## Database Patterns

### Watch Query (Reactive)

```dart
Stream<List<Cycle>> watchCycles(String houseId) {
  return (select(cyclesTable)
    ..where((tbl) =>
      tbl.houseId.equals(houseId) &
      tbl.isDeleted.equals(false)
    )
    ..orderBy([(tbl) => OrderingTerm.desc(tbl.startDate)]))
  .watch();
}
```

### One-Time Query

```dart
Future<Cycle?> getCycle(String id) async {
  return (select(cyclesTable)
    ..where((tbl) => tbl.id.equals(id)))
  .getSingleOrNull();
}
```

### Insert

```dart
await into(cyclesTable).insert(companion);
```

### Update

```dart
await (update(cyclesTable)
  ..where((tbl) => tbl.id.equals(id)))
.write(companion);
```

### Soft Delete

```dart
await (update(cyclesTable)
  ..where((tbl) => tbl.id.equals(id)))
.write(
  CyclesTableCompanion(
    isDeleted: const Value(true),
    updatedAt: Value(DateTime.now()),
  ),
);
```

## UI Patterns

### ConsumerWidget

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(myProvider);
    return Text(data.toString());
  }
}
```

### ConsumerStatefulWidget

```dart
class MyWidget extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends ConsumerState<MyWidget> {
  @override
  Widget build(BuildContext context) {
    final data = ref.watch(myProvider);
    return Text(data.toString());
  }
}
```

## Routes

| Path                   | Name                 | Description      |
| ---------------------- | -------------------- | ---------------- |
| `/`                    | `dashboard`          | Main dashboard   |
| `/create-cycle`        | `create-cycle`       | Create new cycle |
| `/edit-cycle/:cycleId` | `edit-cycle`         | Edit cycle       |
| `/create-consumption`  | `create-consumption` | Record reading   |
| `/settings`            | `settings`           | App settings     |
| `/about`               | `about`              | About screen     |

## Keyboard Shortcuts

| Key                    | Action                  |
| ---------------------- | ----------------------- |
| `Cmd/Ctrl + Shift + P` | VS Code command palette |
| `Shift + Alt + F`      | Format document         |
| `F5`                   | Start debugging         |

## Useful Snippets

### Creating a Provider

```dart
final myProvider = Provider<MyService>((ref) {
  return MyService(ref.watch(dependencyProvider));
});
```

### Creating a Stream Provider

```dart
final myStreamProvider = StreamProvider<List<Data>>((ref) {
  final repo = ref.watch(repositoryProvider);
  return repo.watchData();
});
```

### Creating a State Notifier

```dart
class MyNotifier extends StateNotifier<String?> {
  MyNotifier() : super(null);

  void update(String value) {
    state = value;
  }
}

final myNotifierProvider = StateNotifierProvider<MyNotifier, String?>((ref) {
  return MyNotifier();
});
```

## Troubleshooting Quick Fixes

| Problem                          | Solution                                                                 |
| -------------------------------- | ------------------------------------------------------------------------ |
| Build errors after schema change | Run `flutter pub run build_runner build --delete-conflicting-outputs`    |
| Providers not found              | Check import: `import 'package:flutter_riverpod/flutter_riverpod.dart';` |
| Database file locked             | Close other connections; restart app                                     |
| Navigator context error          | Use `if (context.mounted)` before navigation                             |
| Hot reload not working           | Try hot restart (`Shift + R`)                                            |

## Best Practices

### Do's

✅ Use `const` constructors when possible  
✅ Check `context.mounted` before async operations  
✅ Filter out soft-deleted records in queries  
✅ Use `ref.watch()` in build, `ref.read()` in callbacks  
✅ Handle loading and error states in AsyncValue  
✅ Dispose controllers and listeners

### Don'ts

❌ Don't use `ref.read()` in build method  
❌ Don't forget to check `isDeleted` in queries  
❌ Don't hard-delete records (use soft delete)  
❌ Don't use `setState` in ConsumerWidget  
❌ Don't call async methods without checking mounted  
❌ Don't nest too many builders

## Resources

- [Flutter Docs](https://docs.flutter.dev/)
- [Riverpod Docs](https://riverpod.dev/)
- [Drift Docs](https://drift.simonbinder.eu/)
- [GoRouter Docs](https://pub.dev/packages/go_router)
- [Material Design](https://m3.material.io/)

## Git Workflow

```bash
# Create feature branch
git checkout -b feature/my-feature

# Make changes and commit
git add .
git commit -m "feat: add my feature"

# Push to remote
git push origin feature/my-feature

# Create PR on GitHub
```

## Commit Message Convention

```
type(scope): subject

body (optional)

footer (optional)
```

**Types**: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

**Examples**:

```
feat(cycles): add edit cycle functionality
fix(database): resolve soft delete query issue
docs: update README with new features
```

---

**For detailed documentation, see:**

- [User Guide](USER_GUIDE.md)
- [Architecture](ARCHITECTURE.md)
- [Database Schema](DATABASE.md)
