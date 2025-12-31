import 'package:equatable/equatable.dart';

class House extends Equatable {
  final String id;
  final String name;
  final String? address;
  final String? meterNumber;
  final double defaultPricePerUnit;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const House({
    required this.id,
    required this.name,
    this.address,
    this.meterNumber,
    required this.defaultPricePerUnit,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    address,
    meterNumber,
    defaultPricePerUnit,
    notes,
    createdAt,
    updatedAt,
  ];

  factory House.fromJson(Map<String, dynamic> json) {
    return House(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String?,
      meterNumber: json['meter_number'] as String?,
      defaultPricePerUnit: (json['default_price_per_unit'] as num).toDouble(),
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'meter_number': meterNumber,
      'default_price_per_unit': defaultPricePerUnit,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  House copyWith({
    String? name,
    String? address,
    String? meterNumber,
    double? defaultPricePerUnit,
    String? notes,
    DateTime? updatedAt,
  }) {
    return House(
      id: id,
      name: name ?? this.name,
      address: address ?? this.address,
      meterNumber: meterNumber ?? this.meterNumber,
      defaultPricePerUnit: defaultPricePerUnit ?? this.defaultPricePerUnit,
      notes: notes ?? this.notes,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
