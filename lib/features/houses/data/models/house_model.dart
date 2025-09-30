import 'package:electricity/features/houses/domain/entities/house.dart';

class HouseModel extends House {
  const HouseModel({
    required super.id,
    required super.name,
    required super.address,
    required super.houseType,
    required super.ownershipType,
    super.notes,
    required super.createdAt,
    required super.updatedAt,
    super.isActive = true,
    required super.meterNumber,
    super.defaultPricePerUnit = 0.0,
    super.freeUnitsPerMonth = 0.0,
    super.warningLimitUnits = 1000.0,
    super.isArchived = false,
  });

  factory HouseModel.fromJson(Map<String, dynamic> json) {
    return HouseModel(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      houseType: json['houseType'] as String,
      ownershipType: json['ownershipType'] as String,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
      meterNumber: json['meterNumber'] as String,
      defaultPricePerUnit:
          (json['defaultPricePerUnit'] as num?)?.toDouble() ?? 0.0,
      freeUnitsPerMonth: (json['freeUnitsPerMonth'] as num?)?.toDouble() ?? 0.0,
      warningLimitUnits:
          (json['warningLimitUnits'] as num?)?.toDouble() ?? 1000.0,
      isArchived: json['isArchived'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'houseType': houseType,
      'ownershipType': ownershipType,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isActive': isActive,
      'meterNumber': meterNumber,
      'defaultPricePerUnit': defaultPricePerUnit,
      'freeUnitsPerMonth': freeUnitsPerMonth,
      'warningLimitUnits': warningLimitUnits,
      'isArchived': isArchived,
    };
  }

  factory HouseModel.fromEntity(House house) {
    return HouseModel(
      id: house.id,
      name: house.name,
      address: house.address,
      houseType: house.houseType,
      ownershipType: house.ownershipType,
      notes: house.notes,
      createdAt: house.createdAt,
      updatedAt: house.updatedAt,
      isActive: house.isActive,
      meterNumber: house.meterNumber,
      defaultPricePerUnit: house.defaultPricePerUnit,
      freeUnitsPerMonth: house.freeUnitsPerMonth,
      warningLimitUnits: house.warningLimitUnits,
      isArchived: house.isArchived,
    );
  }

  House toEntity() {
    return House(
      id: id,
      name: name,
      address: address,
      houseType: houseType,
      ownershipType: ownershipType,
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isActive: isActive,
      meterNumber: meterNumber,
      defaultPricePerUnit: defaultPricePerUnit,
      freeUnitsPerMonth: freeUnitsPerMonth,
      warningLimitUnits: warningLimitUnits,
      isArchived: isArchived,
    );
  }
}
