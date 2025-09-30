import 'package:electricity/core/providers/app_providers.dart';
import 'package:electricity/core/providers/backup_providers.dart';
import 'package:electricity/manager/backup_service.dart';
import 'package:electricity/presentation/shared/widgets/app_drawer.dart';
import 'package:electricity/presentation/shared/widgets/theme_handler_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _isBackingUp = false;
  bool _isRestoring = false;

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    final backupMetadataAsync = ref.watch(_backupMetadataProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const ThemeHandlerListTile(),
            const AboutTile(),
            const Divider(height: 32),
            Text(
              'Backup & Restore',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (currentUser == null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.cloud_off,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Sign in to enable backup',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Backup your data to the cloud and restore it on any device.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () => _showAuthDialog(context),
                          icon: const Icon(Icons.login),
                          label: const Text('Sign In'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.cloud_done,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Signed in',
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                Text(
                                  currentUser.email ?? 'No email',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: _signOut,
                            child: const Text('Sign Out'),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: _isBackingUp ? null : _performBackup,
                          icon: _isBackingUp
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.cloud_upload),
                          label: Text(
                            _isBackingUp ? 'Backing up...' : 'Backup Now',
                          ),
                        ),
                      ),
                      backupMetadataAsync.when(
                        data: (metadata) {
                          if (metadata == null) return const SizedBox.shrink();
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              'Last backup: ${_formatDateTime(metadata.createdAt)}\n${metadata.housesCount} houses, ${metadata.cyclesCount} cycles, ${metadata.readingsCount} readings',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          );
                        },
                        loading: () => const SizedBox.shrink(),
                        error: (_, _) => const SizedBox.shrink(),
                      ),
                      // Pending backup indicator
                      _PendingBackupIndicator(),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _isRestoring ? null : _performRestore,
                          icon: _isRestoring
                              ? SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                )
                              : const Icon(Icons.cloud_download),
                          label: Text(
                            _isRestoring ? 'Restoring...' : 'Restore Data',
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

  Future<void> _showAuthDialog(BuildContext context) async {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    var isSignUp = false;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(isSignUp ? 'Sign Up' : 'Sign In'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                try {
                  if (isSignUp) {
                    await ref
                        .read(signUpUseCaseProvider)
                        .execute(
                          emailController.text.trim(),
                          passwordController.text,
                        );
                  } else {
                    await ref
                        .read(signInUseCaseProvider)
                        .execute(
                          emailController.text.trim(),
                          passwordController.text,
                        );
                  }
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isSignUp
                              ? 'Account created! Check your email to verify.'
                              : 'Signed in successfully!',
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: Text(isSignUp ? 'Sign Up' : 'Sign In'),
            ),
            TextButton(
              onPressed: () => setState(() => isSignUp = !isSignUp),
              child: Text(
                isSignUp ? 'Already have an account?' : 'Create account',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signOut() async {
    try {
      await ref.read(signOutUseCaseProvider).execute();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signed out successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign out failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _performBackup() async {
    setState(() => _isBackingUp = true);

    try {
      final db = ref.read(appDatabaseProvider);
      final backupService = BackupService(db);
      final data = await backupService.exportAllData();
      final metadata = await ref
          .read(backupDataUseCaseProvider)
          .execute(
            houses: data['houses']!,
            cycles: data['cycles']!,
            readings: data['readings']!,
          );
      ref.invalidate(_backupMetadataProvider);
      ref.invalidate(_pendingBackupProvider);

      if (mounted) {
        setState(() => _isBackingUp = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Backup completed! ${metadata.housesCount} houses, ${metadata.cyclesCount} cycles, ${metadata.readingsCount} readings',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isBackingUp = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Backup failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _performRestore() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restore Data?'),
        content: const Text(
          'This will replace all your current data with the backed up data. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Restore'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isRestoring = true);

    try {
      final data = await ref.read(restoreDataUseCaseProvider).execute();
      final db = ref.read(appDatabaseProvider);
      final backupService = BackupService(db);
      await backupService.importAllData(
        houses: data['houses']!,
        cycles: data['cycles']!,
        readings: data['readings']!,
      );

      if (mounted) {
        setState(() => _isRestoring = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data restored successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isRestoring = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Restore failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }
}

final _backupMetadataProvider = FutureProvider((ref) async {
  final useCase = ref.watch(getBackupMetadataUseCaseProvider);
  return await useCase.execute();
});

// Provider to calculate pending backup counts
final _pendingBackupProvider = FutureProvider((ref) async {
  final metadata = await ref.watch(_backupMetadataProvider.future);
  final db = ref.read(appDatabaseProvider);

  // Get current local counts using Drift queries
  final houses = await db.select(db.housesTable).get();
  final cycles = await db.select(db.cyclesTable).get();
  final readings = await db.select(db.electricityReadingsTable).get();

  if (metadata == null) {
    // No backup yet - everything is pending
    return PendingBackupCounts(
      houses: houses.length,
      cycles: cycles.length,
      readings: readings.length,
      isFirstBackup: true,
    );
  }

  // Calculate differences (what's new since last backup)
  final pendingHouses = houses.length - metadata.housesCount;
  final pendingCycles = cycles.length - metadata.cyclesCount;
  final pendingReadings = readings.length - metadata.readingsCount;

  return PendingBackupCounts(
    houses: pendingHouses > 0 ? pendingHouses : 0,
    cycles: pendingCycles > 0 ? pendingCycles : 0,
    readings: pendingReadings > 0 ? pendingReadings : 0,
    isFirstBackup: false,
  );
});

class PendingBackupCounts {
  final int houses;
  final int cycles;
  final int readings;
  final bool isFirstBackup;

  const PendingBackupCounts({
    required this.houses,
    required this.cycles,
    required this.readings,
    required this.isFirstBackup,
  });

  bool get hasPending => houses > 0 || cycles > 0 || readings > 0;
}

class _PendingBackupIndicator extends ConsumerWidget {
  const _PendingBackupIndicator();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingAsync = ref.watch(_pendingBackupProvider);

    return pendingAsync.when(
      data: (pending) {
        if (!pending.hasPending) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  pending.isFirstBackup
                      ? Icons.cloud_upload_outlined
                      : Icons.sync_outlined,
                  size: 16,
                  color: Theme.of(context).colorScheme.onTertiaryContainer,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    pending.isFirstBackup
                        ? 'Ready to backup: ${pending.houses} houses, ${pending.cycles} cycles, ${pending.readings} readings'
                        : 'Pending backup: ${_buildPendingText(pending)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onTertiaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (error, stackTrace) => const SizedBox.shrink(),
    );
  }

  String _buildPendingText(PendingBackupCounts pending) {
    final parts = <String>[];
    if (pending.houses > 0) parts.add('${pending.houses} houses');
    if (pending.cycles > 0) parts.add('${pending.cycles} cycles');
    if (pending.readings > 0) parts.add('${pending.readings} readings');
    return parts.join(', ');
  }
}
