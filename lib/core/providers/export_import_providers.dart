import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:electricity/core/providers/app_providers.dart';
import 'package:electricity/core/providers/supabase_provider.dart';
import 'package:electricity/data/services/export/export_import_service.dart';
import 'package:electricity/data/services/export/export_data_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

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

  /// Save exported file
  Future<String?> saveToFile() async {
    if (state.result?.encryptedFile == null) return null;

    try {
      final directory = await getApplicationDocumentsDirectory();
      final filename = ExportImportService.generateExportFilename();
      final file = File('${directory.path}/$filename');

      final jsonContent = jsonEncode(state.result!.encryptedFile!.toJson());
      await file.writeAsString(jsonContent);

      return file.path;
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

      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'Electricity Tracker Backup',
        text: 'My Electricity Tracker data backup',
      );
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
final exportNotifierProvider = NotifierProvider<ExportNotifier, ExportState>(
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
class ImportNotifier extends Notifier<ImportState> {
  @override
  ImportState build() => const ImportState();

  /// Set file content for import
  void setFileContent(String content) {
    state = ImportState(fileContent: content);
  }

  /// Preview import without actually importing
  Future<void> previewImport(String passphrase) async {
    if (state.fileContent == null) {
      state = state.copyWith(error: 'No file content to preview');
      return;
    }

    final user = ref.read(currentUserProvider);
    if (user == null) {
      state = state.copyWith(error: 'You must be logged in to import data');
      return;
    }

    state = state.copyWith(isPreviewing: true, error: null);

    final service = ref.read(exportImportServiceProvider);
    final result = await service.previewImport(
      fileContent: state.fileContent!,
      passphrase: passphrase,
      currentUserId: user.id,
    );

    state = state.copyWith(
      isPreviewing: false,
      validationResult: result,
      error: result.isValid ? null : result.errors.first.message,
    );
  }

  /// Perform the actual import
  Future<void> performImport({
    required String passphrase,
    required ImportMode mode,
  }) async {
    if (state.fileContent == null) {
      state = state.copyWith(error: 'No file content to import');
      return;
    }

    final user = ref.read(currentUserProvider);
    if (user == null) {
      state = state.copyWith(error: 'You must be logged in to import data');
      return;
    }

    state = state.copyWith(isImporting: true, error: null);

    final service = ref.read(exportImportServiceProvider);
    final result = await service.importData(
      fileContent: state.fileContent!,
      passphrase: passphrase,
      currentUserId: user.id,
      mode: mode,
      onProgress: (progress) {
        state = state.copyWith(progress: progress);
      },
    );

    state = state.copyWith(
      isImporting: false,
      importResult: result,
      error: result.isSuccess ? null : result.errors.first.message,
    );

    // Invalidate data providers to refresh UI
    if (result.isSuccess) {
      ref.invalidate(housesStreamProvider);
      ref.invalidate(cyclesForSelectedHouseStreamProvider);
      ref.invalidate(readingsForSelectedCycleStreamProvider);
    }
  }

  /// Parse metadata from encrypted file (for preview without password)
  Map<String, dynamic>? parseMetadata() {
    if (state.fileContent == null) return null;

    try {
      final json = jsonDecode(state.fileContent!) as Map<String, dynamic>;
      final metadataJson = json['metadata'] as String?;
      if (metadataJson != null) {
        return jsonDecode(metadataJson) as Map<String, dynamic>;
      }
    } catch (e) {
      // Invalid file
    }
    return null;
  }

  /// Reset state
  void reset() {
    state = const ImportState();
  }
}

/// Provider for import notifier
final importNotifierProvider = NotifierProvider<ImportNotifier, ImportState>(
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
