import 'package:electricity/features/cycles/domain/entities/cycle.dart';
import 'package:electricity/features/cycles/domain/repositories/cycles_repository.dart';

class GetCyclesUseCase {
  final CyclesRepository repository;

  GetCyclesUseCase(this.repository);

  Future<List<Cycle>> call({String? houseId}) async {
    if (houseId != null) {
      return repository.getCyclesForHouse(houseId);
    }
    return repository.getFilteredCycles();
  }
}

class GetCycleByIdUseCase {
  final CyclesRepository repository;

  GetCycleByIdUseCase(this.repository);

  Future<Cycle?> call(String id) async {
    return repository.getCycleById(id);
  }
}

class GetActiveCycleUseCase {
  final CyclesRepository repository;

  GetActiveCycleUseCase(this.repository);

  Future<Cycle?> call(String houseId) async {
    return repository.getActiveCycleForHouse(houseId);
  }
}

class CreateCycleUseCase {
  final CyclesRepository repository;

  CreateCycleUseCase(this.repository);

  Future<void> call(CreateCycleParams params) async {
    return repository.createCycle(params);
  }
}

class UpdateCycleUseCase {
  final CyclesRepository repository;

  UpdateCycleUseCase(this.repository);

  Future<void> call(Cycle cycle) async {
    return repository.updateCycle(cycle);
  }
}

class DeleteCycleUseCase {
  final CyclesRepository repository;

  DeleteCycleUseCase(this.repository);

  Future<void> call(String id) async {
    return repository.deleteCycle(id);
  }
}
