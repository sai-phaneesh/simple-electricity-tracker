part of 'dashboard_bloc.dart';

sealed class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

final class DashboardInitial extends DashboardState {}

final class DashboardLoaded extends DashboardState {}

final class DashboardLoadError extends DashboardState {
  final String error;
  const DashboardLoadError(this.error);

  @override
  List<Object> get props => [error];
}

final class SelectedCycleUpdatedSuccessfully extends DashboardState {
  final _timestamp = DateTime.now();
  final Cycle? cycle;
  SelectedCycleUpdatedSuccessfully({this.cycle});

  @override
  List<Object> get props => [_timestamp];
}

final class CycleCreatedSuccessfully extends DashboardState {}

final class CycleCreationFailed extends DashboardState {
  final String error;
  const CycleCreationFailed(this.error);

  @override
  List<Object> get props => [error];
}

final class CycleUpdatedSuccessfully extends DashboardState {}

final class ConsumptionCreatedSuccessfully extends DashboardState {}

final class ConsumptionCreationFailed extends DashboardState {
  final String error;
  const ConsumptionCreationFailed(this.error);

  @override
  List<Object> get props => [error];
}

final class CycleDeletedSuccessfully extends DashboardState {}

final class CycleDeletionFailed extends DashboardState {
  final String error;
  const CycleDeletionFailed(this.error);

  @override
  List<Object> get props => [error];
}

final class ConsumptionDeletedSuccessfully extends DashboardState {}

final class ConsumptionDeletionFailed extends DashboardState {
  final String error;
  const ConsumptionDeletionFailed(this.error);

  @override
  List<Object> get props => [error];
}
