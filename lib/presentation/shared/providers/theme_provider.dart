import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:electricity/core/providers/app_providers.dart';
import 'package:electricity/data/datasources/local/preferences/shared_pref_manager.dart';

class ThemeState {
  const ThemeState({required this.mode});

  final ThemeMode mode;

  ThemeState copyWith({ThemeMode? mode}) {
    return ThemeState(mode: mode ?? this.mode);
  }

  factory ThemeState.fromJson(Map<String, dynamic> json) {
    return ThemeState(
      mode: ThemeMode.values.firstWhere(
        (element) => element.name == json['mode'],
        orElse: () => ThemeMode.system,
      ),
    );
  }

  factory ThemeState.initial() => const ThemeState(mode: ThemeMode.system);

  Map<String, dynamic> toJson() => {'mode': mode.name};
}

class ThemeNotifier extends StateNotifier<ThemeState> {
  ThemeNotifier(this._prefs, ThemeState initialState) : super(initialState);

  final SharedPrefManager _prefs;

  void setThemeMode(ThemeMode mode) {
    if (state.mode == mode) return;
    state = state.copyWith(mode: mode);
    _prefs.saveThemeMode(themeJson: state.toJson());
  }

  void toggleThemeMode() {
    late final ThemeMode next;
    switch (state.mode) {
      case ThemeMode.light:
        next = ThemeMode.dark;
        break;
      case ThemeMode.dark:
        next = ThemeMode.system;
        break;
      case ThemeMode.system:
        next = ThemeMode.light;
        break;
    }
    setThemeMode(next);
  }
}

final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((
  ref,
) {
  final prefs = ref.watch(sharedPrefManagerProvider);
  final stored = prefs.getThemeModeJson();
  final initialState = stored == null
      ? ThemeState.initial()
      : ThemeState.fromJson(stored);
  return ThemeNotifier(prefs, initialState);
});
