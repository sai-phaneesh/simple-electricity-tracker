import 'package:electricity/features/houses/domain/entities/house.dart';
import 'package:electricity/features/houses/domain/repositories/houses_repository.dart';

class SearchHousesUseCase {
  final HousesRepository repository;

  SearchHousesUseCase(this.repository);

  Future<List<House>> call(String query) async {
    return await repository.searchHouses(query);
  }
}
