import 'package:electricity/features/houses/domain/entities/house.dart';
import 'package:electricity/features/houses/domain/repositories/houses_repository.dart';

/// Filter parameters for houses
class HousesFilterParams {
  final String searchQuery;
  final String? houseType;
  final String? ownershipType;

  const HousesFilterParams({
    this.searchQuery = '',
    this.houseType,
    this.ownershipType,
  });

  bool get hasFilters =>
      searchQuery.isNotEmpty || houseType != null || ownershipType != null;
}

class GetHousesUseCase {
  final HousesRepository repository;

  GetHousesUseCase(this.repository);

  Future<List<House>> call({HousesFilterParams? filter}) async {
    final filterParams = filter ?? const HousesFilterParams();

    return await repository.getHouses(
      searchQuery: filterParams.searchQuery,
      houseType: filterParams.houseType,
      ownershipType: filterParams.ownershipType,
    );
  }
}
