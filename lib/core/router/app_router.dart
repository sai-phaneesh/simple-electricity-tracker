import 'package:electricity/features/cycles/presentation/screens/house_cycles_screen.dart';
import 'package:electricity/features/cycles/presentation/screens/cycle_detail_screen.dart';
import 'package:electricity/features/cycles/presentation/screens/create_cycle_screen.dart';
import 'package:electricity/features/cycles/presentation/form/create_cycle_form_model.dart';
import 'package:electricity/features/houses/presentation/form/house_form_model.dart';
import 'package:electricity/features/houses/presentation/screens/houses_screen.dart';
import 'package:electricity/features/houses/presentation/screens/house_detail_screen.dart';
import 'package:electricity/features/houses/presentation/screens/house_readings_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:electricity/features/houses/presentation/screens/house_form_screen.dart';
import 'package:electricity/features/analytics/presentation/screens/analytics_screen.dart';
import 'package:electricity/features/profile/presentation/screens/profile_screen.dart';
import 'package:electricity/features/settings/presentation/screens/settings_screen_responsive.dart';
import 'package:electricity/shared/widgets/main_shell.dart';
import 'package:electricity/shared/utils/page_transitions.dart';
import 'package:provider/provider.dart';

// Export the specific screens for router usage
export 'package:electricity/features/houses/presentation/screens/house_form_screen.dart'
    show AddHouseScreen, EditHouseScreen;

/// GoRouter configuration for the Electricity Tracker app
class AppRouter {
  static const String houses = '/houses';
  static const String analytics = '/analytics';
  static const String profile = '/profile';
  static const String settings = '/settings';

  /// House detail routes
  static const String houseDetail = '/houses/:houseId';
  static const String cycleDetail = '/houses/:houseId/cycles/:cycleId';
  static const String houseCycles = '/houses/:houseId/cycles';
  static const String createCycle = '/houses/:houseId/cycles/create';

  /// Auth routes
  static const String login = '/login';
  static const String onboarding = '/onboarding';

  static final GoRouter router = GoRouter(
    initialLocation: houses,
    debugLogDiagnostics: true,
    routes: [
      // Main app shell with bottom navigation
      ShellRoute(
        builder: (context, state, child) {
          return MainShell(child: child);
        },
        routes: [
          // Houses (Home) route
          GoRoute(
            path: houses,
            name: 'houses',
            pageBuilder: (context, state) =>
                ResponsivePageTransitions.buildTabPage(
                  context: context,
                  state: state,
                  child: const HousesScreen(),
                ),
            routes: [
              // Add house route
              GoRoute(
                path: '/add',
                name: 'add-house',
                pageBuilder: (context, state) =>
                    ResponsivePageTransitions.buildPage(
                      context: context,
                      state: state,
                      child: ChangeNotifierProvider(
                        create: (context) => HouseFormModel(),
                        child: const AddHouseScreen(),
                      ),
                    ),
              ),
              // Edit house route
              GoRoute(
                path: '/edit/:houseId',
                name: 'edit-house',
                pageBuilder: (context, state) {
                  final houseId = state.pathParameters['houseId']!;
                  return ResponsivePageTransitions.buildPage(
                    context: context,
                    state: state,
                    child: ChangeNotifierProvider(
                      create: (context) => HouseFormModel(),
                      child: EditHouseScreen(houseId: houseId),
                    ),
                  );
                },
              ),
              // House cycles route
              GoRoute(
                path: '/:houseId/cycles',
                name: 'house-cycles',
                pageBuilder: (context, state) {
                  final houseId = state.pathParameters['houseId']!;
                  return ResponsivePageTransitions.buildPage(
                    context: context,
                    state: state,
                    child: HouseCyclesScreen(houseId: houseId),
                  );
                },
                routes: [
                  // Create cycle route
                  GoRoute(
                    path: '/create',
                    name: 'create-cycle',
                    pageBuilder: (context, state) {
                      final houseId = state.pathParameters['houseId']!;
                      final houseName =
                          state.uri.queryParameters['houseName'] ??
                          'Unknown House';
                      final defaultPricePerUnit =
                          state.uri.queryParameters['defaultPricePerUnit'];

                      return ResponsivePageTransitions.buildPage(
                        context: context,
                        state: state,
                        child: ChangeNotifierProvider(
                          create: (context) => CreateCycleFormModel(
                            houseId: houseId,
                            defaultPricePerUnit: defaultPricePerUnit != null
                                ? double.tryParse(defaultPricePerUnit)
                                : null,
                          ),
                          child: CreateCycleScreen(
                            houseId: houseId,
                            houseName: houseName,
                            defaultPricePerUnit: defaultPricePerUnit != null
                                ? double.tryParse(defaultPricePerUnit)
                                : null,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              // House readings route (legacy - will be moved to cycles)
              GoRoute(
                path: '/:houseId/readings',
                name: 'house-readings',
                pageBuilder: (context, state) {
                  final houseId = state.pathParameters['houseId']!;
                  return ResponsivePageTransitions.buildPage(
                    context: context,
                    state: state,
                    child: HouseReadingsScreen(houseId: houseId),
                  );
                },
              ),
              // House detail route
              GoRoute(
                path: '/:houseId',
                name: 'house-detail',
                pageBuilder: (context, state) {
                  final houseId = state.pathParameters['houseId']!;
                  return ResponsivePageTransitions.buildPage(
                    context: context,
                    state: state,
                    child: HouseDetailScreen(houseId: houseId),
                  );
                },
                routes: [
                  // Cycle detail route
                  GoRoute(
                    path: '/cycles/:cycleId',
                    name: 'cycle-detail',
                    pageBuilder: (context, state) {
                      final houseId = state.pathParameters['houseId']!;
                      final cycleId = state.pathParameters['cycleId']!;
                      return ResponsivePageTransitions.buildPage(
                        context: context,
                        state: state,
                        child: CycleDetailScreen(
                          houseId: houseId,
                          cycleId: cycleId,
                        ),
                      );
                    },
                    routes: [
                      // Cycle readings route
                      GoRoute(
                        path: '/readings',
                        name: 'cycle-readings',
                        pageBuilder: (context, state) {
                          final houseId = state.pathParameters['houseId']!;
                          final cycleId = state.pathParameters['cycleId']!;
                          return ResponsivePageTransitions.buildPage(
                            context: context,
                            state: state,
                            child: HouseReadingsScreen(
                              houseId: houseId,
                              cycleId: cycleId,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          // Analytics route
          GoRoute(
            path: analytics,
            name: 'analytics',
            pageBuilder: (context, state) =>
                ResponsivePageTransitions.buildTabPage(
                  context: context,
                  state: state,
                  child: const AnalyticsScreen(),
                ),
          ),

          // Profile route
          GoRoute(
            path: profile,
            name: 'profile',
            pageBuilder: (context, state) =>
                ResponsivePageTransitions.buildTabPage(
                  context: context,
                  state: state,
                  child: const ProfileScreen(),
                ),
          ),
        ],
      ),

      // Settings route (full screen, not in shell)
      GoRoute(
        path: settings,
        name: 'settings',
        pageBuilder: (context, state) =>
            ResponsivePageTransitions.buildSettingsPage(
              context: context,
              state: state,
              child: const SettingsScreen(),
            ),
      ),

      // Auth routes (outside main shell)
      GoRoute(
        path: login,
        name: 'login',
        pageBuilder: (context, state) => ResponsivePageTransitions.buildPage(
          context: context,
          state: state,
          child: const LoginScreen(),
        ),
      ),

      GoRoute(
        path: onboarding,
        name: 'onboarding',
        pageBuilder: (context, state) => ResponsivePageTransitions.buildPage(
          context: context,
          state: state,
          child: const OnboardingScreen(),
        ),
      ),
    ],

    // Error handling
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found: ${state.uri.path}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(houses),
              child: const Text('Go to Houses'),
            ),
          ],
        ),
      ),
    ),

    // Route guards and redirects can be added here
    redirect: (context, state) {
      // Add authentication logic here if needed
      // For now, we'll allow all routes
      return null;
    },
  );

  /// Helper methods for navigation
  static String buildHouseCyclesPath(String houseId) {
    return '/houses/$houseId/cycles';
  }

  static String buildCreateCyclePath(
    String houseId, {
    String? houseName,
    double? defaultPricePerUnit,
  }) {
    final base = '/houses/$houseId/cycles/create';
    final queryParams = <String, String>{};

    if (houseName != null) {
      queryParams['houseName'] = houseName;
    }

    if (defaultPricePerUnit != null) {
      queryParams['defaultPricePerUnit'] = defaultPricePerUnit.toString();
    }

    if (queryParams.isEmpty) {
      return base;
    }

    final query = queryParams.entries
        .map(
          (e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');

    return '$base?$query';
  }

  static String buildCycleDetailPath(String houseId, String cycleId) {
    return '/houses/$houseId/cycles/$cycleId';
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: const Center(child: Text('Login Screen - Coming Soon')),
    );
  }
}

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome')),
      body: const Center(child: Text('Onboarding Screen - Coming Soon')),
    );
  }
}
