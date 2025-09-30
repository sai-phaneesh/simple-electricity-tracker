// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $CyclesTable extends Cycles with TableInfo<$CyclesTable, Cycle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CyclesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _driftIdMeta = const VerificationMeta(
    'driftId',
  );
  @override
  late final GeneratedColumn<String> driftId = GeneratedColumn<String>(
    'drift_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
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
  static const VerificationMeta _meterReadingMeta = const VerificationMeta(
    'meterReading',
  );
  @override
  late final GeneratedColumn<double> meterReading = GeneratedColumn<double>(
    'meter_reading',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _maxUnitsMeta = const VerificationMeta(
    'maxUnits',
  );
  @override
  late final GeneratedColumn<double> maxUnits = GeneratedColumn<double>(
    'max_units',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdOnMeta = const VerificationMeta(
    'createdOn',
  );
  @override
  late final GeneratedColumn<DateTime> createdOn = GeneratedColumn<DateTime>(
    'created_on',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedOnMeta = const VerificationMeta(
    'updatedOn',
  );
  @override
  late final GeneratedColumn<DateTime> updatedOn = GeneratedColumn<DateTime>(
    'updated_on',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    driftId,
    name,
    startDate,
    endDate,
    meterReading,
    maxUnits,
    createdOn,
    updatedOn,
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
    }
    if (data.containsKey('drift_id')) {
      context.handle(
        _driftIdMeta,
        driftId.isAcceptableOrUnknown(data['drift_id']!, _driftIdMeta),
      );
    } else if (isInserting) {
      context.missing(_driftIdMeta);
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
    if (data.containsKey('max_units')) {
      context.handle(
        _maxUnitsMeta,
        maxUnits.isAcceptableOrUnknown(data['max_units']!, _maxUnitsMeta),
      );
    } else if (isInserting) {
      context.missing(_maxUnitsMeta);
    }
    if (data.containsKey('created_on')) {
      context.handle(
        _createdOnMeta,
        createdOn.isAcceptableOrUnknown(data['created_on']!, _createdOnMeta),
      );
    } else if (isInserting) {
      context.missing(_createdOnMeta);
    }
    if (data.containsKey('updated_on')) {
      context.handle(
        _updatedOnMeta,
        updatedOn.isAcceptableOrUnknown(data['updated_on']!, _updatedOnMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedOnMeta);
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
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      driftId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}drift_id'],
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
      meterReading: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}meter_reading'],
      )!,
      maxUnits: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}max_units'],
      )!,
      createdOn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_on'],
      )!,
      updatedOn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_on'],
      )!,
    );
  }

  @override
  $CyclesTable createAlias(String alias) {
    return $CyclesTable(attachedDatabase, alias);
  }
}

class Cycle extends DataClass implements Insertable<Cycle> {
  final int id;
  final String driftId;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final double meterReading;
  final double maxUnits;
  final DateTime createdOn;
  final DateTime updatedOn;
  const Cycle({
    required this.id,
    required this.driftId,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.meterReading,
    required this.maxUnits,
    required this.createdOn,
    required this.updatedOn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['drift_id'] = Variable<String>(driftId);
    map['name'] = Variable<String>(name);
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    map['meter_reading'] = Variable<double>(meterReading);
    map['max_units'] = Variable<double>(maxUnits);
    map['created_on'] = Variable<DateTime>(createdOn);
    map['updated_on'] = Variable<DateTime>(updatedOn);
    return map;
  }

  CyclesCompanion toCompanion(bool nullToAbsent) {
    return CyclesCompanion(
      id: Value(id),
      driftId: Value(driftId),
      name: Value(name),
      startDate: Value(startDate),
      endDate: Value(endDate),
      meterReading: Value(meterReading),
      maxUnits: Value(maxUnits),
      createdOn: Value(createdOn),
      updatedOn: Value(updatedOn),
    );
  }

  factory Cycle.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Cycle(
      id: serializer.fromJson<int>(json['id']),
      driftId: serializer.fromJson<String>(json['driftId']),
      name: serializer.fromJson<String>(json['name']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      meterReading: serializer.fromJson<double>(json['meterReading']),
      maxUnits: serializer.fromJson<double>(json['maxUnits']),
      createdOn: serializer.fromJson<DateTime>(json['createdOn']),
      updatedOn: serializer.fromJson<DateTime>(json['updatedOn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'driftId': serializer.toJson<String>(driftId),
      'name': serializer.toJson<String>(name),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'meterReading': serializer.toJson<double>(meterReading),
      'maxUnits': serializer.toJson<double>(maxUnits),
      'createdOn': serializer.toJson<DateTime>(createdOn),
      'updatedOn': serializer.toJson<DateTime>(updatedOn),
    };
  }

  Cycle copyWith({
    int? id,
    String? driftId,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    double? meterReading,
    double? maxUnits,
    DateTime? createdOn,
    DateTime? updatedOn,
  }) => Cycle(
    id: id ?? this.id,
    driftId: driftId ?? this.driftId,
    name: name ?? this.name,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    meterReading: meterReading ?? this.meterReading,
    maxUnits: maxUnits ?? this.maxUnits,
    createdOn: createdOn ?? this.createdOn,
    updatedOn: updatedOn ?? this.updatedOn,
  );
  Cycle copyWithCompanion(CyclesCompanion data) {
    return Cycle(
      id: data.id.present ? data.id.value : this.id,
      driftId: data.driftId.present ? data.driftId.value : this.driftId,
      name: data.name.present ? data.name.value : this.name,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      meterReading: data.meterReading.present
          ? data.meterReading.value
          : this.meterReading,
      maxUnits: data.maxUnits.present ? data.maxUnits.value : this.maxUnits,
      createdOn: data.createdOn.present ? data.createdOn.value : this.createdOn,
      updatedOn: data.updatedOn.present ? data.updatedOn.value : this.updatedOn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Cycle(')
          ..write('id: $id, ')
          ..write('driftId: $driftId, ')
          ..write('name: $name, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('meterReading: $meterReading, ')
          ..write('maxUnits: $maxUnits, ')
          ..write('createdOn: $createdOn, ')
          ..write('updatedOn: $updatedOn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    driftId,
    name,
    startDate,
    endDate,
    meterReading,
    maxUnits,
    createdOn,
    updatedOn,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Cycle &&
          other.id == this.id &&
          other.driftId == this.driftId &&
          other.name == this.name &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.meterReading == this.meterReading &&
          other.maxUnits == this.maxUnits &&
          other.createdOn == this.createdOn &&
          other.updatedOn == this.updatedOn);
}

class CyclesCompanion extends UpdateCompanion<Cycle> {
  final Value<int> id;
  final Value<String> driftId;
  final Value<String> name;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<double> meterReading;
  final Value<double> maxUnits;
  final Value<DateTime> createdOn;
  final Value<DateTime> updatedOn;
  const CyclesCompanion({
    this.id = const Value.absent(),
    this.driftId = const Value.absent(),
    this.name = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.meterReading = const Value.absent(),
    this.maxUnits = const Value.absent(),
    this.createdOn = const Value.absent(),
    this.updatedOn = const Value.absent(),
  });
  CyclesCompanion.insert({
    this.id = const Value.absent(),
    required String driftId,
    required String name,
    required DateTime startDate,
    required DateTime endDate,
    required double meterReading,
    required double maxUnits,
    required DateTime createdOn,
    required DateTime updatedOn,
  }) : driftId = Value(driftId),
       name = Value(name),
       startDate = Value(startDate),
       endDate = Value(endDate),
       meterReading = Value(meterReading),
       maxUnits = Value(maxUnits),
       createdOn = Value(createdOn),
       updatedOn = Value(updatedOn);
  static Insertable<Cycle> custom({
    Expression<int>? id,
    Expression<String>? driftId,
    Expression<String>? name,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<double>? meterReading,
    Expression<double>? maxUnits,
    Expression<DateTime>? createdOn,
    Expression<DateTime>? updatedOn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (driftId != null) 'drift_id': driftId,
      if (name != null) 'name': name,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (meterReading != null) 'meter_reading': meterReading,
      if (maxUnits != null) 'max_units': maxUnits,
      if (createdOn != null) 'created_on': createdOn,
      if (updatedOn != null) 'updated_on': updatedOn,
    });
  }

  CyclesCompanion copyWith({
    Value<int>? id,
    Value<String>? driftId,
    Value<String>? name,
    Value<DateTime>? startDate,
    Value<DateTime>? endDate,
    Value<double>? meterReading,
    Value<double>? maxUnits,
    Value<DateTime>? createdOn,
    Value<DateTime>? updatedOn,
  }) {
    return CyclesCompanion(
      id: id ?? this.id,
      driftId: driftId ?? this.driftId,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      meterReading: meterReading ?? this.meterReading,
      maxUnits: maxUnits ?? this.maxUnits,
      createdOn: createdOn ?? this.createdOn,
      updatedOn: updatedOn ?? this.updatedOn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (driftId.present) {
      map['drift_id'] = Variable<String>(driftId.value);
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
    if (meterReading.present) {
      map['meter_reading'] = Variable<double>(meterReading.value);
    }
    if (maxUnits.present) {
      map['max_units'] = Variable<double>(maxUnits.value);
    }
    if (createdOn.present) {
      map['created_on'] = Variable<DateTime>(createdOn.value);
    }
    if (updatedOn.present) {
      map['updated_on'] = Variable<DateTime>(updatedOn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CyclesCompanion(')
          ..write('id: $id, ')
          ..write('driftId: $driftId, ')
          ..write('name: $name, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('meterReading: $meterReading, ')
          ..write('maxUnits: $maxUnits, ')
          ..write('createdOn: $createdOn, ')
          ..write('updatedOn: $updatedOn')
          ..write(')'))
        .toString();
  }
}

class $ConsumptionsTable extends Consumptions
    with TableInfo<$ConsumptionsTable, Consumption> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConsumptionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _driftIdMeta = const VerificationMeta(
    'driftId',
  );
  @override
  late final GeneratedColumn<String> driftId = GeneratedColumn<String>(
    'drift_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _cycleIdMeta = const VerificationMeta(
    'cycleId',
  );
  @override
  late final GeneratedColumn<int> cycleId = GeneratedColumn<int>(
    'cycle_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cycles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _meterReadingMeta = const VerificationMeta(
    'meterReading',
  );
  @override
  late final GeneratedColumn<double> meterReading = GeneratedColumn<double>(
    'meter_reading',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
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
  static const VerificationMeta _unitsConsumedMeta = const VerificationMeta(
    'unitsConsumed',
  );
  @override
  late final GeneratedColumn<double> unitsConsumed = GeneratedColumn<double>(
    'units_consumed',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    driftId,
    cycleId,
    meterReading,
    date,
    unitsConsumed,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'consumptions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Consumption> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('drift_id')) {
      context.handle(
        _driftIdMeta,
        driftId.isAcceptableOrUnknown(data['drift_id']!, _driftIdMeta),
      );
    } else if (isInserting) {
      context.missing(_driftIdMeta);
    }
    if (data.containsKey('cycle_id')) {
      context.handle(
        _cycleIdMeta,
        cycleId.isAcceptableOrUnknown(data['cycle_id']!, _cycleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cycleIdMeta);
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
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Consumption map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Consumption(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      driftId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}drift_id'],
      )!,
      cycleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cycle_id'],
      )!,
      meterReading: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}meter_reading'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      unitsConsumed: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}units_consumed'],
      )!,
    );
  }

  @override
  $ConsumptionsTable createAlias(String alias) {
    return $ConsumptionsTable(attachedDatabase, alias);
  }
}

class Consumption extends DataClass implements Insertable<Consumption> {
  final int id;
  final String driftId;
  final int cycleId;
  final double meterReading;
  final DateTime date;
  final double unitsConsumed;
  const Consumption({
    required this.id,
    required this.driftId,
    required this.cycleId,
    required this.meterReading,
    required this.date,
    required this.unitsConsumed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['drift_id'] = Variable<String>(driftId);
    map['cycle_id'] = Variable<int>(cycleId);
    map['meter_reading'] = Variable<double>(meterReading);
    map['date'] = Variable<DateTime>(date);
    map['units_consumed'] = Variable<double>(unitsConsumed);
    return map;
  }

  ConsumptionsCompanion toCompanion(bool nullToAbsent) {
    return ConsumptionsCompanion(
      id: Value(id),
      driftId: Value(driftId),
      cycleId: Value(cycleId),
      meterReading: Value(meterReading),
      date: Value(date),
      unitsConsumed: Value(unitsConsumed),
    );
  }

  factory Consumption.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Consumption(
      id: serializer.fromJson<int>(json['id']),
      driftId: serializer.fromJson<String>(json['driftId']),
      cycleId: serializer.fromJson<int>(json['cycleId']),
      meterReading: serializer.fromJson<double>(json['meterReading']),
      date: serializer.fromJson<DateTime>(json['date']),
      unitsConsumed: serializer.fromJson<double>(json['unitsConsumed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'driftId': serializer.toJson<String>(driftId),
      'cycleId': serializer.toJson<int>(cycleId),
      'meterReading': serializer.toJson<double>(meterReading),
      'date': serializer.toJson<DateTime>(date),
      'unitsConsumed': serializer.toJson<double>(unitsConsumed),
    };
  }

  Consumption copyWith({
    int? id,
    String? driftId,
    int? cycleId,
    double? meterReading,
    DateTime? date,
    double? unitsConsumed,
  }) => Consumption(
    id: id ?? this.id,
    driftId: driftId ?? this.driftId,
    cycleId: cycleId ?? this.cycleId,
    meterReading: meterReading ?? this.meterReading,
    date: date ?? this.date,
    unitsConsumed: unitsConsumed ?? this.unitsConsumed,
  );
  Consumption copyWithCompanion(ConsumptionsCompanion data) {
    return Consumption(
      id: data.id.present ? data.id.value : this.id,
      driftId: data.driftId.present ? data.driftId.value : this.driftId,
      cycleId: data.cycleId.present ? data.cycleId.value : this.cycleId,
      meterReading: data.meterReading.present
          ? data.meterReading.value
          : this.meterReading,
      date: data.date.present ? data.date.value : this.date,
      unitsConsumed: data.unitsConsumed.present
          ? data.unitsConsumed.value
          : this.unitsConsumed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Consumption(')
          ..write('id: $id, ')
          ..write('driftId: $driftId, ')
          ..write('cycleId: $cycleId, ')
          ..write('meterReading: $meterReading, ')
          ..write('date: $date, ')
          ..write('unitsConsumed: $unitsConsumed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, driftId, cycleId, meterReading, date, unitsConsumed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Consumption &&
          other.id == this.id &&
          other.driftId == this.driftId &&
          other.cycleId == this.cycleId &&
          other.meterReading == this.meterReading &&
          other.date == this.date &&
          other.unitsConsumed == this.unitsConsumed);
}

class ConsumptionsCompanion extends UpdateCompanion<Consumption> {
  final Value<int> id;
  final Value<String> driftId;
  final Value<int> cycleId;
  final Value<double> meterReading;
  final Value<DateTime> date;
  final Value<double> unitsConsumed;
  const ConsumptionsCompanion({
    this.id = const Value.absent(),
    this.driftId = const Value.absent(),
    this.cycleId = const Value.absent(),
    this.meterReading = const Value.absent(),
    this.date = const Value.absent(),
    this.unitsConsumed = const Value.absent(),
  });
  ConsumptionsCompanion.insert({
    this.id = const Value.absent(),
    required String driftId,
    required int cycleId,
    required double meterReading,
    required DateTime date,
    required double unitsConsumed,
  }) : driftId = Value(driftId),
       cycleId = Value(cycleId),
       meterReading = Value(meterReading),
       date = Value(date),
       unitsConsumed = Value(unitsConsumed);
  static Insertable<Consumption> custom({
    Expression<int>? id,
    Expression<String>? driftId,
    Expression<int>? cycleId,
    Expression<double>? meterReading,
    Expression<DateTime>? date,
    Expression<double>? unitsConsumed,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (driftId != null) 'drift_id': driftId,
      if (cycleId != null) 'cycle_id': cycleId,
      if (meterReading != null) 'meter_reading': meterReading,
      if (date != null) 'date': date,
      if (unitsConsumed != null) 'units_consumed': unitsConsumed,
    });
  }

  ConsumptionsCompanion copyWith({
    Value<int>? id,
    Value<String>? driftId,
    Value<int>? cycleId,
    Value<double>? meterReading,
    Value<DateTime>? date,
    Value<double>? unitsConsumed,
  }) {
    return ConsumptionsCompanion(
      id: id ?? this.id,
      driftId: driftId ?? this.driftId,
      cycleId: cycleId ?? this.cycleId,
      meterReading: meterReading ?? this.meterReading,
      date: date ?? this.date,
      unitsConsumed: unitsConsumed ?? this.unitsConsumed,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (driftId.present) {
      map['drift_id'] = Variable<String>(driftId.value);
    }
    if (cycleId.present) {
      map['cycle_id'] = Variable<int>(cycleId.value);
    }
    if (meterReading.present) {
      map['meter_reading'] = Variable<double>(meterReading.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (unitsConsumed.present) {
      map['units_consumed'] = Variable<double>(unitsConsumed.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConsumptionsCompanion(')
          ..write('id: $id, ')
          ..write('driftId: $driftId, ')
          ..write('cycleId: $cycleId, ')
          ..write('meterReading: $meterReading, ')
          ..write('date: $date, ')
          ..write('unitsConsumed: $unitsConsumed')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CyclesTable cycles = $CyclesTable(this);
  late final $ConsumptionsTable consumptions = $ConsumptionsTable(this);
  late final CycleDao cycleDao = CycleDao(this as AppDatabase);
  late final ConsumptionDao consumptionDao = ConsumptionDao(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [cycles, consumptions];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'cycles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('consumptions', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$CyclesTableCreateCompanionBuilder =
    CyclesCompanion Function({
      Value<int> id,
      required String driftId,
      required String name,
      required DateTime startDate,
      required DateTime endDate,
      required double meterReading,
      required double maxUnits,
      required DateTime createdOn,
      required DateTime updatedOn,
    });
typedef $$CyclesTableUpdateCompanionBuilder =
    CyclesCompanion Function({
      Value<int> id,
      Value<String> driftId,
      Value<String> name,
      Value<DateTime> startDate,
      Value<DateTime> endDate,
      Value<double> meterReading,
      Value<double> maxUnits,
      Value<DateTime> createdOn,
      Value<DateTime> updatedOn,
    });

final class $$CyclesTableReferences
    extends BaseReferences<_$AppDatabase, $CyclesTable, Cycle> {
  $$CyclesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ConsumptionsTable, List<Consumption>>
  _consumptionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.consumptions,
    aliasName: $_aliasNameGenerator(db.cycles.id, db.consumptions.cycleId),
  );

  $$ConsumptionsTableProcessedTableManager get consumptionsRefs {
    final manager = $$ConsumptionsTableTableManager(
      $_db,
      $_db.consumptions,
    ).filter((f) => f.cycleId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_consumptionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CyclesTableFilterComposer
    extends Composer<_$AppDatabase, $CyclesTable> {
  $$CyclesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get driftId => $composableBuilder(
    column: $table.driftId,
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

  ColumnFilters<double> get meterReading => $composableBuilder(
    column: $table.meterReading,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get maxUnits => $composableBuilder(
    column: $table.maxUnits,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdOn => $composableBuilder(
    column: $table.createdOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedOn => $composableBuilder(
    column: $table.updatedOn,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> consumptionsRefs(
    Expression<bool> Function($$ConsumptionsTableFilterComposer f) f,
  ) {
    final $$ConsumptionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.consumptions,
      getReferencedColumn: (t) => t.cycleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ConsumptionsTableFilterComposer(
            $db: $db,
            $table: $db.consumptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CyclesTableOrderingComposer
    extends Composer<_$AppDatabase, $CyclesTable> {
  $$CyclesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get driftId => $composableBuilder(
    column: $table.driftId,
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

  ColumnOrderings<double> get meterReading => $composableBuilder(
    column: $table.meterReading,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get maxUnits => $composableBuilder(
    column: $table.maxUnits,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdOn => $composableBuilder(
    column: $table.createdOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedOn => $composableBuilder(
    column: $table.updatedOn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CyclesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CyclesTable> {
  $$CyclesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get driftId =>
      $composableBuilder(column: $table.driftId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<double> get meterReading => $composableBuilder(
    column: $table.meterReading,
    builder: (column) => column,
  );

  GeneratedColumn<double> get maxUnits =>
      $composableBuilder(column: $table.maxUnits, builder: (column) => column);

  GeneratedColumn<DateTime> get createdOn =>
      $composableBuilder(column: $table.createdOn, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedOn =>
      $composableBuilder(column: $table.updatedOn, builder: (column) => column);

  Expression<T> consumptionsRefs<T extends Object>(
    Expression<T> Function($$ConsumptionsTableAnnotationComposer a) f,
  ) {
    final $$ConsumptionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.consumptions,
      getReferencedColumn: (t) => t.cycleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ConsumptionsTableAnnotationComposer(
            $db: $db,
            $table: $db.consumptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CyclesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CyclesTable,
          Cycle,
          $$CyclesTableFilterComposer,
          $$CyclesTableOrderingComposer,
          $$CyclesTableAnnotationComposer,
          $$CyclesTableCreateCompanionBuilder,
          $$CyclesTableUpdateCompanionBuilder,
          (Cycle, $$CyclesTableReferences),
          Cycle,
          PrefetchHooks Function({bool consumptionsRefs})
        > {
  $$CyclesTableTableManager(_$AppDatabase db, $CyclesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CyclesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CyclesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CyclesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> driftId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime> endDate = const Value.absent(),
                Value<double> meterReading = const Value.absent(),
                Value<double> maxUnits = const Value.absent(),
                Value<DateTime> createdOn = const Value.absent(),
                Value<DateTime> updatedOn = const Value.absent(),
              }) => CyclesCompanion(
                id: id,
                driftId: driftId,
                name: name,
                startDate: startDate,
                endDate: endDate,
                meterReading: meterReading,
                maxUnits: maxUnits,
                createdOn: createdOn,
                updatedOn: updatedOn,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String driftId,
                required String name,
                required DateTime startDate,
                required DateTime endDate,
                required double meterReading,
                required double maxUnits,
                required DateTime createdOn,
                required DateTime updatedOn,
              }) => CyclesCompanion.insert(
                id: id,
                driftId: driftId,
                name: name,
                startDate: startDate,
                endDate: endDate,
                meterReading: meterReading,
                maxUnits: maxUnits,
                createdOn: createdOn,
                updatedOn: updatedOn,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$CyclesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({consumptionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (consumptionsRefs) db.consumptions],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (consumptionsRefs)
                    await $_getPrefetchedData<Cycle, $CyclesTable, Consumption>(
                      currentTable: table,
                      referencedTable: $$CyclesTableReferences
                          ._consumptionsRefsTable(db),
                      managerFromTypedResult: (p0) => $$CyclesTableReferences(
                        db,
                        table,
                        p0,
                      ).consumptionsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.cycleId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CyclesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CyclesTable,
      Cycle,
      $$CyclesTableFilterComposer,
      $$CyclesTableOrderingComposer,
      $$CyclesTableAnnotationComposer,
      $$CyclesTableCreateCompanionBuilder,
      $$CyclesTableUpdateCompanionBuilder,
      (Cycle, $$CyclesTableReferences),
      Cycle,
      PrefetchHooks Function({bool consumptionsRefs})
    >;
typedef $$ConsumptionsTableCreateCompanionBuilder =
    ConsumptionsCompanion Function({
      Value<int> id,
      required String driftId,
      required int cycleId,
      required double meterReading,
      required DateTime date,
      required double unitsConsumed,
    });
typedef $$ConsumptionsTableUpdateCompanionBuilder =
    ConsumptionsCompanion Function({
      Value<int> id,
      Value<String> driftId,
      Value<int> cycleId,
      Value<double> meterReading,
      Value<DateTime> date,
      Value<double> unitsConsumed,
    });

final class $$ConsumptionsTableReferences
    extends BaseReferences<_$AppDatabase, $ConsumptionsTable, Consumption> {
  $$ConsumptionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CyclesTable _cycleIdTable(_$AppDatabase db) => db.cycles.createAlias(
    $_aliasNameGenerator(db.consumptions.cycleId, db.cycles.id),
  );

  $$CyclesTableProcessedTableManager get cycleId {
    final $_column = $_itemColumn<int>('cycle_id')!;

    final manager = $$CyclesTableTableManager(
      $_db,
      $_db.cycles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cycleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ConsumptionsTableFilterComposer
    extends Composer<_$AppDatabase, $ConsumptionsTable> {
  $$ConsumptionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get driftId => $composableBuilder(
    column: $table.driftId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get meterReading => $composableBuilder(
    column: $table.meterReading,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get unitsConsumed => $composableBuilder(
    column: $table.unitsConsumed,
    builder: (column) => ColumnFilters(column),
  );

  $$CyclesTableFilterComposer get cycleId {
    final $$CyclesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cycleId,
      referencedTable: $db.cycles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CyclesTableFilterComposer(
            $db: $db,
            $table: $db.cycles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ConsumptionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ConsumptionsTable> {
  $$ConsumptionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get driftId => $composableBuilder(
    column: $table.driftId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get meterReading => $composableBuilder(
    column: $table.meterReading,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get unitsConsumed => $composableBuilder(
    column: $table.unitsConsumed,
    builder: (column) => ColumnOrderings(column),
  );

  $$CyclesTableOrderingComposer get cycleId {
    final $$CyclesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cycleId,
      referencedTable: $db.cycles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CyclesTableOrderingComposer(
            $db: $db,
            $table: $db.cycles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ConsumptionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConsumptionsTable> {
  $$ConsumptionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get driftId =>
      $composableBuilder(column: $table.driftId, builder: (column) => column);

  GeneratedColumn<double> get meterReading => $composableBuilder(
    column: $table.meterReading,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get unitsConsumed => $composableBuilder(
    column: $table.unitsConsumed,
    builder: (column) => column,
  );

  $$CyclesTableAnnotationComposer get cycleId {
    final $$CyclesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cycleId,
      referencedTable: $db.cycles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CyclesTableAnnotationComposer(
            $db: $db,
            $table: $db.cycles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ConsumptionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ConsumptionsTable,
          Consumption,
          $$ConsumptionsTableFilterComposer,
          $$ConsumptionsTableOrderingComposer,
          $$ConsumptionsTableAnnotationComposer,
          $$ConsumptionsTableCreateCompanionBuilder,
          $$ConsumptionsTableUpdateCompanionBuilder,
          (Consumption, $$ConsumptionsTableReferences),
          Consumption,
          PrefetchHooks Function({bool cycleId})
        > {
  $$ConsumptionsTableTableManager(_$AppDatabase db, $ConsumptionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConsumptionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConsumptionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConsumptionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> driftId = const Value.absent(),
                Value<int> cycleId = const Value.absent(),
                Value<double> meterReading = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<double> unitsConsumed = const Value.absent(),
              }) => ConsumptionsCompanion(
                id: id,
                driftId: driftId,
                cycleId: cycleId,
                meterReading: meterReading,
                date: date,
                unitsConsumed: unitsConsumed,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String driftId,
                required int cycleId,
                required double meterReading,
                required DateTime date,
                required double unitsConsumed,
              }) => ConsumptionsCompanion.insert(
                id: id,
                driftId: driftId,
                cycleId: cycleId,
                meterReading: meterReading,
                date: date,
                unitsConsumed: unitsConsumed,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ConsumptionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({cycleId = false}) {
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
                    if (cycleId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.cycleId,
                                referencedTable: $$ConsumptionsTableReferences
                                    ._cycleIdTable(db),
                                referencedColumn: $$ConsumptionsTableReferences
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

typedef $$ConsumptionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ConsumptionsTable,
      Consumption,
      $$ConsumptionsTableFilterComposer,
      $$ConsumptionsTableOrderingComposer,
      $$ConsumptionsTableAnnotationComposer,
      $$ConsumptionsTableCreateCompanionBuilder,
      $$ConsumptionsTableUpdateCompanionBuilder,
      (Consumption, $$ConsumptionsTableReferences),
      Consumption,
      PrefetchHooks Function({bool cycleId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CyclesTableTableManager get cycles =>
      $$CyclesTableTableManager(_db, _db.cycles);
  $$ConsumptionsTableTableManager get consumptions =>
      $$ConsumptionsTableTableManager(_db, _db.consumptions);
}
