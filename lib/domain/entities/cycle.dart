import 'package:equatable/equatable.dart';

class Cycle extends Equatable {
  final String id;
  final String houseId;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final double initialMeterReading;
  final int maxUnits;
  final double pricePerUnit;
  final String? notes;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

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
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

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
    isActive,
    createdAt,
    updatedAt,
  ];

  factory Cycle.fromJson(Map<String, dynamic> json) {
    return Cycle(
      id: json['id'] as String,
      houseId: json['house_id'] as String,
      name: json['name'] as String,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      initialMeterReading: (json['initial_meter_reading'] as num).toDouble(),
      maxUnits: json['max_units'] as int,
      pricePerUnit: (json['price_per_unit'] as num).toDouble(),
      notes: json['notes'] as String?,
      isActive: json['is_active'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'house_id': houseId,
      'name': name,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'initial_meter_reading': initialMeterReading,
      'max_units': maxUnits,
      'price_per_unit': pricePerUnit,
      'notes': notes,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Cycle copyWith({
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    double? initialMeterReading,
    int? maxUnits,
    double? pricePerUnit,
    String? notes,
    bool? isActive,
    DateTime? updatedAt,
  }) {
    return Cycle(
      id: id,
      houseId: houseId,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      initialMeterReading: initialMeterReading ?? this.initialMeterReading,
      maxUnits: maxUnits ?? this.maxUnits,
      pricePerUnit: pricePerUnit ?? this.pricePerUnit,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
