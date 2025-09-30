import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:electricity/features/houses/domain/entities/house.dart';
import 'package:electricity/features/houses/domain/usecases/get_houses_usecase.dart';
import 'package:electricity/features/houses/domain/usecases/get_house_by_id_usecase.dart';
import 'package:electricity/features/houses/domain/usecases/add_house_usecase.dart';
import 'package:electricity/features/houses/domain/usecases/update_house_usecase.dart';
import 'package:electricity/features/houses/domain/usecases/delete_house_usecase.dart';
import 'package:uuid/uuid.dart';

part 'houses_event.dart';
part 'houses_state.dart';

/// Filter class for houses (search, type, ownership)
class HousesFilter extends Equatable {
  final String searchQuery;
  final String? houseType;
  final String? ownershipType;

  const HousesFilter({
    this.searchQuery = '',
    this.houseType,
    this.ownershipType,
  });

  HousesFilter copyWith({
    String? searchQuery,
    String? houseType,
    String? ownershipType,
  }) {
    return HousesFilter(
      searchQuery: searchQuery ?? this.searchQuery,
      houseType: houseType ?? this.houseType,
      ownershipType: ownershipType ?? this.ownershipType,
    );
  }

  @override
  List<Object?> get props => [searchQuery, houseType, ownershipType];
}

// BLoC
class HousesBloc extends Bloc<HousesEvent, HousesState> {
  static const _uuid = Uuid();

  final GetHousesUseCase _getHousesUseCase;
  final GetHouseByIdUseCase _getHouseByIdUseCase;
  final AddHouseUseCase _addHouseUseCase;
  final UpdateHouseUseCase _updateHouseUseCase;
  final DeleteHouseUseCase _deleteHouseUseCase;

  HousesFilter _filter = const HousesFilter();
  HousesFilter get filter => _filter;

  HousesBloc({
    required GetHousesUseCase getHousesUseCase,
    required GetHouseByIdUseCase getHouseByIdUseCase,
    required AddHouseUseCase addHouseUseCase,
    required UpdateHouseUseCase updateHouseUseCase,
    required DeleteHouseUseCase deleteHouseUseCase,
  }) : _getHousesUseCase = getHousesUseCase,
       _getHouseByIdUseCase = getHouseByIdUseCase,
       _addHouseUseCase = addHouseUseCase,
       _updateHouseUseCase = updateHouseUseCase,
       _deleteHouseUseCase = deleteHouseUseCase,
       super(HousesInitial()) {
    on<LoadHouses>(_onLoadHouses);
    on<AddHouse>(_onAddHouse);
    on<UpdateHouse>(_onUpdateHouse);
    on<DeleteHouse>(_onDeleteHouse);
    on<UpdateHousesFilter>(_onUpdateFilter);
    on<ClearFilters>(_onClearFilters);
  }

  Future<void> _onLoadHouses(
    LoadHouses event,
    Emitter<HousesState> emit,
  ) async {
    emit(HousesLoading());
    try {
      final filterParams = HousesFilterParams(
        searchQuery: _filter.searchQuery,
        houseType: _filter.houseType,
        ownershipType: _filter.ownershipType,
      );
      final houses = await _getHousesUseCase(filter: filterParams);
      emit(HousesLoaded(houses: houses, filter: _filter));
    } catch (e) {
      emit(HousesError('Failed to load houses: $e'));
    }
  }

  Future<void> _onAddHouse(AddHouse event, Emitter<HousesState> emit) async {
    try {
      final newHouse = House(
        id: _uuid.v4(),
        name: event.name,
        address: event.address,
        houseType: event.houseType,
        ownershipType: event.ownershipType,
        notes: event.notes,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        meterNumber: event.meterNumber,
        defaultPricePerUnit: event.defaultPricePerUnit,
        freeUnitsPerMonth: event.freeUnitsPerMonth,
        warningLimitUnits: event.warningLimitUnits,
      );
      await _addHouseUseCase(newHouse);
      add(LoadHouses());
    } catch (e) {
      emit(HousesError('Failed to add house: $e'));
    }
  }

  Future<void> _onUpdateHouse(
    UpdateHouse event,
    Emitter<HousesState> emit,
  ) async {
    try {
      final updatedHouse = event.house.copyWith(updatedAt: DateTime.now());
      await _updateHouseUseCase(updatedHouse);
      add(LoadHouses());
    } catch (e) {
      emit(HousesError('Failed to update house: $e'));
    }
  }

  Future<void> _onDeleteHouse(
    DeleteHouse event,
    Emitter<HousesState> emit,
  ) async {
    try {
      await _deleteHouseUseCase(event.houseId);
      add(LoadHouses());
    } catch (e) {
      emit(HousesError('Failed to delete house: $e'));
    }
  }

  /// Update the filter and emit new state
  Future<void> _onUpdateFilter(
    UpdateHousesFilter event,
    Emitter<HousesState> emit,
  ) async {
    _filter = event.filter;
    // Create filter params and get filtered houses
    final filterParams = HousesFilterParams(
      searchQuery: _filter.searchQuery,
      houseType: _filter.houseType,
      ownershipType: _filter.ownershipType,
    );
    final houses = await _getHousesUseCase(filter: filterParams);
    emit(HousesLoaded(houses: houses, filter: _filter));
  }

  /// Clear all filters
  Future<void> _onClearFilters(
    ClearFilters event,
    Emitter<HousesState> emit,
  ) async {
    _filter = const HousesFilter();
    // Get all houses without filters
    final houses = await _getHousesUseCase();
    emit(HousesLoaded(houses: houses, filter: _filter));
  }

  // Filtering is now handled in the UI using context.watch<HousesBloc>().filter

  Future<House?> getHouseById(String id) async {
    try {
      return await _getHouseByIdUseCase(id);
    } catch (e) {
      return null;
    }
  }
}
