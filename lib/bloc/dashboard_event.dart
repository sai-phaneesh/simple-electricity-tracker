part of 'dashboard_bloc.dart';

sealed class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

final class UpdateSelectedCycleEvent extends DashboardEvent {
  final Cycle cycle;

  const UpdateSelectedCycleEvent({required this.cycle});

  @override
  List<Object> get props => [cycle];
}

final class CreateCycleEvent extends DashboardEvent {
  final DateTime startDate;
  final DateTime endDate;
  final String name;
  final double meterReading;
  final double maxUnits;

  const CreateCycleEvent({
    required this.startDate,
    required this.endDate,
    required this.name,
    required this.meterReading,
    required this.maxUnits,
  });

  @override
  List<Object> get props => [
        startDate,
        endDate,
        name,
        meterReading,
        maxUnits,
      ];
}

class CreateConsumptionEvent extends DashboardEvent {
  final DateTime _timestamp = DateTime.now();
  final String cycleId;
  final double meterReading;

  CreateConsumptionEvent({
    required this.cycleId,
    required this.meterReading,
  });

  @override
  List<Object> get props => [meterReading, _timestamp];
}

class DeleteCycleEvent extends DashboardEvent {
  final DateTime _timestamp = DateTime.now();
  final String cycleId;

  DeleteCycleEvent({
    required this.cycleId,
  });

  @override
  List<Object> get props => [_timestamp, cycleId];
}

class DeleteConsumptionEvent extends DashboardEvent {
  final DateTime _timestamp = DateTime.now();
  final String cycleId;
  final String consumptionId;

  DeleteConsumptionEvent({
    required this.cycleId,
    required this.consumptionId,
  });

  @override
  List<Object> get props => [_timestamp, cycleId, consumptionId];
}
