import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Custom page transitions for responsive design
class ResponsivePageTransitions {
  /// Create a responsive page transition based on screen size
  static Page<T> buildPage<T extends Object?>({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    String? name,
    Object? arguments,
    String? restorationId,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Use fade transition for larger screens (tablet/desktop)
    if (screenWidth >= 768) {
      return CustomTransitionPage<T>(
        key: state.pageKey,
        name: name,
        arguments: arguments,
        restorationId: restorationId,
        child: child,
        transitionsBuilder: _buildFadeTransition,
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 200),
      );
    }

    // Use slide transition for mobile
    return CustomTransitionPage<T>(
      key: state.pageKey,
      name: name,
      arguments: arguments,
      restorationId: restorationId,
      child: child,
      transitionsBuilder: _buildSlideTransition,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 200),
    );
  }

  /// Fade transition for larger screens - elegant and subtle
  static Widget _buildFadeTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
      child: child,
    );
  }

  /// Slide transition for mobile - familiar mobile pattern
  static Widget _buildSlideTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(1.0, 0.0);
    const end = Offset.zero;
    const curve = Curves.easeInOut;

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    return SlideTransition(position: animation.drive(tween), child: child);
  }

  /// Special transition for settings page (comes from bottom)
  static Page<T> buildSettingsPage<T extends Object?>({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    String? name,
    Object? arguments,
    String? restorationId,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      name: name,
      arguments: arguments,
      restorationId: restorationId,
      child: child,
      transitionsBuilder: _buildBottomSlideTransition,
      transitionDuration: const Duration(milliseconds: 350),
      reverseTransitionDuration: const Duration(milliseconds: 300),
    );
  }

  /// Bottom slide transition for settings and modal-like pages
  static Widget _buildBottomSlideTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(0.0, 1.0);
    const end = Offset.zero;
    const curve = Curves.easeOutCubic;

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    return SlideTransition(position: animation.drive(tween), child: child);
  }

  /// Cross-fade transition for navigating between main tabs
  static Page<T> buildTabPage<T extends Object?>({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    String? name,
    Object? arguments,
    String? restorationId,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;

    // For larger screens, use a subtle cross-fade
    if (screenWidth >= 768) {
      return CustomTransitionPage<T>(
        key: state.pageKey,
        name: name,
        arguments: arguments,
        restorationId: restorationId,
        child: child,
        transitionsBuilder: _buildCrossFadeTransition,
        transitionDuration: const Duration(milliseconds: 200),
        reverseTransitionDuration: const Duration(milliseconds: 150),
      );
    }

    // For mobile, use a subtle horizontal slide
    return CustomTransitionPage<T>(
      key: state.pageKey,
      name: name,
      arguments: arguments,
      restorationId: restorationId,
      child: child,
      transitionsBuilder: _buildSubtleSlideTransition,
      transitionDuration: const Duration(milliseconds: 250),
      reverseTransitionDuration: const Duration(milliseconds: 200),
    );
  }

  /// Cross-fade transition for tab navigation on larger screens
  static Widget _buildCrossFadeTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurveTween(curve: Curves.easeInOut).animate(animation)),
      child: child,
    );
  }

  /// Subtle slide transition for tab navigation on mobile
  static Widget _buildSubtleSlideTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(0.3, 0.0);
    const end = Offset.zero;
    const curve = Curves.easeOutQuart;

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    return SlideTransition(
      position: animation.drive(tween),
      child: FadeTransition(
        opacity: Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurveTween(curve: Curves.easeIn).animate(animation)),
        child: child,
      ),
    );
  }
}

/// Animation curves optimized for different screen sizes
class ResponsiveCurves {
  /// Smooth curve for desktop transitions
  static const Curve desktop = Curves.easeInOut;

  /// More dynamic curve for mobile transitions
  static const Curve mobile = Curves.easeOutQuart;

  /// Gentle curve for tab transitions
  static const Curve tabs = Curves.easeInOutCubic;
}
