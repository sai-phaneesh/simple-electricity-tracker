import 'package:electricity/core/providers/app_providers.dart';
import 'package:electricity/data/database/database.dart';
import 'package:electricity/presentation/mobile/features/consumptions/presentation/create_consumption_screen.dart';
import 'package:electricity/presentation/mobile/features/cycles/presentation/screens/create_cycle_screen.dart';
import 'package:electricity/presentation/mobile/features/dashboard/presentation/screens/dashboard.dart';
import 'package:electricity/presentation/mobile/features/settings/pages/settings_screen.dart';
import 'package:electricity/presentation/shared/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

abstract class AppRouteNames {
  static const dashboard = 'dashboard';
  static const createCycle = 'create-cycle';
  static const editCycle = 'edit-cycle';
  static const createConsumption = '/create-consumption';
  static const about = 'about';
  static const settings = '/settings';
}

class DashboardShell extends ConsumerWidget {
  const DashboardShell({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedHouseAsync = ref.watch(selectedHouseProvider);
    final selectedCycleAsync = ref.watch(selectedCycleProvider);
    final selectedHouse = selectedHouseAsync.valueOrNull;
    final selectedCycle = selectedCycleAsync.valueOrNull;

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Electricity Tracker'),
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(child: child),
      floatingActionButton: selectedHouse == null || selectedCycle == null
          ? null
          : FloatingActionButton(
              onPressed: () {
                context.push(AppRouteNames.createConsumption);
              },
              tooltip: 'Add consumption',
              child: const Icon(Icons.add),
            ),
    );
  }
}

GoRouter createAppRouter() {
  return GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) => DashboardShell(child: child),
        routes: [
          GoRoute(
            path: '/',
            name: AppRouteNames.dashboard,
            builder: (context, state) => const Dashboard(),
          ),
        ],
      ),
      GoRoute(
        path: '/create-cycle',
        name: AppRouteNames.createCycle,
        builder: (context, state) => const CreateCycleScreen(),
      ),
      GoRoute(
        path: '/edit-cycle/:cycleId',
        name: AppRouteNames.editCycle,
        builder: (context, state) {
          final cycleId = state.pathParameters['cycleId']!;
          return CreateCycleScreen(cycleId: cycleId);
        },
      ),
      GoRoute(
        path: '/create-consumption',
        name: AppRouteNames.createConsumption,
        builder: (context, state) {
          final reading = state.extra as ElectricityReading?;
          return CreateConsumptionScreen(reading: reading);
        },
      ),
      GoRoute(
        path: '/about',
        name: AppRouteNames.about,
        builder: (context, state) => const AboutScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: AppRouteNames.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}
