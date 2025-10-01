# Clean Architecture Migration - Sync Tracking

## Overview

Successfully migrated sync tracking functionality from inline code to proper Clean Architecture layers.

## Migration Summary

### ✅ **Before (Problems Fixed):**

- Providers mixed directly in settings screen
- Direct database access in UI layer
- Mixed concerns in BackupService
- No separation between data sources and repositories
- Business logic scattered across layers

### ✅ **After (Clean Architecture):**

- Proper layer separation (Domain → Data → Presentation → Core)
- Repository pattern for data access
- Use cases for business logic
- Dependency injection via Riverpod
- Reusable components

## New Architecture Structure

### 1. **Domain Layer** (`lib/domain/`)

```
entities/
  ├── pending_backup_counts.dart      # Entity for pending counts
  └── backup_metadata.dart            # Existing backup metadata

repositories/
  ├── sync_tracking_repository.dart   # Repository interface
  └── backup_repository.dart          # Existing backup repo

usecases/
  ├── sync_tracking_usecases.dart     # 3 use cases for sync operations
  └── backup_usecases.dart            # Existing backup use cases
```

### 2. **Data Layer** (`lib/data/`)

```
datasources/
  ├── sync_tracking_datasource.dart             # Abstract data source
  └── local/
      └── local_sync_tracking_datasource.dart   # Drift implementation

repositories/
  ├── sync_tracking_repository_impl.dart        # Repository implementation
  └── supabase_backup_repository.dart           # Existing backup repo
```

### 3. **Manager Layer** (`lib/manager/`)

```
backup_service.dart                   # Updated to use repository
```

### 4. **Core Layer** (`lib/core/providers/`)

```
sync_tracking_providers.dart         # All sync-related providers
backup_providers.dart                # Existing backup providers
app_providers.dart                   # Existing app providers
```

### 5. **Presentation Layer** (`lib/presentation/`)

```
shared/widgets/
  └── pending_backup_indicator.dart             # Reusable widget

mobile/features/settings/pages/
  └── settings_screen.dart                      # Clean, focused screen
```

## Key Components Created

### Domain Layer

#### `PendingBackupCounts` Entity

```dart
class PendingBackupCounts {
  final int houses;
  final int cycles;
  final int readings;
  final bool isFirstBackup;

  bool get hasPending => houses > 0 || cycles > 0 || readings > 0;
}
```

#### `SyncTrackingRepository` Interface

```dart
abstract class SyncTrackingRepository {
  Future<PendingBackupCounts> getPendingBackupCounts();
  Future<void> markAllItemsAsSynced();
  Future<void> markItemsAsNeedingSync({...});
}
```

#### Use Cases

1. **`GetPendingBackupCountsUseCase`** - Get pending counts
2. **`MarkAllItemsAsSyncedUseCase`** - Mark as synced after backup
3. **`MarkItemsAsNeedingSyncUseCase`** - Mark for sync when modified

### Data Layer

#### `SyncTrackingDataSource` Interface

```dart
abstract class SyncTrackingDataSource {
  Future<List<House>> getHousesNeedingSync();
  Future<List<Cycle>> getCyclesNeedingSync();
  Future<List<ElectricityReading>> getReadingsNeedingSync();
  // ... sync management methods
}
```

#### `LocalSyncTrackingDataSource` Implementation

- Uses Drift queries: `db.select(table).where(needsSync = true)`
- Filters soft-deleted items
- Transaction-based sync updates
- Efficient batch operations

### Presentation Layer

#### `PendingBackupIndicator` Widget

- Reusable component for any screen
- Uses `pendingBackupCountsProvider`
- Clean separation from business logic
- Consistent theming

## Provider Architecture

### Dependency Injection Chain

```
AppDatabase → SyncTrackingDataSource → SyncTrackingRepository → UseCases → Providers
```

### Provider Hierarchy

```dart
// Data Layer
syncTrackingDataSourceProvider → LocalSyncTrackingDataSource(db)
syncTrackingRepositoryProvider → SyncTrackingRepositoryImpl(dataSource)

// Use Cases
getPendingBackupCountsUseCaseProvider → GetPendingBackupCountsUseCase(repository)
markAllItemsAsSyncedUseCaseProvider → MarkAllItemsAsSyncedUseCase(repository)
markItemsAsNeedingSyncUseCaseProvider → MarkItemsAsNeedingSyncUseCase(repository)

// Presentation
pendingBackupCountsProvider → useCase.execute()
```

## Updated Components

### BackupService (Manager Layer)

**Before:**

```dart
BackupService(AppDatabase db)
// Direct database queries for sync operations
```

**After:**

```dart
BackupService(AppDatabase db, SyncTrackingRepository syncRepository)
// Delegates sync operations to repository
```

### Settings Screen (Presentation)

**Before:**

```dart
// 100+ lines of provider and widget code mixed in
final _pendingBackupProvider = FutureProvider((ref) async {
  final db = ref.read(appDatabaseProvider);
  // Direct database queries...
});

class _PendingBackupIndicator extends ConsumerWidget {
  // 50+ lines of UI code...
}
```

**After:**

```dart
// Clean imports and simple widget usage
const PendingBackupIndicator()
```

## Benefits Achieved

### ✅ **Separation of Concerns**

- Domain logic isolated from UI
- Data access abstracted behind repositories
- Business rules in use cases

### ✅ **Testability**

- Each layer can be unit tested independently
- Mock repositories for testing use cases
- Mock data sources for testing repositories

### ✅ **Maintainability**

- Single responsibility principle
- Clear dependency flow
- Easy to modify individual layers

### ✅ **Reusability**

- `PendingBackupIndicator` can be used anywhere
- Use cases can be shared across features
- Repository can support multiple UI patterns

### ✅ **Scalability**

- Easy to add new sync-related features
- Can swap data sources (e.g., add remote sync)
- Provider system supports lazy loading

## Migration Checklist

- [x] Create domain entities
- [x] Create repository interfaces
- [x] Create use cases
- [x] Create data source interfaces
- [x] Implement local data source
- [x] Implement repository
- [x] Create providers
- [x] Create reusable widgets
- [x] Update backup service
- [x] Update settings screen
- [x] Remove old inline code
- [x] Verify compilation
- [x] Update documentation

## Next Steps

1. **Integration Testing** - Test the full flow end-to-end
2. **CRUD Integration** - Update create/update/delete operations to use `markItemsAsNeedingSyncUseCase`
3. **Error Handling** - Add proper error states and retry mechanisms
4. **Performance** - Monitor provider efficiency with large datasets
5. **Remote Sync** - Future extension to support cloud sync data sources

## Files Created/Modified

### New Files Created (9 files)

1. `lib/domain/entities/pending_backup_counts.dart`
2. `lib/domain/repositories/sync_tracking_repository.dart`
3. `lib/domain/usecases/sync_tracking_usecases.dart`
4. `lib/data/datasources/sync_tracking_datasource.dart`
5. `lib/data/datasources/local/local_sync_tracking_datasource.dart`
6. `lib/data/repositories/sync_tracking_repository_impl.dart`
7. `lib/core/providers/sync_tracking_providers.dart`
8. `lib/presentation/shared/widgets/pending_backup_indicator.dart`
9. `docs/CLEAN_ARCHITECTURE_MIGRATION.md` (this file)

### Files Modified (2 files)

1. `lib/manager/backup_service.dart` - Updated to use repository
2. `lib/presentation/mobile/features/settings/pages/settings_screen.dart` - Simplified and cleaned

## Architecture Validation

✅ **Domain Layer** - No dependencies on other layers
✅ **Data Layer** - Only depends on Domain
✅ **Presentation Layer** - Uses Core providers, not direct data access
✅ **Core Layer** - Orchestrates dependency injection
✅ **Manager Layer** - Uses repositories, not direct data access

The migration successfully implements Clean Architecture principles with proper separation of concerns!
