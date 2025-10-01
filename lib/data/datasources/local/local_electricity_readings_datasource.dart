import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:electricity/data/database/database.dart';
import 'package:electricity/data/datasources/electricity_readings_datasource.dart';

class LocalElectricityReadingsDataSource
    implements ElectricityReadingsDataSource {
  final AppDatabase _database;
  static const _uuid = Uuid();

  LocalElectricityReadingsDataSource(this._database);

  @override
  Future<List<ElectricityReading>> getAllReadings() async {
    return await (_database.select(_database.electricityReadingsTable)
          ..where((tbl) => tbl.isDeleted.equals(false))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.date)]))
        .get();
  }

  @override
  Stream<List<ElectricityReading>> watchAllReadings() {
    return (_database.select(_database.electricityReadingsTable)
          ..where((tbl) => tbl.isDeleted.equals(false))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.date)]))
        .watch();
  }

  @override
  Stream<List<ElectricityReading>> watchReadingsByHouseId(String houseId) {
    return (_database.select(_database.electricityReadingsTable)
          ..where(
            (tbl) => tbl.houseId.equals(houseId) & tbl.isDeleted.equals(false),
          )
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.date)]))
        .watch();
  }

  @override
  Stream<List<ElectricityReading>> watchReadingsByCycleId(String cycleId) {
    return (_database.select(_database.electricityReadingsTable)
          ..where(
            (tbl) => tbl.cycleId.equals(cycleId) & tbl.isDeleted.equals(false),
          )
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]))
        .watch();
  }

  @override
  Stream<ElectricityReading?> watchReadingById(String id) {
    return (_database.select(_database.electricityReadingsTable)
          ..where((tbl) => tbl.id.equals(id) & tbl.isDeleted.equals(false)))
        .watchSingleOrNull();
  }

  @override
  Stream<List<ElectricityReading>> watchReadingsNeedingSync() {
    return (_database.select(_database.electricityReadingsTable)
          ..where((tbl) => tbl.needsSync.equals(true))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.updatedAt)]))
        .watch();
  }

  @override
  Future<List<ElectricityReading>> getReadingsByCycleId(String cycleId) async {
    return await (_database.select(_database.electricityReadingsTable)
          ..where(
            (tbl) => tbl.cycleId.equals(cycleId) & tbl.isDeleted.equals(false),
          )
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.date)]))
        .get();
  }

  @override
  Future<ElectricityReading?> getReadingById(String id) async {
    return await (_database.select(_database.electricityReadingsTable)
          ..where((tbl) => tbl.id.equals(id) & tbl.isDeleted.equals(false)))
        .getSingleOrNull();
  }

  @override
  Future<String> createReading(
    ElectricityReadingsTableCompanion reading,
  ) async {
    final id = reading.id.present ? reading.id.value : _uuid.v4();
    final now = DateTime.now();

    final readingWithDefaults = reading.copyWith(
      id: Value(id),
      createdAt: reading.createdAt.present ? reading.createdAt : Value(now),
      updatedAt: Value(now),
      needsSync: const Value(true),
      syncStatus: const Value('pending'),
      isDeleted: const Value(false),
    );

    await _database
        .into(_database.electricityReadingsTable)
        .insert(readingWithDefaults);
    return id;
  }

  @override
  Future<void> updateReading(ElectricityReadingsTableCompanion reading) async {
    final updatedReading = reading.copyWith(
      updatedAt: Value(DateTime.now()),
      needsSync: const Value(true),
      syncStatus: const Value('pending'),
    );

    await (_database.update(
      _database.electricityReadingsTable,
    )..where((tbl) => tbl.id.equals(reading.id.value))).write(updatedReading);
  }

  @override
  Future<void> deleteReading(String id) async {
    await (_database.update(
      _database.electricityReadingsTable,
    )..where((tbl) => tbl.id.equals(id))).write(
      ElectricityReadingsTableCompanion(
        isDeleted: const Value(true),
        needsSync: const Value(true),
        syncStatus: const Value('pending'),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<List<ElectricityReading>> getReadingsNeedingSync() async {
    return await (_database.select(_database.electricityReadingsTable)
          ..where((tbl) => tbl.needsSync.equals(true))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.updatedAt)]))
        .get();
  }

  @override
  Future<List<ElectricityReading>> getDeletedReadings() async {
    return await (_database.select(_database.electricityReadingsTable)
          ..where((tbl) => tbl.isDeleted.equals(true))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.updatedAt)]))
        .get();
  }

  @override
  Future<void> markReadingAsSynced(String id) async {
    await (_database.update(
      _database.electricityReadingsTable,
    )..where((tbl) => tbl.id.equals(id))).write(
      ElectricityReadingsTableCompanion(
        needsSync: const Value(false),
        syncStatus: const Value('synced'),
        lastSyncAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<void> markReadingAsNeedingSync(String id) async {
    await (_database.update(
      _database.electricityReadingsTable,
    )..where((tbl) => tbl.id.equals(id))).write(
      const ElectricityReadingsTableCompanion(
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
      _database.electricityReadingsTable,
    )..where((tbl) => tbl.id.equals(id))).write(
      ElectricityReadingsTableCompanion(
        syncStatus: Value(status),
        lastSyncAt: lastSyncAt != null
            ? Value(lastSyncAt)
            : const Value.absent(),
      ),
    );
  }

  @override
  Future<List<ElectricityReading>> getReadingsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    return await (_database.select(_database.electricityReadingsTable)
          ..where(
            (tbl) =>
                tbl.date.isBetweenValues(startDate, endDate) &
                tbl.isDeleted.equals(false),
          )
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.date)]))
        .get();
  }

  @override
  Future<List<ElectricityReading>> getReadingsByMeterRange(
    int minReading,
    int maxReading,
  ) async {
    return await (_database.select(_database.electricityReadingsTable)
          ..where(
            (tbl) =>
                tbl.meterReading.isBetweenValues(
                  minReading.toDouble(),
                  maxReading.toDouble(),
                ) &
                tbl.isDeleted.equals(false),
          )
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.date)]))
        .get();
  }

  @override
  Future<List<ElectricityReading>> getReadingsByStatus({
    bool? isDeleted,
    bool? needsSync,
  }) async {
    final query = _database.select(_database.electricityReadingsTable);

    if (isDeleted != null) {
      query.where((tbl) => tbl.isDeleted.equals(isDeleted));
    }
    if (needsSync != null) {
      query.where((tbl) => tbl.needsSync.equals(needsSync));
    }

    query.orderBy([(tbl) => OrderingTerm.desc(tbl.date)]);
    return await query.get();
  }

  @override
  Future<List<ElectricityReading>> getReadingsByHouseId(String houseId) async {
    return await (_database.select(_database.electricityReadingsTable)
          ..where(
            (tbl) => tbl.houseId.equals(houseId) & tbl.isDeleted.equals(false),
          )
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.date)]))
        .get();
  }

  @override
  Future<ElectricityReading?> getLatestReadingForHouse(String houseId) async {
    return await (_database.select(_database.electricityReadingsTable)
          ..where(
            (tbl) => tbl.houseId.equals(houseId) & tbl.isDeleted.equals(false),
          )
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.date)])
          ..limit(1))
        .getSingleOrNull();
  }

  @override
  Future<double> getAverageConsumptionForHouse(String houseId) async {
    final readings = await getReadingsByHouseId(houseId);
    if (readings.length < 2) return 0.0;

    readings.sort((a, b) => a.date.compareTo(b.date));

    final first = readings.first;
    final last = readings.last;

    final totalConsumption = (last.meterReading - first.meterReading)
        .toDouble();
    final daysDifference = last.date.difference(first.date).inDays;

    if (daysDifference == 0) return 0.0;

    return totalConsumption / daysDifference;
  }

  @override
  Future<ElectricityReading?> getPreviousReading(
    String cycleId,
    DateTime currentDate,
  ) async {
    return await (_database.select(_database.electricityReadingsTable)
          ..where(
            (tbl) =>
                tbl.cycleId.equals(cycleId) &
                tbl.date.isSmallerThanValue(currentDate) &
                tbl.isDeleted.equals(false),
          )
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.date)])
          ..limit(1))
        .getSingleOrNull();
  }

  @override
  Future<List<ElectricityReading>> searchReadings(String query) async {
    return await (_database.select(_database.electricityReadingsTable)
          ..where(
            (tbl) => tbl.notes.contains(query) & tbl.isDeleted.equals(false),
          )
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.date)]))
        .get();
  }

  @override
  Future<List<ElectricityReading>> getReadingsWithNotes() async {
    return await (_database.select(_database.electricityReadingsTable)
          ..where(
            (tbl) =>
                tbl.notes.isNotNull() &
                tbl.notes.equals('').not() &
                tbl.isDeleted.equals(false),
          )
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.date)]))
        .get();
  }

  @override
  Future<ElectricityReading?> getLatestReadingForCycle(String cycleId) async {
    return await (_database.select(_database.electricityReadingsTable)
          ..where(
            (tbl) => tbl.cycleId.equals(cycleId) & tbl.isDeleted.equals(false),
          )
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.date)])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<ElectricityReading?> getEarliestReadingForCycle(String cycleId) async {
    return await (_database.select(_database.electricityReadingsTable)
          ..where(
            (tbl) => tbl.cycleId.equals(cycleId) & tbl.isDeleted.equals(false),
          )
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.date)])
          ..limit(1))
        .getSingleOrNull();
  }

  @override
  Future<double> getTotalConsumptionForCycle(String cycleId) async {
    final readings = await getReadingsByCycleId(cycleId);
    if (readings.isEmpty) return 0.0;

    readings.sort((a, b) => a.date.compareTo(b.date));

    if (readings.length == 1) return 0.0;

    final first = readings.first;
    final last = readings.last;

    return (last.meterReading - first.meterReading).toDouble();
  }

  @override
  Future<double> getTotalCostForCycle(String cycleId) async {
    final readings = await getReadingsByCycleId(cycleId);
    if (readings.isEmpty) return 0.0;

    double totalCost = 0.0;
    for (final reading in readings) {
      totalCost += reading.totalCost;
    }
    return totalCost;
  }

  @override
  Future<Map<String, double>> getMonthlyConsumption(
    String houseId,
    int year,
  ) async {
    final startDate = DateTime(year, 1, 1);
    final endDate = DateTime(year + 1, 1, 1);

    final readings =
        await (_database.select(_database.electricityReadingsTable)
              ..where(
                (tbl) =>
                    tbl.houseId.equals(houseId) &
                    tbl.date.isBetweenValues(startDate, endDate) &
                    tbl.isDeleted.equals(false),
              )
              ..orderBy([(tbl) => OrderingTerm.asc(tbl.date)]))
            .get();

    final monthlyStats = <String, double>{};

    // Group readings by month
    final readingsByMonth = <int, List<ElectricityReading>>{};
    for (final reading in readings) {
      final month = reading.date.month;
      readingsByMonth.putIfAbsent(month, () => []).add(reading);
    }

    // Calculate usage for each month
    for (final entry in readingsByMonth.entries) {
      final monthReadings = entry.value
        ..sort((a, b) => a.date.compareTo(b.date));

      if (monthReadings.length >= 2) {
        final monthUsage =
            (monthReadings.last.meterReading - monthReadings.first.meterReading)
                .toDouble();
        final monthName = _getMonthName(entry.key);
        monthlyStats[monthName] = monthUsage;
      }
    }

    return monthlyStats;
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  @override
  Future<void> batchInsertReadings(
    List<ElectricityReadingsTableCompanion> readings,
  ) async {
    await _database.batch((batch) {
      for (final reading in readings) {
        final id = reading.id.present ? reading.id.value : _uuid.v4();
        final now = DateTime.now();

        final readingWithDefaults = reading.copyWith(
          id: Value(id),
          createdAt: reading.createdAt.present ? reading.createdAt : Value(now),
          updatedAt: Value(now),
          needsSync: const Value(true),
          syncStatus: const Value('pending'),
          isDeleted: const Value(false),
        );

        batch.insert(_database.electricityReadingsTable, readingWithDefaults);
      }
    });
  }

  @override
  Future<void> batchUpdateReadings(
    List<ElectricityReadingsTableCompanion> readings,
  ) async {
    await _database.batch((batch) {
      for (final reading in readings) {
        final updatedReading = reading.copyWith(
          updatedAt: Value(DateTime.now()),
          needsSync: const Value(true),
          syncStatus: const Value('pending'),
        );

        batch.update(
          _database.electricityReadingsTable,
          updatedReading,
          where: (tbl) => tbl.id.equals(reading.id.value),
        );
      }
    });
  }

  @override
  Future<void> batchDeleteReadings(List<String> ids) async {
    await _database.batch((batch) {
      for (final id in ids) {
        batch.update(
          _database.electricityReadingsTable,
          ElectricityReadingsTableCompanion(
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
  Future<int> getReadingsCount({
    String? houseId,
    String? cycleId,
    bool includeDeleted = false,
  }) async {
    final countExp = _database.electricityReadingsTable.id.count();
    final query = _database.selectOnly(_database.electricityReadingsTable)
      ..addColumns([countExp]);

    if (houseId != null) {
      query.where(_database.electricityReadingsTable.houseId.equals(houseId));
    }
    if (cycleId != null) {
      query.where(_database.electricityReadingsTable.cycleId.equals(cycleId));
    }
    if (!includeDeleted) {
      query.where(_database.electricityReadingsTable.isDeleted.equals(false));
    }

    final result = await query.getSingle();
    return result.read(countExp) ?? 0;
  }

  @override
  Future<DateTime?> getLastSyncTime() async {
    final result =
        await (_database.selectOnly(_database.electricityReadingsTable)
              ..addColumns([
                _database.electricityReadingsTable.lastSyncAt.max(),
              ])
              ..where(
                _database.electricityReadingsTable.lastSyncAt.isNotNull(),
              ))
            .getSingleOrNull();

    return result?.read(_database.electricityReadingsTable.lastSyncAt.max());
  }

  Future<List<ElectricityReading>> getReadingsWithPagination({
    int? limit,
    int? offset,
    String? cycleId,
  }) async {
    final query = _database.select(_database.electricityReadingsTable)
      ..where((tbl) => tbl.isDeleted.equals(false));

    if (cycleId != null) {
      query.where((tbl) => tbl.cycleId.equals(cycleId));
    }

    query.orderBy([(tbl) => OrderingTerm.desc(tbl.date)]);

    if (limit != null) {
      query.limit(limit, offset: offset);
    }

    return await query.get();
  }

  Future<bool> hasReadingForDate(String cycleId, DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final reading =
        await (_database.select(_database.electricityReadingsTable)
              ..where(
                (tbl) =>
                    tbl.cycleId.equals(cycleId) &
                    tbl.date.isBetweenValues(startOfDay, endOfDay) &
                    tbl.isDeleted.equals(false),
              )
              ..limit(1))
            .getSingleOrNull();

    return reading != null;
  }

  Future<List<ElectricityReading>> getDuplicateReadings() async {
    // This is a simplified approach - in a real scenario, you might want to use raw SQL
    // for more complex duplicate detection
    final allReadings = await getAllReadings();
    final duplicates = <ElectricityReading>[];

    final seen = <String, ElectricityReading>{};
    for (final reading in allReadings) {
      final key =
          '${reading.cycleId}_${reading.date.toIso8601String().split('T')[0]}';
      if (seen.containsKey(key)) {
        duplicates.add(reading);
      } else {
        seen[key] = reading;
      }
    }

    return duplicates;
  }

  // ==================== Backup and Restore Operations ====================

  @override
  Future<List<Map<String, dynamic>>> exportAllReadingsAsJson({
    String? houseId,
    String? cycleId,
    DateTime? fromDate,
    DateTime? toDate,
    bool includeDeleted = false,
    bool includeSyncFields = true,
  }) async {
    final query = _database.select(_database.electricityReadingsTable);

    if (houseId != null) {
      query.where((tbl) => tbl.houseId.equals(houseId));
    }

    if (cycleId != null) {
      query.where((tbl) => tbl.cycleId.equals(cycleId));
    }

    if (fromDate != null) {
      query.where((tbl) => tbl.date.isBiggerOrEqualValue(fromDate));
    }

    if (toDate != null) {
      query.where((tbl) => tbl.date.isSmallerOrEqualValue(toDate));
    }

    if (!includeDeleted) {
      query.where((tbl) => tbl.isDeleted.equals(false));
    }

    final readings = await query.get();

    return readings
        .map((reading) => _readingToJson(reading, includeSyncFields))
        .toList();
  }

  @override
  Future<Map<String, dynamic>> exportReadingAsJson(
    String id, {
    bool includeSyncFields = true,
  }) async {
    final reading = await (_database.select(
      _database.electricityReadingsTable,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

    if (reading == null) {
      throw Exception('Reading with ID $id not found');
    }

    return _readingToJson(reading, includeSyncFields);
  }

  @override
  Future<void> importReadingsFromJson(
    List<Map<String, dynamic>> jsonData, {
    bool replaceExisting = false,
    bool preserveIds = true,
    bool skipInvalid = true,
  }) async {
    for (final readingData in jsonData) {
      try {
        await importReadingFromJson(
          readingData,
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
  Future<String> importReadingFromJson(
    Map<String, dynamic> jsonData, {
    bool replaceExisting = false,
    bool preserveId = true,
  }) async {
    if (!await validateReadingData(jsonData)) {
      throw Exception('Invalid reading data provided');
    }

    final id = preserveId && jsonData['id'] != null
        ? jsonData['id'] as String
        : _uuid.v4();

    final existing = await getReadingById(id);

    if (existing != null && !replaceExisting) {
      throw Exception('Reading with ID $id already exists');
    }

    final companion = _jsonToReadingCompanion(jsonData, id);

    if (existing != null) {
      await _database
          .update(_database.electricityReadingsTable)
          .replace(companion);
    } else {
      await _database
          .into(_database.electricityReadingsTable)
          .insert(companion);
    }

    return id;
  }

  @override
  Future<void> clearAllReadings({
    String? houseId,
    String? cycleId,
    bool includeSyncData = false,
  }) async {
    final query = _database.delete(_database.electricityReadingsTable);

    if (houseId != null) {
      query.where((tbl) => tbl.houseId.equals(houseId));
    }

    if (cycleId != null) {
      query.where((tbl) => tbl.cycleId.equals(cycleId));
    }

    if (includeSyncData) {
      await query.go();
    } else {
      // Soft delete by marking as deleted
      final updateQuery = _database.update(_database.electricityReadingsTable);

      if (houseId != null) {
        updateQuery.where((tbl) => tbl.houseId.equals(houseId));
      }

      if (cycleId != null) {
        updateQuery.where((tbl) => tbl.cycleId.equals(cycleId));
      }

      await updateQuery.write(
        ElectricityReadingsTableCompanion(
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
    String? filterByCycleId,
  }) async {
    if (clearExisting) {
      await clearAllReadings(
        houseId: filterByHouseId,
        cycleId: filterByCycleId,
        includeSyncData: true,
      );
    }

    List<Map<String, dynamic>> filteredData = backupData;

    if (filterByHouseId != null) {
      filteredData = filteredData
          .where((data) => data['houseId'] == filterByHouseId)
          .toList();
    }

    if (filterByCycleId != null) {
      filteredData = filteredData
          .where((data) => data['cycleId'] == filterByCycleId)
          .toList();
    }

    await importReadingsFromJson(
      filteredData,
      replaceExisting: true,
      preserveIds: preserveIds,
      skipInvalid: false,
    );
  }

  @override
  Future<List<ElectricityReading>> getAllReadingsRaw({
    bool includeDeleted = true,
  }) async {
    final query = _database.select(_database.electricityReadingsTable);

    if (!includeDeleted) {
      query.where((tbl) => tbl.isDeleted.equals(false));
    }

    return await query.get();
  }

  @override
  Future<bool> validateReadingData(Map<String, dynamic> data) async {
    try {
      // Required fields validation
      if (data['houseId'] == null ||
          (data['houseId'] as String).trim().isEmpty) {
        return false;
      }

      if (data['cycleId'] == null ||
          (data['cycleId'] as String).trim().isEmpty) {
        return false;
      }

      if (data['date'] == null) {
        return false;
      }

      if (data['meterReading'] == null || (data['meterReading'] as num) < 0) {
        return false;
      }

      // Date validation
      DateTime.parse(data['date'] as String);

      // Optional fields validation
      if (data['notes'] != null && (data['notes'] as String).length > 1000) {
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

    // Check for readings with negative meter readings
    final negativeReadings = await (_database.select(
      _database.electricityReadingsTable,
    )..where((tbl) => tbl.meterReading.isSmallerThanValue(0))).get();

    if (negativeReadings.isNotEmpty) {
      issues.add(
        '${negativeReadings.length} readings have negative meter readings',
      );
    }

    // Check for readings with future dates
    final futureReadings = await (_database.select(
      _database.electricityReadingsTable,
    )..where((tbl) => tbl.date.isBiggerThanValue(DateTime.now()))).get();

    if (futureReadings.isNotEmpty) {
      issues.add('${futureReadings.length} readings have future dates');
    }

    // Check for duplicate readings (same house, cycle, and date)
    final duplicates = await getDuplicateReadings();

    if (duplicates.isNotEmpty) {
      issues.add('${duplicates.length} duplicate readings found');
    }

    // Check sync consistency
    final inconsistentSync =
        await (_database.select(_database.electricityReadingsTable)..where(
              (tbl) => tbl.needsSync.equals(false) & tbl.lastSyncAt.isNull(),
            ))
            .get();

    if (inconsistentSync.isNotEmpty) {
      issues.add(
        '${inconsistentSync.length} readings marked as synced but have no sync timestamp',
      );
    }

    // Check for readings with invalid consumption patterns
    final cycleIdsQuery =
        _database.selectOnly(_database.electricityReadingsTable)
          ..addColumns([_database.electricityReadingsTable.cycleId])
          ..groupBy([_database.electricityReadingsTable.cycleId]);

    final cycleIds = await cycleIdsQuery
        .map((row) => row.read(_database.electricityReadingsTable.cycleId)!)
        .get();

    int invalidConsumptionCount = 0;
    for (final cycleId in cycleIds) {
      final cycleReadings = await getReadingsByCycleId(cycleId);
      if (cycleReadings.length > 1) {
        cycleReadings.sort((a, b) => a.date.compareTo(b.date));

        for (int i = 1; i < cycleReadings.length; i++) {
          if (cycleReadings[i].meterReading <
              cycleReadings[i - 1].meterReading) {
            invalidConsumptionCount++;
          }
        }
      }
    }

    if (invalidConsumptionCount > 0) {
      issues.add(
        '$invalidConsumptionCount readings have meter readings lower than previous readings',
      );
    }

    return issues;
  }

  @override
  Future<Map<String, int>> getBackupStatistics() async {
    final total = await (_database.select(
      _database.electricityReadingsTable,
    )).get();
    final active = await (_database.select(
      _database.electricityReadingsTable,
    )..where((tbl) => tbl.isDeleted.equals(false))).get();
    final needsSync = await (_database.select(
      _database.electricityReadingsTable,
    )..where((tbl) => tbl.needsSync.equals(true))).get();
    final withNotes =
        await (_database.select(_database.electricityReadingsTable)..where(
              (tbl) => tbl.notes.isNotNull() & tbl.notes.equals('').not(),
            ))
            .get();

    return {
      'total': total.length,
      'active': active.length,
      'deleted': total.length - active.length,
      'needsSync': needsSync.length,
      'synced': total.length - needsSync.length,
      'withNotes': withNotes.length,
    };
  }

  // ==================== Helper Methods ====================

  Map<String, dynamic> _readingToJson(
    ElectricityReading reading,
    bool includeSyncFields,
  ) {
    final json = {
      'id': reading.id,
      'houseId': reading.houseId,
      'cycleId': reading.cycleId,
      'date': reading.date.toIso8601String(),
      'meterReading': reading.meterReading,
      'unitsConsumed': reading.unitsConsumed,
      'totalCost': reading.totalCost,
      'notes': reading.notes,
      'createdAt': reading.createdAt.toIso8601String(),
      'updatedAt': reading.updatedAt.toIso8601String(),
    };

    if (includeSyncFields) {
      json.addAll({
        'isDeleted': reading.isDeleted,
        'needsSync': reading.needsSync,
        'lastSyncAt': reading.lastSyncAt?.toIso8601String(),
        'syncStatus': reading.syncStatus,
      });
    }

    return json;
  }

  ElectricityReadingsTableCompanion _jsonToReadingCompanion(
    Map<String, dynamic> json,
    String id,
  ) {
    return ElectricityReadingsTableCompanion.insert(
      id: id,
      houseId: json['houseId'] as String,
      cycleId: json['cycleId'] as String,
      date: DateTime.parse(json['date'] as String),
      meterReading: (json['meterReading'] as num).toDouble(),
      unitsConsumed: (json['unitsConsumed'] as num).toDouble(),
      totalCost: (json['totalCost'] as num?)?.toDouble() ?? 0.0,
      notes: Value(json['notes'] as String?),
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
