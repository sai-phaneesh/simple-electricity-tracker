import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

extension ToastExtension on BuildContext {
  void showToast(String message) {
    clearToast();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void clearToast() {
    ScaffoldMessenger.of(this).clearSnackBars();
  }

  Future<void> showFlushbar(
    String message, {
    Duration duration = const Duration(seconds: 1),
    Widget? icon,
    FlushbarPosition flushbarPosition = FlushbarPosition.TOP,
    FlushbarStyle flushbarStyle = FlushbarStyle.GROUNDED,
    FlushbarColor backgroundColor = FlushbarColor.basic,
  }) async {
    await Flushbar(
      message: message,
      duration: duration,
      icon: icon,
      flushbarPosition: flushbarPosition,
      flushbarStyle: flushbarStyle,
      backgroundColor: backgroundColor.backgroundColor,
    ).show(this);
  }
}

enum FlushbarColor {
  success(
    Colors.green, // background color
    Colors.white, // text color
    Icons.check_circle, // icon
  ),
  error(
    Colors.red, // background color
    Colors.white, // text color
    Icons.error, // icon
  ),
  warning(
    Colors.amber, // background color
    Colors.black, // text color
    Icons.warning, // icon
  ),
  info(
    Colors.blue, // background color
    Colors.white, // text color
    Icons.info, // icon
  ),
  neutral(
    Colors.grey, // background color
    Colors.white, // text color
    Icons.info_outline, // icon
  ),
  basic(
    Color(0xFF303030),
    Colors.white,
    Icons.info,
  );

  final Color backgroundColor;
  final Color textColor;
  final IconData icon;

  const FlushbarColor(this.backgroundColor, this.textColor, this.icon);
}
