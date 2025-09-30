import 'package:flutter/material.dart';

/// A small wrapper that unfocuses the current FocusNode when the user
/// taps anywhere in the wrapped area.
///
/// Use this to wrap your top-level `Scaffold` (or entire screen) so that
/// accidental taps close keyboards and remove focus from TextFields.
///
/// Example:
/// ```dart
/// FocusWrapper(
///   child: Scaffold(...),
/// )
/// ```
class FocusWrapper extends StatelessWidget {
  /// The widget subtree to wrap (usually a `Scaffold`).
  final Widget child;

  /// If true, unfocus will happen on pointer down (faster, immediate).
  /// If false (default) it will unfocus on tap.
  final bool unfocusOnPointerDown;

  const FocusWrapper({
    super.key,
    required this.child,
    this.unfocusOnPointerDown = false,
  });

  void _unfocus(BuildContext context) => FocusScope.of(context).unfocus();

  @override
  Widget build(BuildContext context) {
    // Listener with onPointerDown is slightly more aggressive and will
    // unfocus as soon as the pointer goes down. GestureDetector.onTap waits
    // for gesture recognition which can feel slightly slower.
    if (unfocusOnPointerDown) {
      return Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (_) => _unfocus(context),
        child: child,
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => _unfocus(context),
      child: child,
    );
  }
}
