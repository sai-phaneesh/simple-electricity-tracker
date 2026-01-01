import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

extension ToastExtension on BuildContext {
  void showToast(String message) {
    clearToast();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 3)),
    );
  }

  void clearToast() {
    ScaffoldMessenger.of(this).clearSnackBars();
  }

  /// Shows a styled flushbar notification with theme-aware colors.
  ///
  /// [message] - The main message to display
  /// [title] - Optional title displayed above the message
  /// [type] - The notification type (success, error, warning, info)
  /// [duration] - How long the notification stays visible
  /// [position] - Where to show the notification (top/bottom)
  /// [isDismissible] - Whether user can swipe to dismiss
  /// [showProgressIndicator] - Show a progress bar at the bottom
  Future<void> showFlushbar(
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
    Widget? icon,
    FlushbarPosition flushbarPosition = FlushbarPosition.TOP,
    FlushbarStyle flushbarStyle = FlushbarStyle.FLOATING,
    FlushbarColor backgroundColor = FlushbarColor.info,
    bool isDismissible = true,
    bool showProgressIndicator = false,
  }) async {
    final theme = Theme.of(this);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = backgroundColor.getColorScheme(isDark);

    await Flushbar(
      title: title,
      titleColor: colorScheme.foreground,
      titleSize: 14,
      message: message,
      messageColor: colorScheme.foreground,
      messageSize: 13,
      duration: duration,
      icon: Padding(
        padding: const EdgeInsets.only(left: 12),
        child:
            icon ??
            Icon(colorScheme.icon, color: colorScheme.iconColor, size: 24),
      ),
      flushbarPosition: flushbarPosition,
      flushbarStyle: flushbarStyle,
      backgroundColor: colorScheme.background,
      borderRadius: BorderRadius.circular(12),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      boxShadows: [
        BoxShadow(
          color: colorScheme.shadowColor,
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
      isDismissible: isDismissible,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      forwardAnimationCurve: Curves.easeOutCubic,
      reverseAnimationCurve: Curves.easeInCubic,
      animationDuration: const Duration(milliseconds: 400),
      showProgressIndicator: showProgressIndicator,
      progressIndicatorBackgroundColor: colorScheme.progressBackground,
      progressIndicatorValueColor: AlwaysStoppedAnimation<Color>(
        colorScheme.progressForeground,
      ),
      leftBarIndicatorColor: colorScheme.accentBar,
    ).show(this);
  }

  /// Quick success notification
  Future<void> showSuccess(String message, {String? title}) => showFlushbar(
    message,
    title: title,
    backgroundColor: FlushbarColor.success,
  );

  /// Quick error notification
  Future<void> showError(String message, {String? title}) =>
      showFlushbar(message, title: title, backgroundColor: FlushbarColor.error);

  /// Quick warning notification
  Future<void> showWarning(String message, {String? title}) => showFlushbar(
    message,
    title: title,
    backgroundColor: FlushbarColor.warning,
  );

  /// Quick info notification
  Future<void> showInfo(String message, {String? title}) =>
      showFlushbar(message, title: title, backgroundColor: FlushbarColor.info);
}

/// Color scheme for a flushbar notification
class FlushbarColorScheme {
  final Color background;
  final Color foreground;
  final Color iconColor;
  final IconData icon;
  final Color shadowColor;
  final Color accentBar;
  final Color progressBackground;
  final Color progressForeground;

  const FlushbarColorScheme({
    required this.background,
    required this.foreground,
    required this.iconColor,
    required this.icon,
    required this.shadowColor,
    required this.accentBar,
    required this.progressBackground,
    required this.progressForeground,
  });
}

enum FlushbarColor {
  success,
  error,
  warning,
  info,
  neutral,
  basic;

  FlushbarColorScheme getColorScheme(bool isDark) {
    switch (this) {
      case FlushbarColor.success:
        return isDark
            ? const FlushbarColorScheme(
                background: Color(0xFF1B3D2F),
                foreground: Color(0xFFB8E6C8),
                iconColor: Color(0xFF4ADE80),
                icon: Icons.check_circle_rounded,
                shadowColor: Color(0x404ADE80),
                accentBar: Color(0xFF22C55E),
                progressBackground: Color(0xFF2D5A43),
                progressForeground: Color(0xFF4ADE80),
              )
            : const FlushbarColorScheme(
                background: Color(0xFFDCFCE7),
                foreground: Color(0xFF166534),
                iconColor: Color(0xFF22C55E),
                icon: Icons.check_circle_rounded,
                shadowColor: Color(0x2022C55E),
                accentBar: Color(0xFF22C55E),
                progressBackground: Color(0xFFBBF7D0),
                progressForeground: Color(0xFF22C55E),
              );

      case FlushbarColor.error:
        return isDark
            ? const FlushbarColorScheme(
                background: Color(0xFF3D1B1B),
                foreground: Color(0xFFFECACA),
                iconColor: Color(0xFFF87171),
                icon: Icons.error_rounded,
                shadowColor: Color(0x40F87171),
                accentBar: Color(0xFFEF4444),
                progressBackground: Color(0xFF5A2D2D),
                progressForeground: Color(0xFFF87171),
              )
            : const FlushbarColorScheme(
                background: Color(0xFFFEE2E2),
                foreground: Color(0xFF991B1B),
                iconColor: Color(0xFFDC2626),
                icon: Icons.error_rounded,
                shadowColor: Color(0x20DC2626),
                accentBar: Color(0xFFEF4444),
                progressBackground: Color(0xFFFECACA),
                progressForeground: Color(0xFFEF4444),
              );

      case FlushbarColor.warning:
        return isDark
            ? const FlushbarColorScheme(
                background: Color(0xFF3D351B),
                foreground: Color(0xFFFEF08A),
                iconColor: Color(0xFFFACC15),
                icon: Icons.warning_rounded,
                shadowColor: Color(0x40FACC15),
                accentBar: Color(0xFFEAB308),
                progressBackground: Color(0xFF5A4D2D),
                progressForeground: Color(0xFFFACC15),
              )
            : const FlushbarColorScheme(
                background: Color(0xFFFEF9C3),
                foreground: Color(0xFF854D0E),
                iconColor: Color(0xFFCA8A04),
                icon: Icons.warning_rounded,
                shadowColor: Color(0x20CA8A04),
                accentBar: Color(0xFFEAB308),
                progressBackground: Color(0xFFFEF08A),
                progressForeground: Color(0xFFEAB308),
              );

      case FlushbarColor.info:
        return isDark
            ? const FlushbarColorScheme(
                background: Color(0xFF1B2D3D),
                foreground: Color(0xFFBAE6FD),
                iconColor: Color(0xFF38BDF8),
                icon: Icons.info_rounded,
                shadowColor: Color(0x4038BDF8),
                accentBar: Color(0xFF0EA5E9),
                progressBackground: Color(0xFF2D435A),
                progressForeground: Color(0xFF38BDF8),
              )
            : const FlushbarColorScheme(
                background: Color(0xFFE0F2FE),
                foreground: Color(0xFF075985),
                iconColor: Color(0xFF0284C7),
                icon: Icons.info_rounded,
                shadowColor: Color(0x200284C7),
                accentBar: Color(0xFF0EA5E9),
                progressBackground: Color(0xFFBAE6FD),
                progressForeground: Color(0xFF0EA5E9),
              );

      case FlushbarColor.neutral:
      case FlushbarColor.basic:
        return isDark
            ? const FlushbarColorScheme(
                background: Color(0xFF374151),
                foreground: Color(0xFFE5E7EB),
                iconColor: Color(0xFF9CA3AF),
                icon: Icons.info_outline_rounded,
                shadowColor: Color(0x409CA3AF),
                accentBar: Color(0xFF6B7280),
                progressBackground: Color(0xFF4B5563),
                progressForeground: Color(0xFF9CA3AF),
              )
            : const FlushbarColorScheme(
                background: Color(0xFFF3F4F6),
                foreground: Color(0xFF374151),
                iconColor: Color(0xFF6B7280),
                icon: Icons.info_outline_rounded,
                shadowColor: Color(0x206B7280),
                accentBar: Color(0xFF9CA3AF),
                progressBackground: Color(0xFFE5E7EB),
                progressForeground: Color(0xFF6B7280),
              );
    }
  }

  // Keep backward compatibility
  Color get backgroundColor => getColorScheme(false).background;
  Color get textColor => getColorScheme(false).foreground;
  IconData get icon => getColorScheme(false).icon;
}
