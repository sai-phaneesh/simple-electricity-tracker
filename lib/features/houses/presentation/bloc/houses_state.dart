part of 'houses_bloc.dart';

/// States for HousesBloc
abstract class HousesState {}

/// Initial state
class HousesInitial extends HousesState {}

/// Loading state
class HousesLoading extends HousesState {}

/// Loaded state with houses and filter
class HousesLoaded extends HousesState {
  final List<House> houses;
  final HousesFilter filter;

  HousesLoaded({required this.houses, required this.filter});

  HousesLoaded copyWith({List<House>? houses, HousesFilter? filter}) {
    return HousesLoaded(
      houses: houses ?? this.houses,
      filter: filter ?? this.filter,
    );
  }
}

/// Error state
class HousesError extends HousesState {
  final String message;
  HousesError(this.message);
}
