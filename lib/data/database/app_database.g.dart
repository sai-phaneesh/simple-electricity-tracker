// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $HousesTableTable extends HousesTable
    with TableInfo<$HousesTableTable, House> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HousesTableTable(this.attachedDatabase, [this._alias]);
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
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _meterNumberMeta = const VerificationMeta(
    'meterNumber',
  );
  @override
  late final GeneratedColumn<String> meterNumber = GeneratedColumn<String>(
    'meter_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _needsSyncMeta = const VerificationMeta(
    'needsSync',
  );
  @override
  late final GeneratedColumn<bool> needsSync = GeneratedColumn<bool>(
    'needs_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("needs_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _lastSyncAtMeta = const VerificationMeta(
    'lastSyncAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncAt = GeneratedColumn<DateTime>(
    'last_sync_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    address,
    meterNumber,
    defaultPricePerUnit,
    notes,
    createdAt,
    updatedAt,
    isDeleted,
    needsSync,
    lastSyncAt,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'houses';
  @override
  VerificationContext validateIntegrity(
    Insertable<House> instance, {
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
    }
    if (data.containsKey('meterNumber')) {
      context.handle(
        _meterNumberMeta,
        meterNumber.isAcceptableOrUnknown(
          data['meterNumber']!,
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
    } else if (isInserting) {
      context.missing(_defaultPricePerUnitMeta);
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
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('needs_sync')) {
      context.handle(
        _needsSyncMeta,
        needsSync.isAcceptableOrUnknown(data['needs_sync']!, _needsSyncMeta),
      );
    }
    if (data.containsKey('last_sync_at')) {
      context.handle(
        _lastSyncAtMeta,
        lastSyncAt.isAcceptableOrUnknown(
          data['last_sync_at']!,
          _lastSyncAtMeta,
        ),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  House map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return House(
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
      ),
      meterNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meter_number'],
      ),
      defaultPricePerUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}default_price_per_unit'],
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
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      needsSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}needs_sync'],
      )!,
      lastSyncAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_sync_at'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $HousesTableTable createAlias(String alias) {
    return $HousesTableTable(attachedDatabase, alias);
  }
}

class House extends DataClass implements Insertable<House> {
  final String id;
  final String name;
  final String? address;
  final String? meterNumber;
  final double defaultPricePerUnit;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isDeleted;
  final bool needsSync;
  final DateTime? lastSyncAt;
  final String syncStatus;
  const House({
    required this.id,
    required this.name,
    this.address,
    this.meterNumber,
    required this.defaultPricePerUnit,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
    required this.needsSync,
    this.lastSyncAt,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || meterNumber != null) {
      map['meter_number'] = Variable<String>(meterNumber);
    }
    map['default_price_per_unit'] = Variable<double>(defaultPricePerUnit);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['needs_sync'] = Variable<bool>(needsSync);
    if (!nullToAbsent || lastSyncAt != null) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  HousesTableCompanion toCompanion(bool nullToAbsent) {
    return HousesTableCompanion(
      id: Value(id),
      name: Value(name),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      meterNumber: meterNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(meterNumber),
      defaultPricePerUnit: Value(defaultPricePerUnit),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isDeleted: Value(isDeleted),
      needsSync: Value(needsSync),
      lastSyncAt: lastSyncAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncAt),
      syncStatus: Value(syncStatus),
    );
  }

  factory House.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return House(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      address: serializer.fromJson<String?>(json['address']),
      meterNumber: serializer.fromJson<String?>(json['meterNumber']),
      defaultPricePerUnit: serializer.fromJson<double>(
        json['defaultPricePerUnit'],
      ),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      needsSync: serializer.fromJson<bool>(json['needsSync']),
      lastSyncAt: serializer.fromJson<DateTime?>(json['lastSyncAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'address': serializer.toJson<String?>(address),
      'meterNumber': serializer.toJson<String?>(meterNumber),
      'defaultPricePerUnit': serializer.toJson<double>(defaultPricePerUnit),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'needsSync': serializer.toJson<bool>(needsSync),
      'lastSyncAt': serializer.toJson<DateTime?>(lastSyncAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  House copyWith({
    String? id,
    String? name,
    Value<String?> address = const Value.absent(),
    Value<String?> meterNumber = const Value.absent(),
    double? defaultPricePerUnit,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
    bool? needsSync,
    Value<DateTime?> lastSyncAt = const Value.absent(),
    String? syncStatus,
  }) => House(
    id: id ?? this.id,
    name: name ?? this.name,
    address: address.present ? address.value : this.address,
    meterNumber: meterNumber.present ? meterNumber.value : this.meterNumber,
    defaultPricePerUnit: defaultPricePerUnit ?? this.defaultPricePerUnit,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isDeleted: isDeleted ?? this.isDeleted,
    needsSync: needsSync ?? this.needsSync,
    lastSyncAt: lastSyncAt.present ? lastSyncAt.value : this.lastSyncAt,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  House copyWithCompanion(HousesTableCompanion data) {
    return House(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      address: data.address.present ? data.address.value : this.address,
      meterNumber: data.meterNumber.present
          ? data.meterNumber.value
          : this.meterNumber,
      defaultPricePerUnit: data.defaultPricePerUnit.present
          ? data.defaultPricePerUnit.value
          : this.defaultPricePerUnit,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      needsSync: data.needsSync.present ? data.needsSync.value : this.needsSync,
      lastSyncAt: data.lastSyncAt.present
          ? data.lastSyncAt.value
          : this.lastSyncAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('House(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('meterNumber: $meterNumber, ')
          ..write('defaultPricePerUnit: $defaultPricePerUnit, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('needsSync: $needsSync, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    address,
    meterNumber,
    defaultPricePerUnit,
    notes,
    createdAt,
    updatedAt,
    isDeleted,
    needsSync,
    lastSyncAt,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is House &&
          other.id == this.id &&
          other.name == this.name &&
          other.address == this.address &&
          other.meterNumber == this.meterNumber &&
          other.defaultPricePerUnit == this.defaultPricePerUnit &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isDeleted == this.isDeleted &&
          other.needsSync == this.needsSync &&
          other.lastSyncAt == this.lastSyncAt &&
          other.syncStatus == this.syncStatus);
}

class HousesTableCompanion extends UpdateCompanion<House> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> address;
  final Value<String?> meterNumber;
  final Value<double> defaultPricePerUnit;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isDeleted;
  final Value<bool> needsSync;
  final Value<DateTime?> lastSyncAt;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const HousesTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.address = const Value.absent(),
    this.meterNumber = const Value.absent(),
    this.defaultPricePerUnit = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.needsSync = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HousesTableCompanion.insert({
    required String id,
    required String name,
    this.address = const Value.absent(),
    this.meterNumber = const Value.absent(),
    required double defaultPricePerUnit,
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.isDeleted = const Value.absent(),
    this.needsSync = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       defaultPricePerUnit = Value(defaultPricePerUnit),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<House> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? address,
    Expression<String>? meterNumber,
    Expression<double>? defaultPricePerUnit,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isDeleted,
    Expression<bool>? needsSync,
    Expression<DateTime>? lastSyncAt,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (address != null) 'address': address,
      if (meterNumber != null) 'meter_number': meterNumber,
      if (defaultPricePerUnit != null)
        'default_price_per_unit': defaultPricePerUnit,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (needsSync != null) 'needs_sync': needsSync,
      if (lastSyncAt != null) 'last_sync_at': lastSyncAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HousesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? address,
    Value<String?>? meterNumber,
    Value<double>? defaultPricePerUnit,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? isDeleted,
    Value<bool>? needsSync,
    Value<DateTime?>? lastSyncAt,
    Value<String>? syncStatus,
    Value<int>? rowid,
  }) {
    return HousesTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      meterNumber: meterNumber ?? this.meterNumber,
      defaultPricePerUnit: defaultPricePerUnit ?? this.defaultPricePerUnit,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      needsSync: needsSync ?? this.needsSync,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      syncStatus: syncStatus ?? this.syncStatus,
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
    if (meterNumber.present) {
      map['meter_number'] = Variable<String>(meterNumber.value);
    }
    if (defaultPricePerUnit.present) {
      map['default_price_per_unit'] = Variable<double>(
        defaultPricePerUnit.value,
      );
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
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (needsSync.present) {
      map['needs_sync'] = Variable<bool>(needsSync.value);
    }
    if (lastSyncAt.present) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HousesTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('meterNumber: $meterNumber, ')
          ..write('defaultPricePerUnit: $defaultPricePerUnit, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('needsSync: $needsSync, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CyclesTableTable extends CyclesTable
    with TableInfo<$CyclesTableTable, Cycle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CyclesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _houseIdMeta = const VerificationMeta(
    'houseId',
  );
  @override
  late final GeneratedColumn<String> houseId = GeneratedColumn<String>(
    'house_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES houses (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _initialMeterReadingMeta =
      const VerificationMeta('initialMeterReading');
  @override
  late final GeneratedColumn<int> initialMeterReading = GeneratedColumn<int>(
    'initial_meter_reading',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _maxUnitsMeta = const VerificationMeta(
    'maxUnits',
  );
  @override
  late final GeneratedColumn<int> maxUnits = GeneratedColumn<int>(
    'max_units',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pricePerUnitMeta = const VerificationMeta(
    'pricePerUnit',
  );
  @override
  late final GeneratedColumn<double> pricePerUnit = GeneratedColumn<double>(
    'price_per_unit',
    aliasedName,
    false,
    type: DriftSqlType.double,
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
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _needsSyncMeta = const VerificationMeta(
    'needsSync',
  );
  @override
  late final GeneratedColumn<bool> needsSync = GeneratedColumn<bool>(
    'needs_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("needs_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _lastSyncAtMeta = const VerificationMeta(
    'lastSyncAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncAt = GeneratedColumn<DateTime>(
    'last_sync_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  @override
  List<GeneratedColumn> get $columns => [
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
    isDeleted,
    needsSync,
    lastSyncAt,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cycles';
  @override
  VerificationContext validateIntegrity(
    Insertable<Cycle> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('house_id')) {
      context.handle(
        _houseIdMeta,
        houseId.isAcceptableOrUnknown(data['house_id']!, _houseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_houseIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('initial_meter_reading')) {
      context.handle(
        _initialMeterReadingMeta,
        initialMeterReading.isAcceptableOrUnknown(
          data['initial_meter_reading']!,
          _initialMeterReadingMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_initialMeterReadingMeta);
    }
    if (data.containsKey('max_units')) {
      context.handle(
        _maxUnitsMeta,
        maxUnits.isAcceptableOrUnknown(data['max_units']!, _maxUnitsMeta),
      );
    } else if (isInserting) {
      context.missing(_maxUnitsMeta);
    }
    if (data.containsKey('price_per_unit')) {
      context.handle(
        _pricePerUnitMeta,
        pricePerUnit.isAcceptableOrUnknown(
          data['price_per_unit']!,
          _pricePerUnitMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_pricePerUnitMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
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
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('needs_sync')) {
      context.handle(
        _needsSyncMeta,
        needsSync.isAcceptableOrUnknown(data['needs_sync']!, _needsSyncMeta),
      );
    }
    if (data.containsKey('last_sync_at')) {
      context.handle(
        _lastSyncAtMeta,
        lastSyncAt.isAcceptableOrUnknown(
          data['last_sync_at']!,
          _lastSyncAtMeta,
        ),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Cycle map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Cycle(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      houseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}house_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      )!,
      initialMeterReading: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}initial_meter_reading'],
      )!,
      maxUnits: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_units'],
      )!,
      pricePerUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price_per_unit'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      needsSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}needs_sync'],
      )!,
      lastSyncAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_sync_at'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $CyclesTableTable createAlias(String alias) {
    return $CyclesTableTable(attachedDatabase, alias);
  }
}

class Cycle extends DataClass implements Insertable<Cycle> {
  final String id;
  final String houseId;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final int initialMeterReading;
  final int maxUnits;
  final double pricePerUnit;
  final String? notes;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isDeleted;
  final bool needsSync;
  final DateTime? lastSyncAt;
  final String syncStatus;
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
    required this.isDeleted,
    required this.needsSync,
    this.lastSyncAt,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['house_id'] = Variable<String>(houseId);
    map['name'] = Variable<String>(name);
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    map['initial_meter_reading'] = Variable<int>(initialMeterReading);
    map['max_units'] = Variable<int>(maxUnits);
    map['price_per_unit'] = Variable<double>(pricePerUnit);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['needs_sync'] = Variable<bool>(needsSync);
    if (!nullToAbsent || lastSyncAt != null) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  CyclesTableCompanion toCompanion(bool nullToAbsent) {
    return CyclesTableCompanion(
      id: Value(id),
      houseId: Value(houseId),
      name: Value(name),
      startDate: Value(startDate),
      endDate: Value(endDate),
      initialMeterReading: Value(initialMeterReading),
      maxUnits: Value(maxUnits),
      pricePerUnit: Value(pricePerUnit),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isDeleted: Value(isDeleted),
      needsSync: Value(needsSync),
      lastSyncAt: lastSyncAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncAt),
      syncStatus: Value(syncStatus),
    );
  }

  factory Cycle.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Cycle(
      id: serializer.fromJson<String>(json['id']),
      houseId: serializer.fromJson<String>(json['houseId']),
      name: serializer.fromJson<String>(json['name']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      initialMeterReading: serializer.fromJson<int>(
        json['initialMeterReading'],
      ),
      maxUnits: serializer.fromJson<int>(json['maxUnits']),
      pricePerUnit: serializer.fromJson<double>(json['pricePerUnit']),
      notes: serializer.fromJson<String?>(json['notes']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      needsSync: serializer.fromJson<bool>(json['needsSync']),
      lastSyncAt: serializer.fromJson<DateTime?>(json['lastSyncAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'houseId': serializer.toJson<String>(houseId),
      'name': serializer.toJson<String>(name),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'initialMeterReading': serializer.toJson<int>(initialMeterReading),
      'maxUnits': serializer.toJson<int>(maxUnits),
      'pricePerUnit': serializer.toJson<double>(pricePerUnit),
      'notes': serializer.toJson<String?>(notes),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'needsSync': serializer.toJson<bool>(needsSync),
      'lastSyncAt': serializer.toJson<DateTime?>(lastSyncAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
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
    Value<String?> notes = const Value.absent(),
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
    bool? needsSync,
    Value<DateTime?> lastSyncAt = const Value.absent(),
    String? syncStatus,
  }) => Cycle(
    id: id ?? this.id,
    houseId: houseId ?? this.houseId,
    name: name ?? this.name,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    initialMeterReading: initialMeterReading ?? this.initialMeterReading,
    maxUnits: maxUnits ?? this.maxUnits,
    pricePerUnit: pricePerUnit ?? this.pricePerUnit,
    notes: notes.present ? notes.value : this.notes,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isDeleted: isDeleted ?? this.isDeleted,
    needsSync: needsSync ?? this.needsSync,
    lastSyncAt: lastSyncAt.present ? lastSyncAt.value : this.lastSyncAt,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  Cycle copyWithCompanion(CyclesTableCompanion data) {
    return Cycle(
      id: data.id.present ? data.id.value : this.id,
      houseId: data.houseId.present ? data.houseId.value : this.houseId,
      name: data.name.present ? data.name.value : this.name,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      initialMeterReading: data.initialMeterReading.present
          ? data.initialMeterReading.value
          : this.initialMeterReading,
      maxUnits: data.maxUnits.present ? data.maxUnits.value : this.maxUnits,
      pricePerUnit: data.pricePerUnit.present
          ? data.pricePerUnit.value
          : this.pricePerUnit,
      notes: data.notes.present ? data.notes.value : this.notes,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      needsSync: data.needsSync.present ? data.needsSync.value : this.needsSync,
      lastSyncAt: data.lastSyncAt.present
          ? data.lastSyncAt.value
          : this.lastSyncAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Cycle(')
          ..write('id: $id, ')
          ..write('houseId: $houseId, ')
          ..write('name: $name, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('initialMeterReading: $initialMeterReading, ')
          ..write('maxUnits: $maxUnits, ')
          ..write('pricePerUnit: $pricePerUnit, ')
          ..write('notes: $notes, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('needsSync: $needsSync, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
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
    isDeleted,
    needsSync,
    lastSyncAt,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Cycle &&
          other.id == this.id &&
          other.houseId == this.houseId &&
          other.name == this.name &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.initialMeterReading == this.initialMeterReading &&
          other.maxUnits == this.maxUnits &&
          other.pricePerUnit == this.pricePerUnit &&
          other.notes == this.notes &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isDeleted == this.isDeleted &&
          other.needsSync == this.needsSync &&
          other.lastSyncAt == this.lastSyncAt &&
          other.syncStatus == this.syncStatus);
}

class CyclesTableCompanion extends UpdateCompanion<Cycle> {
  final Value<String> id;
  final Value<String> houseId;
  final Value<String> name;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<int> initialMeterReading;
  final Value<int> maxUnits;
  final Value<double> pricePerUnit;
  final Value<String?> notes;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isDeleted;
  final Value<bool> needsSync;
  final Value<DateTime?> lastSyncAt;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const CyclesTableCompanion({
    this.id = const Value.absent(),
    this.houseId = const Value.absent(),
    this.name = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.initialMeterReading = const Value.absent(),
    this.maxUnits = const Value.absent(),
    this.pricePerUnit = const Value.absent(),
    this.notes = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.needsSync = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CyclesTableCompanion.insert({
    required String id,
    required String houseId,
    required String name,
    required DateTime startDate,
    required DateTime endDate,
    required int initialMeterReading,
    required int maxUnits,
    required double pricePerUnit,
    this.notes = const Value.absent(),
    this.isActive = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.isDeleted = const Value.absent(),
    this.needsSync = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       houseId = Value(houseId),
       name = Value(name),
       startDate = Value(startDate),
       endDate = Value(endDate),
       initialMeterReading = Value(initialMeterReading),
       maxUnits = Value(maxUnits),
       pricePerUnit = Value(pricePerUnit),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Cycle> custom({
    Expression<String>? id,
    Expression<String>? houseId,
    Expression<String>? name,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<int>? initialMeterReading,
    Expression<int>? maxUnits,
    Expression<double>? pricePerUnit,
    Expression<String>? notes,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isDeleted,
    Expression<bool>? needsSync,
    Expression<DateTime>? lastSyncAt,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (houseId != null) 'house_id': houseId,
      if (name != null) 'name': name,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (initialMeterReading != null)
        'initial_meter_reading': initialMeterReading,
      if (maxUnits != null) 'max_units': maxUnits,
      if (pricePerUnit != null) 'price_per_unit': pricePerUnit,
      if (notes != null) 'notes': notes,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (needsSync != null) 'needs_sync': needsSync,
      if (lastSyncAt != null) 'last_sync_at': lastSyncAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CyclesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? houseId,
    Value<String>? name,
    Value<DateTime>? startDate,
    Value<DateTime>? endDate,
    Value<int>? initialMeterReading,
    Value<int>? maxUnits,
    Value<double>? pricePerUnit,
    Value<String?>? notes,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? isDeleted,
    Value<bool>? needsSync,
    Value<DateTime?>? lastSyncAt,
    Value<String>? syncStatus,
    Value<int>? rowid,
  }) {
    return CyclesTableCompanion(
      id: id ?? this.id,
      houseId: houseId ?? this.houseId,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      initialMeterReading: initialMeterReading ?? this.initialMeterReading,
      maxUnits: maxUnits ?? this.maxUnits,
      pricePerUnit: pricePerUnit ?? this.pricePerUnit,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      needsSync: needsSync ?? this.needsSync,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (houseId.present) {
      map['house_id'] = Variable<String>(houseId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (initialMeterReading.present) {
      map['initial_meter_reading'] = Variable<int>(initialMeterReading.value);
    }
    if (maxUnits.present) {
      map['max_units'] = Variable<int>(maxUnits.value);
    }
    if (pricePerUnit.present) {
      map['price_per_unit'] = Variable<double>(pricePerUnit.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (needsSync.present) {
      map['needs_sync'] = Variable<bool>(needsSync.value);
    }
    if (lastSyncAt.present) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CyclesTableCompanion(')
          ..write('id: $id, ')
          ..write('houseId: $houseId, ')
          ..write('name: $name, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('initialMeterReading: $initialMeterReading, ')
          ..write('maxUnits: $maxUnits, ')
          ..write('pricePerUnit: $pricePerUnit, ')
          ..write('notes: $notes, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('needsSync: $needsSync, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ElectricityReadingsTableTable extends ElectricityReadingsTable
    with TableInfo<$ElectricityReadingsTableTable, ElectricityReading> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ElectricityReadingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _houseIdMeta = const VerificationMeta(
    'houseId',
  );
  @override
  late final GeneratedColumn<String> houseId = GeneratedColumn<String>(
    'house_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES houses (id)',
    ),
  );
  static const VerificationMeta _cycleIdMeta = const VerificationMeta(
    'cycleId',
  );
  @override
  late final GeneratedColumn<String> cycleId = GeneratedColumn<String>(
    'cycle_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cycles (id)',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _meterReadingMeta = const VerificationMeta(
    'meterReading',
  );
  @override
  late final GeneratedColumn<int> meterReading = GeneratedColumn<int>(
    'meter_reading',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitsConsumedMeta = const VerificationMeta(
    'unitsConsumed',
  );
  @override
  late final GeneratedColumn<int> unitsConsumed = GeneratedColumn<int>(
    'units_consumed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalCostMeta = const VerificationMeta(
    'totalCost',
  );
  @override
  late final GeneratedColumn<double> totalCost = GeneratedColumn<double>(
    'total_cost',
    aliasedName,
    false,
    type: DriftSqlType.double,
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
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _needsSyncMeta = const VerificationMeta(
    'needsSync',
  );
  @override
  late final GeneratedColumn<bool> needsSync = GeneratedColumn<bool>(
    'needs_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("needs_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _lastSyncAtMeta = const VerificationMeta(
    'lastSyncAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncAt = GeneratedColumn<DateTime>(
    'last_sync_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  @override
  List<GeneratedColumn> get $columns => [
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
    isDeleted,
    needsSync,
    lastSyncAt,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'electricity_readings';
  @override
  VerificationContext validateIntegrity(
    Insertable<ElectricityReading> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('house_id')) {
      context.handle(
        _houseIdMeta,
        houseId.isAcceptableOrUnknown(data['house_id']!, _houseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_houseIdMeta);
    }
    if (data.containsKey('cycle_id')) {
      context.handle(
        _cycleIdMeta,
        cycleId.isAcceptableOrUnknown(data['cycle_id']!, _cycleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cycleIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('meter_reading')) {
      context.handle(
        _meterReadingMeta,
        meterReading.isAcceptableOrUnknown(
          data['meter_reading']!,
          _meterReadingMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_meterReadingMeta);
    }
    if (data.containsKey('units_consumed')) {
      context.handle(
        _unitsConsumedMeta,
        unitsConsumed.isAcceptableOrUnknown(
          data['units_consumed']!,
          _unitsConsumedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_unitsConsumedMeta);
    }
    if (data.containsKey('total_cost')) {
      context.handle(
        _totalCostMeta,
        totalCost.isAcceptableOrUnknown(data['total_cost']!, _totalCostMeta),
      );
    } else if (isInserting) {
      context.missing(_totalCostMeta);
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
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('needs_sync')) {
      context.handle(
        _needsSyncMeta,
        needsSync.isAcceptableOrUnknown(data['needs_sync']!, _needsSyncMeta),
      );
    }
    if (data.containsKey('last_sync_at')) {
      context.handle(
        _lastSyncAtMeta,
        lastSyncAt.isAcceptableOrUnknown(
          data['last_sync_at']!,
          _lastSyncAtMeta,
        ),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ElectricityReading map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ElectricityReading(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      houseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}house_id'],
      )!,
      cycleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cycle_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      meterReading: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}meter_reading'],
      )!,
      unitsConsumed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}units_consumed'],
      )!,
      totalCost: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_cost'],
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
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      needsSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}needs_sync'],
      )!,
      lastSyncAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_sync_at'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $ElectricityReadingsTableTable createAlias(String alias) {
    return $ElectricityReadingsTableTable(attachedDatabase, alias);
  }
}

class ElectricityReading extends DataClass
    implements Insertable<ElectricityReading> {
  final String id;
  final String houseId;
  final String cycleId;
  final DateTime date;
  final int meterReading;
  final int unitsConsumed;
  final double totalCost;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isDeleted;
  final bool needsSync;
  final DateTime? lastSyncAt;
  final String syncStatus;
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
    required this.isDeleted,
    required this.needsSync,
    this.lastSyncAt,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['house_id'] = Variable<String>(houseId);
    map['cycle_id'] = Variable<String>(cycleId);
    map['date'] = Variable<DateTime>(date);
    map['meter_reading'] = Variable<int>(meterReading);
    map['units_consumed'] = Variable<int>(unitsConsumed);
    map['total_cost'] = Variable<double>(totalCost);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['needs_sync'] = Variable<bool>(needsSync);
    if (!nullToAbsent || lastSyncAt != null) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  ElectricityReadingsTableCompanion toCompanion(bool nullToAbsent) {
    return ElectricityReadingsTableCompanion(
      id: Value(id),
      houseId: Value(houseId),
      cycleId: Value(cycleId),
      date: Value(date),
      meterReading: Value(meterReading),
      unitsConsumed: Value(unitsConsumed),
      totalCost: Value(totalCost),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isDeleted: Value(isDeleted),
      needsSync: Value(needsSync),
      lastSyncAt: lastSyncAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncAt),
      syncStatus: Value(syncStatus),
    );
  }

  factory ElectricityReading.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ElectricityReading(
      id: serializer.fromJson<String>(json['id']),
      houseId: serializer.fromJson<String>(json['houseId']),
      cycleId: serializer.fromJson<String>(json['cycleId']),
      date: serializer.fromJson<DateTime>(json['date']),
      meterReading: serializer.fromJson<int>(json['meterReading']),
      unitsConsumed: serializer.fromJson<int>(json['unitsConsumed']),
      totalCost: serializer.fromJson<double>(json['totalCost']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      needsSync: serializer.fromJson<bool>(json['needsSync']),
      lastSyncAt: serializer.fromJson<DateTime?>(json['lastSyncAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'houseId': serializer.toJson<String>(houseId),
      'cycleId': serializer.toJson<String>(cycleId),
      'date': serializer.toJson<DateTime>(date),
      'meterReading': serializer.toJson<int>(meterReading),
      'unitsConsumed': serializer.toJson<int>(unitsConsumed),
      'totalCost': serializer.toJson<double>(totalCost),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'needsSync': serializer.toJson<bool>(needsSync),
      'lastSyncAt': serializer.toJson<DateTime?>(lastSyncAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  ElectricityReading copyWith({
    String? id,
    String? houseId,
    String? cycleId,
    DateTime? date,
    int? meterReading,
    int? unitsConsumed,
    double? totalCost,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
    bool? needsSync,
    Value<DateTime?> lastSyncAt = const Value.absent(),
    String? syncStatus,
  }) => ElectricityReading(
    id: id ?? this.id,
    houseId: houseId ?? this.houseId,
    cycleId: cycleId ?? this.cycleId,
    date: date ?? this.date,
    meterReading: meterReading ?? this.meterReading,
    unitsConsumed: unitsConsumed ?? this.unitsConsumed,
    totalCost: totalCost ?? this.totalCost,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isDeleted: isDeleted ?? this.isDeleted,
    needsSync: needsSync ?? this.needsSync,
    lastSyncAt: lastSyncAt.present ? lastSyncAt.value : this.lastSyncAt,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  ElectricityReading copyWithCompanion(ElectricityReadingsTableCompanion data) {
    return ElectricityReading(
      id: data.id.present ? data.id.value : this.id,
      houseId: data.houseId.present ? data.houseId.value : this.houseId,
      cycleId: data.cycleId.present ? data.cycleId.value : this.cycleId,
      date: data.date.present ? data.date.value : this.date,
      meterReading: data.meterReading.present
          ? data.meterReading.value
          : this.meterReading,
      unitsConsumed: data.unitsConsumed.present
          ? data.unitsConsumed.value
          : this.unitsConsumed,
      totalCost: data.totalCost.present ? data.totalCost.value : this.totalCost,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      needsSync: data.needsSync.present ? data.needsSync.value : this.needsSync,
      lastSyncAt: data.lastSyncAt.present
          ? data.lastSyncAt.value
          : this.lastSyncAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ElectricityReading(')
          ..write('id: $id, ')
          ..write('houseId: $houseId, ')
          ..write('cycleId: $cycleId, ')
          ..write('date: $date, ')
          ..write('meterReading: $meterReading, ')
          ..write('unitsConsumed: $unitsConsumed, ')
          ..write('totalCost: $totalCost, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('needsSync: $needsSync, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
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
    isDeleted,
    needsSync,
    lastSyncAt,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ElectricityReading &&
          other.id == this.id &&
          other.houseId == this.houseId &&
          other.cycleId == this.cycleId &&
          other.date == this.date &&
          other.meterReading == this.meterReading &&
          other.unitsConsumed == this.unitsConsumed &&
          other.totalCost == this.totalCost &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isDeleted == this.isDeleted &&
          other.needsSync == this.needsSync &&
          other.lastSyncAt == this.lastSyncAt &&
          other.syncStatus == this.syncStatus);
}

class ElectricityReadingsTableCompanion
    extends UpdateCompanion<ElectricityReading> {
  final Value<String> id;
  final Value<String> houseId;
  final Value<String> cycleId;
  final Value<DateTime> date;
  final Value<int> meterReading;
  final Value<int> unitsConsumed;
  final Value<double> totalCost;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isDeleted;
  final Value<bool> needsSync;
  final Value<DateTime?> lastSyncAt;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const ElectricityReadingsTableCompanion({
    this.id = const Value.absent(),
    this.houseId = const Value.absent(),
    this.cycleId = const Value.absent(),
    this.date = const Value.absent(),
    this.meterReading = const Value.absent(),
    this.unitsConsumed = const Value.absent(),
    this.totalCost = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.needsSync = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ElectricityReadingsTableCompanion.insert({
    required String id,
    required String houseId,
    required String cycleId,
    required DateTime date,
    required int meterReading,
    required int unitsConsumed,
    required double totalCost,
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.isDeleted = const Value.absent(),
    this.needsSync = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       houseId = Value(houseId),
       cycleId = Value(cycleId),
       date = Value(date),
       meterReading = Value(meterReading),
       unitsConsumed = Value(unitsConsumed),
       totalCost = Value(totalCost),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ElectricityReading> custom({
    Expression<String>? id,
    Expression<String>? houseId,
    Expression<String>? cycleId,
    Expression<DateTime>? date,
    Expression<int>? meterReading,
    Expression<int>? unitsConsumed,
    Expression<double>? totalCost,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isDeleted,
    Expression<bool>? needsSync,
    Expression<DateTime>? lastSyncAt,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (houseId != null) 'house_id': houseId,
      if (cycleId != null) 'cycle_id': cycleId,
      if (date != null) 'date': date,
      if (meterReading != null) 'meter_reading': meterReading,
      if (unitsConsumed != null) 'units_consumed': unitsConsumed,
      if (totalCost != null) 'total_cost': totalCost,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (needsSync != null) 'needs_sync': needsSync,
      if (lastSyncAt != null) 'last_sync_at': lastSyncAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ElectricityReadingsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? houseId,
    Value<String>? cycleId,
    Value<DateTime>? date,
    Value<int>? meterReading,
    Value<int>? unitsConsumed,
    Value<double>? totalCost,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? isDeleted,
    Value<bool>? needsSync,
    Value<DateTime?>? lastSyncAt,
    Value<String>? syncStatus,
    Value<int>? rowid,
  }) {
    return ElectricityReadingsTableCompanion(
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
      isDeleted: isDeleted ?? this.isDeleted,
      needsSync: needsSync ?? this.needsSync,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (houseId.present) {
      map['house_id'] = Variable<String>(houseId.value);
    }
    if (cycleId.present) {
      map['cycle_id'] = Variable<String>(cycleId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (meterReading.present) {
      map['meter_reading'] = Variable<int>(meterReading.value);
    }
    if (unitsConsumed.present) {
      map['units_consumed'] = Variable<int>(unitsConsumed.value);
    }
    if (totalCost.present) {
      map['total_cost'] = Variable<double>(totalCost.value);
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
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (needsSync.present) {
      map['needs_sync'] = Variable<bool>(needsSync.value);
    }
    if (lastSyncAt.present) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ElectricityReadingsTableCompanion(')
          ..write('id: $id, ')
          ..write('houseId: $houseId, ')
          ..write('cycleId: $cycleId, ')
          ..write('date: $date, ')
          ..write('meterReading: $meterReading, ')
          ..write('unitsConsumed: $unitsConsumed, ')
          ..write('totalCost: $totalCost, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('needsSync: $needsSync, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $HousesTableTable housesTable = $HousesTableTable(this);
  late final $CyclesTableTable cyclesTable = $CyclesTableTable(this);
  late final $ElectricityReadingsTableTable electricityReadingsTable =
      $ElectricityReadingsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    housesTable,
    cyclesTable,
    electricityReadingsTable,
  ];
}

typedef $$HousesTableTableCreateCompanionBuilder =
    HousesTableCompanion Function({
      required String id,
      required String name,
      Value<String?> address,
      Value<String?> meterNumber,
      required double defaultPricePerUnit,
      Value<String?> notes,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<bool> isDeleted,
      Value<bool> needsSync,
      Value<DateTime?> lastSyncAt,
      Value<String> syncStatus,
      Value<int> rowid,
    });
typedef $$HousesTableTableUpdateCompanionBuilder =
    HousesTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> address,
      Value<String?> meterNumber,
      Value<double> defaultPricePerUnit,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isDeleted,
      Value<bool> needsSync,
      Value<DateTime?> lastSyncAt,
      Value<String> syncStatus,
      Value<int> rowid,
    });

final class $$HousesTableTableReferences
    extends BaseReferences<_$AppDatabase, $HousesTableTable, House> {
  $$HousesTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CyclesTableTable, List<Cycle>>
  _cyclesTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.cyclesTable,
    aliasName: $_aliasNameGenerator(db.housesTable.id, db.cyclesTable.houseId),
  );

  $$CyclesTableTableProcessedTableManager get cyclesTableRefs {
    final manager = $$CyclesTableTableTableManager(
      $_db,
      $_db.cyclesTable,
    ).filter((f) => f.houseId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_cyclesTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ElectricityReadingsTableTable,
    List<ElectricityReading>
  >
  _electricityReadingsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.electricityReadingsTable,
        aliasName: $_aliasNameGenerator(
          db.housesTable.id,
          db.electricityReadingsTable.houseId,
        ),
      );

  $$ElectricityReadingsTableTableProcessedTableManager
  get electricityReadingsTableRefs {
    final manager = $$ElectricityReadingsTableTableTableManager(
      $_db,
      $_db.electricityReadingsTable,
    ).filter((f) => f.houseId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _electricityReadingsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$HousesTableTableFilterComposer
    extends Composer<_$AppDatabase, $HousesTableTable> {
  $$HousesTableTableFilterComposer({
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

  ColumnFilters<String> get meterNumber => $composableBuilder(
    column: $table.meterNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get defaultPricePerUnit => $composableBuilder(
    column: $table.defaultPricePerUnit,
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

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get needsSync => $composableBuilder(
    column: $table.needsSync,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> cyclesTableRefs(
    Expression<bool> Function($$CyclesTableTableFilterComposer f) f,
  ) {
    final $$CyclesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cyclesTable,
      getReferencedColumn: (t) => t.houseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CyclesTableTableFilterComposer(
            $db: $db,
            $table: $db.cyclesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> electricityReadingsTableRefs(
    Expression<bool> Function($$ElectricityReadingsTableTableFilterComposer f)
    f,
  ) {
    final $$ElectricityReadingsTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.electricityReadingsTable,
          getReferencedColumn: (t) => t.houseId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ElectricityReadingsTableTableFilterComposer(
                $db: $db,
                $table: $db.electricityReadingsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$HousesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $HousesTableTable> {
  $$HousesTableTableOrderingComposer({
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

  ColumnOrderings<String> get meterNumber => $composableBuilder(
    column: $table.meterNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get defaultPricePerUnit => $composableBuilder(
    column: $table.defaultPricePerUnit,
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

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get needsSync => $composableBuilder(
    column: $table.needsSync,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HousesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $HousesTableTable> {
  $$HousesTableTableAnnotationComposer({
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

  GeneratedColumn<String> get meterNumber => $composableBuilder(
    column: $table.meterNumber,
    builder: (column) => column,
  );

  GeneratedColumn<double> get defaultPricePerUnit => $composableBuilder(
    column: $table.defaultPricePerUnit,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<bool> get needsSync =>
      $composableBuilder(column: $table.needsSync, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  Expression<T> cyclesTableRefs<T extends Object>(
    Expression<T> Function($$CyclesTableTableAnnotationComposer a) f,
  ) {
    final $$CyclesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cyclesTable,
      getReferencedColumn: (t) => t.houseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CyclesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.cyclesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> electricityReadingsTableRefs<T extends Object>(
    Expression<T> Function($$ElectricityReadingsTableTableAnnotationComposer a)
    f,
  ) {
    final $$ElectricityReadingsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.electricityReadingsTable,
          getReferencedColumn: (t) => t.houseId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ElectricityReadingsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.electricityReadingsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$HousesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HousesTableTable,
          House,
          $$HousesTableTableFilterComposer,
          $$HousesTableTableOrderingComposer,
          $$HousesTableTableAnnotationComposer,
          $$HousesTableTableCreateCompanionBuilder,
          $$HousesTableTableUpdateCompanionBuilder,
          (House, $$HousesTableTableReferences),
          House,
          PrefetchHooks Function({
            bool cyclesTableRefs,
            bool electricityReadingsTableRefs,
          })
        > {
  $$HousesTableTableTableManager(_$AppDatabase db, $HousesTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HousesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HousesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HousesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> meterNumber = const Value.absent(),
                Value<double> defaultPricePerUnit = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<bool> needsSync = const Value.absent(),
                Value<DateTime?> lastSyncAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HousesTableCompanion(
                id: id,
                name: name,
                address: address,
                meterNumber: meterNumber,
                defaultPricePerUnit: defaultPricePerUnit,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
                needsSync: needsSync,
                lastSyncAt: lastSyncAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> address = const Value.absent(),
                Value<String?> meterNumber = const Value.absent(),
                required double defaultPricePerUnit,
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<bool> isDeleted = const Value.absent(),
                Value<bool> needsSync = const Value.absent(),
                Value<DateTime?> lastSyncAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HousesTableCompanion.insert(
                id: id,
                name: name,
                address: address,
                meterNumber: meterNumber,
                defaultPricePerUnit: defaultPricePerUnit,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
                needsSync: needsSync,
                lastSyncAt: lastSyncAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$HousesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                cyclesTableRefs = false,
                electricityReadingsTableRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (cyclesTableRefs) db.cyclesTable,
                    if (electricityReadingsTableRefs)
                      db.electricityReadingsTable,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (cyclesTableRefs)
                        await $_getPrefetchedData<
                          House,
                          $HousesTableTable,
                          Cycle
                        >(
                          currentTable: table,
                          referencedTable: $$HousesTableTableReferences
                              ._cyclesTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$HousesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).cyclesTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.houseId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (electricityReadingsTableRefs)
                        await $_getPrefetchedData<
                          House,
                          $HousesTableTable,
                          ElectricityReading
                        >(
                          currentTable: table,
                          referencedTable: $$HousesTableTableReferences
                              ._electricityReadingsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$HousesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).electricityReadingsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.houseId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$HousesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HousesTableTable,
      House,
      $$HousesTableTableFilterComposer,
      $$HousesTableTableOrderingComposer,
      $$HousesTableTableAnnotationComposer,
      $$HousesTableTableCreateCompanionBuilder,
      $$HousesTableTableUpdateCompanionBuilder,
      (House, $$HousesTableTableReferences),
      House,
      PrefetchHooks Function({
        bool cyclesTableRefs,
        bool electricityReadingsTableRefs,
      })
    >;
typedef $$CyclesTableTableCreateCompanionBuilder =
    CyclesTableCompanion Function({
      required String id,
      required String houseId,
      required String name,
      required DateTime startDate,
      required DateTime endDate,
      required int initialMeterReading,
      required int maxUnits,
      required double pricePerUnit,
      Value<String?> notes,
      Value<bool> isActive,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<bool> isDeleted,
      Value<bool> needsSync,
      Value<DateTime?> lastSyncAt,
      Value<String> syncStatus,
      Value<int> rowid,
    });
typedef $$CyclesTableTableUpdateCompanionBuilder =
    CyclesTableCompanion Function({
      Value<String> id,
      Value<String> houseId,
      Value<String> name,
      Value<DateTime> startDate,
      Value<DateTime> endDate,
      Value<int> initialMeterReading,
      Value<int> maxUnits,
      Value<double> pricePerUnit,
      Value<String?> notes,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isDeleted,
      Value<bool> needsSync,
      Value<DateTime?> lastSyncAt,
      Value<String> syncStatus,
      Value<int> rowid,
    });

final class $$CyclesTableTableReferences
    extends BaseReferences<_$AppDatabase, $CyclesTableTable, Cycle> {
  $$CyclesTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $HousesTableTable _houseIdTable(_$AppDatabase db) =>
      db.housesTable.createAlias(
        $_aliasNameGenerator(db.cyclesTable.houseId, db.housesTable.id),
      );

  $$HousesTableTableProcessedTableManager get houseId {
    final $_column = $_itemColumn<String>('house_id')!;

    final manager = $$HousesTableTableTableManager(
      $_db,
      $_db.housesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_houseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $ElectricityReadingsTableTable,
    List<ElectricityReading>
  >
  _electricityReadingsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.electricityReadingsTable,
        aliasName: $_aliasNameGenerator(
          db.cyclesTable.id,
          db.electricityReadingsTable.cycleId,
        ),
      );

  $$ElectricityReadingsTableTableProcessedTableManager
  get electricityReadingsTableRefs {
    final manager = $$ElectricityReadingsTableTableTableManager(
      $_db,
      $_db.electricityReadingsTable,
    ).filter((f) => f.cycleId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _electricityReadingsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CyclesTableTableFilterComposer
    extends Composer<_$AppDatabase, $CyclesTableTable> {
  $$CyclesTableTableFilterComposer({
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

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get initialMeterReading => $composableBuilder(
    column: $table.initialMeterReading,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxUnits => $composableBuilder(
    column: $table.maxUnits,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pricePerUnit => $composableBuilder(
    column: $table.pricePerUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
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

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get needsSync => $composableBuilder(
    column: $table.needsSync,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  $$HousesTableTableFilterComposer get houseId {
    final $$HousesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.houseId,
      referencedTable: $db.housesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HousesTableTableFilterComposer(
            $db: $db,
            $table: $db.housesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> electricityReadingsTableRefs(
    Expression<bool> Function($$ElectricityReadingsTableTableFilterComposer f)
    f,
  ) {
    final $$ElectricityReadingsTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.electricityReadingsTable,
          getReferencedColumn: (t) => t.cycleId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ElectricityReadingsTableTableFilterComposer(
                $db: $db,
                $table: $db.electricityReadingsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$CyclesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CyclesTableTable> {
  $$CyclesTableTableOrderingComposer({
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

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get initialMeterReading => $composableBuilder(
    column: $table.initialMeterReading,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxUnits => $composableBuilder(
    column: $table.maxUnits,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pricePerUnit => $composableBuilder(
    column: $table.pricePerUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
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

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get needsSync => $composableBuilder(
    column: $table.needsSync,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  $$HousesTableTableOrderingComposer get houseId {
    final $$HousesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.houseId,
      referencedTable: $db.housesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HousesTableTableOrderingComposer(
            $db: $db,
            $table: $db.housesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CyclesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CyclesTableTable> {
  $$CyclesTableTableAnnotationComposer({
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

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<int> get initialMeterReading => $composableBuilder(
    column: $table.initialMeterReading,
    builder: (column) => column,
  );

  GeneratedColumn<int> get maxUnits =>
      $composableBuilder(column: $table.maxUnits, builder: (column) => column);

  GeneratedColumn<double> get pricePerUnit => $composableBuilder(
    column: $table.pricePerUnit,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<bool> get needsSync =>
      $composableBuilder(column: $table.needsSync, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  $$HousesTableTableAnnotationComposer get houseId {
    final $$HousesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.houseId,
      referencedTable: $db.housesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HousesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.housesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> electricityReadingsTableRefs<T extends Object>(
    Expression<T> Function($$ElectricityReadingsTableTableAnnotationComposer a)
    f,
  ) {
    final $$ElectricityReadingsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.electricityReadingsTable,
          getReferencedColumn: (t) => t.cycleId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ElectricityReadingsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.electricityReadingsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$CyclesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CyclesTableTable,
          Cycle,
          $$CyclesTableTableFilterComposer,
          $$CyclesTableTableOrderingComposer,
          $$CyclesTableTableAnnotationComposer,
          $$CyclesTableTableCreateCompanionBuilder,
          $$CyclesTableTableUpdateCompanionBuilder,
          (Cycle, $$CyclesTableTableReferences),
          Cycle,
          PrefetchHooks Function({
            bool houseId,
            bool electricityReadingsTableRefs,
          })
        > {
  $$CyclesTableTableTableManager(_$AppDatabase db, $CyclesTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CyclesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CyclesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CyclesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> houseId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime> endDate = const Value.absent(),
                Value<int> initialMeterReading = const Value.absent(),
                Value<int> maxUnits = const Value.absent(),
                Value<double> pricePerUnit = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<bool> needsSync = const Value.absent(),
                Value<DateTime?> lastSyncAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CyclesTableCompanion(
                id: id,
                houseId: houseId,
                name: name,
                startDate: startDate,
                endDate: endDate,
                initialMeterReading: initialMeterReading,
                maxUnits: maxUnits,
                pricePerUnit: pricePerUnit,
                notes: notes,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
                needsSync: needsSync,
                lastSyncAt: lastSyncAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String houseId,
                required String name,
                required DateTime startDate,
                required DateTime endDate,
                required int initialMeterReading,
                required int maxUnits,
                required double pricePerUnit,
                Value<String?> notes = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<bool> isDeleted = const Value.absent(),
                Value<bool> needsSync = const Value.absent(),
                Value<DateTime?> lastSyncAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CyclesTableCompanion.insert(
                id: id,
                houseId: houseId,
                name: name,
                startDate: startDate,
                endDate: endDate,
                initialMeterReading: initialMeterReading,
                maxUnits: maxUnits,
                pricePerUnit: pricePerUnit,
                notes: notes,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
                needsSync: needsSync,
                lastSyncAt: lastSyncAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CyclesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({houseId = false, electricityReadingsTableRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (electricityReadingsTableRefs)
                      db.electricityReadingsTable,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (houseId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.houseId,
                                    referencedTable:
                                        $$CyclesTableTableReferences
                                            ._houseIdTable(db),
                                    referencedColumn:
                                        $$CyclesTableTableReferences
                                            ._houseIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (electricityReadingsTableRefs)
                        await $_getPrefetchedData<
                          Cycle,
                          $CyclesTableTable,
                          ElectricityReading
                        >(
                          currentTable: table,
                          referencedTable: $$CyclesTableTableReferences
                              ._electricityReadingsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CyclesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).electricityReadingsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.cycleId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CyclesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CyclesTableTable,
      Cycle,
      $$CyclesTableTableFilterComposer,
      $$CyclesTableTableOrderingComposer,
      $$CyclesTableTableAnnotationComposer,
      $$CyclesTableTableCreateCompanionBuilder,
      $$CyclesTableTableUpdateCompanionBuilder,
      (Cycle, $$CyclesTableTableReferences),
      Cycle,
      PrefetchHooks Function({bool houseId, bool electricityReadingsTableRefs})
    >;
typedef $$ElectricityReadingsTableTableCreateCompanionBuilder =
    ElectricityReadingsTableCompanion Function({
      required String id,
      required String houseId,
      required String cycleId,
      required DateTime date,
      required int meterReading,
      required int unitsConsumed,
      required double totalCost,
      Value<String?> notes,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<bool> isDeleted,
      Value<bool> needsSync,
      Value<DateTime?> lastSyncAt,
      Value<String> syncStatus,
      Value<int> rowid,
    });
typedef $$ElectricityReadingsTableTableUpdateCompanionBuilder =
    ElectricityReadingsTableCompanion Function({
      Value<String> id,
      Value<String> houseId,
      Value<String> cycleId,
      Value<DateTime> date,
      Value<int> meterReading,
      Value<int> unitsConsumed,
      Value<double> totalCost,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isDeleted,
      Value<bool> needsSync,
      Value<DateTime?> lastSyncAt,
      Value<String> syncStatus,
      Value<int> rowid,
    });

final class $$ElectricityReadingsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ElectricityReadingsTableTable,
          ElectricityReading
        > {
  $$ElectricityReadingsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $HousesTableTable _houseIdTable(_$AppDatabase db) =>
      db.housesTable.createAlias(
        $_aliasNameGenerator(
          db.electricityReadingsTable.houseId,
          db.housesTable.id,
        ),
      );

  $$HousesTableTableProcessedTableManager get houseId {
    final $_column = $_itemColumn<String>('house_id')!;

    final manager = $$HousesTableTableTableManager(
      $_db,
      $_db.housesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_houseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CyclesTableTable _cycleIdTable(_$AppDatabase db) =>
      db.cyclesTable.createAlias(
        $_aliasNameGenerator(
          db.electricityReadingsTable.cycleId,
          db.cyclesTable.id,
        ),
      );

  $$CyclesTableTableProcessedTableManager get cycleId {
    final $_column = $_itemColumn<String>('cycle_id')!;

    final manager = $$CyclesTableTableTableManager(
      $_db,
      $_db.cyclesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cycleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ElectricityReadingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ElectricityReadingsTableTable> {
  $$ElectricityReadingsTableTableFilterComposer({
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

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get meterReading => $composableBuilder(
    column: $table.meterReading,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unitsConsumed => $composableBuilder(
    column: $table.unitsConsumed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalCost => $composableBuilder(
    column: $table.totalCost,
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

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get needsSync => $composableBuilder(
    column: $table.needsSync,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  $$HousesTableTableFilterComposer get houseId {
    final $$HousesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.houseId,
      referencedTable: $db.housesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HousesTableTableFilterComposer(
            $db: $db,
            $table: $db.housesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CyclesTableTableFilterComposer get cycleId {
    final $$CyclesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cycleId,
      referencedTable: $db.cyclesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CyclesTableTableFilterComposer(
            $db: $db,
            $table: $db.cyclesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ElectricityReadingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ElectricityReadingsTableTable> {
  $$ElectricityReadingsTableTableOrderingComposer({
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

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get meterReading => $composableBuilder(
    column: $table.meterReading,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitsConsumed => $composableBuilder(
    column: $table.unitsConsumed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalCost => $composableBuilder(
    column: $table.totalCost,
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

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get needsSync => $composableBuilder(
    column: $table.needsSync,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  $$HousesTableTableOrderingComposer get houseId {
    final $$HousesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.houseId,
      referencedTable: $db.housesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HousesTableTableOrderingComposer(
            $db: $db,
            $table: $db.housesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CyclesTableTableOrderingComposer get cycleId {
    final $$CyclesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cycleId,
      referencedTable: $db.cyclesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CyclesTableTableOrderingComposer(
            $db: $db,
            $table: $db.cyclesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ElectricityReadingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ElectricityReadingsTableTable> {
  $$ElectricityReadingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get meterReading => $composableBuilder(
    column: $table.meterReading,
    builder: (column) => column,
  );

  GeneratedColumn<int> get unitsConsumed => $composableBuilder(
    column: $table.unitsConsumed,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalCost =>
      $composableBuilder(column: $table.totalCost, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<bool> get needsSync =>
      $composableBuilder(column: $table.needsSync, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  $$HousesTableTableAnnotationComposer get houseId {
    final $$HousesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.houseId,
      referencedTable: $db.housesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HousesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.housesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CyclesTableTableAnnotationComposer get cycleId {
    final $$CyclesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cycleId,
      referencedTable: $db.cyclesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CyclesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.cyclesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ElectricityReadingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ElectricityReadingsTableTable,
          ElectricityReading,
          $$ElectricityReadingsTableTableFilterComposer,
          $$ElectricityReadingsTableTableOrderingComposer,
          $$ElectricityReadingsTableTableAnnotationComposer,
          $$ElectricityReadingsTableTableCreateCompanionBuilder,
          $$ElectricityReadingsTableTableUpdateCompanionBuilder,
          (ElectricityReading, $$ElectricityReadingsTableTableReferences),
          ElectricityReading,
          PrefetchHooks Function({bool houseId, bool cycleId})
        > {
  $$ElectricityReadingsTableTableTableManager(
    _$AppDatabase db,
    $ElectricityReadingsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ElectricityReadingsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ElectricityReadingsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ElectricityReadingsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> houseId = const Value.absent(),
                Value<String> cycleId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> meterReading = const Value.absent(),
                Value<int> unitsConsumed = const Value.absent(),
                Value<double> totalCost = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<bool> needsSync = const Value.absent(),
                Value<DateTime?> lastSyncAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ElectricityReadingsTableCompanion(
                id: id,
                houseId: houseId,
                cycleId: cycleId,
                date: date,
                meterReading: meterReading,
                unitsConsumed: unitsConsumed,
                totalCost: totalCost,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
                needsSync: needsSync,
                lastSyncAt: lastSyncAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String houseId,
                required String cycleId,
                required DateTime date,
                required int meterReading,
                required int unitsConsumed,
                required double totalCost,
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<bool> isDeleted = const Value.absent(),
                Value<bool> needsSync = const Value.absent(),
                Value<DateTime?> lastSyncAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ElectricityReadingsTableCompanion.insert(
                id: id,
                houseId: houseId,
                cycleId: cycleId,
                date: date,
                meterReading: meterReading,
                unitsConsumed: unitsConsumed,
                totalCost: totalCost,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
                needsSync: needsSync,
                lastSyncAt: lastSyncAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ElectricityReadingsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({houseId = false, cycleId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (houseId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.houseId,
                                referencedTable:
                                    $$ElectricityReadingsTableTableReferences
                                        ._houseIdTable(db),
                                referencedColumn:
                                    $$ElectricityReadingsTableTableReferences
                                        ._houseIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (cycleId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.cycleId,
                                referencedTable:
                                    $$ElectricityReadingsTableTableReferences
                                        ._cycleIdTable(db),
                                referencedColumn:
                                    $$ElectricityReadingsTableTableReferences
                                        ._cycleIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ElectricityReadingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ElectricityReadingsTableTable,
      ElectricityReading,
      $$ElectricityReadingsTableTableFilterComposer,
      $$ElectricityReadingsTableTableOrderingComposer,
      $$ElectricityReadingsTableTableAnnotationComposer,
      $$ElectricityReadingsTableTableCreateCompanionBuilder,
      $$ElectricityReadingsTableTableUpdateCompanionBuilder,
      (ElectricityReading, $$ElectricityReadingsTableTableReferences),
      ElectricityReading,
      PrefetchHooks Function({bool houseId, bool cycleId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$HousesTableTableTableManager get housesTable =>
      $$HousesTableTableTableManager(_db, _db.housesTable);
  $$CyclesTableTableTableManager get cyclesTable =>
      $$CyclesTableTableTableManager(_db, _db.cyclesTable);
  $$ElectricityReadingsTableTableTableManager get electricityReadingsTable =>
      $$ElectricityReadingsTableTableTableManager(
        _db,
        _db.electricityReadingsTable,
      );
}
