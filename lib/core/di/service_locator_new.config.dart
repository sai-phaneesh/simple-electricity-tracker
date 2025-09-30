// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:electricity/core/di/register_module.dart' as _i720;
import 'package:electricity/features/houses/data/datasources/database/app_database.dart'
    as _i632;
import 'package:electricity/features/houses/data/datasources/houses_local_data_source.dart'
    as _i542;
import 'package:electricity/features/houses/domain/repositories/houses_repository.dart'
    as _i72;
import 'package:electricity/features/houses/domain/usecases/add_house_usecase.dart'
    as _i222;
import 'package:electricity/features/houses/domain/usecases/delete_house_usecase.dart'
    as _i999;
import 'package:electricity/features/houses/domain/usecases/filter_houses_usecase.dart'
    as _i496;
import 'package:electricity/features/houses/domain/usecases/get_house_by_id_usecase.dart'
    as _i277;
import 'package:electricity/features/houses/domain/usecases/get_houses_usecase.dart'
    as _i107;
import 'package:electricity/features/houses/domain/usecases/search_houses_usecase.dart'
    as _i183;
import 'package:electricity/features/houses/domain/usecases/update_house_usecase.dart'
    as _i9;
import 'package:electricity/features/houses/presentation/bloc/houses_bloc.dart'
    as _i1054;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.singleton<_i632.AppDatabase>(() => registerModule.appDatabase());
    gh.singleton<_i542.HousesLocalDataSource>(
      () => registerModule.housesLocalDataSource(gh<_i632.AppDatabase>()),
      instanceName: 'local',
    );
    gh.singleton<_i72.HousesRepository>(
      () => registerModule.housesRepository(
        gh<_i542.HousesLocalDataSource>(instanceName: 'local'),
      ),
    );
    gh.singleton<_i107.GetHousesUseCase>(
      () => registerModule.getHousesUseCase(gh<_i72.HousesRepository>()),
    );
    gh.singleton<_i277.GetHouseByIdUseCase>(
      () => registerModule.getHouseByIdUseCase(gh<_i72.HousesRepository>()),
    );
    gh.singleton<_i222.AddHouseUseCase>(
      () => registerModule.addHouseUseCase(gh<_i72.HousesRepository>()),
    );
    gh.singleton<_i9.UpdateHouseUseCase>(
      () => registerModule.updateHouseUseCase(gh<_i72.HousesRepository>()),
    );
    gh.singleton<_i999.DeleteHouseUseCase>(
      () => registerModule.deleteHouseUseCase(gh<_i72.HousesRepository>()),
    );
    gh.singleton<_i183.SearchHousesUseCase>(
      () => registerModule.searchHousesUseCase(gh<_i72.HousesRepository>()),
    );
    gh.singleton<_i496.FilterHousesUseCase>(
      () => registerModule.filterHousesUseCase(gh<_i72.HousesRepository>()),
    );
    gh.singleton<_i1054.HousesBloc>(
      () => registerModule.housesBloc(
        gh<_i107.GetHousesUseCase>(),
        gh<_i277.GetHouseByIdUseCase>(),
        gh<_i222.AddHouseUseCase>(),
        gh<_i9.UpdateHouseUseCase>(),
        gh<_i999.DeleteHouseUseCase>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i720.RegisterModule {}
