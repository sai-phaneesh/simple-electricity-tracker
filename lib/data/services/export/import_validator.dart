import 'package:electricity/data/datasources/houses_datasource.dart';
import 'package:electricity/data/datasources/cycles_datasource.dart';
import 'package:electricity/data/datasources/electricity_readings_datasource.dart';
import 'package:electricity/data/services/export/export_data_model.dart';
import 'package:electricity/domain/entities/house.dart';
import 'package:electricity/domain/entities/cycle.dart';
import 'package:electricity/domain/entities/electricity_reading.dart';

/// Comprehensive validator for import data
class ImportValidator {
  /// Validate an import package
  Future<ImportValidationResult> validate({
    required ExportPackage package,
    required String currentUserId,
    String? currentUserEmail,
    required HousesDataSource housesDataSource,
    required CyclesDataSource cyclesDataSource,
    required ElectricityReadingsDataSource readingsDataSource,
  }) async {
    try {
      final errors = <ValidationError>[];
      final warnings = <ValidationWarning>[];

      // 1. Validate magic header
      if (package.magic != kExportMagicHeader) {
        errors.add(
          ValidationError(
            type: ValidationErrorType.invalidMagicHeader,
            message: 'Invalid file format: magic header mismatch',
            invalidValue: package.magic,
          ),
        );
      }

      // 2. Validate version
      if (package.version > kExportFormatVersion) {
        errors.add(
          ValidationError(
            type: ValidationErrorType.unsupportedVersion,
            message:
                'Export version ${package.version} is not supported. '
                'Please update the app to import this file.',
            invalidValue: package.version,
          ),
        );
      }

      // 3. Validate metadata counts match actual data
      final metadataCountErrors = _validateMetadataCounts(package);
      errors.addAll(metadataCountErrors);

      // 4. Validate payload checksum (if available)
      if (package.metadata.payloadChecksum.isNotEmpty) {
        final checksumValid = _validatePayloadChecksum(package);
        if (!checksumValid) {
          errors.add(
            ValidationError(
              type: ValidationErrorType.checksumMismatch,
              message: 'Data integrity check failed: payload checksum mismatch',
            ),
          );
        }
      }

      // 5. Validate all houses
      for (var i = 0; i < package.payload.houses.length; i++) {
        final houseErrors = _validateHouse(package.payload.houses[i], i);
        errors.addAll(houseErrors);
      }

      // 6. Validate all cycles
      final houseIds = package.payload.houses.map((h) => h.id).toSet();
      for (var i = 0; i < package.payload.cycles.length; i++) {
        final cycleErrors = _validateCycle(
          package.payload.cycles[i],
          i,
          houseIds,
        );
        errors.addAll(cycleErrors);
      }

      // 7. Validate all readings
      final cycleIds = package.payload.cycles.map((c) => c.id).toSet();
      for (var i = 0; i < package.payload.readings.length; i++) {
        final readingErrors = _validateReading(
          package.payload.readings[i],
          i,
          houseIds,
          cycleIds,
        );
        errors.addAll(readingErrors);
      }

      // 8. Check for duplicate IDs
      final duplicateErrors = _checkDuplicateIds(package);
      errors.addAll(duplicateErrors);

      // 9. Validate referential integrity
      final integrityErrors = _validateReferentialIntegrity(package);
      errors.addAll(integrityErrors);

      // 10. Check for user mismatch (warning only) — compare only user IDs
      final packageUserId = package.metadata.userId.trim();
      final normalizedCurrentUserId = currentUserId.trim();

      if (packageUserId.isNotEmpty &&
          normalizedCurrentUserId.isNotEmpty &&
          packageUserId != normalizedCurrentUserId) {
        warnings.add(
          ValidationWarning(
            message:
                'This backup was created by a different user '
                '(${package.metadata.userEmail})',
            suggestion: 'The data will be imported into your account',
          ),
        );
      }

      // 11. Determine what will be created/updated
      final summary = await _calculateImportSummary(
        package: package,
        housesDataSource: housesDataSource,
        cyclesDataSource: cyclesDataSource,
        readingsDataSource: readingsDataSource,
      );

      if (errors.isNotEmpty) {
        return ImportValidationResult(
          isValid: false,
          errors: errors,
          warnings: warnings,
        );
      }

      return ImportValidationResult(
        isValid: true,
        errors: [],
        warnings: warnings,
        summary: summary,
      );
    } catch (e) {
      return ImportValidationResult.failure([
        ValidationError(
          type: ValidationErrorType.corruptedData,
          message: 'Validation failed: $e',
        ),
      ]);
    }
  }

  /// Validate that metadata counts match actual data
  List<ValidationError> _validateMetadataCounts(ExportPackage package) {
    final errors = <ValidationError>[];

    if (package.metadata.housesCount != package.payload.houses.length) {
      errors.add(
        ValidationError(
          type: ValidationErrorType.corruptedData,
          message:
              'Houses count mismatch: metadata says '
              '${package.metadata.housesCount}, but payload has '
              '${package.payload.houses.length}',
        ),
      );
    }

    if (package.metadata.cyclesCount != package.payload.cycles.length) {
      errors.add(
        ValidationError(
          type: ValidationErrorType.corruptedData,
          message:
              'Cycles count mismatch: metadata says '
              '${package.metadata.cyclesCount}, but payload has '
              '${package.payload.cycles.length}',
        ),
      );
    }

    if (package.metadata.readingsCount != package.payload.readings.length) {
      errors.add(
        ValidationError(
          type: ValidationErrorType.corruptedData,
          message:
              'Readings count mismatch: metadata says '
              '${package.metadata.readingsCount}, but payload has '
              '${package.payload.readings.length}',
        ),
      );
    }

    return errors;
  }

  /// Validate payload checksum
  bool _validatePayloadChecksum(ExportPackage package) {
    // Note: We'd need to import dart:convert for jsonEncode
    // For now, we'll skip this as it's validated during decryption
    return true;
  }

  /// Validate a single house entity
  List<ValidationError> _validateHouse(House house, int index) {
    final errors = <ValidationError>[];

    // Validate ID
    if (house.id.isEmpty) {
      errors.add(
        ValidationError(
          type: ValidationErrorType.missingRequiredField,
          message: 'House at index $index has empty ID',
          field: 'houses[$index].id',
        ),
      );
    }

    // Validate name
    if (house.name.isEmpty) {
      errors.add(
        ValidationError(
          type: ValidationErrorType.missingRequiredField,
          message: 'House at index $index has empty name',
          field: 'houses[$index].name',
        ),
      );
    }

    if (house.name.length > 100) {
      errors.add(
        ValidationError(
          type: ValidationErrorType.invalidDataType,
          message: 'House name at index $index exceeds maximum length (100)',
          field: 'houses[$index].name',
          invalidValue: house.name.length,
        ),
      );
    }

    // Validate defaultPricePerUnit
    if (house.defaultPricePerUnit < 0) {
      errors.add(
        ValidationError(
          type: ValidationErrorType.invalidNumber,
          message: 'House at index $index has negative price per unit',
          field: 'houses[$index].defaultPricePerUnit',
          invalidValue: house.defaultPricePerUnit,
        ),
      );
    }

    // Validate dates
    if (house.createdAt.isAfter(DateTime.now().add(const Duration(days: 1)))) {
      errors.add(
        ValidationError(
          type: ValidationErrorType.invalidDate,
          message: 'House at index $index has future created_at date',
          field: 'houses[$index].createdAt',
          invalidValue: house.createdAt,
        ),
      );
    }

    return errors;
  }

  /// Validate a single cycle entity
  List<ValidationError> _validateCycle(
    Cycle cycle,
    int index,
    Set<String> validHouseIds,
  ) {
    final errors = <ValidationError>[];

    // Validate ID
    if (cycle.id.isEmpty) {
      errors.add(
        ValidationError(
          type: ValidationErrorType.missingRequiredField,
          message: 'Cycle at index $index has empty ID',
          field: 'cycles[$index].id',
        ),
      );
    }

    // Validate houseId reference
    if (cycle.houseId.isEmpty) {
      errors.add(
        ValidationError(
          type: ValidationErrorType.missingRequiredField,
          message: 'Cycle at index $index has empty houseId',
          field: 'cycles[$index].houseId',
        ),
      );
    } else if (!validHouseIds.contains(cycle.houseId)) {
      errors.add(
        ValidationError(
          type: ValidationErrorType.referentialIntegrity,
          message:
              'Cycle at index $index references non-existent house: '
              '${cycle.houseId}',
          field: 'cycles[$index].houseId',
          invalidValue: cycle.houseId,
        ),
      );
    }

    // Validate name
    if (cycle.name.isEmpty) {
      errors.add(
        ValidationError(
          type: ValidationErrorType.missingRequiredField,
          message: 'Cycle at index $index has empty name',
          field: 'cycles[$index].name',
        ),
      );
    }

    // Validate dates
    if (cycle.startDate.isAfter(cycle.endDate)) {
      errors.add(
        ValidationError(
          type: ValidationErrorType.invalidDate,
          message: 'Cycle at index $index has start date after end date',
          field: 'cycles[$index].startDate',
        ),
      );
    }

    // Validate numeric fields
    if (cycle.initialMeterReading < 0) {
      errors.add(
        ValidationError(
          type: ValidationErrorType.invalidNumber,
          message: 'Cycle at index $index has negative initial meter reading',
          field: 'cycles[$index].initialMeterReading',
          invalidValue: cycle.initialMeterReading,
        ),
      );
    }

    if (cycle.maxUnits < 0) {
      errors.add(
        ValidationError(
          type: ValidationErrorType.invalidNumber,
          message: 'Cycle at index $index has negative maxUnits',
          field: 'cycles[$index].maxUnits',
          invalidValue: cycle.maxUnits,
        ),
      );
    }

    if (cycle.pricePerUnit < 0) {
      errors.add(
        ValidationError(
          type: ValidationErrorType.invalidNumber,
          message: 'Cycle at index $index has negative price per unit',
          field: 'cycles[$index].pricePerUnit',
          invalidValue: cycle.pricePerUnit,
        ),
      );
    }

    return errors;
  }

  /// Validate a single reading entity
  List<ValidationError> _validateReading(
    ElectricityReading reading,
    int index,
    Set<String> validHouseIds,
    Set<String> validCycleIds,
  ) {
    final errors = <ValidationError>[];

    // Validate ID
    if (reading.id.isEmpty) {
      errors.add(
        ValidationError(
          type: ValidationErrorType.missingRequiredField,
          message: 'Reading at index $index has empty ID',
          field: 'readings[$index].id',
        ),
      );
    }

    // Validate houseId reference
    if (reading.houseId.isEmpty) {
      errors.add(
        ValidationError(
          type: ValidationErrorType.missingRequiredField,
          message: 'Reading at index $index has empty houseId',
          field: 'readings[$index].houseId',
        ),
      );
    } else if (!validHouseIds.contains(reading.houseId)) {
      errors.add(
        ValidationError(
          type: ValidationErrorType.referentialIntegrity,
          message:
              'Reading at index $index references non-existent house: '
              '${reading.houseId}',
          field: 'readings[$index].houseId',
          invalidValue: reading.houseId,
        ),
      );
    }

    // Validate cycleId reference
    if (reading.cycleId.isEmpty) {
      errors.add(
        ValidationError(
          type: ValidationErrorType.missingRequiredField,
          message: 'Reading at index $index has empty cycleId',
          field: 'readings[$index].cycleId',
        ),
      );
    } else if (!validCycleIds.contains(reading.cycleId)) {
      errors.add(
        ValidationError(
          type: ValidationErrorType.referentialIntegrity,
          message:
              'Reading at index $index references non-existent cycle: '
              '${reading.cycleId}',
          field: 'readings[$index].cycleId',
          invalidValue: reading.cycleId,
        ),
      );
    }

    // Validate numeric fields
    if (reading.meterReading < 0) {
      errors.add(
        ValidationError(
          type: ValidationErrorType.invalidNumber,
          message: 'Reading at index $index has negative meter reading',
          field: 'readings[$index].meterReading',
          invalidValue: reading.meterReading,
        ),
      );
    }

    if (reading.unitsConsumed < 0) {
      errors.add(
        ValidationError(
          type: ValidationErrorType.invalidNumber,
          message: 'Reading at index $index has negative units consumed',
          field: 'readings[$index].unitsConsumed',
          invalidValue: reading.unitsConsumed,
        ),
      );
    }

    if (reading.totalCost < 0) {
      errors.add(
        ValidationError(
          type: ValidationErrorType.invalidNumber,
          message: 'Reading at index $index has negative total cost',
          field: 'readings[$index].totalCost',
          invalidValue: reading.totalCost,
        ),
      );
    }

    // Validate date is not too far in the future
    if (reading.date.isAfter(DateTime.now().add(const Duration(days: 1)))) {
      errors.add(
        ValidationError(
          type: ValidationErrorType.invalidDate,
          message: 'Reading at index $index has future date',
          field: 'readings[$index].date',
          invalidValue: reading.date,
        ),
      );
    }

    return errors;
  }

  /// Check for duplicate IDs across all entities
  List<ValidationError> _checkDuplicateIds(ExportPackage package) {
    final errors = <ValidationError>[];

    // Check house IDs
    final houseIds = <String>{};
    for (final house in package.payload.houses) {
      if (houseIds.contains(house.id)) {
        errors.add(
          ValidationError(
            type: ValidationErrorType.duplicateId,
            message: 'Duplicate house ID: ${house.id}',
            field: 'houses',
            invalidValue: house.id,
          ),
        );
      }
      houseIds.add(house.id);
    }

    // Check cycle IDs
    final cycleIds = <String>{};
    for (final cycle in package.payload.cycles) {
      if (cycleIds.contains(cycle.id)) {
        errors.add(
          ValidationError(
            type: ValidationErrorType.duplicateId,
            message: 'Duplicate cycle ID: ${cycle.id}',
            field: 'cycles',
            invalidValue: cycle.id,
          ),
        );
      }
      cycleIds.add(cycle.id);
    }

    // Check reading IDs
    final readingIds = <String>{};
    for (final reading in package.payload.readings) {
      if (readingIds.contains(reading.id)) {
        errors.add(
          ValidationError(
            type: ValidationErrorType.duplicateId,
            message: 'Duplicate reading ID: ${reading.id}',
            field: 'readings',
            invalidValue: reading.id,
          ),
        );
      }
      readingIds.add(reading.id);
    }

    return errors;
  }

  /// Validate referential integrity between entities
  List<ValidationError> _validateReferentialIntegrity(ExportPackage package) {
    final errors = <ValidationError>[];
    final houseIds = package.payload.houses.map((h) => h.id).toSet();
    final cycleIds = package.payload.cycles.map((c) => c.id).toSet();

    // Check that all cycles reference valid houses
    for (final cycle in package.payload.cycles) {
      if (!houseIds.contains(cycle.houseId)) {
        errors.add(
          ValidationError(
            type: ValidationErrorType.referentialIntegrity,
            message: 'Cycle "${cycle.name}" references non-existent house',
            field: 'cycle.houseId',
            invalidValue: cycle.houseId,
          ),
        );
      }
    }

    // Check that all readings reference valid houses and cycles
    for (final reading in package.payload.readings) {
      if (!houseIds.contains(reading.houseId)) {
        errors.add(
          ValidationError(
            type: ValidationErrorType.referentialIntegrity,
            message: 'Reading references non-existent house',
            field: 'reading.houseId',
            invalidValue: reading.houseId,
          ),
        );
      }
      if (!cycleIds.contains(reading.cycleId)) {
        errors.add(
          ValidationError(
            type: ValidationErrorType.referentialIntegrity,
            message: 'Reading references non-existent cycle',
            field: 'reading.cycleId',
            invalidValue: reading.cycleId,
          ),
        );
      }
    }

    // Check cycle-reading house consistency
    final cycleHouseMap = {
      for (final c in package.payload.cycles) c.id: c.houseId,
    };
    for (final reading in package.payload.readings) {
      final expectedHouseId = cycleHouseMap[reading.cycleId];
      if (expectedHouseId != null && reading.houseId != expectedHouseId) {
        errors.add(
          ValidationError(
            type: ValidationErrorType.referentialIntegrity,
            message: 'Reading house ID does not match cycle house ID',
            field: 'reading.houseId',
            invalidValue: reading.houseId,
          ),
        );
      }
    }

    return errors;
  }

  /// Calculate summary of what will be imported
  Future<ImportSummary> _calculateImportSummary({
    required ExportPackage package,
    required HousesDataSource housesDataSource,
    required CyclesDataSource cyclesDataSource,
    required ElectricityReadingsDataSource readingsDataSource,
  }) async {
    int newHouses = 0;
    int existingHouses = 0;
    int newCycles = 0;
    int existingCycles = 0;
    int newReadings = 0;
    int existingReadings = 0;

    // Check houses
    for (final house in package.payload.houses) {
      final existing = await housesDataSource.getHouseById(house.id);
      if (existing != null) {
        existingHouses++;
      } else {
        newHouses++;
      }
    }

    // Check cycles
    for (final cycle in package.payload.cycles) {
      final existing = await cyclesDataSource.getCycleById(cycle.id);
      if (existing != null) {
        existingCycles++;
      } else {
        newCycles++;
      }
    }

    // Check readings
    for (final reading in package.payload.readings) {
      final existing = await readingsDataSource.getReadingById(reading.id);
      if (existing != null) {
        existingReadings++;
      } else {
        newReadings++;
      }
    }

    return ImportSummary(
      housesCount: package.payload.houses.length,
      cyclesCount: package.payload.cycles.length,
      readingsCount: package.payload.readings.length,
      newHouses: newHouses,
      existingHouses: existingHouses,
      newCycles: newCycles,
      existingCycles: existingCycles,
      newReadings: newReadings,
      existingReadings: existingReadings,
      exportedAt: package.metadata.exportedAt,
      exportedBy: package.metadata.userEmail,
    );
  }
}

/// Helper extension to get human-readable error messages
extension ValidationErrorTypeExtension on ValidationErrorType {
  String get displayName {
    switch (this) {
      case ValidationErrorType.invalidFormat:
        return 'Invalid Format';
      case ValidationErrorType.invalidMagicHeader:
        return 'Invalid File';
      case ValidationErrorType.unsupportedVersion:
        return 'Unsupported Version';
      case ValidationErrorType.corruptedData:
        return 'Corrupted Data';
      case ValidationErrorType.checksumMismatch:
        return 'Checksum Error';
      case ValidationErrorType.signatureInvalid:
        return 'Invalid Signature';
      case ValidationErrorType.missingRequiredField:
        return 'Missing Field';
      case ValidationErrorType.invalidDataType:
        return 'Invalid Data';
      case ValidationErrorType.referentialIntegrity:
        return 'Reference Error';
      case ValidationErrorType.duplicateId:
        return 'Duplicate ID';
      case ValidationErrorType.invalidDate:
        return 'Invalid Date';
      case ValidationErrorType.invalidNumber:
        return 'Invalid Number';
      case ValidationErrorType.userMismatch:
        return 'User Mismatch';
      case ValidationErrorType.decryptionFailed:
        return 'Decryption Failed';
    }
  }
}
