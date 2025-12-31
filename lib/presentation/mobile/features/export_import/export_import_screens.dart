import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:electricity/core/providers/export_import_providers.dart';
import 'package:electricity/data/services/export/export_data_model.dart';

/// Export screen with progress and file sharing options
class ExportScreen extends ConsumerStatefulWidget {
  const ExportScreen({super.key});

  @override
  ConsumerState<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends ConsumerState<ExportScreen> {
  final _passphraseController = TextEditingController();
  final _confirmPassphraseController = TextEditingController();
  bool _obscurePassphrase = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _passphraseController.dispose();
    _confirmPassphraseController.dispose();
    super.dispose();
  }

  void _startExport() {
    if (_passphraseController.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passphrase must be at least 8 characters'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_passphraseController.text != _confirmPassphraseController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passphrases do not match'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    ref
        .read(exportNotifierProvider.notifier)
        .exportData(_passphraseController.text);
  }

  @override
  Widget build(BuildContext context) {
    final exportState = ref.watch(exportNotifierProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Export Data'),
        actions: [
          if (exportState.result?.isSuccess == true)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                ref.read(exportNotifierProvider.notifier).reset();
                _passphraseController.clear();
                _confirmPassphraseController.clear();
              },
              tooltip: 'Start Over',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Info card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'About Export',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Your data will be encrypted with a passphrase you choose. '
                      'Keep this passphrase safe - you will need it to import the data.',
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '• All houses, cycles, and readings will be exported\n'
                      '• File is encrypted for security\n'
                      '• HMAC signature ensures data integrity',
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Show passphrase form if not started
            if (!exportState.isExporting && exportState.result == null) ...[
              Text('Encryption Passphrase', style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              TextFormField(
                controller: _passphraseController,
                obscureText: _obscurePassphrase,
                decoration: InputDecoration(
                  hintText: 'Enter passphrase (min 8 characters)',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassphrase
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassphrase = !_obscurePassphrase);
                    },
                  ),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPassphraseController,
                obscureText: _obscureConfirm,
                decoration: InputDecoration(
                  hintText: 'Confirm passphrase',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirm
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      setState(() => _obscureConfirm = !_obscureConfirm);
                    },
                  ),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _startExport,
                icon: const Icon(Icons.upload_file),
                label: const Text('Start Export'),
              ),
            ],

            // Progress indicator
            if (exportState.isExporting) ...[
              const SizedBox(height: 32),
              Center(
                child: Column(
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(exportState.progress?.message ?? 'Exporting...'),
                    if (exportState.progress != null) ...[
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: exportState.progress!.progress,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${(exportState.progress!.progress * 100).toStringAsFixed(0)}%',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
            ],

            // Error message
            if (exportState.error != null) ...[
              const SizedBox(height: 16),
              Card(
                color: theme.colorScheme.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: theme.colorScheme.error),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          exportState.error!,
                          style: TextStyle(
                            color: theme.colorScheme.onErrorContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            // Success - show export options
            if (exportState.result?.isSuccess == true) ...[
              const SizedBox(height: 16),
              Card(
                color: theme.colorScheme.primaryContainer.withValues(
                  alpha: 0.3,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green[700]),
                          const SizedBox(width: 8),
                          Text(
                            'Export Complete!',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildSummaryRow(
                        'Houses',
                        exportState.result!.summary!.housesCount.toString(),
                      ),
                      _buildSummaryRow(
                        'Cycles',
                        exportState.result!.summary!.cyclesCount.toString(),
                      ),
                      _buildSummaryRow(
                        'Readings',
                        exportState.result!.summary!.readingsCount.toString(),
                      ),
                      const Divider(height: 24),
                      _buildSummaryRow(
                        'File Size',
                        exportState.result!.summary!.fileSizeFormatted,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Save or Share Your Backup',
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final path = await ref
                            .read(exportNotifierProvider.notifier)
                            .saveToFile();
                        if (path != null && mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Saved to: $path'),
                              duration: const Duration(seconds: 5),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.save_alt),
                      label: const Text('Save File'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () {
                        ref.read(exportNotifierProvider.notifier).shareFile();
                      },
                      icon: const Icon(Icons.share),
                      label: const Text('Share'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () async {
                  final content = ref
                      .read(exportNotifierProvider.notifier)
                      .getExportContent();
                  if (content != null) {
                    await Clipboard.setData(ClipboardData(text: content));
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Copied to clipboard')),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.copy),
                label: const Text('Copy to Clipboard'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

/// Import screen with file picker, validation preview, and import options
class ImportScreen extends ConsumerStatefulWidget {
  const ImportScreen({super.key});

  @override
  ConsumerState<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends ConsumerState<ImportScreen> {
  final _passphraseController = TextEditingController();
  bool _obscurePassphrase = true;
  ImportMode _selectedMode = ImportMode.mergeSkip;

  @override
  void dispose() {
    _passphraseController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final content = await file.readAsString();
      ref.read(importNotifierProvider.notifier).setFileContent(content);
    }
  }

  void _previewImport() {
    if (_passphraseController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the passphrase'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    ref
        .read(importNotifierProvider.notifier)
        .previewImport(_passphraseController.text);
  }

  void _performImport() {
    ref
        .read(importNotifierProvider.notifier)
        .performImport(
          passphrase: _passphraseController.text,
          mode: _selectedMode,
        );
  }

  @override
  Widget build(BuildContext context) {
    final importState = ref.watch(importNotifierProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Import Data'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(importNotifierProvider.notifier).reset();
              _passphraseController.clear();
            },
            tooltip: 'Start Over',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Warning card
            Card(
              color: theme.colorScheme.errorContainer.withValues(alpha: 0.3),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.warning_amber,
                          color: theme.colorScheme.error,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Important',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.error,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Import will modify your Supabase database. Make sure you have '
                      'a backup of your current data if needed. Choose the import mode carefully.',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Step 1: Select file
            _buildStepHeader(
              '1',
              'Select Backup File',
              importState.fileContent != null,
            ),
            const SizedBox(height: 8),
            if (importState.fileContent == null)
              OutlinedButton.icon(
                onPressed: _pickFile,
                icon: const Icon(Icons.file_open),
                label: const Text('Choose File'),
              )
            else ...[
              Card(
                child: ListTile(
                  leading: const Icon(Icons.insert_drive_file),
                  title: const Text('File Selected'),
                  subtitle: Builder(
                    builder: (context) {
                      final metadata = ref
                          .read(importNotifierProvider.notifier)
                          .parseMetadata();
                      if (metadata != null) {
                        return Text(
                          'From: ${metadata['userEmail'] ?? 'Unknown'}\n'
                          'Date: ${metadata['exportedAt'] ?? 'Unknown'}',
                        );
                      }
                      return const Text('Ready to validate');
                    },
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      ref.read(importNotifierProvider.notifier).reset();
                    },
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),

            // Step 2: Enter passphrase and validate
            _buildStepHeader(
              '2',
              'Validate Backup',
              importState.validationResult?.isValid == true,
            ),
            const SizedBox(height: 8),
            if (importState.fileContent != null) ...[
              TextFormField(
                controller: _passphraseController,
                obscureText: _obscurePassphrase,
                decoration: InputDecoration(
                  hintText: 'Enter backup passphrase',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassphrase
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassphrase = !_obscurePassphrase);
                    },
                  ),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: importState.isPreviewing ? null : _previewImport,
                icon: importState.isPreviewing
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.check_circle_outline),
                label: Text(
                  importState.isPreviewing ? 'Validating...' : 'Validate',
                ),
              ),
            ],

            // Validation errors
            if (importState.hasValidationErrors) ...[
              const SizedBox(height: 16),
              Card(
                color: theme.colorScheme.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.error, color: theme.colorScheme.error),
                          const SizedBox(width: 8),
                          Text(
                            'Validation Failed',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onErrorContainer,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...importState.errorMessages.map(
                        (msg) => Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('• '),
                              Expanded(
                                child: Text(
                                  msg,
                                  style: TextStyle(
                                    color: theme.colorScheme.onErrorContainer,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            // Validation warnings
            if (importState.hasWarnings) ...[
              const SizedBox(height: 16),
              Card(
                color: Colors.orange.withValues(alpha: 0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.warning, color: Colors.orange),
                          SizedBox(width: 8),
                          Text(
                            'Warnings',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...importState.warningMessages.map(
                        (msg) => Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('• '),
                              Expanded(child: Text(msg)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            // Validation success - show summary
            if (importState.validationResult?.isValid == true) ...[
              const SizedBox(height: 16),
              Card(
                color: Colors.green.withValues(alpha: 0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green[700]),
                          const SizedBox(width: 8),
                          const Text(
                            'Validation Passed',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildSummaryRow(
                        'Houses',
                        importState.validationResult!.summary!.housesCount
                            .toString(),
                      ),
                      _buildSummaryRow(
                        'Cycles',
                        importState.validationResult!.summary!.cyclesCount
                            .toString(),
                      ),
                      _buildSummaryRow(
                        'Readings',
                        importState.validationResult!.summary!.readingsCount
                            .toString(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),

            // Step 3: Choose import mode and import
            if (importState.canImport) ...[
              _buildStepHeader(
                '3',
                'Import Data',
                importState.importResult?.isSuccess == true,
              ),
              const SizedBox(height: 12),

              // Import mode selection
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Import Mode', style: theme.textTheme.titleSmall),
                      const SizedBox(height: 8),
                      _buildImportModeOption(
                        title: 'Replace All',
                        subtitle: 'Delete existing data and import backup',
                        value: ImportMode.replace,
                        theme: theme,
                      ),
                      _buildImportModeOption(
                        title: 'Merge (Skip Conflicts)',
                        subtitle: 'Add new data, keep existing on conflict',
                        value: ImportMode.mergeSkip,
                        theme: theme,
                      ),
                      _buildImportModeOption(
                        title: 'Merge (Overwrite)',
                        subtitle:
                            'Add new data, overwrite existing on conflict',
                        value: ImportMode.mergeOverwrite,
                        theme: theme,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              if (_selectedMode == ImportMode.replace)
                Card(
                  color: theme.colorScheme.errorContainer.withValues(
                    alpha: 0.5,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning,
                          color: theme.colorScheme.error,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Replace mode will DELETE all existing data!',
                            style: TextStyle(
                              color: theme.colorScheme.error,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),

              FilledButton.icon(
                onPressed: importState.isImporting ? null : _performImport,
                style: FilledButton.styleFrom(
                  backgroundColor: _selectedMode == ImportMode.replace
                      ? theme.colorScheme.error
                      : null,
                ),
                icon: importState.isImporting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.download),
                label: Text(
                  importState.isImporting ? 'Importing...' : 'Import Data',
                ),
              ),
            ],

            // Import progress
            if (importState.isImporting && importState.progress != null) ...[
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(importState.progress!.message),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: importState.progress!.progress,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${(importState.progress!.progress * 100).toStringAsFixed(0)}%',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ],

            // Import success
            if (importState.importResult?.isSuccess == true) ...[
              const SizedBox(height: 16),
              Card(
                color: Colors.green.withValues(alpha: 0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green[700],
                        size: 48,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Import Successful!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Created: ${importState.importResult!.stats?.totalCreated ?? 0}, '
                        'Updated: ${importState.importResult!.stats?.totalUpdated ?? 0}, '
                        'Skipped: ${importState.importResult!.stats?.totalSkipped ?? 0}',
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Done'),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            // Import error
            if (importState.importResult != null &&
                !importState.importResult!.isSuccess) ...[
              const SizedBox(height: 16),
              Card(
                color: theme.colorScheme.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.error, color: theme.colorScheme.error),
                          const SizedBox(width: 8),
                          Text(
                            'Import Failed',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onErrorContainer,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...importState.importResult!.errors.map(
                        (e) => Text(
                          '• ${e.message}',
                          style: TextStyle(
                            color: theme.colorScheme.onErrorContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStepHeader(String step, String title, bool completed) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: completed ? Colors.green : theme.colorScheme.primary,
          ),
          child: Center(
            child: completed
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : Text(
                    step,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildImportModeOption({
    required String title,
    required String subtitle,
    required ImportMode value,
    required ThemeData theme,
  }) {
    final isSelected = _selectedMode == value;
    return InkWell(
      onTap: () => setState(() => _selectedMode = value),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Radio<ImportMode>(
              value: value,
              groupValue: _selectedMode,
              onChanged: (v) => setState(() => _selectedMode = v!),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
