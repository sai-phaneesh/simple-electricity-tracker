import 'package:electricity/core/providers/app_providers.dart';
import 'package:electricity/core/providers/supabase_provider.dart';
import 'package:electricity/presentation/mobile/features/auth/auth_screen.dart';
import 'package:electricity/presentation/mobile/features/consumptions/presentation/create_consumption_screen.dart';
import 'package:electricity/presentation/mobile/features/consumptions/presentation/edit_consumption_screen.dart';
import 'package:electricity/presentation/mobile/features/cycles/presentation/screens/create_cycle_screen.dart';
import 'package:electricity/presentation/mobile/features/cycles/presentation/screens/edit_cycle_screen.dart';
import 'package:electricity/presentation/mobile/features/dashboard/presentation/screens/dashboard.dart';
import 'package:electricity/presentation/mobile/features/settings/pages/settings_screen.dart';
import 'package:electricity/presentation/shared/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

abstract class AppRouteNames {
  static const auth = 'auth';
  static const dashboard = 'dashboard';
  static const createCycle = 'create-cycle';
  static const editCycle = 'edit-cycle';
  static const createConsumption = 'create-consumption';
  static const editConsumption = 'edit-consumption';
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
    final selectedHouse = selectedHouseAsync.value;
    final selectedCycle = selectedCycleAsync.value;

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
                context.push('/create-consumption');
              },
              tooltip: 'Add consumption',
              child: const Icon(Icons.add),
            ),
    );
  }
}

/// Provider for the GoRouter instance
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/auth',
    refreshListenable: GoRouterRefreshStream(ref),
    redirect: (context, state) {
      final isLoggedIn = authState.maybeWhen(
        data: (auth) => auth.session != null,
        orElse: () => false,
      );
      final isLoggingIn = state.matchedLocation == '/auth';

      // If not logged in and not on auth page, redirect to auth
      if (!isLoggedIn && !isLoggingIn) {
        return '/auth';
      }

      // If logged in and on auth page, redirect to dashboard
      if (isLoggedIn && isLoggingIn) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/auth',
        name: AppRouteNames.auth,
        builder: (context, state) => const AuthScreen(),
      ),
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
          return EditCycleScreen(cycleId: cycleId);
        },
      ),
      GoRoute(
        path: '/create-consumption',
        name: AppRouteNames.createConsumption,
        builder: (context, state) => const CreateConsumptionScreen(),
      ),
      GoRoute(
        path: '/edit-consumption/:readingId',
        name: AppRouteNames.editConsumption,
        builder: (context, state) {
          final readingId = state.pathParameters['readingId']!;
          return EditConsumptionScreen(readingId: readingId);
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
});

/// A ChangeNotifier that rebuilds the router when the ref changes
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(this._ref) {
    _ref.listen(authStateProvider, (_, next) {
      notifyListeners();
    });
  }

  final Ref _ref;
}
