/// Theme mode options for the app
enum AppThemeMode {
  light('Light', 'Use light theme'),
  dark('Dark', 'Use dark theme'),
  system('System', 'Follow system theme');

  const AppThemeMode(this.label, this.description);

  final String label;
  final String description;

  /// Get theme mode from string
  static AppThemeMode fromString(String value) {
    return AppThemeMode.values.firstWhere(
      (mode) => mode.name == value,
      orElse: () => AppThemeMode.system,
    );
  }
}
