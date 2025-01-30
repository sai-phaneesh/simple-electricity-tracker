import 'package:flutter/material.dart';

class FocusRemoveWrapper extends StatelessWidget {
  const FocusRemoveWrapper({super.key, required this.child});

  final Widget child;

  static removeFocus() => FocusManager.instance.primaryFocus?.unfocus();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: child,
    );
  }
}
