# Sync Integration TODO - UPDATED

## Next Steps for CRUD Integration

✅ **COMPLETED**: Clean Architecture foundation
✅ **COMPLETED**: Sync tracking repository and use cases created  
✅ **COMPLETED**: PendingBackupIndicator widget extracted
✅ **COMPLETED**: BackupService updated to use repository pattern
✅ **COMPLETED**: All components compile successfully

⚠️ **NEXT PRIORITY**: CRUD operations still need sync integration

## Current Architecture Summary

### Clean Architecture Layers Implemented:

1. **Domain Layer**: Entities, repository interfaces, use cases
2. **Data Layer**: Data sources (abstract + Drift), repository implementations
3. **Manager Layer**: BackupService using repositories
4. **Core Layer**: Riverpod providers for dependency injection
5. **Presentation Layer**: Extracted reusable widgets

### Key Components Available:

- `MarkItemsAsNeedingSyncUseCase` - Ready for CRUD integration
- `PendingBackupIndicator` - Shows real-time pending counts
- `SyncTrackingRepository` - Abstracts all sync operations
- Provider chain: Database → DataSource → Repository → UseCase → UI

## Integration Required

All create, update, and delete operations for the following entities need to call `markItemsAsNeedingSyncUseCase`:

### 1. Houses (`lib/features/houses/`)

- **Create house**: Mark new house as needing sync
- **Update house**: Mark modified house as needing sync
- **Delete house**: Mark house as deleted and needing sync

### 2. Cycles (`lib/features/cycles/`)

- **Create cycle**: Mark new cycle as needing sync
- **Update cycle**: Mark modified cycle as needing sync
- **Delete cycle**: Mark cycle as deleted and needing sync

### 3. Electricity Readings (`lib/features/readings/`)

- **Create reading**: Mark new reading as needing sync
- **Update reading**: Mark modified reading as needing sync
- **Delete reading**: Mark reading as deleted and needing sync

## Implementation Pattern

For each CRUD operation, follow this pattern:

```dart
// Import the use case provider
import '../../core/providers/sync_tracking_providers.dart';

// After successful database operation
try {
  // 1. Perform the database operation (insert/update/delete)
  await database.operation();

  // 2. Mark items as needing sync
  await ref.read(markItemsAsNeedingSyncUseCaseProvider)(
    MarkItemsAsNeedingSyncParams(
      houseIds: operation == 'house' ? [houseId] : null,
      cycleIds: operation == 'cycle' ? [cycleId] : null,
      readingIds: operation == 'reading' ? [readingId] : null,
    ),
  );

  // 3. Success feedback
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Item saved and marked for backup')),
  );
} catch (e) {
  // Error handling
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Error: $e')),
  );
}
```

## Files to Update

Look for CRUD operations in these locations:

- `lib/features/houses/` - House management forms/dialogs
- `lib/features/cycles/` - Cycle management forms/dialogs
- `lib/features/readings/` - Reading management forms/dialogs
- Any other forms or dialogs that modify data

## Testing Strategy

After implementation:

1. **Create Test**: Create any item → Check `PendingBackupIndicator` shows +1
2. **Update Test**: Modify existing item → Check indicator increases
3. **Delete Test**: Delete item → Check indicator increases
4. **Backup Test**: Perform backup → Verify indicator shows 0
5. **Full Cycle**: Modify items → Backup → Modify again → Verify cycle works

This ensures true change tracking rather than superficial count-based tracking.

## Verification Checklist

After CRUD integration is complete:

- [ ] House creation marks item for sync
- [ ] House editing marks item for sync
- [ ] House deletion marks item for sync
- [ ] Cycle creation marks item for sync
- [ ] Cycle editing marks item for sync
- [ ] Cycle deletion marks item for sync
- [ ] Reading creation marks item for sync
- [ ] Reading editing marks item for sync
- [ ] Reading deletion marks item for sync
- [ ] PendingBackupIndicator updates in real-time
- [ ] Backup clears all pending items
- [ ] Full sync cycle works end-to-end

## Architecture Documentation

See `docs/CLEAN_ARCHITECTURE_MIGRATION.md` for complete details on the implemented architecture and migration process.
