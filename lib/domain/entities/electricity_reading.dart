import 'package:equatable/equatable.dart';

class ElectricityReading extends Equatable {
  final String id;
  final String houseId;
  final String cycleId;
  final DateTime date;
  final double meterReading;
  final double unitsConsumed;
  final double totalCost;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ElectricityReading({
    required this.id,
    required this.houseId,
    required this.cycleId,
    required this.date,
    required this.meterReading,
    required this.unitsConsumed,
    required this.totalCost,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

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

  factory ElectricityReading.fromJson(Map<String, dynamic> json) {
    return ElectricityReading(
      id: json['id'] as String,
      houseId: json['house_id'] as String,
      cycleId: json['cycle_id'] as String,
      date: DateTime.parse(json['date'] as String),
      meterReading: (json['meter_reading'] as num).toDouble(),
      unitsConsumed: (json['units_consumed'] as num).toDouble(),
      totalCost: (json['total_cost'] as num).toDouble(),
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'house_id': houseId,
      'cycle_id': cycleId,
      'date': date.toIso8601String(),
      'meter_reading': meterReading,
      'units_consumed': unitsConsumed,
      'total_cost': totalCost,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  ElectricityReading copyWith({
    DateTime? date,
    double? meterReading,
    double? unitsConsumed,
    double? totalCost,
    String? notes,
    DateTime? updatedAt,
  }) {
    return ElectricityReading(
      id: id,
      houseId: houseId,
      cycleId: cycleId,
      date: date ?? this.date,
      meterReading: meterReading ?? this.meterReading,
      unitsConsumed: unitsConsumed ?? this.unitsConsumed,
      totalCost: totalCost ?? this.totalCost,
      notes: notes ?? this.notes,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
