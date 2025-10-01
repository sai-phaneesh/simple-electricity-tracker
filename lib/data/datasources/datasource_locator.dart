import 'package:electricity/data/database/database.dart';
import 'package:electricity/data/datasources/houses_datasource.dart';
import 'package:electricity/data/datasources/cycles_datasource.dart';
import 'package:electricity/data/datasources/electricity_readings_datasource.dart';
import 'package:electricity/data/datasources/local/local_houses_datasource.dart';
import 'package:electricity/data/datasources/local/local_cycles_datasource.dart';
import 'package:electricity/data/datasources/local/local_electricity_readings_datasource.dart';

/// Service locator for datasource instances following Clean Architecture principles
/// This follows the offline-first approach where local datasources are used
/// by default and remote datasources can be added later for sync functionality
class DataSourceLocator {
  final AppDatabase _database;

  // Singleton instances
  HousesDataSource? _housesDataSource;
  CyclesDataSource? _cyclesDataSource;
  ElectricityReadingsDataSource? _electricityReadingsDataSource;

  DataSourceLocator(this._database);

  /// Get the Houses datasource (offline-first local implementation)
  HousesDataSource get houses {
    _housesDataSource ??= LocalHousesDataSource(_database);
    return _housesDataSource!;
  }

  /// Get the Cycles datasource (offline-first local implementation)
  CyclesDataSource get cycles {
    _cyclesDataSource ??= LocalCyclesDataSource(_database);
    return _cyclesDataSource!;
  }

  /// Get the Electricity Readings datasource (offline-first local implementation)
  ElectricityReadingsDataSource get electricityReadings {
    _electricityReadingsDataSource ??= LocalElectricityReadingsDataSource(
      _database,
    );
    return _electricityReadingsDataSource!;
  }

  /// Get all items that need to be synced across all datasources
  Future<Map<String, int>> getAllItemsNeedingSync() async {
    final housesNeedingSync = await houses.getHousesNeedingSync();
    final cyclesNeedingSync = await cycles.getCyclesNeedingSync();
    final readingsNeedingSync = await electricityReadings
        .getReadingsNeedingSync();

    return {
      'houses': housesNeedingSync.length,
      'cycles': cyclesNeedingSync.length,
      'readings': readingsNeedingSync.length,
    };
  }

  /// Get the total count of items across all datasources
  Future<Map<String, int>> getAllItemsCounts() async {
    final housesCount = await houses.getHousesCount();
    final cyclesCount = await cycles.getCyclesCount();
    final readingsCount = await electricityReadings.getReadingsCount();

    return {
      'houses': housesCount,
      'cycles': cyclesCount,
      'readings': readingsCount,
    };
  }

  /// Get the last sync time across all datasources
  Future<DateTime?> getLastSyncTime() async {
    final housesLastSync = await houses.getLastSyncTime();
    final cyclesLastSync = await cycles.getLastSyncTime();
    final readingsLastSync = await electricityReadings.getLastSyncTime();

    final syncTimes = [
      housesLastSync,
      cyclesLastSync,
      readingsLastSync,
    ].where((time) => time != null).cast<DateTime>().toList();

    if (syncTimes.isEmpty) return null;

    // Return the earliest sync time (most out of date)
    syncTimes.sort();
    return syncTimes.first;
  }

  /// Check if any data needs to be synced
  Future<bool> hasDataNeedingSync() async {
    final syncCounts = await getAllItemsNeedingSync();
    return syncCounts.values.any((count) => count > 0);
  }

  /// Reset all datasource instances (useful for testing or changing implementations)
  void reset() {
    _housesDataSource = null;
    _cyclesDataSource = null;
    _electricityReadingsDataSource = null;
  }

  /// Get database statistics for monitoring
  Future<Map<String, dynamic>> getDatabaseStats() async {
    final counts = await getAllItemsCounts();
    final syncCounts = await getAllItemsNeedingSync();
    final lastSync = await getLastSyncTime();

    return {
      'total_items': counts,
      'items_needing_sync': syncCounts,
      'last_sync_time': lastSync?.toIso8601String(),
      'has_pending_sync': await hasDataNeedingSync(),
    };
  }
}
