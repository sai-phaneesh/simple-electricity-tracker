import 'package:equatable/equatable.dart';
import 'package:electricity/domain/entities/house.dart';
import 'package:electricity/domain/entities/cycle.dart';
import 'package:electricity/domain/entities/electricity_reading.dart';

/// Version of the export format - increment when breaking changes are made
const int kExportFormatVersion = 1;

/// Magic bytes to identify the file format
const String kExportMagicHeader = 'ELEC_TRACKER_EXPORT';

/// Represents the complete export package structure
class ExportPackage extends Equatable {
  /// Magic header to identify file format
  final String magic;

  /// Version of the export format
  final int version;

  /// Metadata about the export
  final ExportMetadata metadata;

  /// The actual data payload (encrypted in file)
  final ExportPayload payload;

  /// HMAC signature for integrity verification
  final String signature;

  const ExportPackage({
    required this.magic,
    required this.version,
    required this.metadata,
    required this.payload,
    required this.signature,
  });

  @override
  List<Object?> get props => [magic, version, metadata, payload, signature];

  /// Create a new export package with current timestamp
  factory ExportPackage.create({
    required ExportPayload payload,
    required String signature,
    required String userId,
    required String userEmail,
  }) {
    return ExportPackage(
      magic: kExportMagicHeader,
      version: kExportFormatVersion,
      metadata: ExportMetadata.create(
        userId: userId,
        userEmail: userEmail,
        housesCount: payload.houses.length,
        cyclesCount: payload.cycles.length,
        readingsCount: payload.readings.length,
      ),
      payload: payload,
      signature: signature,
    );
  }

  /// Serialize to JSON (without encryption - for internal use)
  Map<String, dynamic> toJson() {
    return {
      'magic': magic,
      'version': version,
      'metadata': metadata.toJson(),
      'payload': payload.toJson(),
      'signature': signature,
    };
  }

  /// Deserialize from JSON (after decryption)
  factory ExportPackage.fromJson(Map<String, dynamic> json) {
    return ExportPackage(
      magic: json['magic'] as String,
      version: json['version'] as int,
      metadata: ExportMetadata.fromJson(
        json['metadata'] as Map<String, dynamic>,
      ),
      payload: ExportPayload.fromJson(json['payload'] as Map<String, dynamic>),
      signature: json['signature'] as String,
    );
  }
}

/// Metadata about the export
class ExportMetadata extends Equatable {
  /// When the export was created
  final DateTime exportedAt;

  /// User ID who created the export
  final String userId;

  /// User email for reference
  final String userEmail;

  /// App version that created the export
  final String appVersion;

  /// Platform the export was created on
  final String platform;

  /// Summary counts for quick validation
  final int housesCount;
  final int cyclesCount;
  final int readingsCount;

  /// Checksum of the payload data
  final String payloadChecksum;

  const ExportMetadata({
    required this.exportedAt,
    required this.userId,
    required this.userEmail,
    required this.appVersion,
    required this.platform,
    required this.housesCount,
    required this.cyclesCount,
    required this.readingsCount,
    required this.payloadChecksum,
  });

  @override
  List<Object?> get props => [
    exportedAt,
    userId,
    userEmail,
    appVersion,
    platform,
    housesCount,
    cyclesCount,
    readingsCount,
    payloadChecksum,
  ];

  factory ExportMetadata.create({
    required String userId,
    required String userEmail,
    required int housesCount,
    required int cyclesCount,
    required int readingsCount,
    String? payloadChecksum,
  }) {
    return ExportMetadata(
      exportedAt: DateTime.now().toUtc(),
      userId: userId,
      userEmail: userEmail,
      appVersion: '2.0.0', // TODO: Get from package_info_plus
      platform: _getPlatform(),
      housesCount: housesCount,
      cyclesCount: cyclesCount,
      readingsCount: readingsCount,
      payloadChecksum: payloadChecksum ?? '',
    );
  }

  ExportMetadata copyWith({String? payloadChecksum}) {
    return ExportMetadata(
      exportedAt: exportedAt,
      userId: userId,
      userEmail: userEmail,
      appVersion: appVersion,
      platform: platform,
      housesCount: housesCount,
      cyclesCount: cyclesCount,
      readingsCount: readingsCount,
      payloadChecksum: payloadChecksum ?? this.payloadChecksum,
    );
  }

  static String _getPlatform() {
    // Will be determined at runtime
    return 'unknown';
  }

  Map<String, dynamic> toJson() {
    return {
      'exported_at': exportedAt.toIso8601String(),
      'user_id': userId,
      'user_email': userEmail,
      'app_version': appVersion,
      'platform': platform,
      'houses_count': housesCount,
      'cycles_count': cyclesCount,
      'readings_count': readingsCount,
      'payload_checksum': payloadChecksum,
    };
  }

  factory ExportMetadata.fromJson(Map<String, dynamic> json) {
    return ExportMetadata(
      exportedAt: DateTime.parse(json['exported_at'] as String),
      userId: json['user_id'] as String,
      userEmail: json['user_email'] as String,
      appVersion: json['app_version'] as String,
      platform: json['platform'] as String,
      housesCount: json['houses_count'] as int,
      cyclesCount: json['cycles_count'] as int,
      readingsCount: json['readings_count'] as int,
      payloadChecksum: json['payload_checksum'] as String,
    );
  }
}

/// The actual data payload
class ExportPayload extends Equatable {
  final List<House> houses;
  final List<Cycle> cycles;
  final List<ElectricityReading> readings;

  const ExportPayload({
    required this.houses,
    required this.cycles,
    required this.readings,
  });

  @override
  List<Object?> get props => [houses, cycles, readings];

  bool get isEmpty => houses.isEmpty && cycles.isEmpty && readings.isEmpty;

  Map<String, dynamic> toJson() {
    return {
      'houses': houses.map((h) => h.toJson()).toList(),
      'cycles': cycles.map((c) => c.toJson()).toList(),
      'readings': readings.map((r) => r.toJson()).toList(),
    };
  }

  factory ExportPayload.fromJson(Map<String, dynamic> json) {
    return ExportPayload(
      houses: (json['houses'] as List<dynamic>)
          .map((h) => House.fromJson(h as Map<String, dynamic>))
          .toList(),
      cycles: (json['cycles'] as List<dynamic>)
          .map((c) => Cycle.fromJson(c as Map<String, dynamic>))
          .toList(),
      readings: (json['readings'] as List<dynamic>)
          .map((r) => ElectricityReading.fromJson(r as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// Result of import validation
class ImportValidationResult {
  final bool isValid;
  final List<ValidationError> errors;
  final List<ValidationWarning> warnings;
  final ImportSummary? summary;

  const ImportValidationResult({
    required this.isValid,
    required this.errors,
    required this.warnings,
    this.summary,
  });

  factory ImportValidationResult.success(ImportSummary summary) {
    return ImportValidationResult(
      isValid: true,
      errors: const [],
      warnings: const [],
      summary: summary,
    );
  }

  factory ImportValidationResult.failure(List<ValidationError> errors) {
    return ImportValidationResult(
      isValid: false,
      errors: errors,
      warnings: const [],
    );
  }
}

/// Validation error details
class ValidationError {
  final ValidationErrorType type;
  final String message;
  final String? field;
  final dynamic invalidValue;

  const ValidationError({
    required this.type,
    required this.message,
    this.field,
    this.invalidValue,
  });
}

enum ValidationErrorType {
  invalidFormat,
  invalidMagicHeader,
  unsupportedVersion,
  corruptedData,
  checksumMismatch,
  signatureInvalid,
  missingRequiredField,
  invalidDataType,
  referentialIntegrity,
  duplicateId,
  invalidDate,
  invalidNumber,
  userMismatch,
  decryptionFailed,
}

/// Validation warning (non-blocking issues)
class ValidationWarning {
  final String message;
  final String? suggestion;

  const ValidationWarning({required this.message, this.suggestion});
}

/// Summary of what will be imported
class ImportSummary {
  final int housesCount;
  final int cyclesCount;
  final int readingsCount;
  final int newHouses;
  final int existingHouses;
  final int newCycles;
  final int existingCycles;
  final int newReadings;
  final int existingReadings;
  final DateTime exportedAt;
  final String exportedBy;

  const ImportSummary({
    required this.housesCount,
    required this.cyclesCount,
    required this.readingsCount,
    required this.newHouses,
    required this.existingHouses,
    required this.newCycles,
    required this.existingCycles,
    required this.newReadings,
    required this.existingReadings,
    required this.exportedAt,
    required this.exportedBy,
  });
}

/// Import mode options
enum ImportMode {
  /// Replace all existing data with imported data
  replace,

  /// Merge with existing data (skip duplicates)
  mergeSkip,

  /// Merge with existing data (overwrite duplicates)
  mergeOverwrite,
}
