import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:electricity/shared/widgets/animated_shell.dart';
import 'package:electricity/shared/enums/navigation_destination.dart';

/// Main shell widget that provides responsive navigation for the app
class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use rail navigation for larger screens (tablet/desktop)
        if (constraints.maxWidth >= 768) {
          return _DesktopLayout(child: child);
        }
        // Use bottom navigation for mobile
        return _MobileLayout(child: child);
      },
    );
  }
}

/// Mobile layout with bottom navigation
class _MobileLayout extends StatelessWidget {
  final Widget child;

  const _MobileLayout({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveContentWrapper(isDesktop: false, child: child),
      bottomNavigationBar: _BottomNavigationBarWrapper(),
    );
  }
}

/// Desktop/Tablet layout with rail navigation
class _DesktopLayout extends StatelessWidget {
  final Widget child;

  const _DesktopLayout({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          _NavigationRailWrapper(),
          Expanded(
            child: ResponsiveContentWrapper(isDesktop: true, child: child),
          ),
        ],
      ),
    );
  }
}

/// Navigation rail for desktop/tablet
class _NavigationRailWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String matchedLocation = GoRouterState.of(context).matchedLocation;

    return NavigationRail(
      selectedIndex: NavigationDestinationType.getSelectedIndex(
        matchedLocation,
      ),
      onDestinationSelected: (index) => _onItemTapped(context, index),
      labelType: NavigationRailLabelType.all,
      leading: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Icon(
          Icons.bolt,
          size: 32,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      destinations: NavigationDestinationType.all
          .map(
            (destination) => NavigationRailDestination(
              icon: Icon(destination.icon),
              selectedIcon: Icon(destination.selectedIcon),
              label: Text(destination.label),
            ),
          )
          .toList(),
    );
  }

  void _onItemTapped(BuildContext context, int index) {
    final destination = NavigationDestinationType.fromIndex(index);
    if (destination != null) {
      context.go(destination.route);
    }
  }
}

/// Bottom navigation for mobile
class _BottomNavigationBarWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String matchedLocation = GoRouterState.of(context).matchedLocation;

    return NavigationBar(
      selectedIndex: NavigationDestinationType.getSelectedIndex(
        matchedLocation,
      ),
      onDestinationSelected: (index) => _onItemTapped(context, index),
      destinations: NavigationDestinationType.all
          .map(
            (destination) => NavigationDestination(
              icon: Icon(destination.icon),
              selectedIcon: Icon(destination.selectedIcon),
              label: destination.label,
            ),
          )
          .toList(),
    );
  }

  void _onItemTapped(BuildContext context, int index) {
    final destination = NavigationDestinationType.fromIndex(index);
    if (destination != null) {
      context.go(destination.route);
    }
  }
}
