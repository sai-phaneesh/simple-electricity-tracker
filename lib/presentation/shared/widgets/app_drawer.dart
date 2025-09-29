import 'package:electricity/core/router/app_router.dart';
import 'package:electricity/presentation/shared/bloc/dashboard/dashboard_bloc.dart';
import 'package:electricity/presentation/shared/widgets/delete_confirmation_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'theme_handler_widgets.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Drawer(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DrawerHeader(child: Text('Electricity Tracker')),
            CycleSelectorList(),
            DrawerActions(),
          ],
        ),
      ),
    );
  }
}

class CycleSelectorList extends StatelessWidget {
  const CycleSelectorList({super.key});

  @override
  Widget build(BuildContext context) {
    final cycles = context.watch<DashboardBloc>().cycles;
    final selectedCycle = context.watch<DashboardBloc>().selectedCycle;
    if (cycles.isEmpty) {
      return const Expanded(child: Center(child: Text('No Cycles Found')));
    }
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: cycles.length,
        itemBuilder: (context, index) {
          final cycle = cycles[index];
          final selected = cycle.id == selectedCycle?.id;
          return ListTile(
            textColor: selected ? null : Colors.grey,
            title: Text(cycle.name),
            subtitle: Text(
              '${cycle.totalConsumptions.toStringAsFixed(2)} Units',
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: selected ? null : Colors.grey,
            ),
            onTap: () {
              context.read<DashboardBloc>().add(
                UpdateSelectedCycleEvent(cycle: cycle),
              );
              context.pop();
            },
            onLongPress: () async {
              final delete = await showDialog<bool>(
                context: context,
                builder: (context) => DeleteConfirmationModal(),
              );
              if (delete != true || !context.mounted) return;
              context.read<DashboardBloc>().add(
                DeleteCycleEvent(cycleId: cycle.id),
              );
            },
          );
        },
      ),
    );
  }
}

class DrawerActions extends StatelessWidget {
  const DrawerActions({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const Divider(),
          ListTile(
            onTap: () {
              context.pop();
              context.pushNamed(AppRouteNames.createCycle);
            },
            title: const Text('Create Cycle'),
            trailing: const Icon(Icons.add),
          ),
          const ThemeHandlerListTile(),
          const AboutTile(),
        ],
      ),
    );
  }
}

class AboutTile extends StatelessWidget {
  const AboutTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('About'),
      trailing: const Icon(Icons.info),
      onTap: () {
        // TODO: implement onTap
        context.pop();
        context.pushNamed(AppRouteNames.about);
      },
    );
  }
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('About')));
  }
}
