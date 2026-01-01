// ignore_for_file: deprecated_member_use
import 'dart:convert';
import 'dart:io';
import 'package:electricity/core/providers/supabase_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:electricity/core/providers/export_import_providers.dart';
import 'package:electricity/core/utils/extensions/toast.dart';
import 'package:electricity/data/services/export/export_data_model.dart';
import 'package:path_provider/path_provider.dart';

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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Ensure a fresh export state when opening the screen
      ref.read(exportNotifierProvider.notifier).reset();
      _passphraseController.clear();
      _confirmPassphraseController.clear();
    });
  }

  @override
  void dispose() {
    _passphraseController.dispose();
    _confirmPassphraseController.dispose();
    super.dispose();
  }

  void _startExport() {
    if (_passphraseController.text.length < 8) {
      context.showWarning('Passphrase must be at least 8 characters');
      return;
    }

    if (_passphraseController.text != _confirmPassphraseController.text) {
      context.showWarning('Passphrases do not match');
      return;
    }

    context.showInfo('Exporting data...');
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
                        final result = await ref
                            .read(exportNotifierProvider.notifier)
                            .saveToFile();
                        if (result != null && mounted && context.mounted) {
                          final message = result.usedFallback
                              ? 'Saved to app documents folder: ${result.path} — use Share to save elsewhere.'
                              : 'Saved to: ${result.path}';
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(message),
                              duration: const Duration(seconds: 6),
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
                  }
                },
                icon: const Icon(Icons.copy),
                label: const Text('Copy to Clipboard'),
              ),
              const SizedBox(height: 12),
              Center(
                child: FilledButton(
                  onPressed: () {
                    // Reset export state and close screen
                    ref.read(exportNotifierProvider.notifier).reset();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Done'),
                ),
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

class _BackupItem {
  final String path;
  final String name;
  final Map<String, dynamic>? metadata;
  _BackupItem({required this.path, required this.name, this.metadata});
}

class _ImportScreenState extends ConsumerState<ImportScreen> {
  final _passphraseController = TextEditingController();
  bool _obscurePassphrase = true;
  ImportMode _selectedMode = ImportMode.mergeSkip;

  @override
  void initState() {
    super.initState();
    // Ensure any leftover import state is cleared when the screen is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(importNotifierProvider.notifier).reset();
      _passphraseController.clear();
    });
  }

  @override
  void dispose() {
    _passphraseController.dispose();
    super.dispose();
  }

  String? _selectedFilePath;
  bool _allowCrossUserImport = false;

  /// Show picker options: system file picker or scan known folders for backups
  Future<void> _pickFile() async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      builder: (c) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.folder_open),
            title: const Text('Pick from system file picker'),
            onTap: () => Navigator.of(c).pop('system'),
          ),
          ListTile(
            leading: const Icon(Icons.storage),
            title: const Text('Show backups on device'),
            onTap: () => Navigator.of(c).pop('list'),
          ),
        ],
      ),
    );

    if (choice == 'system') {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final content = await file.readAsString();
        if (content.isEmpty) {
          context.showError('Selected backup file is empty');
          return;
        }

        final ok = await _checkAndConfirmCrossUser(content);
        if (ok) {
          ref.read(importNotifierProvider.notifier).setFileContent(content);
          setState(() {
            _selectedFilePath = file.path;
          });
          if (mounted && context.mounted) {
            // File selected and stored in provider; no transient SnackBar needed
          }
        }
      }
    } else if (choice == 'list') {
      await _showBackupsList();
    }
  }

  /// Check metadata and show a confirmation dialog if the backup belongs to another user
  Future<bool> _checkAndConfirmCrossUser(String content) async {
    final metadata = _parseMetadata(content);
    final currentUser = ref.read(currentUserProvider);

    // No metadata or no logged in user -> allow
    if (metadata == null || currentUser == null) {
      return true;
    }

    final ownerId = metadata['userId'] as String?;

    // Only compare user IDs. If ownerId is missing, allow (no warning).
    if (ownerId == null) return true;

    final ownerIdNorm = ownerId.trim();
    final currentUserIdNorm = currentUser.id.trim();
    final matchesUser =
        ownerIdNorm.isNotEmpty &&
        currentUserIdNorm.isNotEmpty &&
        ownerIdNorm == currentUserIdNorm;

    if (!matchesUser) {
      final allow = await showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          title: const Text('Import from different user'),
          content: Text(
            'This backup appears to belong to ${metadata['userEmail'] ?? ownerId ?? 'another user'}.\n'
            'Importing it may mix another user\'s data into your account.\nDo you want to continue?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(c).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(c).pop(true),
              child: const Text('Import Anyway'),
            ),
          ],
        ),
      );

      if (allow == true) {
        setState(() {
          _allowCrossUserImport = true;
        });
        return true;
      }
      return false;
    }

    return true;
  }

  Map<String, dynamic>? _parseMetadata(String content) {
    try {
      final json = jsonDecode(content) as Map<String, dynamic>;
      final metadataJson = json['metadata'] as String?;
      if (metadataJson != null) {
        return jsonDecode(metadataJson) as Map<String, dynamic>;
      }
    } catch (_) {
      // ignore
    }
    return null;
  }

  Future<void> _showBackupsList() async {
    // Show progress while scanning
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => const Center(child: CircularProgressIndicator()),
    );

    final backups = await _scanForBackups();

    if (mounted) Navigator.of(context).pop(); // remove progress

    if (backups.isEmpty) {
      context.showInfo('No backups found in known folders');
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Backups found'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: backups.length,
            itemBuilder: (context, index) {
              final b = backups[index];
              final meta = b.metadata;
              return ListTile(
                leading: const Icon(Icons.insert_drive_file),
                title: Text(b.name),
                subtitle: Text(
                  'From: ${meta?['userEmail'] ?? 'Unknown'}\nDate: ${meta?['exportedAt'] ?? 'Unknown'}',
                ),
                trailing: TextButton(
                  onPressed: () async {
                    try {
                      final content = await File(b.path).readAsString();
                      final ok = await _checkAndConfirmCrossUser(content);
                      if (ok) {
                        ref
                            .read(importNotifierProvider.notifier)
                            .setFileContent(content);
                        setState(() => _selectedFilePath = b.path);
                        if (mounted) Navigator.of(context).pop();
                        // File selected and stored in provider; no transient SnackBar needed
                      }
                    } catch (e) {
                      context.showError('Failed to read file: $e');
                    }
                  },
                  child: const Text('Select'),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(c).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  /// Ensure storage permission on Android with rationale and settings fallback
  Future<bool> _ensureStoragePermission() async {
    try {
      final status = await Permission.storage.status;

      if (status.isGranted) return true;

      if (status.isPermanentlyDenied) {
        final open = await showDialog<bool>(
          context: context,
          builder: (c) => AlertDialog(
            title: const Text('Storage permission required'),
            content: const Text(
              'Storage access is required to scan your Downloads folder for backups.\nOpen app settings to grant permission?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(c).pop(false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(c).pop(true),
                child: const Text('Open Settings'),
              ),
            ],
          ),
        );
        if (open == true) await openAppSettings();
        return false;
      }

      // Show rationale before requesting
      final allow = await showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          title: const Text('Allow storage access?'),
          content: const Text(
            'To help you import backups from your device, the app needs temporary access to storage so it can scan common folders (Downloads).\nDo you want to grant access?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(c).pop(false),
              child: const Text('No'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(c).pop(true),
              child: const Text('Yes'),
            ),
          ],
        ),
      );

      if (allow != true) {
        if (mounted) {
          context.showInfo(
            'Storage permission denied - cannot scan Downloads for backups. Use system picker or copy files into app Documents.',
          );
        }
        return false;
      }

      final result = await Permission.storage.request();
      if (result.isGranted) return true;

      if (result.isPermanentlyDenied) {
        final open = await showDialog<bool>(
          context: context,
          builder: (c) => AlertDialog(
            title: const Text('Storage permission required'),
            content: const Text(
              'Permission permanently denied. Open app settings to grant access.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(c).pop(false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(c).pop(true),
                child: const Text('Open Settings'),
              ),
            ],
          ),
        );
        if (open == true) await openAppSettings();
      } else {
        if (mounted) {
          context.showInfo(
            'Storage permission denied - cannot scan Downloads for backups.',
          );
        }
      }

      return false;
    } catch (_) {
      return false;
    }
  }

  Future<List<_BackupItem>> _scanForBackups() async {
    final dirs = <Directory>{};
    try {
      final docs = await getApplicationDocumentsDirectory();
      dirs.add(docs);
    } catch (_) {}
    try {
      final temp = await getTemporaryDirectory();
      dirs.add(temp);
    } catch (_) {}
    try {
      final ext = await getExternalStorageDirectory();
      if (ext != null) dirs.add(ext);
    } catch (_) {}

    if (Platform.isAndroid) {
      try {
        final allowed = await _ensureStoragePermission();
        if (allowed) {
          final downloads = Directory('/storage/emulated/0/Download');
          if (downloads.existsSync()) dirs.add(downloads);
        }
      } catch (_) {
        // ignore
      }
    } else {
      try {
        final downloads = await getDownloadsDirectory();
        if (downloads != null) dirs.add(downloads);
      } catch (_) {}
    }

    final results = <_BackupItem>[];
    for (final d in dirs) {
      try {
        await for (final entity in d.list(
          recursive: true,
          followLinks: false,
        )) {
          if (entity is File && entity.path.toLowerCase().endsWith('.json')) {
            try {
              final content = await entity.readAsString();
              final meta = _parseMetadata(content);
              if (meta != null) {
                results.add(
                  _BackupItem(
                    path: entity.path,
                    name: entity.uri.pathSegments.last,
                    metadata: meta,
                  ),
                );
              }
            } catch (_) {
              // ignore broken files
            }
          }
        }
      } catch (_) {
        // ignore unreadable directories
      }
    }

    // Sort by name (or could sort by date if metadata has date)
    results.sort((a, b) => b.name.compareTo(a.name));
    return results;
  }

  void _previewImport() async {
    if (_passphraseController.text.isEmpty) {
      context.showError('Please enter the passphrase');
      return;
    }

    // Check cross-user confirmation before validating
    final metadata = ref.read(importNotifierProvider.notifier).parseMetadata();
    final currentUser = ref.read(currentUserProvider);
    final ownerEmail = metadata?['userEmail'] as String?;
    final ownerId = metadata?['userId'] as String?;

    // Only compare user IDs. If no ownerId is present, allow (no warning).
    final ownerIdNorm = ownerId?.trim() ?? '';
    final currentUserIdNorm = currentUser != null ? currentUser.id.trim() : '';
    final matchesUser =
        ownerIdNorm.isNotEmpty &&
        currentUserIdNorm.isNotEmpty &&
        ownerIdNorm == currentUserIdNorm;

    if (metadata != null &&
        currentUser != null &&
        ownerId != null &&
        !matchesUser &&
        !_allowCrossUserImport) {
      final allow = await showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          title: const Text('Import from different user'),
          content: Text(
            'This backup belongs to $ownerEmail.\nImporting it may mix another user\'s data into your account.\nDo you want to continue?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(c).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(c).pop(true),
              child: const Text('Continue'),
            ),
          ],
        ),
      );

      if (allow != true) return;
      setState(() => _allowCrossUserImport = true);
    }

    // Show blocking loading dialog while validating (prevents UI freeze)
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (c) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await ref
          .read(importNotifierProvider.notifier)
          .previewImport(_passphraseController.text);
    } catch (e) {
      if (mounted && context.mounted) {
        if (Navigator.canPop(context)) Navigator.of(context).pop();
        context.showError('Preview failed: $e', title: 'Validation failed');
      }
      return;
    } finally {
      if (mounted && context.mounted && Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
    }

    // Show feedback after validation completes
    if (!mounted) return;

    try {
      final importState = ref.read(importNotifierProvider);

      if (importState.validationResult?.isValid == true) {
        if (mounted && context.mounted) {
          context.showSuccess('Validation successful', title: 'File is valid');
        }
      } else if (importState.error != null) {
        if (mounted && context.mounted) {
          context.showError(importState.error!, title: 'Validation failed');
        }
      }
    } catch (e) {
      if (mounted && context.mounted) {
        context.showError('Validation failed: $e', title: 'Validation failed');
      }
    }
  }

  void _performImport() async {
    if (!context.mounted) return;

    // Double-check cross-user confirmation before importing
    final metadata = ref.read(importNotifierProvider.notifier).parseMetadata();
    final currentUser = ref.read(currentUserProvider);
    final ownerEmail = metadata?['userEmail'] as String?;
    final ownerId = metadata?['userId'] as String?;

    final ownerIdNorm = ownerId?.trim() ?? '';
    final currentUserIdNorm = currentUser != null ? currentUser.id.trim() : '';
    final matchesUser =
        ownerIdNorm.isNotEmpty &&
        currentUserIdNorm.isNotEmpty &&
        ownerIdNorm == currentUserIdNorm;

    if (metadata != null &&
        currentUser != null &&
        ownerId != null &&
        !matchesUser &&
        !_allowCrossUserImport) {
      final allow = await showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          title: const Text('Import from different user'),
          content: Text(
            'This backup belongs to $ownerEmail.\nImporting it may mix another user\'s data into your account.\nDo you want to continue?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(c).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(c).pop(true),
              child: const Text('Import Anyway'),
            ),
          ],
        ),
      );

      if (allow != true) return;
      setState(() => _allowCrossUserImport = true);
    }

    var importStateBefore = ref.read(importNotifierProvider);

    // If provider has no file content, attempt to re-read from selected path
    if ((importStateBefore.fileContent == null ||
            importStateBefore.fileContent!.isEmpty) &&
        _selectedFilePath != null) {
      try {
        final f = File(_selectedFilePath!);
        if (await f.exists()) {
          final reRead = await f.readAsString();
          if (reRead.isNotEmpty) {
            ref.read(importNotifierProvider.notifier).setFileContent(reRead);
            importStateBefore = ref.read(importNotifierProvider);
          }
        }
      } catch (_) {
        // ignore read failures silently for now
      }
    }

    // If content is still empty after attempting a re-read, abort with an error
    if (importStateBefore.fileContent == null ||
        importStateBefore.fileContent!.isEmpty) {
      if (mounted && context.mounted) {
        context.showError(
          'Selected backup file is empty or could not be read',
          title: 'Import failed',
        );
      }
      return;
    }

    context.showInfo('Importing data...');

    // Show blocking loading dialog while importing (prevents UI freeze)
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (c) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await ref
          .read(importNotifierProvider.notifier)
          .performImport(
            passphrase: _passphraseController.text,
            mode: _selectedMode,
          );
    } catch (e) {
      if (mounted && context.mounted) {
        if (Navigator.canPop(context)) Navigator.of(context).pop();
        context.showError('Import failed: $e', title: 'Import failed');
      }
      return;
    } finally {
      if (mounted && context.mounted && Navigator.canPop(context))
        Navigator.of(context).pop();
    }

    // Show feedback after import completes
    if (!mounted) return;

    final importState = ref.read(importNotifierProvider);

    if (importState.importResult?.isSuccess == true) {
      if (mounted && context.mounted) {
        context.showSuccess(
          'Data imported successfully',
          title: 'Import complete',
        );
      }
    } else if (importState.error != null) {
      if (mounted && context.mounted) {
        context.showError(importState.error!, title: 'Import failed');
      }
    }
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
                      'Import will modify your database. Make sure you have '
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
                        final pathInfo = _selectedFilePath != null
                            ? '\nPath: ${_selectedFilePath}'
                            : '';
                        return Text(
                          'From: ${metadata['userEmail'] ?? 'Unknown'}\n'
                          'Date: ${metadata['exportedAt'] ?? 'Unknown'}$pathInfo',
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
                        onPressed: () {
                          // Clear import state when finishing
                          ref.read(importNotifierProvider.notifier).reset();
                          Navigator.of(context).pop();
                        },
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
            Radio<ImportMode>.adaptive(
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
