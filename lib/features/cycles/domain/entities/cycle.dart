import 'package:equatable/equatable.dart';

/// Represents a billing cycle within a house
class Cycle extends Equatable {
  final String id;
  final String houseId;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final int initialMeterReading;
  final int maxUnits;
  final double pricePerUnit; // Price per unit for this cycle
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  const Cycle({
    required this.id,
    required this.houseId,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.initialMeterReading,
    required this.maxUnits,
    required this.pricePerUnit,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
  });

  /// Get the duration of the cycle in days
  int get durationInDays {
    return endDate.difference(startDate).inDays + 1;
  }

  /// Check if the cycle is currently active (current date is within the cycle period)
  bool get isCurrentlyActive {
    final now = DateTime.now();
    return now.isAfter(startDate) &&
        now.isBefore(endDate.add(const Duration(days: 1)));
  }

  /// Get the progress of the cycle (0.0 to 1.0)
  double get progress {
    final now = DateTime.now();
    if (now.isBefore(startDate)) return 0.0;
    if (now.isAfter(endDate)) return 1.0;

    final totalDuration = endDate.difference(startDate).inDays;
    final elapsed = now.difference(startDate).inDays;
    return elapsed / totalDuration;
  }

  Cycle copyWith({
    String? id,
    String? houseId,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    int? initialMeterReading,
    int? maxUnits,
    double? pricePerUnit,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return Cycle(
      id: id ?? this.id,
      houseId: houseId ?? this.houseId,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      initialMeterReading: initialMeterReading ?? this.initialMeterReading,
      maxUnits: maxUnits ?? this.maxUnits,
      pricePerUnit: pricePerUnit ?? this.pricePerUnit,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [
    id,
    houseId,
    name,
    startDate,
    endDate,
    initialMeterReading,
    maxUnits,
    pricePerUnit,
    notes,
    createdAt,
    updatedAt,
    isActive,
  ];
}

/// Parameters for creating a new cycle
class CreateCycleParams extends Equatable {
  final String houseId;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final int initialMeterReading;
  final int maxUnits;
  final double pricePerUnit;
  final String? notes;

  const CreateCycleParams({
    required this.houseId,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.initialMeterReading,
    required this.maxUnits,
    required this.pricePerUnit,
    this.notes,
  });

  @override
  List<Object?> get props => [
    houseId,
    name,
    startDate,
    endDate,
    initialMeterReading,
    maxUnits,
    pricePerUnit,
    notes,
  ];
}
