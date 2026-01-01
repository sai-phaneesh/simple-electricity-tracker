import 'package:electricity/core/providers/app_providers.dart';
import 'package:electricity/core/utils/helpers/focus_remove_wrapper.dart';
import 'package:electricity/presentation/mobile/features/cycles/presentation/widgets/cycle_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Screen for creating a new cycle.
///
/// This screen is simplified to only handle the creation flow.
/// For editing, use [EditCycleScreen] instead.
class CreateCycleScreen extends ConsumerWidget {
  const CreateCycleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedHouseAsync = ref.watch(selectedHouseProvider);
    final housesAsync = ref.watch(housesStreamProvider);

    return FocusRemoveWrapper(
      child: Scaffold(
        appBar: AppBar(title: const Text('Add Cycle')),
        body: selectedHouseAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => _buildErrorState(
            context,
            message: 'Failed to load house',
            error: error.toString(),
          ),
          data: (selectedHouse) {
            // If no house selected, show house selector
            if (selectedHouse == null) {
              return housesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => _buildErrorState(
                  context,
                  message: 'Failed to load houses',
                  error: error.toString(),
                ),
                data: (houses) {
                  if (houses.isEmpty) {
                    return _buildErrorState(
                      context,
                      message: 'No houses available',
                      subtitle:
                          'Create a house from the drawer first to add cycles.',
                      icon: Icons.home_outlined,
                    );
                  }

                  return _buildHouseSelector(context, ref, houses);
                },
              );
            }

            return SafeArea(
              child: CycleForm(
                selectedHouse: selectedHouse,
                editingCycle: null,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHouseSelector(
    BuildContext context,
    WidgetRef ref,
    List<dynamic> houses,
  ) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(
            Icons.home_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
          ),
          const SizedBox(height: 16),
          Text(
            'Select a House',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Choose which house this cycle belongs to.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Select house',
              border: OutlineInputBorder(),
            ),
            items: houses
                .map(
                  (h) => DropdownMenuItem(
                    value: h.id as String,
                    child: Text(h.name as String),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value == null) return;
              ref.read(selectedHouseIdProvider.notifier).setHouse(value);
            },
          ),
        ],
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
          ],
        ),
      ),
    );
  }
}
