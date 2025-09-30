import 'package:flutter/material.dart';

/// Toast types similar to react-toastify
enum ToastType { success, error, warning, info }

/// Position of the toast
enum ToastPosition {
  topRight,
  topLeft,
  topCenter,
  bottomRight,
  bottomLeft,
  bottomCenter,
}

/// Toast configuration
class ToastConfig {
  final Duration autoClose;
  final bool hideProgressBar;
  final bool closeOnClick;
  final bool pauseOnHover;
  final bool draggable;
  final ToastPosition position;
  final Duration transition;

  const ToastConfig({
    this.autoClose = const Duration(seconds: 4),
    this.hideProgressBar = false,
    this.closeOnClick = true,
    this.pauseOnHover = true,
    this.draggable = true,
    this.position = ToastPosition.topRight,
    this.transition = const Duration(milliseconds: 300),
  });
}

/// Individual toast item
class ToastItem {
  final String id;
  final String message;
  final ToastType type;
  final Widget? icon;
  final VoidCallback? onClose;
  final ToastConfig config;
  final DateTime createdAt;

  ToastItem({
    required this.id,
    required this.message,
    required this.type,
    this.icon,
    this.onClose,
    this.config = const ToastConfig(),
  }) : createdAt = DateTime.now();

  Color get backgroundColor {
    switch (type) {
      case ToastType.success:
        return const Color(0xFF22C55E);
      case ToastType.error:
        return const Color(0xFFEF4444);
      case ToastType.warning:
        return const Color(0xFFF59E0B);
      case ToastType.info:
        return const Color(0xFF3B82F6);
    }
  }

  IconData get defaultIcon {
    switch (type) {
      case ToastType.success:
        return Icons.check_circle;
      case ToastType.error:
        return Icons.error;
      case ToastType.warning:
        return Icons.warning;
      case ToastType.info:
        return Icons.info;
    }
  }
}

/// Toast container widget
class ToastWidget extends StatefulWidget {
  final ToastItem toast;
  final VoidCallback onRemove;

  const ToastWidget({super.key, required this.toast, required this.onRemove});

  @override
  State<ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<ToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.toast.config.transition,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _progressAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    _controller.forward();

    // Auto close timer
    if (widget.toast.config.autoClose.inMilliseconds > 0) {
      Future.delayed(widget.toast.config.autoClose, () {
        if (mounted) _dismiss();
      });
    }

    // Progress bar animation
    if (!widget.toast.config.hideProgressBar) {
      _controller.addListener(() {
        if (_controller.isCompleted) {
          AnimationController progressController = AnimationController(
            duration: widget.toast.config.autoClose,
            vsync: this,
          );
          progressController.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _dismiss() async {
    await _controller.reverse();
    widget.onRemove();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          decoration: BoxDecoration(
            color: widget.toast.backgroundColor,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Progress bar
              if (!widget.toast.config.hideProgressBar)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: AnimatedBuilder(
                    animation: _progressAnimation,
                    builder: (context, child) {
                      return LinearProgressIndicator(
                        value: _progressAnimation.value,
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white.withOpacity(0.3),
                        ),
                        minHeight: 3,
                      );
                    },
                  ),
                ),
              // Toast content
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.toast.config.closeOnClick ? _dismiss : null,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Icon
                        widget.toast.icon ??
                            Icon(
                              widget.toast.defaultIcon,
                              color: Colors.white,
                              size: 20,
                            ),
                        const SizedBox(width: 12),
                        // Message
                        Expanded(
                          child: Text(
                            widget.toast.message,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        // Close button
                        InkWell(
                          onTap: _dismiss,
                          borderRadius: BorderRadius.circular(4),
                          child: const Padding(
                            padding: EdgeInsets.all(4),
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Toast manager - singleton for global access
class FlutterToastX {
  static final FlutterToastX _instance = FlutterToastX._internal();
  factory FlutterToastX() => _instance;
  FlutterToastX._internal();

  static FlutterToastX get instance => _instance;

  final List<ToastItem> _toasts = [];
  final ValueNotifier<List<ToastItem>> _toastsNotifier = ValueNotifier([]);

  ValueNotifier<List<ToastItem>> get toastsNotifier => _toastsNotifier;

  /// Show a success toast
  static String success(
    String message, {
    ToastConfig? config,
    Widget? icon,
    VoidCallback? onClose,
  }) {
    return _instance._showToast(
      message: message,
      type: ToastType.success,
      config: config ?? const ToastConfig(),
      icon: icon,
      onClose: onClose,
    );
  }

  /// Show an error toast
  static String error(
    String message, {
    ToastConfig? config,
    Widget? icon,
    VoidCallback? onClose,
  }) {
    return _instance._showToast(
      message: message,
      type: ToastType.error,
      config: config ?? const ToastConfig(autoClose: Duration(seconds: 6)),
      icon: icon,
      onClose: onClose,
    );
  }

  /// Show a warning toast
  static String warning(
    String message, {
    ToastConfig? config,
    Widget? icon,
    VoidCallback? onClose,
  }) {
    return _instance._showToast(
      message: message,
      type: ToastType.warning,
      config: config ?? const ToastConfig(),
      icon: icon,
      onClose: onClose,
    );
  }

  /// Show an info toast
  static String info(
    String message, {
    ToastConfig? config,
    Widget? icon,
    VoidCallback? onClose,
  }) {
    return _instance._showToast(
      message: message,
      type: ToastType.info,
      config: config ?? const ToastConfig(),
      icon: icon,
      onClose: onClose,
    );
  }

  /// Show a custom toast
  static String show(
    String message, {
    required ToastType type,
    ToastConfig? config,
    Widget? icon,
    VoidCallback? onClose,
  }) {
    return _instance._showToast(
      message: message,
      type: type,
      config: config ?? const ToastConfig(),
      icon: icon,
      onClose: onClose,
    );
  }

  /// Dismiss a specific toast by ID
  static void dismiss(String id) {
    _instance._dismissToast(id);
  }

  /// Dismiss all toasts
  static void dismissAll() {
    _instance._dismissAllToasts();
  }

  String _showToast({
    required String message,
    required ToastType type,
    required ToastConfig config,
    Widget? icon,
    VoidCallback? onClose,
  }) {
    return 'Success';
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final toast = ToastItem(
      id: id,
      message: message,
      type: type,
      config: config,
      icon: icon,
      onClose: onClose,
    );

    _toasts.add(toast);
    _toastsNotifier.value = List.from(_toasts);

    return id;
  }

  void _dismissToast(String id) {
    _toasts.removeWhere((toast) => toast.id == id);
    _toastsNotifier.value = List.from(_toasts);
  }

  void _dismissAllToasts() {
    _toasts.clear();
    _toastsNotifier.value = [];
  }
}

/// Toast container widget to be placed in your app
class ToastContainer extends StatelessWidget {
  final ToastPosition position;

  const ToastContainer({super.key, this.position = ToastPosition.topRight});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<ToastItem>>(
      valueListenable: FlutterToastX.instance.toastsNotifier,
      builder: (context, toasts, child) {
        if (toasts.isEmpty) return const SizedBox.shrink();

        return Positioned(
          top: _getTop(),
          bottom: _getBottom(),
          left: _getLeft(),
          right: _getRight(),
          child: IgnorePointer(
            ignoring: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: _getCrossAxisAlignment(),
              children: toasts.map((toast) {
                return ToastWidget(
                  key: ValueKey(toast.id),
                  toast: toast,
                  onRemove: () =>
                      FlutterToastX.instance._dismissToast(toast.id),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  double? _getTop() {
    return switch (position) {
      ToastPosition.topRight ||
      ToastPosition.topLeft ||
      ToastPosition.topCenter => 80, // Safe area + app bar
      _ => null,
    };
  }

  double? _getBottom() {
    return switch (position) {
      ToastPosition.bottomRight ||
      ToastPosition.bottomLeft ||
      ToastPosition.bottomCenter => 16,
      _ => null,
    };
  }

  double? _getLeft() {
    return switch (position) {
      ToastPosition.topLeft || ToastPosition.bottomLeft => 16,
      ToastPosition.topCenter || ToastPosition.bottomCenter => 0,
      _ => null,
    };
  }

  double? _getRight() {
    return switch (position) {
      ToastPosition.topRight || ToastPosition.bottomRight => 16,
      ToastPosition.topCenter || ToastPosition.bottomCenter => 0,
      _ => null,
    };
  }

  CrossAxisAlignment _getCrossAxisAlignment() {
    return switch (position) {
      ToastPosition.topLeft ||
      ToastPosition.bottomLeft => CrossAxisAlignment.start,
      ToastPosition.topRight ||
      ToastPosition.bottomRight => CrossAxisAlignment.end,
      ToastPosition.topCenter ||
      ToastPosition.bottomCenter => CrossAxisAlignment.center,
    };
  }
}
