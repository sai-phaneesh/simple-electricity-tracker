import 'package:electricity/data/database/database.dart';

/// Abstract repository interface for cycle operations
/// Repositories coordinate between multiple datasources and implement business logic
abstract class CyclesRepository {
  // Basic CRUD operations
  Future<List<Cycle>> getAllCycles();
  Future<List<Cycle>> getCyclesByHouseId(String houseId);
  Future<Cycle?> getCycleById(String id);
  Future<String> createCycle({
    required String houseId,
    required String name,
    required DateTime startDate,
    required DateTime endDate,
    required int initialMeterReading,
    required int maxUnits,
    required double pricePerUnit,
    bool isActive = false,
    String? notes,
  });
  Future<void> updateCycle({
    required String id,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    int? initialMeterReading,
    int? maxUnits,
    double? pricePerUnit,
    bool? isActive,
    String? notes,
  });
  Future<void> deleteCycle(String id);

  // Business logic operations
  Future<Cycle?> getActiveCycleForHouse(String houseId);
  Future<void> setActiveCycle(String houseId, String cycleId);
  Future<List<Cycle>> getCyclesByDateRange(
    DateTime startDate,
    DateTime endDate,
  );
  Future<List<Cycle>> searchCycles(String query);
  Future<int> getCyclesCount({String? houseId});

  // Sync operations
  Future<List<Cycle>> getCyclesNeedingSync();
  Future<void> markCycleAsSynced(String id);
  Future<bool> hasDataNeedingSync();
  Future<DateTime?> getLastSyncTime();

  // Analytics operations
  Future<Map<String, dynamic>> getCycleStatistics(String cycleId);
  Future<double> getCycleProgress(String cycleId);
  Future<int> getRemainingUnits(String cycleId);
  Future<double> getEstimatedCost(String cycleId);
}
