import 'package:flutter/material.dart';

/// Animated shell wrapper that provides smooth transitions for the main content area
class AnimatedShell extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const AnimatedShell({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 200),
  });

  @override
  State<AnimatedShell> createState() => _AnimatedShellState();
}

class _AnimatedShellState extends State<AnimatedShell>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurveTween(curve: Curves.easeInOut).animate(_controller));

    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child.runtimeType != widget.child.runtimeType) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return FadeTransition(opacity: _fadeAnimation, child: widget.child);
      },
    );
  }
}

/// Responsive animated container for the main content area
class ResponsiveContentWrapper extends StatelessWidget {
  final Widget child;
  final bool isDesktop;

  const ResponsiveContentWrapper({
    super.key,
    required this.child,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    if (isDesktop) {
      return Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: AnimatedShell(child: child),
      );
    }

    return AnimatedShell(child: child);
  }
}
