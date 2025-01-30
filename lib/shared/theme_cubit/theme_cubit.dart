import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../manager/shared_pref_manager.dart';

class ThemeState {
  final ThemeMode mode;
  // final Brightness brightness;
  const ThemeState({
    required this.mode,
    // required this.brightness,
  });

  ThemeState copyWith({
    ThemeMode? mode,
    // Brightness? brightness,
  }) {
    return ThemeState(
      mode: mode ?? this.mode,
      // brightness: brightness ?? this.brightness,
    );
  }

  factory ThemeState.fromJson(Map<String, dynamic> json) {
    return ThemeState(
      mode: ThemeMode.values.firstWhere((e) => e.name == json['mode']),
      // brightness:
      // Brightness.values.firstWhere((e) => e.name == json['brightness']),
    );
  }

  factory ThemeState.initial() {
    return const ThemeState(
      mode: ThemeMode.system,
      // brightness: Brightness.light,
    );
  }

  Map<String, dynamic> toJson() => {
        'mode': mode.name,
        // 'brightness': brightness.name,
      };
}

class ThemeCubit extends Cubit<ThemeState> {
  final SharedPrefManager _prefs;
  ThemeCubit(
    this._prefs, {
    required ThemeState initialTheme,
  }) : super(initialTheme);

  void changeThemeState(ThemeState mode) {
    emit(mode);
    _prefs.saveThemeMode(theme: mode);
    // emit(ThemeState(mode: mode, brightness: brightness));
    // _prefs.saveThemeMode(theme: state);
    // print(mode);
    // print(brightness);
  }

  void toggleThemeState() {
    late final ThemeMode newThemeMode;
    switch (state.mode) {
      case ThemeMode.light:
        newThemeMode = ThemeMode.dark;
        break;
      case ThemeMode.dark:
        newThemeMode = ThemeMode.system;
        break;
      case ThemeMode.system:
        newThemeMode = ThemeMode.light;
        break;
    }
    emit(state.copyWith(mode: newThemeMode));
    _prefs.saveThemeMode(theme: state);
  }
}
