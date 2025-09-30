import 'package:electricity/features/houses/domain/repositories/houses_repository.dart';

class DeleteHouseUseCase {
  final HousesRepository repository;

  DeleteHouseUseCase(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteHouse(id);
  }
}
