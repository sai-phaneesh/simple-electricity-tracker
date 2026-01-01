import 'package:collection/collection.dart';
import 'package:electricity/core/providers/app_providers.dart';
import 'package:electricity/core/utils/helpers/focus_remove_wrapper.dart';
import 'package:electricity/domain/entities/electricity_reading.dart';
import 'package:electricity/presentation/mobile/features/consumptions/presentation/widgets/consumption_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Screen for editing an existing consumption reading.
///
/// This screen handles:
/// - Loading state while fetching the reading
/// - Error state when reading is not found
/// - Proper navigation back if reading was deleted
class EditConsumptionScreen extends ConsumerWidget {
  const EditConsumptionScreen({required this.readingId, super.key});

  /// The ID of the reading to edit.
  final String readingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cycleAsync = ref.watch(selectedCycleProvider);
    final readingsAsync = ref.watch(readingsForSelectedCycleStreamProvider);

    return FocusRemoveWrapper(
      child: Scaffold(
        appBar: AppBar(title: const Text('Edit Consumption')),
        body: cycleAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => _buildErrorState(
            context,
            message: 'Failed to load cycle',
            error: error.toString(),
          ),
          data: (cycle) {
            if (cycle == null) {
              return _buildErrorState(
                context,
                message: 'No cycle selected',
                subtitle: 'Please select a cycle first.',
                icon: Icons.info_outline,
              );
            }

            return readingsAsync.when(
              loading: () => _buildLoadingState(context),
              error: (error, stack) => _buildErrorState(
                context,
                message: 'Failed to load readings',
                error: error.toString(),
              ),
              data: (readings) {
                // Sort readings by date (oldest first)
                final sortedReadings = List<ElectricityReading>.of(readings)
                  ..sort((a, b) => a.date.compareTo(b.date));

                // Find the reading to edit
                final reading = sortedReadings.firstWhereOrNull(
                  (r) => r.id == readingId,
                );

                // Handle reading not found
                if (reading == null) {
                  return _buildNotFoundState(context);
                }

                return ConsumptionForm(
                  cycle: cycle,
                  sortedReadings: sortedReadings,
                  editingReading: reading,
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
            'Loading consumption data...',
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
              'Reading Not Found',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'The consumption reading you\'re looking for doesn\'t exist or may have been deleted.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'ID: $readingId',
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
                  onPressed: () => context.pop(),
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
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
