import 'package:flutter/material.dart';

/// A slide-in panel that appears from the right side of the screen
/// Designed for desktop form interfaces to provide a more native feel
class SlideInPanel extends StatefulWidget {
  final Widget child;
  final String title;
  final VoidCallback? onClose;
  final double width;
  final bool showCloseButton;
  final bool showHeader;

  const SlideInPanel({
    super.key,
    required this.child,
    required this.title,
    this.onClose,
    this.width = 600,
    this.showCloseButton = true,
    this.showHeader = true,
  });

  @override
  State<SlideInPanel> createState() => _SlideInPanelState();
}

class _SlideInPanelState extends State<SlideInPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    // Start animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _close() async {
    await _animationController.reverse();
    if (mounted && widget.onClose != null) {
      widget.onClose!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Backdrop
        AnimatedBuilder(
          animation: _fadeAnimation,
          builder: (context, child) {
            return GestureDetector(
              onTap: _close,
              child: Container(
                color: Colors.black.withOpacity(_fadeAnimation.value),
                width: double.infinity,
                height: double.infinity,
              ),
            );
          },
        ),
        // Slide-in panel
        Positioned(
          top: 0,
          bottom: 0,
          right: 0,
          child: SlideTransition(
            position: _slideAnimation,
            child: Material(
              elevation: 8,
              child: Container(
                width: widget.width,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(-2, 0),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Header
                    if (widget.showHeader)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).primaryColor.withOpacity(0.1),
                          border: Border(
                            bottom: BorderSide(
                              color: Theme.of(context).dividerColor,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.title,
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            if (widget.showCloseButton)
                              IconButton(
                                onPressed: _close,
                                icon: const Icon(Icons.close),
                                tooltip: 'Close',
                              ),
                          ],
                        ),
                      ),
                    // Content
                    Expanded(child: widget.child),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// A slide-in panel specifically for screens that already have their own AppBar
class _ScreenSlideInPanel extends StatefulWidget {
  final Widget child;
  final VoidCallback? onClose;
  final double width;

  const _ScreenSlideInPanel({
    required this.child,
    this.onClose,
    this.width = 600,
  });

  @override
  State<_ScreenSlideInPanel> createState() => _ScreenSlideInPanelState();
}

class _ScreenSlideInPanelState extends State<_ScreenSlideInPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    // Start animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _close() async {
    await _animationController.reverse();
    if (mounted && widget.onClose != null) {
      widget.onClose!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Backdrop
        AnimatedBuilder(
          animation: _fadeAnimation,
          builder: (context, child) {
            return GestureDetector(
              onTap: _close,
              child: Container(
                color: Colors.black.withOpacity(_fadeAnimation.value),
                width: double.infinity,
                height: double.infinity,
              ),
            );
          },
        ),
        // Slide-in panel
        Positioned(
          top: 0,
          bottom: 0,
          right: 0,
          child: SlideTransition(
            position: _slideAnimation,
            child: Material(
              elevation: 8,
              child: Container(
                width: widget.width,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(-2, 0),
                    ),
                  ],
                ),
                child: widget.child,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Extension to show slide-in panel as an overlay
extension SlideInPanelExtension on BuildContext {
  void showSlideInPanel({
    required Widget child,
    required String title,
    double width = 600,
    bool showCloseButton = true,
    bool showHeader = true,
  }) {
    Navigator.of(this).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        pageBuilder: (context, animation, secondaryAnimation) {
          return SlideInPanel(
            title: title,
            width: width,
            showCloseButton: showCloseButton,
            showHeader: showHeader,
            onClose: () => Navigator.of(context).pop(),
            child: child,
          );
        },
      ),
    );
  }

  /// Show slide-in panel for a screen that already has its own AppBar
  void showSlideInScreenPanel({
    required Widget screenChild,
    double width = 600,
  }) {
    Navigator.of(this).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        pageBuilder: (context, animation, secondaryAnimation) {
          return _ScreenSlideInPanel(
            width: width,
            onClose: () => Navigator.of(context).pop(),
            child: screenChild,
          );
        },
      ),
    );
  }
}
