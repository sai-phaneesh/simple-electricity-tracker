import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:electricity/data/database/database.dart';
import 'package:electricity/data/datasources/cycles_datasource.dart';

class LocalCyclesDataSource implements CyclesDataSource {
  final AppDatabase _database;
  static const _uuid = Uuid();

  LocalCyclesDataSource(this._database);

  @override
  Future<List<Cycle>> getAllCycles() async {
    return await (_database.select(_database.cyclesTable)
          ..where((tbl) => tbl.isDeleted.equals(false))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.updatedAt)]))
        .get();
  }

  @override
  Stream<List<Cycle>> watchAllCycles() {
    return (_database.select(_database.cyclesTable)
          ..where((tbl) => tbl.isDeleted.equals(false))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.updatedAt)]))
        .watch();
  }

  @override
  Stream<List<Cycle>> watchCyclesByHouseId(String houseId) {
    return (_database.select(_database.cyclesTable)
          ..where(
            (tbl) => tbl.houseId.equals(houseId) & tbl.isDeleted.equals(false),
          )
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]))
        .watch();
  }

  @override
  Stream<Cycle?> watchCycleById(String id) {
    return (_database.select(_database.cyclesTable)
          ..where((tbl) => tbl.id.equals(id) & tbl.isDeleted.equals(false)))
        .watchSingleOrNull();
  }

  @override
  Stream<Cycle?> watchActiveCycleForHouse(String houseId) {
    return (_database.select(_database.cyclesTable)
          ..where(
            (tbl) =>
                tbl.houseId.equals(houseId) &
                tbl.isActive.equals(true) &
                tbl.isDeleted.equals(false),
          )
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.startDate)])
          ..limit(1))
        .watchSingleOrNull();
  }

  @override
  Stream<List<Cycle>> watchCyclesNeedingSync() {
    return (_database.select(_database.cyclesTable)
          ..where((tbl) => tbl.needsSync.equals(true))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.updatedAt)]))
        .watch();
  }

  @override
  Future<List<Cycle>> getCyclesByHouseId(String houseId) async {
    return await (_database.select(_database.cyclesTable)
          ..where(
            (tbl) => tbl.houseId.equals(houseId) & tbl.isDeleted.equals(false),
          )
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.startDate)]))
        .get();
  }

  @override
  Future<Cycle?> getCycleById(String id) async {
    return await (_database.select(_database.cyclesTable)
          ..where((tbl) => tbl.id.equals(id) & tbl.isDeleted.equals(false)))
        .getSingleOrNull();
  }

  @override
  Future<String> createCycle(CyclesTableCompanion cycle) async {
    final id = cycle.id.present ? cycle.id.value : _uuid.v4();
    final now = DateTime.now();

    final cycleWithDefaults = cycle.copyWith(
      id: Value(id),
      createdAt: cycle.createdAt.present ? cycle.createdAt : Value(now),
      updatedAt: Value(now),
      needsSync: const Value(true),
      syncStatus: const Value('pending'),
      isDeleted: const Value(false),
    );

    await _database.into(_database.cyclesTable).insert(cycleWithDefaults);
    return id;
  }

  @override
  Future<void> updateCycle(CyclesTableCompanion cycle) async {
    final updatedCycle = cycle.copyWith(
      updatedAt: Value(DateTime.now()),
      needsSync: const Value(true),
      syncStatus: const Value('pending'),
    );

    await (_database.update(
      _database.cyclesTable,
    )..where((tbl) => tbl.id.equals(cycle.id.value))).write(updatedCycle);
  }

  @override
  Future<void> deleteCycle(String id) async {
    await (_database.update(
      _database.cyclesTable,
    )..where((tbl) => tbl.id.equals(id))).write(
      CyclesTableCompanion(
        isDeleted: const Value(true),
        needsSync: const Value(true),
        syncStatus: const Value('pending'),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<List<Cycle>> getCyclesNeedingSync() async {
    return await (_database.select(_database.cyclesTable)
          ..where((tbl) => tbl.needsSync.equals(true))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.updatedAt)]))
        .get();
  }

  @override
  Future<List<Cycle>> getDeletedCycles() async {
    return await (_database.select(_database.cyclesTable)
          ..where((tbl) => tbl.isDeleted.equals(true))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.updatedAt)]))
        .get();
  }

  @override
  Future<void> markCycleAsSynced(String id) async {
    await (_database.update(
      _database.cyclesTable,
    )..where((tbl) => tbl.id.equals(id))).write(
      CyclesTableCompanion(
        needsSync: const Value(false),
        syncStatus: const Value('synced'),
        lastSyncAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<void> markCycleAsNeedingSync(String id) async {
    await (_database.update(
      _database.cyclesTable,
    )..where((tbl) => tbl.id.equals(id))).write(
      const CyclesTableCompanion(
        needsSync: Value(true),
        syncStatus: Value('pending'),
      ),
    );
  }

  @override
  Future<void> updateSyncStatus(
    String id,
    String status, {
    DateTime? lastSyncAt,
  }) async {
    await (_database.update(
      _database.cyclesTable,
    )..where((tbl) => tbl.id.equals(id))).write(
      CyclesTableCompanion(
        syncStatus: Value(status),
        lastSyncAt: lastSyncAt != null
            ? Value(lastSyncAt)
            : const Value.absent(),
      ),
    );
  }

  @override
  Future<Cycle?> getActiveCycleForHouse(String houseId) async {
    return await (_database.select(_database.cyclesTable)
          ..where(
            (tbl) =>
                tbl.houseId.equals(houseId) &
                tbl.isActive.equals(true) &
                tbl.isDeleted.equals(false),
          )
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.startDate)])
          ..limit(1))
        .getSingleOrNull();
  }

  @override
  Future<List<Cycle>> getCyclesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    return await (_database.select(_database.cyclesTable)
          ..where(
            (tbl) =>
                tbl.startDate.isBetweenValues(startDate, endDate) &
                tbl.isDeleted.equals(false),
          )
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.startDate)]))
        .get();
  }

  @override
  Future<List<Cycle>> getCyclesByStatus({
    bool? isActive,
    bool? isDeleted,
    bool? needsSync,
  }) async {
    final query = _database.select(_database.cyclesTable);

    if (isActive != null) {
      query.where((tbl) => tbl.isActive.equals(isActive));
    }
    if (isDeleted != null) {
      query.where((tbl) => tbl.isDeleted.equals(isDeleted));
    }
    if (needsSync != null) {
      query.where((tbl) => tbl.needsSync.equals(needsSync));
    }

    query.orderBy([(tbl) => OrderingTerm.desc(tbl.updatedAt)]);
    return await query.get();
  }

  @override
  Future<List<Cycle>> searchCycles(String query) async {
    return await (_database.select(_database.cyclesTable)
          ..where(
            (tbl) =>
                (tbl.name.contains(query) | tbl.notes.contains(query)) &
                tbl.isDeleted.equals(false),
          )
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.updatedAt)]))
        .get();
  }

  @override
  Future<List<Cycle>> getCyclesByPriceRange(
    double minPrice,
    double maxPrice,
  ) async {
    return await (_database.select(_database.cyclesTable)
          ..where(
            (tbl) =>
                tbl.pricePerUnit.isBetweenValues(minPrice, maxPrice) &
                tbl.isDeleted.equals(false),
          )
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.startDate)]))
        .get();
  }

  @override
  Future<void> batchInsertCycles(List<CyclesTableCompanion> cycles) async {
    await _database.batch((batch) {
      for (final cycle in cycles) {
        final id = cycle.id.present ? cycle.id.value : _uuid.v4();
        final now = DateTime.now();

        final cycleWithDefaults = cycle.copyWith(
          id: Value(id),
          createdAt: cycle.createdAt.present ? cycle.createdAt : Value(now),
          updatedAt: Value(now),
          needsSync: const Value(true),
          syncStatus: const Value('pending'),
          isDeleted: const Value(false),
        );

        batch.insert(_database.cyclesTable, cycleWithDefaults);
      }
    });
  }

  @override
  Future<void> batchUpdateCycles(List<CyclesTableCompanion> cycles) async {
    await _database.batch((batch) {
      for (final cycle in cycles) {
        final updatedCycle = cycle.copyWith(
          updatedAt: Value(DateTime.now()),
          needsSync: const Value(true),
          syncStatus: const Value('pending'),
        );

        batch.update(
          _database.cyclesTable,
          updatedCycle,
          where: (tbl) => tbl.id.equals(cycle.id.value),
        );
      }
    });
  }

  @override
  Future<void> batchDeleteCycles(List<String> ids) async {
    await _database.batch((batch) {
      for (final id in ids) {
        batch.update(
          _database.cyclesTable,
          CyclesTableCompanion(
            isDeleted: const Value(true),
            needsSync: const Value(true),
            syncStatus: const Value('pending'),
            updatedAt: Value(DateTime.now()),
          ),
          where: (tbl) => tbl.id.equals(id),
        );
      }
    });
  }

  @override
  Future<int> getCyclesCount({
    String? houseId,
    bool includeDeleted = false,
  }) async {
    final countExp = _database.cyclesTable.id.count();
    final query = _database.selectOnly(_database.cyclesTable)
      ..addColumns([countExp]);

    if (houseId != null) {
      query.where(_database.cyclesTable.houseId.equals(houseId));
    }
    if (!includeDeleted) {
      query.where(_database.cyclesTable.isDeleted.equals(false));
    }

    final result = await query.getSingle();
    return result.read(countExp) ?? 0;
  }

  @override
  Future<DateTime?> getLastSyncTime() async {
    final result =
        await (_database.selectOnly(_database.cyclesTable)
              ..addColumns([_database.cyclesTable.lastSyncAt.max()])
              ..where(_database.cyclesTable.lastSyncAt.isNotNull()))
            .getSingleOrNull();

    return result?.read(_database.cyclesTable.lastSyncAt.max());
  }

  @override
  Future<void> deactivateOtherCycles(
    String houseId,
    String activeCycleId,
  ) async {
    await (_database.update(_database.cyclesTable)..where(
          (tbl) =>
              tbl.houseId.equals(houseId) & tbl.id.equals(activeCycleId).not(),
        ))
        .write(
          CyclesTableCompanion(
            isActive: const Value(false),
            needsSync: const Value(true),
            syncStatus: const Value('pending'),
            updatedAt: Value(DateTime.now()),
          ),
        );
  }

  // ==================== Backup and Restore Operations ====================

  @override
  Future<List<Map<String, dynamic>>> exportAllCyclesAsJson({
    String? houseId,
    bool includeDeleted = false,
    bool includeSyncFields = true,
  }) async {
    final query = _database.select(_database.cyclesTable);

    if (houseId != null) {
      query.where((tbl) => tbl.houseId.equals(houseId));
    }

    if (!includeDeleted) {
      query.where((tbl) => tbl.isDeleted.equals(false));
    }

    final cycles = await query.get();

    return cycles
        .map((cycle) => _cycleToJson(cycle, includeSyncFields))
        .toList();
  }

  @override
  Future<Map<String, dynamic>> exportCycleAsJson(
    String id, {
    bool includeSyncFields = true,
  }) async {
    final cycle = await (_database.select(
      _database.cyclesTable,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

    if (cycle == null) {
      throw Exception('Cycle with ID $id not found');
    }

    return _cycleToJson(cycle, includeSyncFields);
  }

  @override
  Future<void> importCyclesFromJson(
    List<Map<String, dynamic>> jsonData, {
    bool replaceExisting = false,
    bool preserveIds = true,
    bool skipInvalid = true,
  }) async {
    for (final cycleData in jsonData) {
      try {
        await importCycleFromJson(
          cycleData,
          replaceExisting: replaceExisting,
          preserveId: preserveIds,
        );
      } catch (e) {
        if (!skipInvalid) rethrow;
        // Skip invalid entries when skipInvalid is true
      }
    }
  }

  @override
  Future<String> importCycleFromJson(
    Map<String, dynamic> jsonData, {
    bool replaceExisting = false,
    bool preserveId = true,
  }) async {
    if (!await validateCycleData(jsonData)) {
      throw Exception('Invalid cycle data provided');
    }

    final id = preserveId && jsonData['id'] != null
        ? jsonData['id'] as String
        : _uuid.v4();

    final existing = await getCycleById(id);

    if (existing != null && !replaceExisting) {
      throw Exception('Cycle with ID $id already exists');
    }

    final companion = _jsonToCycleCompanion(jsonData, id);

    if (existing != null) {
      await _database.update(_database.cyclesTable).replace(companion);
    } else {
      await _database.into(_database.cyclesTable).insert(companion);
    }

    return id;
  }

  @override
  Future<void> clearAllCycles({
    String? houseId,
    bool includeSyncData = false,
  }) async {
    final query = _database.delete(_database.cyclesTable);

    if (houseId != null) {
      query.where((tbl) => tbl.houseId.equals(houseId));
    }

    if (includeSyncData) {
      await query.go();
    } else {
      // Soft delete by marking as deleted
      final updateQuery = _database.update(_database.cyclesTable);
      if (houseId != null) {
        updateQuery.where((tbl) => tbl.houseId.equals(houseId));
      }

      await updateQuery.write(
        CyclesTableCompanion(
          isDeleted: const Value(true),
          needsSync: const Value(true),
          updatedAt: Value(DateTime.now()),
        ),
      );
    }
  }

  @override
  Future<void> restoreFromBackup(
    List<Map<String, dynamic>> backupData, {
    bool clearExisting = false,
    bool preserveIds = true,
    String? filterByHouseId,
  }) async {
    if (clearExisting) {
      await clearAllCycles(houseId: filterByHouseId, includeSyncData: true);
    }

    final filteredData = filterByHouseId != null
        ? backupData
              .where((data) => data['houseId'] == filterByHouseId)
              .toList()
        : backupData;

    await importCyclesFromJson(
      filteredData,
      replaceExisting: true,
      preserveIds: preserveIds,
      skipInvalid: false,
    );
  }

  @override
  Future<List<Cycle>> getAllCyclesRaw({bool includeDeleted = true}) async {
    final query = _database.select(_database.cyclesTable);

    if (!includeDeleted) {
      query.where((tbl) => tbl.isDeleted.equals(false));
    }

    return await query.get();
  }

  @override
  Future<bool> validateCycleData(Map<String, dynamic> data) async {
    try {
      // Required fields validation
      if (data['houseId'] == null ||
          (data['houseId'] as String).trim().isEmpty) {
        return false;
      }

      if (data['name'] == null || (data['name'] as String).trim().isEmpty) {
        return false;
      }

      if (data['startDate'] == null) {
        return false;
      }

      if (data['endDate'] == null) {
        return false;
      }

      // Date validation
      final startDate = DateTime.parse(data['startDate'] as String);
      final endDate = DateTime.parse(data['endDate'] as String);

      if (endDate.isBefore(startDate)) {
        return false;
      }

      // Numeric validation
      if (data['initialMeterReading'] != null &&
          (data['initialMeterReading'] as num) < 0) {
        return false;
      }

      if (data['maxUnits'] != null && (data['maxUnits'] as num) < 0) {
        return false;
      }

      if (data['pricePerUnit'] != null && (data['pricePerUnit'] as num) < 0) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<String>> getDataIntegrityIssues() async {
    final issues = <String>[];

    // Check for cycles with invalid date ranges
    final invalidDates = await (_database.select(
      _database.cyclesTable,
    )..where((tbl) => tbl.endDate.isSmallerThan(tbl.startDate))).get();

    if (invalidDates.isNotEmpty) {
      issues.add(
        '${invalidDates.length} cycles have end date before start date',
      );
    }

    // Check for cycles with negative values
    final negativeReadings = await (_database.select(
      _database.cyclesTable,
    )..where((tbl) => tbl.initialMeterReading.isSmallerThanValue(0))).get();

    if (negativeReadings.isNotEmpty) {
      issues.add(
        '${negativeReadings.length} cycles have negative initial meter readings',
      );
    }

    // Check for cycles with empty names
    final emptyNames = await (_database.select(
      _database.cyclesTable,
    )..where((tbl) => tbl.name.equals('') | tbl.name.isNull())).get();

    if (emptyNames.isNotEmpty) {
      issues.add('${emptyNames.length} cycles have empty names');
    }

    // Check for multiple active cycles per house
    final activeCycles =
        await (_database.select(_database.cyclesTable)..where(
              (tbl) => tbl.isActive.equals(true) & tbl.isDeleted.equals(false),
            ))
            .get();

    final activeByHouse = <String, int>{};
    for (final cycle in activeCycles) {
      activeByHouse[cycle.houseId] = (activeByHouse[cycle.houseId] ?? 0) + 1;
    }

    final multipleActiveHouses = activeByHouse.entries
        .where((entry) => entry.value > 1)
        .length;

    if (multipleActiveHouses > 0) {
      issues.add('$multipleActiveHouses houses have multiple active cycles');
    }

    return issues;
  }

  @override
  Future<Map<String, int>> getBackupStatistics() async {
    final total = await (_database.select(_database.cyclesTable)).get();
    final active = await (_database.select(
      _database.cyclesTable,
    )..where((tbl) => tbl.isDeleted.equals(false))).get();
    final activeCycles =
        await (_database.select(_database.cyclesTable)..where(
              (tbl) => tbl.isActive.equals(true) & tbl.isDeleted.equals(false),
            ))
            .get();
    final needsSync = await (_database.select(
      _database.cyclesTable,
    )..where((tbl) => tbl.needsSync.equals(true))).get();

    return {
      'total': total.length,
      'active': active.length,
      'deleted': total.length - active.length,
      'activeCycles': activeCycles.length,
      'needsSync': needsSync.length,
      'synced': total.length - needsSync.length,
    };
  }

  // ==================== Helper Methods ====================

  Map<String, dynamic> _cycleToJson(Cycle cycle, bool includeSyncFields) {
    final json = {
      'id': cycle.id,
      'houseId': cycle.houseId,
      'name': cycle.name,
      'startDate': cycle.startDate.toIso8601String(),
      'endDate': cycle.endDate.toIso8601String(),
      'initialMeterReading': cycle.initialMeterReading,
      'maxUnits': cycle.maxUnits,
      'pricePerUnit': cycle.pricePerUnit,
      'notes': cycle.notes,
      'isActive': cycle.isActive,
      'createdAt': cycle.createdAt.toIso8601String(),
      'updatedAt': cycle.updatedAt.toIso8601String(),
    };

    if (includeSyncFields) {
      json.addAll({
        'isDeleted': cycle.isDeleted,
        'needsSync': cycle.needsSync,
        'lastSyncAt': cycle.lastSyncAt?.toIso8601String(),
        'syncStatus': cycle.syncStatus,
      });
    }

    return json;
  }

  CyclesTableCompanion _jsonToCycleCompanion(
    Map<String, dynamic> json,
    String id,
  ) {
    return CyclesTableCompanion.insert(
      id: id,
      houseId: json['houseId'] as String,
      name: json['name'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      initialMeterReading: (json['initialMeterReading'] as num).toDouble(),
      maxUnits: json['maxUnits'] as int,
      pricePerUnit: (json['pricePerUnit'] as num).toDouble(),
      notes: Value(json['notes'] as String?),
      isActive: Value(json['isActive'] as bool? ?? false),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
      isDeleted: Value(json['isDeleted'] as bool? ?? false),
      needsSync: Value(json['needsSync'] as bool? ?? true),
      lastSyncAt: json['lastSyncAt'] != null
          ? Value(DateTime.parse(json['lastSyncAt'] as String))
          : const Value.absent(),
      syncStatus: Value(json['syncStatus'] as String? ?? 'pending'),
    );
  }
}
