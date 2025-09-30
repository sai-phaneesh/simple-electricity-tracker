import 'package:equatable/equatable.dart';

/// Represents an electricity meter reading
class ElectricityReading extends Equatable {
  final String id;
  final String houseId;
  final String
  cycleId; // Always required - readings are always linked to cycles
  final DateTime date;
  final int meterReading;
  final int unitsConsumed;
  final double totalCost;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ElectricityReading({
    required this.id,
    required this.houseId,
    required this.cycleId, // Now required
    required this.date,
    required this.meterReading,
    required this.unitsConsumed,
    required this.totalCost,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Calculate units consumed from previous reading
  static int calculateUnitsConsumed(int currentReading, int previousReading) {
    return currentReading - previousReading;
  }

  /// Calculate total cost from units and price per unit (from cycle)
  static double calculateTotalCost(int unitsConsumed, double pricePerUnit) {
    return unitsConsumed * pricePerUnit;
  }

  ElectricityReading copyWith({
    String? id,
    String? houseId,
    String? cycleId,
    DateTime? date,
    int? meterReading,
    int? unitsConsumed,
    double? totalCost,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ElectricityReading(
      id: id ?? this.id,
      houseId: houseId ?? this.houseId,
      cycleId: cycleId ?? this.cycleId,
      date: date ?? this.date,
      meterReading: meterReading ?? this.meterReading,
      unitsConsumed: unitsConsumed ?? this.unitsConsumed,
      totalCost: totalCost ?? this.totalCost,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    houseId,
    cycleId,
    date,
    meterReading,
    unitsConsumed,
    totalCost,
    notes,
    createdAt,
    updatedAt,
  ];
}

/// Parameters for creating a new electricity reading
class CreateReadingParams extends Equatable {
  final String houseId;
  final String cycleId; // Required - readings always belong to a cycle
  final DateTime date;
  final int meterReading;
  final String? notes;

  const CreateReadingParams({
    required this.houseId,
    required this.cycleId,
    required this.date,
    required this.meterReading,
    this.notes,
  });

  @override
  List<Object?> get props => [houseId, cycleId, date, meterReading, notes];
}

/// Parameters for updating an existing electricity reading
class UpdateReadingParams extends Equatable {
  final String id;
  final DateTime? date;
  final int? meterReading;
  final String? notes;

  const UpdateReadingParams({
    required this.id,
    this.date,
    this.meterReading,
    this.notes,
  });

  @override
  List<Object?> get props => [id, date, meterReading, notes];
}
