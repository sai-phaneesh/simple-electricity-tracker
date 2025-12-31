import 'package:electricity/domain/entities/cycle.dart';

/// Abstract interface for cycles data operations
abstract class CyclesDataSource {
  // Basic CRUD operations
  Future<List<Cycle>> getAllCycles();
  Future<List<Cycle>> getCyclesByHouseId(String houseId);
  Future<Cycle?> getCycleById(String id);

  // Stream operations for reactive UI
  Stream<List<Cycle>> watchAllCycles();
  Stream<List<Cycle>> watchCyclesByHouseId(String houseId);
  Stream<Cycle?> watchCycleById(String id);
  Stream<Cycle?> watchActiveCycleForHouse(String houseId);

  Future<void> createCycle(Cycle cycle);
  Future<void> updateCycle(Cycle cycle);
  Future<void> deleteCycle(String id);

  // Business logic operations
  Future<Cycle?> getActiveCycleForHouse(String houseId);

  // Utility operations
  Future<int> getCyclesCount({String? houseId});
  Future<void> deactivateOtherCycles(String houseId, String activeCycleId);
}
