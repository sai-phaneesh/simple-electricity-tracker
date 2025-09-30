import 'package:electricity/features/houses/domain/entities/house.dart';
import 'package:electricity/features/houses/domain/repositories/houses_repository.dart';

class GetHouseByIdUseCase {
  final HousesRepository repository;

  GetHouseByIdUseCase(this.repository);

  Future<House?> call(String id) async {
    return await repository.getHouseById(id);
  }
}
