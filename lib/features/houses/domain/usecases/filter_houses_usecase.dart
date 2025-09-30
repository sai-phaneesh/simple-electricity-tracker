import 'package:electricity/features/houses/domain/entities/house.dart';
import 'package:electricity/features/houses/domain/repositories/houses_repository.dart';

class FilterHousesUseCase {
  final HousesRepository repository;

  FilterHousesUseCase(this.repository);

  Future<List<House>> call({String? houseType, String? ownershipType}) async {
    return await repository.filterHouses(
      houseType: houseType,
      ownershipType: ownershipType,
    );
  }
}
