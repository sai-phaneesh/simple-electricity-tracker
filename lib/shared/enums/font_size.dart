/// Font size options for the app
enum AppFontSize {
  small('Small', 'Compact text for more content', 0.85),
  medium('Medium', 'Default comfortable reading size', 1.0),
  large('Large', 'Larger text for better readability', 1.15),
  extraLarge('Extra Large', 'Maximum text size for accessibility', 1.3);

  const AppFontSize(this.label, this.description, this.scaleFactor);

  final String label;
  final String description;
  final double scaleFactor;

  /// Get font size from string
  static AppFontSize fromString(String value) {
    return AppFontSize.values.firstWhere(
      (size) => size.name == value,
      orElse: () => AppFontSize.medium,
    );
  }

  /// Get scaled font size for specific text style
  double scaleSize(double baseSize) {
    return baseSize * scaleFactor;
  }

  /// Get icon representing this font size
  String get icon {
    switch (this) {
      case AppFontSize.small:
        return 'A⁻';
      case AppFontSize.medium:
        return 'A';
      case AppFontSize.large:
        return 'A⁺';
      case AppFontSize.extraLarge:
        return 'A⁺⁺';
    }
  }
}
