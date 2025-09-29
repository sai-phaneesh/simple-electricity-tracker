import 'package:electricity/presentation/mobile/features/consumptions/presentation/create_consumption_screen.dart';
import 'package:electricity/presentation/mobile/features/cycles/presentation/screens/create_cycle_screen.dart';
import 'package:electricity/presentation/mobile/features/dashboard/presentation/screens/dashboard.dart';
import 'package:electricity/presentation/mobile/features/settings/pages/settings_screen.dart';
import 'package:electricity/presentation/shared/widgets/app_drawer.dart';
import 'package:go_router/go_router.dart';

abstract class AppRouteNames {
  static const dashboard = 'dashboard';
  static const createCycle = 'create-cycle';
  // static const createConsumption = 'create-consumption';
  static const createConsumption = 'create-consumption/:cycleId';
  static const about = 'about';
  static const settings = 'settings';
}

GoRouter createAppRouter() {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: AppRouteNames.dashboard,
        builder: (context, state) => const Dashboard(),
        routes: [
          GoRoute(
            path: 'cycles/create',
            name: AppRouteNames.createCycle,
            builder: (context, state) => const CreateCycleScreen(),
          ),
          GoRoute(
            path: 'consumptions/create/:cycleId',
            name: AppRouteNames.createConsumption,
            builder: (context, state) {
              final cycleId = state.pathParameters['cycleId'];
              if (cycleId == null || cycleId.isEmpty) {
                throw StateError('cycleId is required to create a consumption');
              }
              return CreateConsumptionScreen(cycleId: cycleId);
            },
          ),
          GoRoute(
            path: 'about',
            name: AppRouteNames.about,
            builder: (context, state) => const AboutScreen(),
          ),
          GoRoute(
            path: 'settings',
            name: AppRouteNames.settings,
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
  );
}
