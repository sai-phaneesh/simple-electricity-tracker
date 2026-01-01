import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:electricity/core/providers/app_providers.dart';
import 'package:electricity/core/providers/supabase_provider.dart';
import 'package:electricity/data/services/export/export_import_service.dart';
import 'package:electricity/data/services/export/export_data_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:electricity/data/services/export/crypto_service.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';

/// Provider for the export/import service
final exportImportServiceProvider = Provider<ExportImportService>((ref) {
  return ExportImportService(
    housesDataSource: ref.watch(housesDataSourceProvider),
    cyclesDataSource: ref.watch(cyclesDataSourceProvider),
    readingsDataSource: ref.watch(electricityReadingsDataSourceProvider),
  );
});

/// State for export operation
class ExportState {
  final bool isExporting;
  final ExportProgress? progress;
  final ExportResult? result;
  final String? error;

  const ExportState({
    this.isExporting = false,
    this.progress,
    this.result,
    this.error,
  });

  ExportState copyWith({
    bool? isExporting,
    ExportProgress? progress,
    ExportResult? result,
    String? error,
  }) {
    return ExportState(
      isExporting: isExporting ?? this.isExporting,
      progress: progress,
      result: result,
      error: error,
    );
  }
}

/// Result returned by saveToFile indicating whether a fallback was used
class SaveResult {
  final String path;
  final bool usedFallback;
  SaveResult({required this.path, this.usedFallback = false});
}

/// Notifier for export operations
class ExportNotifier extends Notifier<ExportState> {
  @override
  ExportState build() => const ExportState();

  /// Start export process
  Future<void> exportData(String passphrase) async {
    final user = ref.read(currentUserProvider);
    if (user == null) {
      state = state.copyWith(error: 'You must be logged in to export data');
      return;
    }

    state = ExportState(isExporting: true);

    final service = ref.read(exportImportServiceProvider);
    final result = await service.exportData(
      userId: user.id,
      userEmail: user.email ?? 'unknown',
      passphrase: passphrase,
      onProgress: (progress) {
        state = state.copyWith(progress: progress);
      },
    );

    state = ExportState(
      isExporting: false,
      result: result,
      error: result.isSuccess ? null : result.errorMessage,
    );
  }

  /// Save exported file by asking the user where to save using a system save dialog.
  /// Falls back to application documents directory if the user cancels or if the dialog fails.
  Future<SaveResult?> saveToFile() async {
    if (state.result?.encryptedFile == null) return null;

    final filename = ExportImportService.generateExportFilename();
    final jsonContent = jsonEncode(state.result!.encryptedFile!.toJson());

    try {
      // 1) Prepare a temp file with the content
      final tmpDir = await getTemporaryDirectory();
      final tempFile = File('${tmpDir.path}/$filename');
      await tempFile.writeAsString(jsonContent);

      // 2) Try native "Save As" using flutter_file_dialog (mobile-first)
      try {
        final params = SaveFileDialogParams(
          sourceFilePath: tempFile.path,
          fileName: filename,
        );
        final String? savedPath = await FlutterFileDialog.saveFile(
          params: params,
        );
        if (savedPath != null && savedPath.isNotEmpty) {
          // Clean up temp file if the plugin copied it
          try {
            if (await tempFile.exists() && tempFile.path != savedPath) {
              await tempFile.delete();
            }
          } catch (_) {}
          return SaveResult(path: savedPath, usedFallback: false);
        }
      } catch (e) {
        // Native Save As failed or not supported — continue to next fallback
      }

      // 3) Try folder pick (desktop / fallback)
      try {
        final String? directoryPath = await FilePicker.platform
            .getDirectoryPath();
        if (directoryPath != null && directoryPath.isNotEmpty) {
          final file = File('$directoryPath/$filename');
          await file.writeAsString(jsonContent);
          // Clean up temp file
          try {
            if (await tempFile.exists()) await tempFile.delete();
          } catch (_) {}
          return SaveResult(path: file.path, usedFallback: false);
        }
      } catch (e) {
        // Directory picker failed or not supported — fall through to fallback
      }

      // 4) Final fallback: save to application documents directory
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$filename');
      await file.writeAsString(jsonContent);
      // Clean up temp file
      try {
        if (await tempFile.exists()) await tempFile.delete();
      } catch (_) {}
      return SaveResult(path: file.path, usedFallback: true);
    } catch (e) {
      state = state.copyWith(error: 'Failed to save file: $e');
      return null;
    }
  }

  /// Share exported file
  Future<void> shareFile() async {
    if (state.result?.encryptedFile == null) return;

    try {
      final directory = await getTemporaryDirectory();
      final filename = ExportImportService.generateExportFilename();
      final file = File('${directory.path}/$filename');

      final jsonContent = jsonEncode(state.result!.encryptedFile!.toJson());
      await file.writeAsString(jsonContent);

      try {
        await SharePlus.instance.share(
          ShareParams(
            // text: 'Here is my Electricity Tracker data backup.',
            subject: 'Electricity Tracker Backup',
            files: [XFile(file.path)],
          ),
        );
      } finally {
        // Clean up temp file
        try {
          if (await file.exists()) await file.delete();
        } catch (_) {}
      }
    } catch (e) {
      state = state.copyWith(error: 'Failed to share file: $e');
    }
  }

  /// Get export file content as string (for clipboard)
  String? getExportContent() {
    if (state.result?.encryptedFile == null) return null;
    return jsonEncode(state.result!.encryptedFile!.toJson());
  }

  /// Reset state
  void reset() {
    state = const ExportState();
  }
}

/// Provider for export notifier
final exportNotifierProvider =
    NotifierProvider.autoDispose<ExportNotifier, ExportState>(
      ExportNotifier.new,
    );

/// State for import operation
class ImportState {
  final bool isImporting;
  final bool isPreviewing;
  final ImportProgress? progress;
  final ImportValidationResult? validationResult;
  final ImportResult? importResult;
  final String? error;
  final String? fileContent;

  const ImportState({
    this.isImporting = false,
    this.isPreviewing = false,
    this.progress,
    this.validationResult,
    this.importResult,
    this.error,
    this.fileContent,
  });

  ImportState copyWith({
    bool? isImporting,
    bool? isPreviewing,
    ImportProgress? progress,
    ImportValidationResult? validationResult,
    ImportResult? importResult,
    String? error,
    String? fileContent,
  }) {
    return ImportState(
      isImporting: isImporting ?? this.isImporting,
      isPreviewing: isPreviewing ?? this.isPreviewing,
      progress: progress,
      validationResult: validationResult,
      importResult: importResult,
      error: error,
      fileContent: fileContent,
    );
  }
}

/// Notifier for import operations

/// Helper used with compute() to decrypt EncryptedData in a background isolate.
/// Must be a top-level function to be spawned in an isolate.
String? _decryptEncryptedDataForCompute(Map<String, String> args) {
  final encrypted = EncryptedData(
    salt: args['salt']!,
    iv: args['iv']!,
    ciphertext: args['ciphertext']!,
    hmac: args['hmac']!,
  );
  return ExportCryptoService.decrypt(encrypted, args['passphrase'] ?? '');
}

class ImportNotifier extends Notifier<ImportState> {
  @override
  ImportState build() => const ImportState();

  /// Set file content for import
  void setFileContent(String content) {
    if (content.isEmpty) {
      state = state.copyWith(
        error: 'Selected file is empty',
        fileContent: null,
      );
      return;
    }
    state = ImportState(fileContent: content);
  }

  /// Preview import without actually importing
  Future<void> previewImport(String passphrase) async {
    final fileContent = state.fileContent;
    if (fileContent == null || fileContent.isEmpty) {
      state = state.copyWith(error: 'No file content to preview');
      return;
    }

    final user = ref.read(currentUserProvider);
    if (user == null) {
      state = state.copyWith(error: 'You must be logged in to import data');
      return;
    }

    state = state.copyWith(isPreviewing: true, error: null);

    try {
      final service = ref.read(exportImportServiceProvider);
      final result = await service.previewImport(
        fileContent: fileContent,
        passphrase: passphrase,
        currentUserId: user.id,
        currentUserEmail: user.email,
      );

      state = state.copyWith(
        isPreviewing: false,
        validationResult: result,
        error: result.isValid
            ? null
            : (result.errors.isNotEmpty
                  ? result.errors.first.message
                  : 'Unknown validation error'),
      );
    } catch (e) {
      state = state.copyWith(
        isPreviewing: false,
        error: 'Failed to preview import: $e',
      );
    }
  }

  /// Perform the actual import
  Future<void> performImport({
    required String passphrase,
    required ImportMode mode,
  }) async {
    final fileContent = state.fileContent;
    if (fileContent == null || fileContent.isEmpty) {
      state = state.copyWith(error: 'No file content to import');
      return;
    }

    final user = ref.read(currentUserProvider);
    if (user == null) {
      state = state.copyWith(error: 'You must be logged in to import data');
      return;
    }

    state = state.copyWith(isImporting: true, error: null);

    try {
      final service = ref.read(exportImportServiceProvider);
      final result = await service.importData(
        fileContent: fileContent,
        passphrase: passphrase,
        currentUserId: user.id,
        currentUserEmail: user.email,
        mode: mode,
        onProgress: (progress) {
          state = state.copyWith(progress: progress);
        },
      );

      state = state.copyWith(
        isImporting: false,
        importResult: result,
        error: result.isSuccess
            ? null
            : (result.errors.isNotEmpty
                  ? result.errors.first.message
                  : 'Unknown import error'),
      );

      // Invalidate data providers to refresh UI
      if (result.isSuccess) {
        ref.invalidate(housesStreamProvider);
        ref.invalidate(cyclesForSelectedHouseStreamProvider);
        ref.invalidate(readingsForSelectedCycleStreamProvider);
      }
    } catch (e) {
      state = state.copyWith(isImporting: false, error: 'Failed to import: $e');
    }
  }

  /// Parse metadata from encrypted file (for preview without password).
  ///
  /// Note: metadata is now stored inside the encrypted payload. If the file
  /// contains top-level unencrypted `metadata` (older exports), this function
  /// will return it. For newer encrypted-only files you should call
  /// [parseMetadataWithPassphrase] with the passphrase to decrypt and view
  /// metadata.
  Map<String, dynamic>? parseMetadata() {
    if (state.fileContent == null) return null;

    try {
      final json = jsonDecode(state.fileContent!) as Map<String, dynamic>;
      // Backwards-compatible: older files had a top-level 'metadata' string
      final metadataJson = json['metadata'] as String?;
      if (metadataJson != null) {
        return jsonDecode(metadataJson) as Map<String, dynamic>;
      }
    } catch (e) {
      // Invalid file
    }
    return null;
  }

  /// Attempt to decrypt the package with the provided passphrase and return
  /// the internal metadata (if decryption succeeds). This allows previewing
  /// owner/date even when metadata is encrypted.
  Future<Map<String, dynamic>?> parseMetadataWithPassphrase(
    String passphrase,
  ) async {
    if (state.fileContent == null) return null;

    try {
      final json = jsonDecode(state.fileContent!) as Map<String, dynamic>;
      final encryptedFile = EncryptedExportFile.fromJson(json);
      final decrypted = ExportCryptoService.decrypt(
        encryptedFile.encryptedPayload,
        passphrase,
      );
      if (decrypted == null) return null;

      final packageJson = jsonDecode(decrypted) as Map<String, dynamic>;
      final metadata = packageJson['metadata'] as Map<String, dynamic>?;
      return metadata;
    } catch (e) {
      return null;
    }
  }

  /// Attempt to decrypt the package with the provided passphrase in a background
  /// isolate and return the internal metadata (if decryption succeeds).
  Future<Map<String, dynamic>?> parseMetadataWithPassphraseInBackground(
    String passphrase,
  ) async {
    if (state.fileContent == null) return null;

    try {
      final json = jsonDecode(state.fileContent!) as Map<String, dynamic>;
      final encryptedFile = EncryptedExportFile.fromJson(json);

      final decrypted = await compute(_decryptEncryptedDataForCompute, {
        'salt': encryptedFile.encryptedPayload.salt,
        'iv': encryptedFile.encryptedPayload.iv,
        'ciphertext': encryptedFile.encryptedPayload.ciphertext,
        'hmac': encryptedFile.encryptedPayload.hmac,
        'passphrase': passphrase,
      });

      if (decrypted == null) return null;

      final packageJson = jsonDecode(decrypted) as Map<String, dynamic>;
      final metadata = packageJson['metadata'] as Map<String, dynamic>?;
      return metadata;
    } catch (e) {
      return null;
    }
  }

  /// Reset state
  void reset() {
    state = const ImportState();
  }
}

/// Provider for import notifier
final importNotifierProvider =
    NotifierProvider.autoDispose<ImportNotifier, ImportState>(
      ImportNotifier.new,
    );

/// Extension for easy access to validation error messages
extension ImportStateExtension on ImportState {
  bool get hasValidationErrors =>
      validationResult != null && !validationResult!.isValid;

  bool get hasWarnings =>
      validationResult != null && validationResult!.warnings.isNotEmpty;

  bool get canImport =>
      validationResult != null && validationResult!.isValid && !isImporting;

  List<String> get errorMessages =>
      validationResult?.errors.map((e) => e.message).toList() ?? [];

  List<String> get warningMessages =>
      validationResult?.warnings.map((w) => w.message).toList() ?? [];
}
