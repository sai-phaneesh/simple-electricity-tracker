import 'package:electricity/features/cycles/domain/entities/cycle.dart';

class CycleModel extends Cycle {
  const CycleModel({
    required super.id,
    required super.houseId,
    required super.name,
    required super.startDate,
    required super.endDate,
    required super.initialMeterReading,
    required super.maxUnits,
    required super.pricePerUnit,
    super.notes,
    required super.createdAt,
    required super.updatedAt,
    super.isActive = true,
  });

  factory CycleModel.fromJson(Map<String, dynamic> json) {
    return CycleModel(
      id: json['id'] as String,
      houseId: json['houseId'] as String,
      name: json['name'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      initialMeterReading: json['initialMeterReading'] as int,
      maxUnits: json['maxUnits'] as int,
      pricePerUnit: (json['pricePerUnit'] as num).toDouble(),
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'houseId': houseId,
      'name': name,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'initialMeterReading': initialMeterReading,
      'maxUnits': maxUnits,
      'pricePerUnit': pricePerUnit,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory CycleModel.fromEntity(Cycle cycle) {
    return CycleModel(
      id: cycle.id,
      houseId: cycle.houseId,
      name: cycle.name,
      startDate: cycle.startDate,
      endDate: cycle.endDate,
      initialMeterReading: cycle.initialMeterReading,
      maxUnits: cycle.maxUnits,
      pricePerUnit: cycle.pricePerUnit,
      notes: cycle.notes,
      createdAt: cycle.createdAt,
      updatedAt: cycle.updatedAt,
      isActive: cycle.isActive,
    );
  }

  Cycle toEntity() {
    return Cycle(
      id: id,
      houseId: houseId,
      name: name,
      startDate: startDate,
      endDate: endDate,
      initialMeterReading: initialMeterReading,
      maxUnits: maxUnits,
      pricePerUnit: pricePerUnit,
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isActive: isActive,
    );
  }

  @override
  CycleModel copyWith({
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
    return CycleModel(
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
}
