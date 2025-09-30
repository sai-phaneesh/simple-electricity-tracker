import 'package:electricity/core/providers/app_providers.dart';
import 'package:electricity/data/datasources/local/local_sync_tracking_datasource.dart';
import 'package:electricity/data/datasources/sync_tracking_datasource.dart';
import 'package:electricity/data/repositories/sync_tracking_repository_impl.dart';
import 'package:electricity/domain/repositories/sync_tracking_repository.dart';
import 'package:electricity/domain/usecases/sync_tracking_usecases.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Data source provider for sync tracking
final syncTrackingDataSourceProvider = Provider<SyncTrackingDataSource>((ref) {
  final db = ref.read(appDatabaseProvider);
  return LocalSyncTrackingDataSource(db);
});

/// Repository provider for sync tracking
final syncTrackingRepositoryProvider = Provider<SyncTrackingRepository>((ref) {
  final dataSource = ref.read(syncTrackingDataSourceProvider);
  return SyncTrackingRepositoryImpl(dataSource);
});

/// Use case providers
final getPendingBackupCountsUseCaseProvider =
    Provider<GetPendingBackupCountsUseCase>((ref) {
      final repository = ref.read(syncTrackingRepositoryProvider);
      return GetPendingBackupCountsUseCase(repository);
    });

final markAllItemsAsSyncedUseCaseProvider =
    Provider<MarkAllItemsAsSyncedUseCase>((ref) {
      final repository = ref.read(syncTrackingRepositoryProvider);
      return MarkAllItemsAsSyncedUseCase(repository);
    });

final markItemsAsNeedingSyncUseCaseProvider =
    Provider<MarkItemsAsNeedingSyncUseCase>((ref) {
      final repository = ref.read(syncTrackingRepositoryProvider);
      return MarkItemsAsNeedingSyncUseCase(repository);
    });

/// Pending backup counts provider
final pendingBackupCountsProvider = FutureProvider((ref) async {
  final useCase = ref.read(getPendingBackupCountsUseCaseProvider);
  return await useCase.execute();
});
