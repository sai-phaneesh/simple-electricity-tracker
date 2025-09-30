import 'package:equatable/equatable.dart';

/// House model representing a property for electricity tracking
class House extends Equatable {
  final String id;
  final String name;
  final String address;
  final String houseType;
  final String ownershipType;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  // Electricity tracking fields
  final String meterNumber; // Unique identifier for the meter
  final double defaultPricePerUnit; // Default electricity price per unit
  final double freeUnitsPerMonth; // Number of free units per month
  final double warningLimitUnits; // Warning threshold for consumption
  final bool isArchived; // Whether the house is archived

  const House({
    required this.id,
    required this.name,
    required this.address,
    required this.houseType,
    required this.ownershipType,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
    required this.meterNumber,
    this.defaultPricePerUnit = 0.0,
    this.freeUnitsPerMonth = 0.0,
    this.warningLimitUnits = 1000.0,
    this.isArchived = false,
  });

  House copyWith({
    String? id,
    String? name,
    String? address,
    String? houseType,
    String? ownershipType,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    String? meterNumber,
    double? defaultPricePerUnit,
    double? freeUnitsPerMonth,
    double? warningLimitUnits,
    bool? isArchived,
  }) {
    return House(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      houseType: houseType ?? this.houseType,
      ownershipType: ownershipType ?? this.ownershipType,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      meterNumber: meterNumber ?? this.meterNumber,
      defaultPricePerUnit: defaultPricePerUnit ?? this.defaultPricePerUnit,
      freeUnitsPerMonth: freeUnitsPerMonth ?? this.freeUnitsPerMonth,
      warningLimitUnits: warningLimitUnits ?? this.warningLimitUnits,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    address,
    houseType,
    ownershipType,
    notes,
    createdAt,
    updatedAt,
    isActive,
    meterNumber,
    defaultPricePerUnit,
    freeUnitsPerMonth,
    warningLimitUnits,
    isArchived,
  ];

  @override
  String toString() {
    return 'House(id: $id, name: $name, address: $address, houseType: $houseType, ownershipType: $ownershipType, meterNumber: $meterNumber, isActive: $isActive, isArchived: $isArchived)';
  }
}
