// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $HousesTable extends Houses with TableInfo<$HousesTable, HouseDbModel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HousesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 255,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _houseTypeMeta = const VerificationMeta(
    'houseType',
  );
  @override
  late final GeneratedColumn<String> houseType = GeneratedColumn<String>(
    'house_type',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownershipTypeMeta = const VerificationMeta(
    'ownershipType',
  );
  @override
  late final GeneratedColumn<String> ownershipType = GeneratedColumn<String>(
    'ownership_type',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _meterNumberMeta = const VerificationMeta(
    'meterNumber',
  );
  @override
  late final GeneratedColumn<String> meterNumber = GeneratedColumn<String>(
    'meter_number',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('METER-DEFAULT'),
  );
  static const VerificationMeta _defaultPricePerUnitMeta =
      const VerificationMeta('defaultPricePerUnit');
  @override
  late final GeneratedColumn<double> defaultPricePerUnit =
      GeneratedColumn<double>(
        'default_price_per_unit',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.0),
      );
  static const VerificationMeta _freeUnitsPerMonthMeta = const VerificationMeta(
    'freeUnitsPerMonth',
  );
  @override
  late final GeneratedColumn<double> freeUnitsPerMonth =
      GeneratedColumn<double>(
        'free_units_per_month',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.0),
      );
  static const VerificationMeta _warningLimitUnitsMeta = const VerificationMeta(
    'warningLimitUnits',
  );
  @override
  late final GeneratedColumn<double> warningLimitUnits =
      GeneratedColumn<double>(
        'warning_limit_units',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(1000.0),
      );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
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
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'houses';
  @override
  VerificationContext validateIntegrity(
    Insertable<HouseDbModel> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('house_type')) {
      context.handle(
        _houseTypeMeta,
        houseType.isAcceptableOrUnknown(data['house_type']!, _houseTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_houseTypeMeta);
    }
    if (data.containsKey('ownership_type')) {
      context.handle(
        _ownershipTypeMeta,
        ownershipType.isAcceptableOrUnknown(
          data['ownership_type']!,
          _ownershipTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ownershipTypeMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('meter_number')) {
      context.handle(
        _meterNumberMeta,
        meterNumber.isAcceptableOrUnknown(
          data['meter_number']!,
          _meterNumberMeta,
        ),
      );
    }
    if (data.containsKey('default_price_per_unit')) {
      context.handle(
        _defaultPricePerUnitMeta,
        defaultPricePerUnit.isAcceptableOrUnknown(
          data['default_price_per_unit']!,
          _defaultPricePerUnitMeta,
        ),
      );
    }
    if (data.containsKey('free_units_per_month')) {
      context.handle(
        _freeUnitsPerMonthMeta,
        freeUnitsPerMonth.isAcceptableOrUnknown(
          data['free_units_per_month']!,
          _freeUnitsPerMonthMeta,
        ),
      );
    }
    if (data.containsKey('warning_limit_units')) {
      context.handle(
        _warningLimitUnitsMeta,
        warningLimitUnits.isAcceptableOrUnknown(
          data['warning_limit_units']!,
          _warningLimitUnitsMeta,
        ),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HouseDbModel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HouseDbModel(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      houseType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}house_type'],
      )!,
      ownershipType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ownership_type'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      meterNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meter_number'],
      )!,
      defaultPricePerUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}default_price_per_unit'],
      )!,
      freeUnitsPerMonth: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}free_units_per_month'],
      )!,
      warningLimitUnits: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}warning_limit_units'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
    );
  }

  @override
  $HousesTable createAlias(String alias) {
    return $HousesTable(attachedDatabase, alias);
  }
}

class HouseDbModel extends DataClass implements Insertable<HouseDbModel> {
  final String id;
  final String name;
  final String address;
  final String houseType;
  final String ownershipType;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final String meterNumber;
  final double defaultPricePerUnit;
  final double freeUnitsPerMonth;
  final double warningLimitUnits;
  final bool isArchived;
  const HouseDbModel({
    required this.id,
    required this.name,
    required this.address,
    required this.houseType,
    required this.ownershipType,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
    required this.meterNumber,
    required this.defaultPricePerUnit,
    required this.freeUnitsPerMonth,
    required this.warningLimitUnits,
    required this.isArchived,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['address'] = Variable<String>(address);
    map['house_type'] = Variable<String>(houseType);
    map['ownership_type'] = Variable<String>(ownershipType);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_active'] = Variable<bool>(isActive);
    map['meter_number'] = Variable<String>(meterNumber);
    map['default_price_per_unit'] = Variable<double>(defaultPricePerUnit);
    map['free_units_per_month'] = Variable<double>(freeUnitsPerMonth);
    map['warning_limit_units'] = Variable<double>(warningLimitUnits);
    map['is_archived'] = Variable<bool>(isArchived);
    return map;
  }

  HousesCompanion toCompanion(bool nullToAbsent) {
    return HousesCompanion(
      id: Value(id),
      name: Value(name),
      address: Value(address),
      houseType: Value(houseType),
      ownershipType: Value(ownershipType),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isActive: Value(isActive),
      meterNumber: Value(meterNumber),
      defaultPricePerUnit: Value(defaultPricePerUnit),
      freeUnitsPerMonth: Value(freeUnitsPerMonth),
      warningLimitUnits: Value(warningLimitUnits),
      isArchived: Value(isArchived),
    );
  }

  factory HouseDbModel.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HouseDbModel(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      address: serializer.fromJson<String>(json['address']),
      houseType: serializer.fromJson<String>(json['houseType']),
      ownershipType: serializer.fromJson<String>(json['ownershipType']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      meterNumber: serializer.fromJson<String>(json['meterNumber']),
      defaultPricePerUnit: serializer.fromJson<double>(
        json['defaultPricePerUnit'],
      ),
      freeUnitsPerMonth: serializer.fromJson<double>(json['freeUnitsPerMonth']),
      warningLimitUnits: serializer.fromJson<double>(json['warningLimitUnits']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'address': serializer.toJson<String>(address),
      'houseType': serializer.toJson<String>(houseType),
      'ownershipType': serializer.toJson<String>(ownershipType),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isActive': serializer.toJson<bool>(isActive),
      'meterNumber': serializer.toJson<String>(meterNumber),
      'defaultPricePerUnit': serializer.toJson<double>(defaultPricePerUnit),
      'freeUnitsPerMonth': serializer.toJson<double>(freeUnitsPerMonth),
      'warningLimitUnits': serializer.toJson<double>(warningLimitUnits),
      'isArchived': serializer.toJson<bool>(isArchived),
    };
  }

  HouseDbModel copyWith({
    String? id,
    String? name,
    String? address,
    String? houseType,
    String? ownershipType,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    String? meterNumber,
    double? defaultPricePerUnit,
    double? freeUnitsPerMonth,
    double? warningLimitUnits,
    bool? isArchived,
  }) => HouseDbModel(
    id: id ?? this.id,
    name: name ?? this.name,
    address: address ?? this.address,
    houseType: houseType ?? this.houseType,
    ownershipType: ownershipType ?? this.ownershipType,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isActive: isActive ?? this.isActive,
    meterNumber: meterNumber ?? this.meterNumber,
    defaultPricePerUnit: defaultPricePerUnit ?? this.defaultPricePerUnit,
    freeUnitsPerMonth: freeUnitsPerMonth ?? this.freeUnitsPerMonth,
    warningLimitUnits: warningLimitUnits ?? this.warningLimitUnits,
    isArchived: isArchived ?? this.isArchived,
  );
  HouseDbModel copyWithCompanion(HousesCompanion data) {
    return HouseDbModel(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      address: data.address.present ? data.address.value : this.address,
      houseType: data.houseType.present ? data.houseType.value : this.houseType,
      ownershipType: data.ownershipType.present
          ? data.ownershipType.value
          : this.ownershipType,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      meterNumber: data.meterNumber.present
          ? data.meterNumber.value
          : this.meterNumber,
      defaultPricePerUnit: data.defaultPricePerUnit.present
          ? data.defaultPricePerUnit.value
          : this.defaultPricePerUnit,
      freeUnitsPerMonth: data.freeUnitsPerMonth.present
          ? data.freeUnitsPerMonth.value
          : this.freeUnitsPerMonth,
      warningLimitUnits: data.warningLimitUnits.present
          ? data.warningLimitUnits.value
          : this.warningLimitUnits,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HouseDbModel(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('houseType: $houseType, ')
          ..write('ownershipType: $ownershipType, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isActive: $isActive, ')
          ..write('meterNumber: $meterNumber, ')
          ..write('defaultPricePerUnit: $defaultPricePerUnit, ')
          ..write('freeUnitsPerMonth: $freeUnitsPerMonth, ')
          ..write('warningLimitUnits: $warningLimitUnits, ')
          ..write('isArchived: $isArchived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
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
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HouseDbModel &&
          other.id == this.id &&
          other.name == this.name &&
          other.address == this.address &&
          other.houseType == this.houseType &&
          other.ownershipType == this.ownershipType &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isActive == this.isActive &&
          other.meterNumber == this.meterNumber &&
          other.defaultPricePerUnit == this.defaultPricePerUnit &&
          other.freeUnitsPerMonth == this.freeUnitsPerMonth &&
          other.warningLimitUnits == this.warningLimitUnits &&
          other.isArchived == this.isArchived);
}

class HousesCompanion extends UpdateCompanion<HouseDbModel> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> address;
  final Value<String> houseType;
  final Value<String> ownershipType;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isActive;
  final Value<String> meterNumber;
  final Value<double> defaultPricePerUnit;
  final Value<double> freeUnitsPerMonth;
  final Value<double> warningLimitUnits;
  final Value<bool> isArchived;
  final Value<int> rowid;
  const HousesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.address = const Value.absent(),
    this.houseType = const Value.absent(),
    this.ownershipType = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isActive = const Value.absent(),
    this.meterNumber = const Value.absent(),
    this.defaultPricePerUnit = const Value.absent(),
    this.freeUnitsPerMonth = const Value.absent(),
    this.warningLimitUnits = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HousesCompanion.insert({
    required String id,
    required String name,
    required String address,
    required String houseType,
    required String ownershipType,
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.isActive = const Value.absent(),
    this.meterNumber = const Value.absent(),
    this.defaultPricePerUnit = const Value.absent(),
    this.freeUnitsPerMonth = const Value.absent(),
    this.warningLimitUnits = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       address = Value(address),
       houseType = Value(houseType),
       ownershipType = Value(ownershipType),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<HouseDbModel> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? address,
    Expression<String>? houseType,
    Expression<String>? ownershipType,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isActive,
    Expression<String>? meterNumber,
    Expression<double>? defaultPricePerUnit,
    Expression<double>? freeUnitsPerMonth,
    Expression<double>? warningLimitUnits,
    Expression<bool>? isArchived,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (address != null) 'address': address,
      if (houseType != null) 'house_type': houseType,
      if (ownershipType != null) 'ownership_type': ownershipType,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isActive != null) 'is_active': isActive,
      if (meterNumber != null) 'meter_number': meterNumber,
      if (defaultPricePerUnit != null)
        'default_price_per_unit': defaultPricePerUnit,
      if (freeUnitsPerMonth != null) 'free_units_per_month': freeUnitsPerMonth,
      if (warningLimitUnits != null) 'warning_limit_units': warningLimitUnits,
      if (isArchived != null) 'is_archived': isArchived,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HousesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? address,
    Value<String>? houseType,
    Value<String>? ownershipType,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? isActive,
    Value<String>? meterNumber,
    Value<double>? defaultPricePerUnit,
    Value<double>? freeUnitsPerMonth,
    Value<double>? warningLimitUnits,
    Value<bool>? isArchived,
    Value<int>? rowid,
  }) {
    return HousesCompanion(
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
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (houseType.present) {
      map['house_type'] = Variable<String>(houseType.value);
    }
    if (ownershipType.present) {
      map['ownership_type'] = Variable<String>(ownershipType.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (meterNumber.present) {
      map['meter_number'] = Variable<String>(meterNumber.value);
    }
    if (defaultPricePerUnit.present) {
      map['default_price_per_unit'] = Variable<double>(
        defaultPricePerUnit.value,
      );
    }
    if (freeUnitsPerMonth.present) {
      map['free_units_per_month'] = Variable<double>(freeUnitsPerMonth.value);
    }
    if (warningLimitUnits.present) {
      map['warning_limit_units'] = Variable<double>(warningLimitUnits.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HousesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('houseType: $houseType, ')
          ..write('ownershipType: $ownershipType, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isActive: $isActive, ')
          ..write('meterNumber: $meterNumber, ')
          ..write('defaultPricePerUnit: $defaultPricePerUnit, ')
          ..write('freeUnitsPerMonth: $freeUnitsPerMonth, ')
          ..write('warningLimitUnits: $warningLimitUnits, ')
          ..write('isArchived: $isArchived, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $HousesTable houses = $HousesTable(this);
  late final Index housesTypeIdx = Index(
    'houses_type_idx',
    'CREATE INDEX houses_type_idx ON houses (house_type)',
  );
  late final Index housesOwnershipIdx = Index(
    'houses_ownership_idx',
    'CREATE INDEX houses_ownership_idx ON houses (ownership_type)',
  );
  late final Index housesNameIdx = Index(
    'houses_name_idx',
    'CREATE INDEX houses_name_idx ON houses (name)',
  );
  late final Index housesCreatedIdx = Index(
    'houses_created_idx',
    'CREATE INDEX houses_created_idx ON houses (created_at)',
  );
  late final Index housesTypeCreatedIdx = Index(
    'houses_type_created_idx',
    'CREATE INDEX houses_type_created_idx ON houses (house_type, created_at)',
  );
  late final Index housesOwnershipCreatedIdx = Index(
    'houses_ownership_created_idx',
    'CREATE INDEX houses_ownership_created_idx ON houses (ownership_type, created_at)',
  );
  late final Index housesMeterIdx = Index(
    'houses_meter_idx',
    'CREATE INDEX houses_meter_idx ON houses (meter_number)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    houses,
    housesTypeIdx,
    housesOwnershipIdx,
    housesNameIdx,
    housesCreatedIdx,
    housesTypeCreatedIdx,
    housesOwnershipCreatedIdx,
    housesMeterIdx,
  ];
}

typedef $$HousesTableCreateCompanionBuilder =
    HousesCompanion Function({
      required String id,
      required String name,
      required String address,
      required String houseType,
      required String ownershipType,
      Value<String?> notes,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<bool> isActive,
      Value<String> meterNumber,
      Value<double> defaultPricePerUnit,
      Value<double> freeUnitsPerMonth,
      Value<double> warningLimitUnits,
      Value<bool> isArchived,
      Value<int> rowid,
    });
typedef $$HousesTableUpdateCompanionBuilder =
    HousesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> address,
      Value<String> houseType,
      Value<String> ownershipType,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isActive,
      Value<String> meterNumber,
      Value<double> defaultPricePerUnit,
      Value<double> freeUnitsPerMonth,
      Value<double> warningLimitUnits,
      Value<bool> isArchived,
      Value<int> rowid,
    });

class $$HousesTableFilterComposer
    extends Composer<_$AppDatabase, $HousesTable> {
  $$HousesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get houseType => $composableBuilder(
    column: $table.houseType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownershipType => $composableBuilder(
    column: $table.ownershipType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get meterNumber => $composableBuilder(
    column: $table.meterNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get defaultPricePerUnit => $composableBuilder(
    column: $table.defaultPricePerUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get freeUnitsPerMonth => $composableBuilder(
    column: $table.freeUnitsPerMonth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get warningLimitUnits => $composableBuilder(
    column: $table.warningLimitUnits,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HousesTableOrderingComposer
    extends Composer<_$AppDatabase, $HousesTable> {
  $$HousesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get houseType => $composableBuilder(
    column: $table.houseType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownershipType => $composableBuilder(
    column: $table.ownershipType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get meterNumber => $composableBuilder(
    column: $table.meterNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get defaultPricePerUnit => $composableBuilder(
    column: $table.defaultPricePerUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get freeUnitsPerMonth => $composableBuilder(
    column: $table.freeUnitsPerMonth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get warningLimitUnits => $composableBuilder(
    column: $table.warningLimitUnits,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HousesTableAnnotationComposer
    extends Composer<_$AppDatabase, $HousesTable> {
  $$HousesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get houseType =>
      $composableBuilder(column: $table.houseType, builder: (column) => column);

  GeneratedColumn<String> get ownershipType => $composableBuilder(
    column: $table.ownershipType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get meterNumber => $composableBuilder(
    column: $table.meterNumber,
    builder: (column) => column,
  );

  GeneratedColumn<double> get defaultPricePerUnit => $composableBuilder(
    column: $table.defaultPricePerUnit,
    builder: (column) => column,
  );

  GeneratedColumn<double> get freeUnitsPerMonth => $composableBuilder(
    column: $table.freeUnitsPerMonth,
    builder: (column) => column,
  );

  GeneratedColumn<double> get warningLimitUnits => $composableBuilder(
    column: $table.warningLimitUnits,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );
}

class $$HousesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HousesTable,
          HouseDbModel,
          $$HousesTableFilterComposer,
          $$HousesTableOrderingComposer,
          $$HousesTableAnnotationComposer,
          $$HousesTableCreateCompanionBuilder,
          $$HousesTableUpdateCompanionBuilder,
          (
            HouseDbModel,
            BaseReferences<_$AppDatabase, $HousesTable, HouseDbModel>,
          ),
          HouseDbModel,
          PrefetchHooks Function()
        > {
  $$HousesTableTableManager(_$AppDatabase db, $HousesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HousesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HousesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HousesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String> houseType = const Value.absent(),
                Value<String> ownershipType = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<String> meterNumber = const Value.absent(),
                Value<double> defaultPricePerUnit = const Value.absent(),
                Value<double> freeUnitsPerMonth = const Value.absent(),
                Value<double> warningLimitUnits = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HousesCompanion(
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
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String address,
                required String houseType,
                required String ownershipType,
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<bool> isActive = const Value.absent(),
                Value<String> meterNumber = const Value.absent(),
                Value<double> defaultPricePerUnit = const Value.absent(),
                Value<double> freeUnitsPerMonth = const Value.absent(),
                Value<double> warningLimitUnits = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HousesCompanion.insert(
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
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HousesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HousesTable,
      HouseDbModel,
      $$HousesTableFilterComposer,
      $$HousesTableOrderingComposer,
      $$HousesTableAnnotationComposer,
      $$HousesTableCreateCompanionBuilder,
      $$HousesTableUpdateCompanionBuilder,
      (HouseDbModel, BaseReferences<_$AppDatabase, $HousesTable, HouseDbModel>),
      HouseDbModel,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$HousesTableTableManager get houses =>
      $$HousesTableTableManager(_db, _db.houses);
}
