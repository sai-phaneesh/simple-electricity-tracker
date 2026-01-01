import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:electricity/data/datasources/cycles_datasource.dart';
import 'package:electricity/data/datasources/datasource_locator.dart';
import 'package:electricity/data/datasources/electricity_readings_datasource.dart';
import 'package:electricity/data/datasources/houses_datasource.dart';
import 'package:electricity/data/datasources/local/preferences/shared_pref_manager.dart';
import 'package:electricity/data/repositories/cycles_repository_impl.dart';
import 'package:electricity/data/repositories/electricity_readings_repository_impl.dart';
import 'package:electricity/data/repositories/houses_repository_impl.dart';
import 'package:electricity/domain/entities/house.dart';
import 'package:electricity/domain/entities/cycle.dart';
import 'package:electricity/domain/entities/electricity_reading.dart';
import 'package:electricity/domain/repositories/cycles_repository.dart';
import 'package:electricity/domain/repositories/electricity_readings_repository.dart';
import 'package:electricity/domain/repositories/houses_repository.dart';
import 'package:electricity/core/providers/supabase_provider.dart';

/// Core dependency providers
final sharedPrefManagerProvider = Provider<SharedPrefManager>((ref) {
  return SharedPrefManager();
});

final dataSourceLocatorProvider = Provider<DataSourceLocator>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return DataSourceLocator(supabase);
});

final housesDataSourceProvider = Provider<HousesDataSource>((ref) {
  return ref.watch(dataSourceLocatorProvider).houses;
});

final cyclesDataSourceProvider = Provider<CyclesDataSource>((ref) {
  return ref.watch(dataSourceLocatorProvider).cycles;
});

final electricityReadingsDataSourceProvider =
    Provider<ElectricityReadingsDataSource>((ref) {
      return ref.watch(dataSourceLocatorProvider).electricityReadings;
    });

final housesRepositoryProvider = Provider<HousesRepository>((ref) {
  return HousesRepositoryImpl(
    ref.watch(housesDataSourceProvider),
    ref.watch(cyclesDataSourceProvider),
    ref.watch(electricityReadingsDataSourceProvider),
  );
});

final cyclesRepositoryProvider = Provider<CyclesRepository>((ref) {
  return CyclesRepositoryImpl(
    ref.watch(cyclesDataSourceProvider),
    ref.watch(electricityReadingsDataSourceProvider),
  );
});

final electricityReadingsRepositoryProvider =
    Provider<ElectricityReadingsRepository>((ref) {
      return ElectricityReadingsRepositoryImpl(
        ref.watch(dataSourceLocatorProvider),
      );
    });

/// Stream providers for reactive collections
final housesStreamProvider = StreamProvider<List<House>>((ref) {
  return ref.watch(housesDataSourceProvider).watchAllHouses();
});

final cyclesForSelectedHouseStreamProvider =
    StreamProvider.autoDispose<List<Cycle>>((ref) {
      final selectedHouseId = ref.watch(selectedHouseIdProvider);
      if (selectedHouseId == null) {
        return Stream.value(const <Cycle>[]);
      }
      return ref
          .watch(cyclesDataSourceProvider)
          .watchCyclesByHouseId(selectedHouseId);
    });

final readingsForSelectedCycleStreamProvider =
    StreamProvider.autoDispose<List<ElectricityReading>>((ref) {
      final selectedCycleId = ref.watch(selectedCycleIdProvider);
      if (selectedCycleId == null) {
        return Stream.value(const <ElectricityReading>[]);
      }
      return ref
          .watch(electricityReadingsDataSourceProvider)
          .watchReadingsByCycleId(selectedCycleId);
    });

/// Provider to fetch a cycle by ID (for edit screens)
final cycleByIdProvider = FutureProvider.family<Cycle?, String>((
  ref,
  cycleId,
) async {
  final repository = ref.watch(cyclesRepositoryProvider);
  return repository.getCycleById(cycleId);
});

/// Selected house + cycle state
final selectedHouseIdProvider =
    NotifierProvider<SelectedHouseIdNotifier, String?>(
      SelectedHouseIdNotifier.new,
    );

final selectedCycleIdProvider =
    NotifierProvider<SelectedCycleIdNotifier, String?>(
      SelectedCycleIdNotifier.new,
    );

final selectedHouseProvider = Provider<AsyncValue<House?>>((ref) {
  final housesAsync = ref.watch(housesStreamProvider);
  final selectedHouseId = ref.watch(selectedHouseIdProvider);

  return housesAsync.whenData((houses) {
    if (houses.isEmpty) {
      if (selectedHouseId != null) {
        Future.microtask(() {
          ref.read(selectedHouseIdProvider.notifier).setHouse(null);
        });
      }
      return null;
    }

    final match = houses.firstWhereOrNull(
      (house) => house.id == selectedHouseId,
    );
    if (match != null) {
      return match;
    }

    final fallback = houses.first;
    Future.microtask(() {
      ref.read(selectedHouseIdProvider.notifier).setHouse(fallback.id);
    });
    return fallback;
  });
});

final selectedCycleProvider = Provider<AsyncValue<Cycle?>>((ref) {
  final cyclesAsync = ref.watch(cyclesForSelectedHouseStreamProvider);
  final selectedCycleId = ref.watch(selectedCycleIdProvider);

  return cyclesAsync.whenData((cycles) {
    if (cycles.isEmpty) {
      if (selectedCycleId != null) {
        Future.microtask(() {
          ref.read(selectedCycleIdProvider.notifier).clear();
        });
      }
      return null;
    }

    final match = cycles.firstWhereOrNull(
      (cycle) => cycle.id == selectedCycleId,
    );
    if (match != null) {
      return match;
    }

    final fallback = cycles.first;
    Future.microtask(() {
      ref.read(selectedCycleIdProvider.notifier).setCycle(fallback.id);
    });
    return fallback;
  });
});

/// Controllers for CRUD operations
class HousesController {
  HousesController(this._ref, this._repository);

  final Ref _ref;
  final HousesRepository _repository;

  Future<String> createHouse({
    required String name,
    String? address,
    String? meterNumber,
    required double defaultPricePerUnit,
  }) async {
    final id = await _repository.createHouse(
      name: name,
      address: address,
      meterNumber: meterNumber,
      defaultPricePerUnit: defaultPricePerUnit,
    );

    // Invalidate to refresh the stream immediately
    _ref.invalidate(housesStreamProvider);
    _ref.read(selectedHouseIdProvider.notifier).setHouse(id);
    return id;
  }

  Future<void> updateHouse({
    required String id,
    String? name,
    String? address,
    String? meterNumber,
    double? defaultPricePerUnit,
  }) async {
    await _repository.updateHouse(
      id: id,
      name: name,
      address: address,
      meterNumber: meterNumber,
      defaultPricePerUnit: defaultPricePerUnit,
    );
    // Invalidate to refresh the stream immediately
    _ref.invalidate(housesStreamProvider);
  }

  Future<void> deleteHouse(String id) async {
    await _repository.deleteHouse(id);

    // Invalidate to refresh the stream immediately
    _ref.invalidate(housesStreamProvider);

    final selectedId = _ref.read(selectedHouseIdProvider);
    if (selectedId == id) {
      _ref.read(selectedHouseIdProvider.notifier).setHouse(null);
    }
  }
}

class CyclesController {
  CyclesController(this._ref, this._repository);

  final Ref _ref;
  final CyclesRepository _repository;

  Future<String> createCycle({
    required String houseId,
    required String name,
    required DateTime startDate,
    required DateTime endDate,
    required double initialMeterReading,
    required int maxUnits,
    required double pricePerUnit,
    bool isActive = false,
    String? notes,
  }) async {
    final id = await _repository.createCycle(
      houseId: houseId,
      name: name,
      startDate: startDate,
      endDate: endDate,
      initialMeterReading: initialMeterReading,
      maxUnits: maxUnits,
      pricePerUnit: pricePerUnit,
      isActive: isActive,
      notes: notes,
    );

    // Invalidate to refresh the stream immediately
    _ref.invalidate(cyclesForSelectedHouseStreamProvider);
    _ref.read(selectedCycleIdProvider.notifier).setCycle(id);
    return id;
  }

  Future<void> updateCycle({
    required String id,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    double? initialMeterReading,
    int? maxUnits,
    double? pricePerUnit,
    bool? isActive,
    String? notes,
  }) async {
    await _repository.updateCycle(
      id: id,
      name: name,
      startDate: startDate,
      endDate: endDate,
      initialMeterReading: initialMeterReading,
      maxUnits: maxUnits,
      pricePerUnit: pricePerUnit,
      isActive: isActive,
      notes: notes,
    );
    // Invalidate to refresh the stream immediately
    _ref.invalidate(cyclesForSelectedHouseStreamProvider);
    // Invalidate the specific cycle provider so edit screens get fresh data
    _ref.invalidate(cycleByIdProvider);

    // Also invalidate readings if price or initial reading changed
    // (readings are recalculated in the repository)
    if (pricePerUnit != null || initialMeterReading != null) {
      _ref.invalidate(readingsForSelectedCycleStreamProvider);
    }
  }

  Future<void> deleteCycle(String id) async {
    await _repository.deleteCycle(id);

    // Invalidate to refresh the stream immediately
    _ref.invalidate(cyclesForSelectedHouseStreamProvider);

    final selectedId = _ref.read(selectedCycleIdProvider);
    if (selectedId == id) {
      _ref.read(selectedCycleIdProvider.notifier).clear();
    }
  }
}

class ElectricityReadingsController {
  ElectricityReadingsController(this._ref, this._repository);

  final Ref _ref;
  final ElectricityReadingsRepository _repository;

  Future<String> createReading({
    required String houseId,
    required String cycleId,
    required DateTime date,
    required double meterReading,
    required double unitsConsumed,
    required double totalCost,
    String? notes,
  }) async {
    final id = await _repository.createReading(
      houseId: houseId,
      cycleId: cycleId,
      date: date,
      meterReading: meterReading,
      unitsConsumed: unitsConsumed,
      totalCost: totalCost,
      notes: notes,
    );

    // Invalidate to refresh the stream immediately
    _ref.invalidate(readingsForSelectedCycleStreamProvider);
    return id;
  }

  Future<void> updateReading({
    required String id,
    DateTime? date,
    double? meterReading,
    double? unitsConsumed,
    double? totalCost,
    String? notes,
  }) async {
    await _repository.updateReading(
      id: id,
      date: date,
      meterReading: meterReading,
      unitsConsumed: unitsConsumed,
      totalCost: totalCost,
      notes: notes,
    );
    // Invalidate to refresh the stream immediately
    _ref.invalidate(readingsForSelectedCycleStreamProvider);
  }

  Future<void> deleteReading(String id) async {
    await _repository.deleteReading(id);
    // Invalidate to refresh the stream immediately
    _ref.invalidate(readingsForSelectedCycleStreamProvider);
  }
}

final housesControllerProvider = Provider<HousesController>((ref) {
  return HousesController(ref, ref.watch(housesRepositoryProvider));
});

final cyclesControllerProvider = Provider<CyclesController>((ref) {
  return CyclesController(ref, ref.watch(cyclesRepositoryProvider));
});

final electricityReadingsControllerProvider =
    Provider<ElectricityReadingsController>((ref) {
      return ElectricityReadingsController(
        ref,
        ref.watch(electricityReadingsRepositoryProvider),
      );
    });

class SelectedHouseIdNotifier extends Notifier<String?> {
  @override
  String? build() {
    final prefs = ref.watch(sharedPrefManagerProvider);
    return prefs.getSelectedHouseId();
  }

  void setHouse(String? houseId) {
    if (state == houseId) return;
    state = houseId;
    final prefs = ref.read(sharedPrefManagerProvider);
    unawaited(prefs.saveSelectedHouseId(houseId));
    if (houseId == null) {
      ref.read(selectedCycleIdProvider.notifier).clear();
    }
  }
}

class SelectedCycleIdNotifier extends Notifier<String?> {
  @override
  String? build() {
    final prefs = ref.watch(sharedPrefManagerProvider);
    return prefs.getSelectedCycleId();
  }

  void setCycle(String? cycleId) {
    if (state == cycleId) return;
    state = cycleId;
    final prefs = ref.read(sharedPrefManagerProvider);
    unawaited(prefs.saveSelectedCycleId(cycleId));
  }

  void clear() => setCycle(null);
}
