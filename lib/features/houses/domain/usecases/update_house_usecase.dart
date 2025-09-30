import 'package:electricity/features/houses/domain/entities/house.dart';
import 'package:electricity/features/houses/domain/repositories/houses_repository.dart';

class UpdateHouseUseCase {
  final HousesRepository repository;

  UpdateHouseUseCase(this.repository);

  Future<void> call(House house) async {
    return await repository.updateHouse(house);
  }
}
