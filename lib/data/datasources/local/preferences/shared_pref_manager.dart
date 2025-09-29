import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefManager {
  static final SharedPrefManager _instance = SharedPrefManager._internal();
  static late SharedPreferences _prefs;

  // Private constructor for the singleton
  SharedPrefManager._internal();

  // Factory constructor for returning the singleton instance
  factory SharedPrefManager() {
    return _instance;
  }

  // Initialize SharedPreferences instance (call this once, e.g., in `main()`)
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Constants for keys
  static const _keyThemeMode = "theme_mode";

  // Save the theme mode
  Future<void> saveThemeMode({required Map<String, dynamic> themeJson}) async {
    await _prefs.setString(_keyThemeMode, json.encode(themeJson));
  }

  // Get the theme mode
  Map<String, dynamic>? getThemeModeJson() {
    final themeString = _prefs.getString(_keyThemeMode);
    if (themeString == null) return null;
    final dynamic decoded = json.decode(themeString);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }
    return null;
  }

  void clear() {
    _prefs.clear();
  }
}
