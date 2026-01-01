import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart' show compute;
import 'package:electricity/data/datasources/houses_datasource.dart';
import 'package:electricity/data/datasources/cycles_datasource.dart';
import 'package:electricity/data/datasources/electricity_readings_datasource.dart';
import 'package:electricity/data/services/export/export_data_model.dart';
import 'package:electricity/data/services/export/crypto_service.dart';
import 'package:electricity/data/services/export/import_validator.dart';
import 'package:electricity/domain/entities/cycle.dart';
import 'package:electricity/domain/entities/electricity_reading.dart';

/// Main service for handling data export and import operations
// The real `ExportImportService` is defined below; helper functions appear
// above to support background decryption via `compute()`.

// Top-level helper for compute() to run decryption on a background isolate
String? _decryptEncryptedPayload(Map<String, String> args) {
  try {
    final data = EncryptedData(
      salt: args['salt'] ?? '',
      iv: args['iv'] ?? '',
      ciphertext: args['ciphertext'] ?? '',
      hmac: args['hmac'] ?? '',
    );
    final pass = args['passphrase'] ?? '';
    return ExportCryptoService.decrypt(data, pass);
  } catch (e) {
    // Swallow and return null to indicate failure
    return null;
  }
}

class ExportImportService {
  final HousesDataSource _housesDataSource;
  final CyclesDataSource _cyclesDataSource;
  final ElectricityReadingsDataSource _readingsDataSource;

  ExportImportService({
    required HousesDataSource housesDataSource,
    required CyclesDataSource cyclesDataSource,
    required ElectricityReadingsDataSource readingsDataSource,
  }) : _housesDataSource = housesDataSource,
       _cyclesDataSource = cyclesDataSource,
       _readingsDataSource = readingsDataSource;

  /// Export all user data to an encrypted file
  Future<ExportResult> exportData({
    required String userId,
    required String userEmail,
    required String passphrase,
    void Function(ExportProgress)? onProgress,
  }) async {
    try {
      onProgress?.call(
        ExportProgress(
          stage: ExportStage.fetchingData,
          message: 'Fetching houses...',
          progress: 0.0,
        ),
      );

      // Fetch all data
      final houses = await _housesDataSource.getAllHouses();

      onProgress?.call(
        ExportProgress(
          stage: ExportStage.fetchingData,
          message: 'Fetching cycles...',
          progress: 0.2,
        ),
      );

      final cycles = await _cyclesDataSource.getAllCycles();

      onProgress?.call(
        ExportProgress(
          stage: ExportStage.fetchingData,
          message: 'Fetching readings...',
          progress: 0.4,
        ),
      );

      final readings = await _readingsDataSource.getAllReadings();

      onProgress?.call(
        ExportProgress(
          stage: ExportStage.packaging,
          message: 'Packaging data...',
          progress: 0.6,
        ),
      );

      // Create payload
      final payload = ExportPayload(
        houses: houses,
        cycles: cycles,
        readings: readings,
      );

      // Generate checksum of payload
      final payloadJson = jsonEncode(payload.toJson());
      final payloadChecksum = ExportCryptoService.generateChecksum(payloadJson);

      // Note: metadata is created inside the ExportPackage and will be
      // encrypted as part of the package payload. We no longer store
      // unencrypted metadata at the top level.

      onProgress?.call(
        ExportProgress(
          stage: ExportStage.encrypting,
          message: 'Encrypting data...',
          progress: 0.8,
        ),
      );

      // Create the full package
      final package = ExportPackage.create(
        payload: payload,
        signature: ExportCryptoService.generateSignature(
          payload.toJson(),
          passphrase,
        ),
        userId: userId,
        userEmail: userEmail,
        payloadChecksum: payloadChecksum,
      );

      // Encrypt the package
      final packageJson = jsonEncode(package.toJson());
      final encryptedFile = EncryptedExportFile.create(
        jsonPayload: packageJson,
        passphrase: passphrase,
      );

      onProgress?.call(
        ExportProgress(
          stage: ExportStage.complete,
          message: 'Export complete!',
          progress: 1.0,
        ),
      );

      return ExportResult.success(
        encryptedFile: encryptedFile,
        summary: ExportSummary(
          housesCount: houses.length,
          cyclesCount: cycles.length,
          readingsCount: readings.length,
          exportedAt: DateTime.now(),
          fileSizeBytes: utf8.encode(jsonEncode(encryptedFile.toJson())).length,
        ),
      );
    } catch (e) {
      return ExportResult.failure('Failed to export data: $e');
    }
  }

  /// Import data from an encrypted file
  Future<ImportResult> importData({
    required String fileContent,
    required String passphrase,
    required String currentUserId,
    String? currentUserEmail,
    required ImportMode mode,
    void Function(ImportProgress)? onProgress,
  }) async {
    try {
      onProgress?.call(
        ImportProgress(
          stage: ImportStage.parsing,
          message: 'Parsing file...',
          progress: 0.0,
        ),
      );

      // Parse the encrypted file
      Map<String, dynamic> fileJson;
      try {
        fileJson = jsonDecode(fileContent) as Map<String, dynamic>;
      } catch (e) {
        return ImportResult.failure([
          ValidationError(
            type: ValidationErrorType.invalidFormat,
            message: 'File is not valid JSON',
          ),
        ]);
      }

      // Validate file structure
      late EncryptedExportFile encryptedFile;
      try {
        encryptedFile = EncryptedExportFile.fromJson(fileJson);
      } catch (e) {
        return ImportResult.failure([
          ValidationError(
            type: ValidationErrorType.invalidMagicHeader,
            message: 'File is not a valid Electricity Tracker backup',
          ),
        ]);
      }

      if (!encryptedFile.isValid) {
        return ImportResult.failure([
          ValidationError(
            type: ValidationErrorType.invalidMagicHeader,
            message: 'File is not a valid Electricity Tracker backup',
          ),
        ]);
      }

      onProgress?.call(
        ImportProgress(
          stage: ImportStage.decrypting,
          message: 'Decrypting data...',
          progress: 0.2,
        ),
      );

      // Decrypt the payload in background
      final decrypted =
          await compute(_decryptEncryptedPayload, <String, String>{
            'salt': encryptedFile.encryptedPayload.salt,
            'iv': encryptedFile.encryptedPayload.iv,
            'ciphertext': encryptedFile.encryptedPayload.ciphertext,
            'hmac': encryptedFile.encryptedPayload.hmac,
            'passphrase': passphrase,
          });

      if (decrypted == null) {
        return ImportResult.failure([
          ValidationError(
            type: ValidationErrorType.decryptionFailed,
            message: 'Failed to decrypt file. Please check your passphrase.',
          ),
        ]);
      }

      onProgress?.call(
        ImportProgress(
          stage: ImportStage.validating,
          message: 'Validating data...',
          progress: 0.4,
        ),
      );

      // Parse the decrypted package
      ExportPackage package;
      try {
        package = ExportPackage.fromJson(
          jsonDecode(decrypted) as Map<String, dynamic>,
        );
      } catch (e) {
        return ImportResult.failure([
          ValidationError(
            type: ValidationErrorType.corruptedData,
            message: 'Decrypted data is corrupted',
          ),
        ]);
      }

      // Validate the package
      final validator = ImportValidator();
      final validationResult = await validator.validate(
        package: package,
        currentUserId: currentUserId,
        currentUserEmail: currentUserEmail,
        housesDataSource: _housesDataSource,
        cyclesDataSource: _cyclesDataSource,
        readingsDataSource: _readingsDataSource,
      );

      if (!validationResult.isValid) {
        return ImportResult.failure(validationResult.errors);
      }

      onProgress?.call(
        ImportProgress(
          stage: ImportStage.importing,
          message: 'Importing data...',
          progress: 0.6,
        ),
      );

      // Perform the import based on mode
      final importStats = await _performImport(
        package: package,
        mode: mode,
        currentUserId: currentUserId,
        onProgress: (progress) {
          onProgress?.call(
            ImportProgress(
              stage: ImportStage.importing,
              message: progress,
              progress: 0.6 + (0.3 * 0.5), // Approximate
            ),
          );
        },
      );

      onProgress?.call(
        ImportProgress(
          stage: ImportStage.complete,
          message: 'Import complete!',
          progress: 1.0,
        ),
      );
      return ImportResult.success(
        summary: validationResult.summary!,
        stats: importStats,
      );
    } catch (e) {
      return ImportResult.failure([
        ValidationError(
          type: ValidationErrorType.corruptedData,
          message: 'Failed to import data: $e',
        ),
      ]);
    }
  }

  /// Preview import without actually importing
  Future<ImportValidationResult> previewImport({
    required String fileContent,
    required String passphrase,
    required String currentUserId,
    String? currentUserEmail,
  }) async {
    try {
      // Parse and decrypt
      Map<String, dynamic> fileJson;
      try {
        fileJson = jsonDecode(fileContent) as Map<String, dynamic>;
      } catch (e) {
        return ImportValidationResult.failure([
          ValidationError(
            type: ValidationErrorType.invalidFormat,
            message: 'File is not valid JSON',
          ),
        ]);
      }

      late EncryptedExportFile encryptedFile;
      try {
        encryptedFile = EncryptedExportFile.fromJson(fileJson);
      } catch (e) {
        return ImportValidationResult.failure([
          ValidationError(
            type: ValidationErrorType.invalidMagicHeader,
            message: 'File is not a valid Electricity Tracker backup',
          ),
        ]);
      }

      if (!encryptedFile.isValid) {
        return ImportValidationResult.failure([
          ValidationError(
            type: ValidationErrorType.invalidMagicHeader,
            message: 'File is not a valid Electricity Tracker backup',
          ),
        ]);
      }
      final decrypted =
          await compute(_decryptEncryptedPayload, <String, String>{
            'salt': encryptedFile.encryptedPayload.salt,
            'iv': encryptedFile.encryptedPayload.iv,
            'ciphertext': encryptedFile.encryptedPayload.ciphertext,
            'hmac': encryptedFile.encryptedPayload.hmac,
            'passphrase': passphrase,
          });

      if (decrypted == null) {
        return ImportValidationResult.failure([
          ValidationError(
            type: ValidationErrorType.decryptionFailed,
            message: 'Failed to decrypt file. Please check your passphrase.',
          ),
        ]);
      }

      ExportPackage package;
      try {
        package = ExportPackage.fromJson(
          jsonDecode(decrypted) as Map<String, dynamic>,
        );
      } catch (e) {
        return ImportValidationResult.failure([
          ValidationError(
            type: ValidationErrorType.corruptedData,
            message: 'Decrypted data is corrupted',
          ),
        ]);
      }

      // Validate
      final validator = ImportValidator();
      return await validator.validate(
        package: package,
        currentUserId: currentUserId,
        currentUserEmail: currentUserEmail,
        housesDataSource: _housesDataSource,
        cyclesDataSource: _cyclesDataSource,
        readingsDataSource: _readingsDataSource,
      );
    } catch (e) {
      return ImportValidationResult.failure([
        ValidationError(
          type: ValidationErrorType.corruptedData,
          message: 'Failed to parse file: $e',
        ),
      ]);
    }
  }

  /// Perform the actual import
  Future<ImportStats> _performImport({
    required ExportPackage package,
    required ImportMode mode,
    required String currentUserId,
    void Function(String)? onProgress,
  }) async {
    int housesCreated = 0;
    int housesUpdated = 0;
    int housesSkipped = 0;
    int cyclesCreated = 0;
    int cyclesUpdated = 0;
    int cyclesSkipped = 0;
    int readingsCreated = 0;
    int readingsUpdated = 0;
    int readingsSkipped = 0;

    // Map old IDs to new IDs for referential integrity
    final houseIdMap = <String, String>{};
    final cycleIdMap = <String, String>{};

    // Import houses
    onProgress?.call('Importing houses...');
    for (final house in package.payload.houses) {
      final existingHouse = await _housesDataSource.getHouseById(house.id);

      if (existingHouse != null) {
        switch (mode) {
          case ImportMode.replace:
          case ImportMode.mergeOverwrite:
            await _housesDataSource.updateHouse(house);
            housesUpdated++;
            houseIdMap[house.id] = house.id;
          case ImportMode.mergeSkip:
            housesSkipped++;
            houseIdMap[house.id] = house.id;
        }
      } else {
        await _housesDataSource.createHouse(house);
        housesCreated++;
        houseIdMap[house.id] = house.id;
      }
    }

    // Import cycles
    onProgress?.call('Importing cycles...');
    for (final cycle in package.payload.cycles) {
      // Update house ID reference if needed
      final mappedHouseId = houseIdMap[cycle.houseId] ?? cycle.houseId;
      final updatedCycle = Cycle(
        id: cycle.id,
        houseId: mappedHouseId,
        name: cycle.name,
        startDate: cycle.startDate,
        endDate: cycle.endDate,
        initialMeterReading: cycle.initialMeterReading,
        maxUnits: cycle.maxUnits,
        pricePerUnit: cycle.pricePerUnit,
        notes: cycle.notes,
        isActive: cycle.isActive,
        createdAt: cycle.createdAt,
        updatedAt: cycle.updatedAt,
      );

      final existingCycle = await _cyclesDataSource.getCycleById(cycle.id);

      if (existingCycle != null) {
        switch (mode) {
          case ImportMode.replace:
          case ImportMode.mergeOverwrite:
            await _cyclesDataSource.updateCycle(updatedCycle);
            cyclesUpdated++;
            cycleIdMap[cycle.id] = cycle.id;
          case ImportMode.mergeSkip:
            cyclesSkipped++;
            cycleIdMap[cycle.id] = cycle.id;
        }
      } else {
        await _cyclesDataSource.createCycle(updatedCycle);
        cyclesCreated++;
        cycleIdMap[cycle.id] = cycle.id;
      }
    }

    // Import readings
    onProgress?.call('Importing readings...');
    for (final reading in package.payload.readings) {
      // Update references
      final mappedHouseId = houseIdMap[reading.houseId] ?? reading.houseId;
      final mappedCycleId = cycleIdMap[reading.cycleId] ?? reading.cycleId;
      final updatedReading = ElectricityReading(
        id: reading.id,
        houseId: mappedHouseId,
        cycleId: mappedCycleId,
        date: reading.date,
        meterReading: reading.meterReading,
        unitsConsumed: reading.unitsConsumed,
        totalCost: reading.totalCost,
        notes: reading.notes,
        createdAt: reading.createdAt,
        updatedAt: reading.updatedAt,
      );

      final existingReading = await _readingsDataSource.getReadingById(
        reading.id,
      );

      if (existingReading != null) {
        switch (mode) {
          case ImportMode.replace:
          case ImportMode.mergeOverwrite:
            await _readingsDataSource.updateReading(updatedReading);
            readingsUpdated++;
          case ImportMode.mergeSkip:
            readingsSkipped++;
        }
      } else {
        await _readingsDataSource.createReading(updatedReading);
        readingsCreated++;
      }
    }

    return ImportStats(
      housesCreated: housesCreated,
      housesUpdated: housesUpdated,
      housesSkipped: housesSkipped,
      cyclesCreated: cyclesCreated,
      cyclesUpdated: cyclesUpdated,
      cyclesSkipped: cyclesSkipped,
      readingsCreated: readingsCreated,
      readingsUpdated: readingsUpdated,
      readingsSkipped: readingsSkipped,
    );
  }

  /// Generate a filename for the export
  static String generateExportFilename() {
    final now = DateTime.now();
    final dateStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}';
    return 'electricity_tracker_backup_${dateStr}_$timeStr${EncryptedExportFile.fileExtension}';
  }
}

/// Result of export operation
class ExportResult {
  final bool isSuccess;
  final EncryptedExportFile? encryptedFile;
  final ExportSummary? summary;
  final String? errorMessage;

  const ExportResult._({
    required this.isSuccess,
    this.encryptedFile,
    this.summary,
    this.errorMessage,
  });

  factory ExportResult.success({
    required EncryptedExportFile encryptedFile,
    required ExportSummary summary,
  }) {
    return ExportResult._(
      isSuccess: true,
      encryptedFile: encryptedFile,
      summary: summary,
    );
  }

  factory ExportResult.failure(String message) {
    return ExportResult._(isSuccess: false, errorMessage: message);
  }
}

/// Summary of exported data
class ExportSummary {
  final int housesCount;
  final int cyclesCount;
  final int readingsCount;
  final DateTime exportedAt;
  final int fileSizeBytes;

  const ExportSummary({
    required this.housesCount,
    required this.cyclesCount,
    required this.readingsCount,
    required this.exportedAt,
    required this.fileSizeBytes,
  });

  String get fileSizeFormatted {
    if (fileSizeBytes < 1024) return '$fileSizeBytes B';
    if (fileSizeBytes < 1024 * 1024) {
      return '${(fileSizeBytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(fileSizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

/// Result of import operation
class ImportResult {
  final bool isSuccess;
  final ImportSummary? summary;
  final ImportStats? stats;
  final List<ValidationError> errors;

  const ImportResult._({
    required this.isSuccess,
    this.summary,
    this.stats,
    this.errors = const [],
  });

  factory ImportResult.success({
    required ImportSummary summary,
    required ImportStats stats,
  }) {
    return ImportResult._(isSuccess: true, summary: summary, stats: stats);
  }

  factory ImportResult.failure(List<ValidationError> errors) {
    return ImportResult._(isSuccess: false, errors: errors);
  }
}

/// Statistics of import operation
class ImportStats {
  final int housesCreated;
  final int housesUpdated;
  final int housesSkipped;
  final int cyclesCreated;
  final int cyclesUpdated;
  final int cyclesSkipped;
  final int readingsCreated;
  final int readingsUpdated;
  final int readingsSkipped;

  const ImportStats({
    required this.housesCreated,
    required this.housesUpdated,
    required this.housesSkipped,
    required this.cyclesCreated,
    required this.cyclesUpdated,
    required this.cyclesSkipped,
    required this.readingsCreated,
    required this.readingsUpdated,
    required this.readingsSkipped,
  });

  int get totalCreated => housesCreated + cyclesCreated + readingsCreated;
  int get totalUpdated => housesUpdated + cyclesUpdated + readingsUpdated;
  int get totalSkipped => housesSkipped + cyclesSkipped + readingsSkipped;
}

/// Progress stages for export
enum ExportStage { fetchingData, packaging, encrypting, complete }

/// Progress update for export
class ExportProgress {
  final ExportStage stage;
  final String message;
  final double progress; // 0.0 to 1.0

  const ExportProgress({
    required this.stage,
    required this.message,
    required this.progress,
  });
}

/// Progress stages for import
enum ImportStage { parsing, decrypting, validating, importing, complete }

/// Progress update for import
class ImportProgress {
  final ImportStage stage;
  final String message;
  final double progress; // 0.0 to 1.0

  const ImportProgress({
    required this.stage,
    required this.message,
    required this.progress,
  });
}
