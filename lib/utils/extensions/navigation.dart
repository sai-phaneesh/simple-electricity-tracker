import 'package:flutter/material.dart';

extension NavigatorExtension on BuildContext {
  Future<T?> push<T extends Object?>(Widget page) {
    return Navigator.of(this).push<T>(MaterialPageRoute(builder: (_) => page));
  }

  void pop<T extends Object?>([T? result]) {
    return Navigator.of(this).pop<T>(result);
  }

  Future<T?> pushAndRemoveUntil<T extends Object?>(
    Widget page, {
    required RoutePredicate predicate,
  }) {
    return Navigator.of(this).pushAndRemoveUntil<T>(
      MaterialPageRoute(builder: (_) => page),
      predicate,
    );
  }

  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.of(this).pushNamedAndRemoveUntil<T>(
      routeName,
      ModalRoute.withName(routeName),
      arguments: arguments,
    );
  }
}
