import 'package:get_it/get_it.dart';
import 'package:electricity/data/database/database.dart';
import 'package:electricity/data/datasources/houses_datasource.dart';
import 'package:electricity/data/datasources/cycles_datasource.dart';
import 'package:electricity/data/datasources/electricity_readings_datasource.dart';
import 'package:electricity/data/datasources/local/local_houses_datasource.dart';
import 'package:electricity/data/datasources/local/local_cycles_datasource.dart';
import 'package:electricity/data/datasources/local/local_electricity_readings_datasource.dart';
import 'package:electricity/data/repositories/houses_repository_impl.dart';
import 'package:electricity/data/repositories/cycles_repository_impl.dart';
import 'package:electricity/data/services/backup_service.dart';
import 'package:electricity/domain/repositories/cycles_repository.dart';
import 'package:electricity/domain/repositories/houses_repository.dart';

/// Dependency injection container using GetIt
/// Follows Clean Architecture principles for dependency management
class DependencyInjection {
  static final GetIt _getIt = GetIt.instance;

  /// Initialize all dependencies
  static Future<void> init() async {
    // Database
    final database = DatabaseProvider.database;
    _getIt.registerSingleton<AppDatabase>(database);

    // Datasources
    _getIt.registerLazySingleton<HousesDataSource>(
      () => LocalHousesDataSource(_getIt<AppDatabase>()),
    );

    _getIt.registerLazySingleton<CyclesDataSource>(
      () => LocalCyclesDataSource(_getIt<AppDatabase>()),
    );

    _getIt.registerLazySingleton<ElectricityReadingsDataSource>(
      () => LocalElectricityReadingsDataSource(_getIt<AppDatabase>()),
    );

    // Repositories
    _getIt.registerLazySingleton<HousesRepository>(
      () => HousesRepositoryImpl(
        _getIt<HousesDataSource>(),
        _getIt<CyclesDataSource>(),
        _getIt<ElectricityReadingsDataSource>(),
      ),
    );

    _getIt.registerLazySingleton<CyclesRepository>(
      () => CyclesRepositoryImpl(
        _getIt<CyclesDataSource>(),
        _getIt<ElectricityReadingsDataSource>(),
      ),
    );

    // Register BackupService
    _getIt.registerLazySingleton<BackupService>(
      () => BackupService(
        housesDataSource: _getIt<HousesDataSource>(),
        cyclesDataSource: _getIt<CyclesDataSource>(),
        readingsDataSource: _getIt<ElectricityReadingsDataSource>(),
      ),
    );
  }

  /// Get a dependency
  static T get<T extends Object>() => _getIt<T>();

  /// Check if a dependency is registered
  static bool isRegistered<T extends Object>() => _getIt.isRegistered<T>();

  /// Reset all dependencies (useful for testing)
  static Future<void> reset() async {
    await _getIt.reset();
  }
}
