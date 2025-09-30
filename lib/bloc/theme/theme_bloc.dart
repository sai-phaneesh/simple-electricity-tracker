import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:electricity/shared/enums/theme_mode.dart';

/// Events for theme management
abstract class ThemeEvent {}

class ThemeChanged extends ThemeEvent {
  final AppThemeMode themeMode;
  ThemeChanged(this.themeMode);
}

class ThemeInitialized extends ThemeEvent {}

/// State for theme management
class ThemeState {
  final AppThemeMode themeMode;
  final bool isLoading;

  const ThemeState({required this.themeMode, this.isLoading = false});

  ThemeState copyWith({AppThemeMode? themeMode, bool? isLoading}) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Bloc for managing app theme
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const String _themeKey = 'app_theme_mode';

  ThemeBloc() : super(const ThemeState(themeMode: AppThemeMode.system)) {
    on<ThemeInitialized>(_onThemeInitialized);
    on<ThemeChanged>(_onThemeChanged);
  }

  /// Initialize theme from saved preferences
  Future<void> _onThemeInitialized(
    ThemeInitialized event,
    Emitter<ThemeState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString(_themeKey);

      final themeMode = savedTheme != null
          ? AppThemeMode.fromString(savedTheme)
          : AppThemeMode.system;

      emit(state.copyWith(themeMode: themeMode, isLoading: false));
    } catch (e) {
      emit(state.copyWith(themeMode: AppThemeMode.system, isLoading: false));
    }
  }

  /// Handle theme change
  Future<void> _onThemeChanged(
    ThemeChanged event,
    Emitter<ThemeState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeKey, event.themeMode.name);

      emit(state.copyWith(themeMode: event.themeMode, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }
}
