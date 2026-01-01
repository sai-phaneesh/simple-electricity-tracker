import 'package:electricity/core/providers/app_providers.dart';
import 'package:electricity/core/utils/helpers/focus_remove_wrapper.dart';
import 'package:electricity/presentation/mobile/features/cycles/presentation/widgets/cycle_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Screen for editing an existing cycle.
///
/// This screen handles:
/// - Loading state while fetching the cycle
/// - Error state when cycle is not found
/// - Recalculation warning when changing price or initial reading
class EditCycleScreen extends ConsumerWidget {
  const EditCycleScreen({required this.cycleId, super.key});

  /// The ID of the cycle to edit.
  final String cycleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cycleAsync = ref.watch(cycleByIdProvider(cycleId));
    final housesAsync = ref.watch(housesStreamProvider);

    return FocusRemoveWrapper(
      child: Scaffold(
        appBar: AppBar(title: const Text('Edit Cycle')),
        body: cycleAsync.when(
          loading: () => _buildLoadingState(context),
          error: (error, stack) => _buildErrorState(
            context,
            message: 'Failed to load cycle',
            error: error.toString(),
          ),
          data: (cycle) {
            if (cycle == null) {
              return _buildNotFoundState(context);
            }

            // Get the house for this cycle
            return housesAsync.when(
              loading: () => _buildLoadingState(context),
              error: (error, stack) => _buildErrorState(
                context,
                message: 'Failed to load house data',
                error: error.toString(),
              ),
              data: (houses) {
                final house = houses
                    .where((h) => h.id == cycle.houseId)
                    .firstOrNull;

                if (house == null) {
                  return _buildErrorState(
                    context,
                    message: 'House not found',
                    subtitle:
                        'The house associated with this cycle no longer exists.',
                  );
                }

                return SafeArea(
                  child: CycleForm(selectedHouse: house, editingCycle: cycle),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'Loading cycle data...',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotFoundState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 80,
              color: Theme.of(context).colorScheme.error.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 24),
            Text(
              'Cycle Not Found',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'The cycle you\'re looking for doesn\'t exist or may have been deleted.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'ID: $cycleId',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.5),
                fontFamily: 'monospace',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: context.pop,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Go Back'),
                ),
                const SizedBox(width: 16),
                FilledButton.icon(
                  onPressed: () => context.go('/'),
                  icon: const Icon(Icons.home),
                  label: const Text('Dashboard'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(
    BuildContext context, {
    required String message,
    String? subtitle,
    String? error,
    IconData icon = Icons.error_outline,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: Theme.of(context).colorScheme.error.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (error != null) ...[
              const SizedBox(height: 8),
              Text(
                error,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: context.pop,
              icon: const Icon(Icons.arrow_back),
              label: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
