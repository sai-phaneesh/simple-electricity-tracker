import 'package:electricity/core/providers/app_providers.dart';
import 'package:electricity/core/utils/helpers/focus_remove_wrapper.dart';
import 'package:electricity/domain/entities/electricity_reading.dart';
import 'package:electricity/presentation/mobile/features/consumptions/presentation/widgets/consumption_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Screen for creating a new consumption reading.
///
/// This screen is simplified to only handle the creation flow.
/// For editing, use [EditConsumptionScreen] instead.
class CreateConsumptionScreen extends ConsumerWidget {
  const CreateConsumptionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cycleAsync = ref.watch(selectedCycleProvider);
    final readingsAsync = ref.watch(readingsForSelectedCycleStreamProvider);

    return FocusRemoveWrapper(
      child: Scaffold(
        appBar: AppBar(title: const Text('Add Consumption')),
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
                subtitle:
                    'Please select a cycle first to add consumption readings.',
                icon: Icons.info_outline,
              );
            }

            return readingsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => _buildErrorState(
                context,
                message: 'Failed to load readings',
                error: error.toString(),
              ),
              data: (readings) {
                // Sort readings by date (oldest first)
                final sortedReadings = List<ElectricityReading>.of(readings)
                  ..sort((a, b) => a.date.compareTo(b.date));

                return ConsumptionForm(
                  cycle: cycle,
                  sortedReadings: sortedReadings,
                  editingReading: null,
                );
              },
            );
          },
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
          ],
        ),
      ),
    );
  }
}
