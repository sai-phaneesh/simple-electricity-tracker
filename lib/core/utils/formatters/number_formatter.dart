import 'package:intl/intl.dart';

/// Utility class for formatting numbers with locale-specific formatting
class AppNumberFormatter {
  AppNumberFormatter._();

  /// Format currency with rupee symbol and proper thousands separators
  /// Hides decimals for whole numbers
  /// Example: 1234.56 -> ₹1,234.56, 1234.00 -> ₹1,234
  static String formatCurrency(num value) {
    final isWholeNumber = value == value.toInt();
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: isWholeNumber ? 0 : 2,
    );
    return formatter.format(value);
  }

  /// Format units/numbers with thousands separators but no decimal places
  /// Example: 1234 -> 1,234
  static String formatUnits(int value) {
    final formatter = NumberFormat('#,##,###', 'en_IN');
    return formatter.format(value);
  }

  /// Format numbers with thousands separators and optional decimal places
  /// Hides decimals for whole numbers
  /// Example: 1234.56 -> 1,234.56, 1234.00 -> 1,234
  static String formatNumber(num value, {int decimalDigits = 2}) {
    final isWholeNumber = value == value.toInt();
    if (isWholeNumber) {
      final formatter = NumberFormat('#,##,###', 'en_IN');
      return formatter.format(value.toInt());
    } else {
      final formatter = NumberFormat(
        '#,##,##0.${'0' * decimalDigits}',
        'en_IN',
      );
      return formatter.format(value);
    }
  }

  /// Format meter reading (with thousands separator and decimals)
  /// Hides decimals for whole numbers
  /// Example: 12345.67 -> 12,345.67, 12345.00 -> 12,345
  static String formatMeterReading(num value) {
    final isWholeNumber = value == value.toInt();
    if (isWholeNumber) {
      final formatter = NumberFormat('#,##,###', 'en_IN');
      return formatter.format(value.toInt());
    } else {
      final formatter = NumberFormat('#,##,##0.##', 'en_IN');
      return formatter.format(value);
    }
  }
}
