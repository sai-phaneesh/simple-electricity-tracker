import 'package:flutter/services.dart';

class DecimalTextInputFormatter extends TextInputFormatter {
  final int decimalRange;

  const DecimalTextInputFormatter({this.decimalRange = 2})
      : assert(decimalRange >= 0);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;

    // Allow only digits and a single dot
    final regExp = RegExp(r'^\d*\.?\d*$');
    if (!regExp.hasMatch(text)) {
      return oldValue;
    }

    // Prevent multiple dots
    if (text.indexOf('.') != text.lastIndexOf('.')) {
      return oldValue;
    }

    // Prevents leading zeros (except for cases like '0.')
    if (text.startsWith('00')) {
      return oldValue;
    }

    // Allow single dot at the beginning
    if (text == ".") {
      text = "0.";
    }

    // Truncate decimal places
    if (text.contains(".") && text.split(".").length > 1) {
      String beforeDecimal = text.split(".")[0];
      String afterDecimal = text.split(".")[1];

      if (afterDecimal.length > decimalRange) {
        afterDecimal = afterDecimal.substring(0, decimalRange);
      }

      text = "$beforeDecimal.$afterDecimal";
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
