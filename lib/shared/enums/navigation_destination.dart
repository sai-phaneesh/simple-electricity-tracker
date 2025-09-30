import 'package:flutter/material.dart';

/// Navigation destinations for the app
enum NavigationDestinationType {
  houses(
    route: '/houses',
    label: 'Houses',
    icon: Icons.home_outlined,
    selectedIcon: Icons.home,
    tabIndex: 0,
  ),
  analytics(
    route: '/analytics',
    label: 'Analytics',
    icon: Icons.analytics_outlined,
    selectedIcon: Icons.analytics,
    tabIndex: 1,
  ),
  profile(
    route: '/profile',
    label: 'Profile',
    icon: Icons.person_outline,
    selectedIcon: Icons.person,
    tabIndex: 2,
  );

  const NavigationDestinationType({
    required this.route,
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.tabIndex,
  });

  final String route;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final int tabIndex;

  /// Get navigation destination by route
  static NavigationDestinationType? fromRoute(String route) {
    for (final destination in NavigationDestinationType.values) {
      if (route.startsWith(destination.route)) {
        return destination;
      }
    }
    return null;
  }

  /// Get navigation destination by index
  static NavigationDestinationType? fromIndex(int index) {
    for (final destination in NavigationDestinationType.values) {
      if (destination.tabIndex == index) {
        return destination;
      }
    }
    return null;
  }

  /// Get the selected index for the current route
  static int getSelectedIndex(String route) {
    final destination = fromRoute(route);
    return destination?.tabIndex ?? 0; // Default to houses
  }

  /// Get all navigation destinations as a list
  static List<NavigationDestinationType> get all =>
      NavigationDestinationType.values;
}
