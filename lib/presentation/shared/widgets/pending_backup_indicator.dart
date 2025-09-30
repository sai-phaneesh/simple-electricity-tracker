import 'package:electricity/core/providers/sync_tracking_providers.dart';
import 'package:electricity/domain/entities/pending_backup_counts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Widget for displaying pending backup indicator
class PendingBackupIndicator extends ConsumerWidget {
  const PendingBackupIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingAsync = ref.watch(pendingBackupCountsProvider);

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
                        : 'Pending changes: ${_buildPendingText(pending)}',
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
