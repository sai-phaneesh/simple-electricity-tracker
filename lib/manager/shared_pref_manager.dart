import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../shared/theme_cubit/theme_cubit.dart';

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
  Future<void> saveThemeMode({required ThemeState theme}) async {
    await _prefs.setString(_keyThemeMode, json.encode(theme.toJson()));
  }

  // Get the theme mode
  ThemeState getThemeMode() {
    final themeString = _prefs.getString(_keyThemeMode);
    final themeJson = themeString == null
        ? ThemeState.initial().toJson()
        : json.decode(themeString);
    final ThemeState themeState = ThemeState.fromJson(themeJson);
    return themeState;
    // switch (theme) {
    //   case "light":
    //     return ThemeMode.light;
    //   case "dark":
    //     return ThemeMode.dark;
    //   default:
    //     return ThemeMode.system;
    // }
  }

  void clear() {
    _prefs.clear();
  }
}
