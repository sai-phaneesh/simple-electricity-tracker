import 'package:electricity/core/providers/app_providers.dart';
import 'package:electricity/presentation/mobile/features/dashboard/presentation/components/cycle_summary_card.dart';
import 'package:electricity/presentation/shared/widgets/app_drawer.dart';
import 'package:electricity/presentation/shared/widgets/delete_confirmation_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({super.key});

  @override
  ConsumerState<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final selectedCycleAsync = ref.watch(selectedCycleProvider);
    final selectedCycle = selectedCycleAsync.valueOrNull;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Electricity Tracker'),
        scrolledUnderElevation: 0,
      ),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: selectedCycleAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) {
            stackTrace;
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Something went wrong while loading cycles.\n$error',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
          data: (cycle) {
            if (cycle == null) {
              return Center(
                child: FilledButton(
                  onPressed: _scaffoldKey.currentState?.openDrawer,
                  child: const Text('Select a house and cycle'),
                ),
              );
            }

            return const Column(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CycleSummaryCard(),
                Expanded(child: ConsumptionsListView()),
              ],
            );
          },
        ),
      ),
      floatingActionButton: selectedCycle == null
          ? null
          : FloatingActionButton(
              onPressed: () {
                context.push('create-consumption/${selectedCycle.id}');
              },
              tooltip: 'Add consumption',
              child: const Icon(Icons.add),
            ),
    );
  }
}

class ConsumptionsListView extends ConsumerWidget {
  const ConsumptionsListView({super.key});

  static final _formatter = DateFormat('dd-MM-yyyy (hh:mm a)');

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
            return const SizedBox(height: 8);
          },
          itemBuilder: (context, index) {
            final reading = readings[index];
            return ListTile(
              onLongPress: () async {
                final shouldDelete = await showDialog<bool>(
                  context: context,
                  builder: (context) => const DeleteConfirmationModal(),
                );
                if (shouldDelete != true || !context.mounted) return;

                await controller.deleteReading(reading.id);
              },
              leading: Text('${readings.length - index}'),
              title: Text('${reading.meterReading}'),
              subtitle: Text(_formatter.format(reading.date)),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${reading.unitsConsumed} units'),
                  Text('₹${reading.totalCost.toStringAsFixed(2)}'),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
