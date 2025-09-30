import 'dart:async';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:uuid/uuid.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';
part 'models.dart';

final uuid = const Uuid();

class DashboardBloc extends HydratedBloc<DashboardEvent, DashboardState> {
  Cycle? selectedCycle;

  final List<Cycle> _cycles = [];

  UnmodifiableListView<Cycle> get cycles => UnmodifiableListView(_cycles);

  // Cycle? get selectedCycle =>
  //     _cycles.firstWhereOrNull((e) => e.id == selectedCycleId);

  DashboardBloc() : super(DashboardInitial()) {
    on<UpdateSelectedCycleEvent>(_updateSelectedCycle);
    on<CreateCycleEvent>(_createCycle);
    on<CreateConsumptionEvent>(_createConsumption);
    on<DeleteCycleEvent>(_deleteCycle);
    on<DeleteConsumptionEvent>(_deleteConsumption);
  }

  FutureOr<void> _updateSelectedCycle(
    UpdateSelectedCycleEvent event,
    Emitter<DashboardState> emit,
  ) async {
    selectedCycle = _cycles.firstWhereOrNull((e) => e.id == event.cycle.id);
    emit(SelectedCycleUpdatedSuccessfully(cycle: selectedCycle));
  }

  FutureOr<void> _createCycle(
    CreateCycleEvent event,
    Emitter<DashboardState> emit,
  ) async {
    if (_cycles.firstWhereOrNull((e) => e.name == event.name) != null) {
      emit(const CycleCreationFailed('Cycle with same name already exists.'));
      return;
    }
    final Cycle cycle = Cycle(
      id: uuid.v4(),
      name: event.name,
      startDate: event.startDate,
      endDate: event.endDate,
      createdOn: DateTime.now(),
      updatedOn: DateTime.now(),
      meterReading: event.meterReading,
      maxUnits: event.maxUnits,
      consumptions: [
        Consumption(
          id: uuid.v4(),
          meterReading: event.meterReading,
          date: DateTime.now(),
          unitsConsumed: 0,
        ),
      ],
    );
    _cycles.add(cycle);
    emit(CycleCreatedSuccessfully());
  }

  FutureOr<void> _createConsumption(
    CreateConsumptionEvent event,
    Emitter<DashboardState> emit,
  ) async {
    final Cycle? cycle = _cycles.firstWhereOrNull((e) => e.id == event.cycleId);
    if (cycle == null) {
      emit(const ConsumptionCreationFailed('Cycle not found.'));
      return;
    }
    if (event.meterReading < cycle.meterReading ||
        cycle.consumptions.firstWhereOrNull(
              (e) => e.meterReading >= event.meterReading,
            ) !=
            null) {
      emit(const ConsumptionCreationFailed('Enter proper meter reading.'));
      return;
    }
    cycle.consumptions.add(
      Consumption(
        id: uuid.v4(),
        meterReading: event.meterReading,
        date: DateTime.now(),
        unitsConsumed: event.meterReading - cycle.meterReading,
      ),
    );
    emit(ConsumptionCreatedSuccessfully());
  }

  FutureOr<void> _deleteCycle(
    DeleteCycleEvent event,
    Emitter<DashboardState> emit,
  ) {
    if (selectedCycle?.id == event.cycleId) {
      selectedCycle = null;
    }
    _cycles.removeWhere((e) => e.id == event.cycleId);

    emit(CycleDeletedSuccessfully());
  }

  FutureOr<void> _deleteConsumption(
    DeleteConsumptionEvent event,
    Emitter<DashboardState> emit,
  ) {
    final cycleIndex = _cycles.indexWhere((e) => e.id == event.cycleId);
    if (cycleIndex == -1) {
      emit(const ConsumptionDeletionFailed('Cycle does not exist'));
      return null;
    }
    final cycle = _cycles[cycleIndex];

    cycle.consumptions.removeWhere((e) => e.id == event.consumptionId);

    emit(ConsumptionDeletedSuccessfully());
  }

  @override
  DashboardState? fromJson(Map<String, dynamic> json) {
    try {
      _cycles.clear();
      final cycles = json['cycles'] as List;
      for (final cycle in cycles) {
        _cycles.add(Cycle.fromJson(cycle));
      }
      selectedCycle ??= _cycles.firstOrNull;
      return DashboardLoaded();
    } catch (e) {
      _cycles.clear();
      return DashboardLoadError(e.toString());
    }
  }

  @override
  Map<String, dynamic>? toJson(DashboardState state) {
    return {'cycles': _cycles.map((e) => e.toJson()).toList()};
  }
}
