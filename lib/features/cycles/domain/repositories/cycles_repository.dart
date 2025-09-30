import 'package:electricity/features/cycles/domain/entities/cycle.dart';

abstract class CyclesRepository {
  /// Get all cycles for a specific house
  Future<List<Cycle>> getCyclesForHouse(String houseId);

  /// Get a specific cycle by ID
  Future<Cycle?> getCycleById(String id);

  /// Get the currently active cycle for a house (if any)
  Future<Cycle?> getActiveCycleForHouse(String houseId);

  /// Create a new cycle
  Future<void> createCycle(CreateCycleParams params);

  /// Update an existing cycle
  Future<void> updateCycle(Cycle cycle);

  /// Delete a cycle
  Future<void> deleteCycle(String id);

  /// Archive/deactivate a cycle
  Future<void> archiveCycle(String id);

  /// Get cycles with filtering options
  Future<List<Cycle>> getFilteredCycles({
    String? houseId,
    bool? isActive,
    DateTime? startDateFrom,
    DateTime? startDateTo,
    DateTime? endDateFrom,
    DateTime? endDateTo,
  });
}
