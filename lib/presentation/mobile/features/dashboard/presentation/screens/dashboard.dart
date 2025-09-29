import 'package:electricity/presentation/mobile/features/dashboard/presentation/components/cycle_summary_card.dart';
import 'package:electricity/presentation/shared/bloc/dashboard/dashboard_bloc.dart';
import 'package:electricity/presentation/shared/widgets/app_drawer.dart';
import 'package:electricity/presentation/shared/widgets/delete_confirmation_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final selectedCycle = context.watch<DashboardBloc>().selectedCycle;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Electricity Tracker'),
        scrolledUnderElevation: 0,
        actions: [
          // if (selectedCycle != null)
          //   IconButton(
          //     onPressed: () {
          //       context.push(CreateCycleScreen());
          //     },
          //     icon: const Icon(Icons.add),
          //   ),
        ],
      ),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Builder(
          builder: (context) {
            if (selectedCycle == null) {
              return Center(
                child: FilledButton(
                  onPressed: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                  child: Text('Select a cycle'),
                ),
              );
            }
            return const Column(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [CycleSummaryCard(), ConsumptionsListView()],
            );
          },
        ),
      ),
      floatingActionButton: selectedCycle == null
          ? null
          : FloatingActionButton(
              onPressed: () {
                context.push("create-consumption/${selectedCycle.id}");
              },
              tooltip: 'Consumption',
              child: const Icon(Icons.add),
            ),
    );
  }
}

class ConsumptionsListView extends StatelessWidget {
  const ConsumptionsListView({super.key});

  @override
  Widget build(BuildContext context) {
    final consumptions =
        (context.watch<DashboardBloc>().selectedCycle?.consumptions ?? [])
            .reversed
            .toList();

    return Expanded(
      child: ListView.builder(
        itemCount: consumptions.length,
        padding: const EdgeInsets.all(20),
        itemBuilder: (context, index) {
          final consumption = consumptions[index];
          return ListTile(
            onLongPress: () async {
              final delete = await showDialog<bool>(
                context: context,
                builder: (context) => DeleteConfirmationModal(),
              );
              if (delete != true || !context.mounted) return;

              final selectedCycle = context.read<DashboardBloc>().selectedCycle;
              if (selectedCycle == null) return;
              context.read<DashboardBloc>().add(
                DeleteConsumptionEvent(
                  cycleId: selectedCycle.id,
                  consumptionId: consumption.id,
                ),
              );
            },
            leading: Text('${consumptions.length - (index)}'),
            title: Text(consumption.meterReading.toString()),
            subtitle: Text(
              DateFormat('dd-MM-yyyy (hh:mm a)').format(consumption.date),
            ),
            trailing: Text(consumption.unitsConsumed.toString()),
          );
        },
      ),
    );
  }
}
