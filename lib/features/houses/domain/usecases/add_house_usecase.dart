import 'package:electricity/features/houses/domain/entities/house.dart';
import 'package:electricity/features/houses/domain/repositories/houses_repository.dart';

class AddHouseUseCase {
  final HousesRepository repository;

  AddHouseUseCase(this.repository);

  Future<void> call(House house) async {
    return await repository.addHouse(house);
  }
}
