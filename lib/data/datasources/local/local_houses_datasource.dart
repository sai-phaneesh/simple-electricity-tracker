import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:electricity/data/database/database.dart';
import 'package:electricity/data/datasources/houses_datasource.dart';

class LocalHousesDataSource implements HousesDataSource {
  final AppDatabase _database;
  static const _uuid = Uuid();

  LocalHousesDataSource(this._database);

  @override
  Future<List<House>> getAllHouses() async {
    return await (_database.select(_database.housesTable)
          ..where((tbl) => tbl.isDeleted.equals(false))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.updatedAt)]))
        .get();
  }

  @override
  Stream<List<House>> watchAllHouses() {
    return (_database.select(_database.housesTable)
          ..where((tbl) => tbl.isDeleted.equals(false))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.updatedAt)]))
        .watch();
  }

  @override
  Stream<House?> watchHouseById(String id) {
    return (_database.select(_database.housesTable)
          ..where((tbl) => tbl.id.equals(id) & tbl.isDeleted.equals(false)))
        .watchSingleOrNull();
  }

  @override
  Stream<List<House>> watchHousesNeedingSync() {
    return (_database.select(_database.housesTable)
          ..where((tbl) => tbl.needsSync.equals(true))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.updatedAt)]))
        .watch();
  }

  @override
  Future<House?> getHouseById(String id) async {
    return await (_database.select(_database.housesTable)
          ..where((tbl) => tbl.id.equals(id) & tbl.isDeleted.equals(false)))
        .getSingleOrNull();
  }

  @override
  Future<String> createHouse(HousesTableCompanion house) async {
    final id = house.id.present ? house.id.value : _uuid.v4();
    final now = DateTime.now();

    final houseWithDefaults = house.copyWith(
      id: Value(id),
      createdAt: house.createdAt.present ? house.createdAt : Value(now),
      updatedAt: Value(now),
      needsSync: const Value(true),
      syncStatus: const Value('pending'),
      isDeleted: const Value(false),
    );

    await _database.into(_database.housesTable).insert(houseWithDefaults);
    return id;
  }

  @override
  Future<void> updateHouse(HousesTableCompanion house) async {
    final updatedHouse = house.copyWith(
      updatedAt: Value(DateTime.now()),
      needsSync: const Value(true),
      syncStatus: const Value('pending'),
    );

    await (_database.update(
      _database.housesTable,
    )..where((tbl) => tbl.id.equals(house.id.value))).write(updatedHouse);
  }

  @override
  Future<void> deleteHouse(String id) async {
    await (_database.update(
      _database.housesTable,
    )..where((tbl) => tbl.id.equals(id))).write(
      HousesTableCompanion(
        isDeleted: const Value(true),
        needsSync: const Value(true),
        syncStatus: const Value('pending'),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<List<House>> getHousesNeedingSync() async {
    return await (_database.select(_database.housesTable)
          ..where((tbl) => tbl.needsSync.equals(true))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.updatedAt)]))
        .get();
  }

  @override
  Future<List<House>> getDeletedHouses() async {
    return await (_database.select(_database.housesTable)
          ..where((tbl) => tbl.isDeleted.equals(true))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.updatedAt)]))
        .get();
  }

  @override
  Future<void> markHouseAsSynced(String id) async {
    await (_database.update(
      _database.housesTable,
    )..where((tbl) => tbl.id.equals(id))).write(
      HousesTableCompanion(
        needsSync: const Value(false),
        syncStatus: const Value('synced'),
        lastSyncAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<void> markHouseAsNeedingSync(String id) async {
    await (_database.update(
      _database.housesTable,
    )..where((tbl) => tbl.id.equals(id))).write(
      const HousesTableCompanion(
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
      _database.housesTable,
    )..where((tbl) => tbl.id.equals(id))).write(
      HousesTableCompanion(
        syncStatus: Value(status),
        lastSyncAt: lastSyncAt != null
            ? Value(lastSyncAt)
            : const Value.absent(),
      ),
    );
  }

  @override
  Future<List<House>> searchHouses(String query) async {
    return await (_database.select(_database.housesTable)
          ..where(
            (tbl) =>
                (tbl.name.contains(query) |
                    tbl.address.contains(query) |
                    tbl.notes.contains(query)) &
                tbl.isDeleted.equals(false),
          )
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.updatedAt)]))
        .get();
  }

  @override
  Future<List<House>> getHousesByStatus({
    bool? isDeleted,
    bool? needsSync,
  }) async {
    final query = _database.select(_database.housesTable);

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
  Future<void> batchInsertHouses(List<HousesTableCompanion> houses) async {
    await _database.batch((batch) {
      for (final house in houses) {
        final id = house.id.present ? house.id.value : _uuid.v4();
        final now = DateTime.now();

        final houseWithDefaults = house.copyWith(
          id: Value(id),
          createdAt: house.createdAt.present ? house.createdAt : Value(now),
          updatedAt: Value(now),
          needsSync: const Value(true),
          syncStatus: const Value('pending'),
          isDeleted: const Value(false),
        );

        batch.insert(_database.housesTable, houseWithDefaults);
      }
    });
  }

  @override
  Future<void> batchUpdateHouses(List<HousesTableCompanion> houses) async {
    await _database.batch((batch) {
      for (final house in houses) {
        final updatedHouse = house.copyWith(
          updatedAt: Value(DateTime.now()),
          needsSync: const Value(true),
          syncStatus: const Value('pending'),
        );

        batch.update(
          _database.housesTable,
          updatedHouse,
          where: (tbl) => tbl.id.equals(house.id.value),
        );
      }
    });
  }

  @override
  Future<void> batchDeleteHouses(List<String> ids) async {
    await _database.batch((batch) {
      for (final id in ids) {
        batch.update(
          _database.housesTable,
          HousesTableCompanion(
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
  Future<int> getHousesCount({bool includeDeleted = false}) async {
    final countExp = _database.housesTable.id.count();
    final query = _database.selectOnly(_database.housesTable)
      ..addColumns([countExp]);

    if (!includeDeleted) {
      query.where(_database.housesTable.isDeleted.equals(false));
    }

    final result = await query.getSingle();
    return result.read(countExp) ?? 0;
  }

  @override
  Future<DateTime?> getLastSyncTime() async {
    final result =
        await (_database.selectOnly(_database.housesTable)
              ..addColumns([_database.housesTable.lastSyncAt.max()])
              ..where(_database.housesTable.lastSyncAt.isNotNull()))
            .getSingleOrNull();

    return result?.read(_database.housesTable.lastSyncAt.max());
  }

  // ==================== Backup and Restore Operations ====================

  @override
  Future<List<Map<String, dynamic>>> exportAllHousesAsJson({
    bool includeDeleted = false,
    bool includeSyncFields = true,
  }) async {
    final query = _database.select(_database.housesTable);

    if (!includeDeleted) {
      query.where((tbl) => tbl.isDeleted.equals(false));
    }

    final houses = await query.get();

    return houses
        .map((house) => _houseToJson(house, includeSyncFields))
        .toList();
  }

  @override
  Future<Map<String, dynamic>> exportHouseAsJson(
    String id, {
    bool includeSyncFields = true,
  }) async {
    final house = await (_database.select(
      _database.housesTable,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

    if (house == null) {
      throw Exception('House with ID $id not found');
    }

    return _houseToJson(house, includeSyncFields);
  }

  @override
  Future<void> importHousesFromJson(
    List<Map<String, dynamic>> jsonData, {
    bool replaceExisting = false,
    bool preserveIds = true,
    bool skipInvalid = true,
  }) async {
    for (final houseData in jsonData) {
      try {
        await importHouseFromJson(
          houseData,
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
  Future<String> importHouseFromJson(
    Map<String, dynamic> jsonData, {
    bool replaceExisting = false,
    bool preserveId = true,
  }) async {
    if (!await validateHouseData(jsonData)) {
      throw Exception('Invalid house data provided');
    }

    final id = preserveId && jsonData['id'] != null
        ? jsonData['id'] as String
        : _uuid.v4();

    final existing = await getHouseById(id);

    if (existing != null && !replaceExisting) {
      throw Exception('House with ID $id already exists');
    }

    final companion = _jsonToHouseCompanion(jsonData, id);

    if (existing != null) {
      await _database.update(_database.housesTable).replace(companion);
    } else {
      await _database.into(_database.housesTable).insert(companion);
    }

    return id;
  }

  @override
  Future<void> clearAllHouses({bool includeSyncData = false}) async {
    if (includeSyncData) {
      await _database.delete(_database.housesTable).go();
    } else {
      // Soft delete by marking as deleted
      await _database
          .update(_database.housesTable)
          .write(
            HousesTableCompanion(
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
  }) async {
    if (clearExisting) {
      await clearAllHouses(includeSyncData: true);
    }

    await importHousesFromJson(
      backupData,
      replaceExisting: true,
      preserveIds: preserveIds,
      skipInvalid: false,
    );
  }

  @override
  Future<List<House>> getAllHousesRaw({bool includeDeleted = true}) async {
    final query = _database.select(_database.housesTable);

    if (!includeDeleted) {
      query.where((tbl) => tbl.isDeleted.equals(false));
    }

    return await query.get();
  }

  @override
  Future<bool> validateHouseData(Map<String, dynamic> data) async {
    try {
      // Required fields validation
      if (data['name'] == null || (data['name'] as String).trim().isEmpty) {
        return false;
      }

      if (data['defaultPricePerUnit'] == null ||
          (data['defaultPricePerUnit'] as num) < 0) {
        return false;
      }

      // Optional fields validation
      if (data['address'] != null && (data['address'] as String).length > 500) {
        return false;
      }

      // Date validation
      if (data['createdAt'] != null) {
        DateTime.parse(data['createdAt'] as String);
      }

      if (data['updatedAt'] != null) {
        DateTime.parse(data['updatedAt'] as String);
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<String>> getDataIntegrityIssues() async {
    final issues = <String>[];

    // Check for houses with invalid price
    final invalidPrices = await (_database.select(
      _database.housesTable,
    )..where((tbl) => tbl.defaultPricePerUnit.isSmallerThanValue(0))).get();

    if (invalidPrices.isNotEmpty) {
      issues.add('${invalidPrices.length} houses have negative price per unit');
    }

    // Check for houses with empty names
    final emptyNames = await (_database.select(
      _database.housesTable,
    )..where((tbl) => tbl.name.equals('') | tbl.name.isNull())).get();

    if (emptyNames.isNotEmpty) {
      issues.add('${emptyNames.length} houses have empty names');
    }

    // Check sync consistency
    final inconsistentSync =
        await (_database.select(_database.housesTable)..where(
              (tbl) => tbl.needsSync.equals(false) & tbl.lastSyncAt.isNull(),
            ))
            .get();

    if (inconsistentSync.isNotEmpty) {
      issues.add(
        '${inconsistentSync.length} houses marked as synced but have no sync timestamp',
      );
    }

    return issues;
  }

  @override
  Future<Map<String, int>> getBackupStatistics() async {
    final total = await (_database.select(_database.housesTable)).get();
    final active = await (_database.select(
      _database.housesTable,
    )..where((tbl) => tbl.isDeleted.equals(false))).get();
    final needsSync = await (_database.select(
      _database.housesTable,
    )..where((tbl) => tbl.needsSync.equals(true))).get();

    return {
      'total': total.length,
      'active': active.length,
      'deleted': total.length - active.length,
      'needsSync': needsSync.length,
      'synced': total.length - needsSync.length,
    };
  }

  // ==================== Helper Methods ====================

  Map<String, dynamic> _houseToJson(House house, bool includeSyncFields) {
    final json = {
      'id': house.id,
      'name': house.name,
      'address': house.address,
      'meterNumber': house.meterNumber,
      'defaultPricePerUnit': house.defaultPricePerUnit,
      'createdAt': house.createdAt.toIso8601String(),
      'updatedAt': house.updatedAt.toIso8601String(),
    };

    if (includeSyncFields) {
      json.addAll({
        'isDeleted': house.isDeleted,
        'needsSync': house.needsSync,
        'lastSyncAt': house.lastSyncAt?.toIso8601String(),
        'syncStatus': house.syncStatus,
      });
    }

    return json;
  }

  HousesTableCompanion _jsonToHouseCompanion(
    Map<String, dynamic> json,
    String id,
  ) {
    return HousesTableCompanion.insert(
      id: id,
      name: json['name'] as String,
      address: Value(json['address'] as String?),
      meterNumber: Value(json['meterNumber'] as String?),
      defaultPricePerUnit: (json['defaultPricePerUnit'] as num).toDouble(),
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
