import 'package:injectable/injectable.dart';
import 'package:electricity/features/houses/data/datasources/database/app_database.dart';
import 'package:electricity/features/houses/data/datasources/houses_local_data_source.dart';
import 'package:electricity/features/houses/data/datasources/houses_local_data_source_impl.dart';
import 'package:electricity/features/houses/data/repositories/houses_repository_impl.dart';
import 'package:electricity/features/houses/domain/repositories/houses_repository.dart';
import 'package:electricity/features/houses/domain/usecases/get_houses_usecase.dart';
import 'package:electricity/features/houses/domain/usecases/get_house_by_id_usecase.dart';
import 'package:electricity/features/houses/domain/usecases/add_house_usecase.dart';
import 'package:electricity/features/houses/domain/usecases/update_house_usecase.dart';
import 'package:electricity/features/houses/domain/usecases/delete_house_usecase.dart';
import 'package:electricity/features/houses/domain/usecases/search_houses_usecase.dart';
import 'package:electricity/features/houses/domain/usecases/filter_houses_usecase.dart';
import 'package:electricity/features/houses/presentation/bloc/houses_bloc.dart';

@module
abstract class RegisterModule {
  // Database Layer
  @singleton
  AppDatabase appDatabase() => AppDatabase();

  // Data Sources
  @Named('local')
  @singleton
  HousesLocalDataSource housesLocalDataSource(AppDatabase database) =>
      HousesLocalDataSourceImpl(database);

  // Repository Layer
  @singleton
  HousesRepository housesRepository(
    @Named('local') HousesLocalDataSource localDataSource,
  ) => HousesRepositoryImpl(localDataSource);

  // Use Cases Layer
  @singleton
  GetHousesUseCase getHousesUseCase(HousesRepository repository) =>
      GetHousesUseCase(repository);

  @singleton
  GetHouseByIdUseCase getHouseByIdUseCase(HousesRepository repository) =>
      GetHouseByIdUseCase(repository);

  @singleton
  AddHouseUseCase addHouseUseCase(HousesRepository repository) =>
      AddHouseUseCase(repository);

  @singleton
  UpdateHouseUseCase updateHouseUseCase(HousesRepository repository) =>
      UpdateHouseUseCase(repository);

  @singleton
  DeleteHouseUseCase deleteHouseUseCase(HousesRepository repository) =>
      DeleteHouseUseCase(repository);

  @singleton
  SearchHousesUseCase searchHousesUseCase(HousesRepository repository) =>
      SearchHousesUseCase(repository);

  @singleton
  FilterHousesUseCase filterHousesUseCase(HousesRepository repository) =>
      FilterHousesUseCase(repository);

  // Presentation Layer (BLoC) - Make it singleton to maintain state
  @singleton
  HousesBloc housesBloc(
    GetHousesUseCase getHousesUseCase,
    GetHouseByIdUseCase getHouseByIdUseCase,
    AddHouseUseCase addHouseUseCase,
    UpdateHouseUseCase updateHouseUseCase,
    DeleteHouseUseCase deleteHouseUseCase,
  ) => HousesBloc(
    getHousesUseCase: getHousesUseCase,
    getHouseByIdUseCase: getHouseByIdUseCase,
    addHouseUseCase: addHouseUseCase,
    updateHouseUseCase: updateHouseUseCase,
    deleteHouseUseCase: deleteHouseUseCase,
  );

  // Device info service
  // @singleton
  // DeviceInfoService deviceInfoService() => DeviceInfoService();
}
