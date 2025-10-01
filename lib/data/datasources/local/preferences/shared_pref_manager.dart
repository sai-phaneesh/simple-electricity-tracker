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
  static const _keySelectedHouseId = "selected_house_id";
  static const _keySelectedCycleId = "selected_cycle_id";

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

  Future<void> saveSelectedHouseId(String? houseId) async {
    if (houseId == null) {
      await _prefs.remove(_keySelectedHouseId);
      return;
    }
    await _prefs.setString(_keySelectedHouseId, houseId);
  }

  String? getSelectedHouseId() => _prefs.getString(_keySelectedHouseId);

  Future<void> saveSelectedCycleId(String? cycleId) async {
    if (cycleId == null) {
      await _prefs.remove(_keySelectedCycleId);
      return;
    }
    await _prefs.setString(_keySelectedCycleId, cycleId);
  }

  String? getSelectedCycleId() => _prefs.getString(_keySelectedCycleId);

  void clear() {
    _prefs.clear();
  }
}
