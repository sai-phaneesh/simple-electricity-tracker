import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:electricity/data/datasources/houses_datasource.dart';
import 'package:electricity/data/datasources/cycles_datasource.dart';
import 'package:electricity/data/datasources/electricity_readings_datasource.dart';

/// Comprehensive backup and restore service that coordinates all datasources
/// Provides easy-to-use methods for complete application data backup/restore
class BackupService {
  final HousesDataSource _housesDataSource;
  final CyclesDataSource _cyclesDataSource;
  final ElectricityReadingsDataSource _readingsDataSource;

  BackupService({
    required HousesDataSource housesDataSource,
    required CyclesDataSource cyclesDataSource,
    required ElectricityReadingsDataSource readingsDataSource,
  }) : _housesDataSource = housesDataSource,
       _cyclesDataSource = cyclesDataSource,
       _readingsDataSource = readingsDataSource;

  // ==================== Complete Backup Operations ====================

  /// Creates a complete backup of all application data
  Future<Map<String, dynamic>> createCompleteBackup({
    bool includeDeleted = false,
    bool includeSyncFields = true,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    final houses = await _housesDataSource.exportAllHousesAsJson(
      includeDeleted: includeDeleted,
      includeSyncFields: includeSyncFields,
    );

    final cycles = await _cyclesDataSource.exportAllCyclesAsJson(
      includeDeleted: includeDeleted,
      includeSyncFields: includeSyncFields,
    );

    final readings = await _readingsDataSource.exportAllReadingsAsJson(
      fromDate: fromDate,
      toDate: toDate,
      includeDeleted: includeDeleted,
      includeSyncFields: includeSyncFields,
    );

    return {
      'metadata': {
        'version': '1.0',
        'createdAt': DateTime.now().toIso8601String(),
        'includeDeleted': includeDeleted,
        'includeSyncFields': includeSyncFields,
        'fromDate': fromDate?.toIso8601String(),
        'toDate': toDate?.toIso8601String(),
        'totalHouses': houses.length,
        'totalCycles': cycles.length,
        'totalReadings': readings.length,
      },
      'data': {'houses': houses, 'cycles': cycles, 'readings': readings},
    };
  }

  /// Creates a backup for a specific house and all its data
  Future<Map<String, dynamic>> createHouseBackup(
    String houseId, {
    bool includeDeleted = false,
    bool includeSyncFields = true,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    final house = await _housesDataSource.exportHouseAsJson(
      houseId,
      includeSyncFields: includeSyncFields,
    );

    final cycles = await _cyclesDataSource.exportAllCyclesAsJson(
      houseId: houseId,
      includeDeleted: includeDeleted,
      includeSyncFields: includeSyncFields,
    );

    final readings = await _readingsDataSource.exportAllReadingsAsJson(
      houseId: houseId,
      fromDate: fromDate,
      toDate: toDate,
      includeDeleted: includeDeleted,
      includeSyncFields: includeSyncFields,
    );

    return {
      'metadata': {
        'version': '1.0',
        'createdAt': DateTime.now().toIso8601String(),
        'houseId': houseId,
        'houseName': house['name'],
        'includeDeleted': includeDeleted,
        'includeSyncFields': includeSyncFields,
        'fromDate': fromDate?.toIso8601String(),
        'toDate': toDate?.toIso8601String(),
        'totalCycles': cycles.length,
        'totalReadings': readings.length,
      },
      'data': {'house': house, 'cycles': cycles, 'readings': readings},
    };
  }

  /// Creates a backup for a specific cycle and all its readings
  Future<Map<String, dynamic>> createCycleBackup(
    String cycleId, {
    bool includeDeleted = false,
    bool includeSyncFields = true,
  }) async {
    final cycle = await _cyclesDataSource.exportCycleAsJson(
      cycleId,
      includeSyncFields: includeSyncFields,
    );

    final readings = await _readingsDataSource.exportAllReadingsAsJson(
      cycleId: cycleId,
      includeDeleted: includeDeleted,
      includeSyncFields: includeSyncFields,
    );

    return {
      'metadata': {
        'version': '1.0',
        'createdAt': DateTime.now().toIso8601String(),
        'cycleId': cycleId,
        'cycleName': cycle['name'],
        'houseId': cycle['houseId'],
        'includeDeleted': includeDeleted,
        'includeSyncFields': includeSyncFields,
        'totalReadings': readings.length,
      },
      'data': {'cycle': cycle, 'readings': readings},
    };
  }

  // ==================== File Operations ====================

  /// Saves backup data to a file
  Future<String> saveBackupToFile(
    Map<String, dynamic> backupData,
    String fileName,
  ) async {
    final directory = await getApplicationDocumentsDirectory();
    final backupDir = Directory('${directory.path}/backups');

    if (!await backupDir.exists()) {
      await backupDir.create(recursive: true);
    }

    final file = File('${backupDir.path}/$fileName.json');
    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(backupData),
    );

    return file.path;
  }

  /// Loads backup data from a file
  Future<Map<String, dynamic>> loadBackupFromFile(String filePath) async {
    final file = File(filePath);

    if (!await file.exists()) {
      throw Exception('Backup file not found: $filePath');
    }

    final content = await file.readAsString();
    final data = jsonDecode(content) as Map<String, dynamic>;

    // Validate backup format
    if (!_validateBackupFormat(data)) {
      throw Exception('Invalid backup file format');
    }

    return data;
  }

  /// Gets list of available backup files
  Future<List<FileSystemEntity>> getAvailableBackups() async {
    final directory = await getApplicationDocumentsDirectory();
    final backupDir = Directory('${directory.path}/backups');

    if (!await backupDir.exists()) {
      return [];
    }

    return backupDir
        .listSync()
        .where((entity) => entity.path.endsWith('.json'))
        .toList();
  }

  // ==================== Restore Operations ====================

  /// Restores complete backup data
  Future<void> restoreCompleteBackup(
    Map<String, dynamic> backupData, {
    bool clearExisting = false,
    bool preserveIds = true,
  }) async {
    final data = backupData['data'] as Map<String, dynamic>;

    // Restore houses first
    final houses = (data['houses'] as List<dynamic>)
        .cast<Map<String, dynamic>>();

    await _housesDataSource.restoreFromBackup(
      houses,
      clearExisting: clearExisting,
      preserveIds: preserveIds,
    );

    // Then restore cycles
    final cycles = (data['cycles'] as List<dynamic>)
        .cast<Map<String, dynamic>>();

    await _cyclesDataSource.restoreFromBackup(
      cycles,
      clearExisting: clearExisting,
      preserveIds: preserveIds,
    );

    // Finally restore readings
    final readings = (data['readings'] as List<dynamic>)
        .cast<Map<String, dynamic>>();

    await _readingsDataSource.restoreFromBackup(
      readings,
      clearExisting: clearExisting,
      preserveIds: preserveIds,
    );
  }

  /// Restores backup from file
  Future<void> restoreFromFile(
    String filePath, {
    bool clearExisting = false,
    bool preserveIds = true,
  }) async {
    final backupData = await loadBackupFromFile(filePath);
    await restoreCompleteBackup(
      backupData,
      clearExisting: clearExisting,
      preserveIds: preserveIds,
    );
  }

  /// Restores only a specific house and its data
  Future<void> restoreHouseBackup(
    Map<String, dynamic> backupData, {
    bool replaceExisting = false,
    bool preserveId = true,
  }) async {
    final data = backupData['data'] as Map<String, dynamic>;
    final houseId = backupData['metadata']['houseId'] as String;

    // Restore house
    final house = data['house'] as Map<String, dynamic>;
    await _housesDataSource.importHouseFromJson(
      house,
      replaceExisting: replaceExisting,
      preserveId: preserveId,
    );

    // Restore cycles for this house
    final cycles = (data['cycles'] as List<dynamic>)
        .cast<Map<String, dynamic>>();

    await _cyclesDataSource.restoreFromBackup(
      cycles,
      clearExisting: replaceExisting,
      preserveIds: preserveId,
      filterByHouseId: houseId,
    );

    // Restore readings for this house
    final readings = (data['readings'] as List<dynamic>)
        .cast<Map<String, dynamic>>();

    await _readingsDataSource.restoreFromBackup(
      readings,
      clearExisting: replaceExisting,
      preserveIds: preserveId,
      filterByHouseId: houseId,
    );
  }

  // ==================== Data Validation and Statistics ====================

  /// Validates the integrity of all data
  Future<Map<String, dynamic>> validateDataIntegrity() async {
    final houseIssues = await _housesDataSource.getDataIntegrityIssues();
    final cycleIssues = await _cyclesDataSource.getDataIntegrityIssues();
    final readingIssues = await _readingsDataSource.getDataIntegrityIssues();

    return {
      'houses': {'issues': houseIssues, 'hasIssues': houseIssues.isNotEmpty},
      'cycles': {'issues': cycleIssues, 'hasIssues': cycleIssues.isNotEmpty},
      'readings': {
        'issues': readingIssues,
        'hasIssues': readingIssues.isNotEmpty,
      },
      'summary': {
        'totalIssues':
            houseIssues.length + cycleIssues.length + readingIssues.length,
        'hasAnyIssues':
            houseIssues.isNotEmpty ||
            cycleIssues.isNotEmpty ||
            readingIssues.isNotEmpty,
      },
    };
  }

  /// Gets comprehensive statistics about the data
  Future<Map<String, dynamic>> getDataStatistics() async {
    final houseStats = await _housesDataSource.getBackupStatistics();
    final cycleStats = await _cyclesDataSource.getBackupStatistics();
    final readingStats = await _readingsDataSource.getBackupStatistics();

    return {
      'houses': houseStats,
      'cycles': cycleStats,
      'readings': readingStats,
      'summary': {
        'totalRecords':
            houseStats['total']! +
            cycleStats['total']! +
            readingStats['total']!,
        'activeRecords':
            houseStats['active']! +
            cycleStats['active']! +
            readingStats['active']!,
        'deletedRecords':
            houseStats['deleted']! +
            cycleStats['deleted']! +
            readingStats['deleted']!,
        'recordsNeedingSync':
            houseStats['needsSync']! +
            cycleStats['needsSync']! +
            readingStats['needsSync']!,
      },
    };
  }

  // ==================== Utility Methods ====================

  /// Generates a backup file name with timestamp
  String generateBackupFileName({String? prefix, String? suffix}) {
    final timestamp = DateTime.now();
    final dateStr =
        '${timestamp.year}-${timestamp.month.toString().padLeft(2, '0')}-${timestamp.day.toString().padLeft(2, '0')}';
    final timeStr =
        '${timestamp.hour.toString().padLeft(2, '0')}-${timestamp.minute.toString().padLeft(2, '0')}-${timestamp.second.toString().padLeft(2, '0')}';

    String fileName = 'backup_${dateStr}_$timeStr';

    if (prefix != null) {
      fileName = '${prefix}_$fileName';
    }

    if (suffix != null) {
      fileName = '${fileName}_$suffix';
    }

    return fileName;
  }

  /// Validates backup file format
  bool _validateBackupFormat(Map<String, dynamic> data) {
    try {
      // Check required top-level structure
      if (!data.containsKey('metadata') || !data.containsKey('data')) {
        return false;
      }

      final metadata = data['metadata'] as Map<String, dynamic>;
      final dataSection = data['data'] as Map<String, dynamic>;

      // Check metadata structure
      if (!metadata.containsKey('version') ||
          !metadata.containsKey('createdAt')) {
        return false;
      }

      // Check data structure
      if (dataSection.containsKey('houses') &&
          dataSection.containsKey('cycles') &&
          dataSection.containsKey('readings')) {
        // Complete backup format
        return true;
      } else if (dataSection.containsKey('house') &&
          dataSection.containsKey('cycles') &&
          dataSection.containsKey('readings')) {
        // House backup format
        return true;
      } else if (dataSection.containsKey('cycle') &&
          dataSection.containsKey('readings')) {
        // Cycle backup format
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  /// Clears all application data (use with caution!)
  Future<void> clearAllData({bool includeSyncData = false}) async {
    await _readingsDataSource.clearAllReadings(
      includeSyncData: includeSyncData,
    );
    await _cyclesDataSource.clearAllCycles(includeSyncData: includeSyncData);
    await _housesDataSource.clearAllHouses(includeSyncData: includeSyncData);
  }
}
