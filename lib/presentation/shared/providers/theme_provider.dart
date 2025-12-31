import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:electricity/core/providers/app_providers.dart';

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

class ThemeNotifier extends Notifier<ThemeState> {
  @override
  ThemeState build() {
    final prefs = ref.watch(sharedPrefManagerProvider);
    final savedTheme = prefs.getThemeModeJson();
    return savedTheme != null
        ? ThemeState.fromJson(savedTheme)
        : ThemeState.initial();
  }

  void setThemeMode(ThemeMode mode) {
    if (state.mode == mode) return;
    state = state.copyWith(mode: mode);
    final prefs = ref.read(sharedPrefManagerProvider);
    prefs.saveThemeMode(themeJson: state.toJson());
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

final themeNotifierProvider = NotifierProvider<ThemeNotifier, ThemeState>(
  ThemeNotifier.new,
);
