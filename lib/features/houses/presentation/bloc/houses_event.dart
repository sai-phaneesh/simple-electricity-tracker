part of 'houses_bloc.dart';

/// Base class for all events in HousesBloc.
abstract class HousesEvent {}

/// Event to load all houses from the repository.
class LoadHouses extends HousesEvent {}

/// Event to add a new house.
class AddHouse extends HousesEvent {
  final String name;
  final String address;
  final String houseType;
  final String ownershipType;
  final String? notes;
  final String meterNumber;
  final double defaultPricePerUnit;
  final double freeUnitsPerMonth;
  final double warningLimitUnits;

  AddHouse({
    required this.name,
    required this.address,
    required this.houseType,
    required this.ownershipType,
    this.notes,
    required this.meterNumber,
    this.defaultPricePerUnit = 0.0,
    this.freeUnitsPerMonth = 0.0,
    this.warningLimitUnits = 1000.0,
  });
}

/// Event to update an existing house.
class UpdateHouse extends HousesEvent {
  final dynamic house; // House type is available via part-of
  UpdateHouse(this.house);
}

/// Event to delete a house by id.
class DeleteHouse extends HousesEvent {
  final String houseId;
  DeleteHouse(this.houseId);
}

/// Event to update the filter (search, type, ownership).
class UpdateHousesFilter extends HousesEvent {
  final HousesFilter filter;
  UpdateHousesFilter(this.filter);
}

/// Event to clear all filters.
class ClearFilters extends HousesEvent {
  ClearFilters();
}

/// Event to toggle the filter panel.
class ToggleFiltersPanel extends HousesEvent {
  final bool show;
  ToggleFiltersPanel(this.show);
}
