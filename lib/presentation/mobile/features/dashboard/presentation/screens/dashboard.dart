import 'package:electricity/core/providers/app_providers.dart';
import 'package:electricity/presentation/mobile/features/dashboard/presentation/components/consumption_card.dart';
import 'package:electricity/presentation/mobile/features/dashboard/presentation/components/cycle_picker_strip.dart';
import 'package:electricity/presentation/mobile/features/dashboard/presentation/components/cycle_summary_card.dart';
import 'package:electricity/presentation/shared/widgets/delete_confirmation_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({super.key});

  @override
  ConsumerState<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> {
  @override
  Widget build(BuildContext context) {
    final selectedHouseAsync = ref.watch(selectedHouseProvider);
    final selectedHouse = selectedHouseAsync.valueOrNull;
    final selectedCycleAsync = ref.watch(selectedCycleProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const CyclePickerStrip(),
        Expanded(
          child: selectedCycleAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) {
              stackTrace;
              return Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Text(
                    'Something went wrong while loading cycles.\n$error',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
            data: (cycle) {
              if (selectedHouseAsync.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              final scaffoldState = Scaffold.maybeOf(context);
              final VoidCallback? openDrawerCallback =
                  scaffoldState?.openDrawer;

              if (selectedHouse == null) {
                return _buildPrompt(
                  icon: Icons.home_work_outlined,
                  title: 'Select a house',
                  message:
                      'Open the drawer and choose a house to view its cycles and readings.',
                  actionLabel: openDrawerCallback == null
                      ? null
                      : 'Open drawer',
                  onPressed: openDrawerCallback,
                );
              }

              if (cycle == null) {
                return _buildPrompt(
                  icon: Icons.bolt_outlined,
                  title: 'Pick a cycle',
                  message:
                      'Select a cycle from the horizontal list or add a new one.',
                  actionLabel: openDrawerCallback == null
                      ? null
                      : 'Open drawer',
                  onPressed: openDrawerCallback,
                );
              }

              return const Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CycleSummaryCard(),
                  Expanded(child: ConsumptionsListView()),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPrompt({
    required IconData icon,
    required String title,
    required String message,
    String? actionLabel,
    VoidCallback? onPressed,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onPressed != null) ...[
              const SizedBox(height: 16),
              FilledButton(onPressed: onPressed, child: Text(actionLabel)),
            ],
          ],
        ),
      ),
    );
  }
}

class ConsumptionsListView extends ConsumerWidget {
  const ConsumptionsListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final readingsAsync = ref.watch(readingsForSelectedCycleStreamProvider);
    final controller = ref.watch(electricityReadingsControllerProvider);

    return readingsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) {
        stackTrace;
        return Center(child: Text('Failed to load readings\n$error'));
      },
      data: (readings) {
        if (readings.isEmpty) {
          return const Center(
            child: Text('No readings yet. Add one to get started.'),
          );
        }

        return ListView.separated(
          itemCount: readings.length,
          padding: const EdgeInsets.all(20),
          separatorBuilder: (_, index) {
            index;
            return const SizedBox(height: 12);
          },
          itemBuilder: (context, index) {
            final reading = readings[index];
            return ConsumptionCard(
              reading: reading,
              index: readings.length - index,
              onEdit: () {
                context.push('/create-consumption', extra: reading);
              },
              onDelete: () async {
                final shouldDelete = await showDialog<bool>(
                  context: context,
                  builder: (context) => const DeleteConfirmationModal(),
                );
                if (shouldDelete != true || !context.mounted) return;

                await controller.deleteReading(reading.id);
              },
            );
          },
        );
      },
    );
  }
}
