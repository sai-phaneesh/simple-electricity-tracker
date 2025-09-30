import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:electricity/shared/enums/font_size.dart';

/// Events for font size management
abstract class FontSizeEvent {}

class FontSizeChanged extends FontSizeEvent {
  final AppFontSize fontSize;
  FontSizeChanged(this.fontSize);
}

class FontSizeInitialized extends FontSizeEvent {}

/// State for font size management
class FontSizeState {
  final AppFontSize fontSize;
  final bool isLoading;

  const FontSizeState({required this.fontSize, this.isLoading = false});

  FontSizeState copyWith({AppFontSize? fontSize, bool? isLoading}) {
    return FontSizeState(
      fontSize: fontSize ?? this.fontSize,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Bloc for managing app font size
class FontSizeBloc extends Bloc<FontSizeEvent, FontSizeState> {
  static const String _fontSizeKey = 'app_font_size';

  FontSizeBloc() : super(const FontSizeState(fontSize: AppFontSize.medium)) {
    on<FontSizeInitialized>(_onFontSizeInitialized);
    on<FontSizeChanged>(_onFontSizeChanged);
  }

  /// Initialize font size from saved preferences
  Future<void> _onFontSizeInitialized(
    FontSizeInitialized event,
    Emitter<FontSizeState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedFontSize = prefs.getString(_fontSizeKey);

      final fontSize = savedFontSize != null
          ? AppFontSize.fromString(savedFontSize)
          : AppFontSize.medium;

      emit(state.copyWith(fontSize: fontSize, isLoading: false));
    } catch (e) {
      emit(state.copyWith(fontSize: AppFontSize.medium, isLoading: false));
    }
  }

  /// Handle font size change
  Future<void> _onFontSizeChanged(
    FontSizeChanged event,
    Emitter<FontSizeState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_fontSizeKey, event.fontSize.name);

      emit(state.copyWith(fontSize: event.fontSize, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }
}
