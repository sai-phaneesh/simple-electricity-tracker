import 'package:flutter/material.dart';
import 'package:electricity/shared/enums/font_size.dart';

/// Custom color schemes for the electricity tracker app
class AppColorSchemes {
  /// Light color scheme with electricity theme
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF1565C0), // Deep blue for electricity theme
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFBBDEFB),
    onPrimaryContainer: Color(0xFF0D47A1),
    secondary: Color(0xFF4CAF50), // Green for positive energy
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFC8E6C9),
    onSecondaryContainer: Color(0xFF1B5E20),
    tertiary: Color(0xFFFF9800), // Orange for warnings/alerts
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFFFE0B2),
    onTertiaryContainer: Color(0xFFE65100),
    error: Color(0xFFD32F2F),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFFEBEE),
    onErrorContainer: Color(0xFFB71C1C),
    outline: Color(0xFF79747E),
    surface: Color(0xFFFFFBFE),
    onSurface: Color(0xFF1C1B1F),
    surfaceContainerHighest: Color(0xFFE7E0EC),
    onSurfaceVariant: Color(0xFF49454F),
    inverseSurface: Color(0xFF313033),
    onInverseSurface: Color(0xFFF4EFF4),
    inversePrimary: Color(0xFF90CAF9),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    surfaceTint: Color(0xFF1565C0),
  );

  /// Dark color scheme with electricity theme
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF90CAF9), // Light blue for dark mode
    onPrimary: Color(0xFF0D47A1),
    primaryContainer: Color(0xFF1976D2),
    onPrimaryContainer: Color(0xFFE3F2FD),
    secondary: Color(0xFF81C784), // Light green for dark mode
    onSecondary: Color(0xFF1B5E20),
    secondaryContainer: Color(0xFF388E3C),
    onSecondaryContainer: Color(0xFFE8F5E8),
    tertiary: Color(0xFFFFB74D), // Light orange for dark mode
    onTertiary: Color(0xFFE65100),
    tertiaryContainer: Color(0xFFF57C00),
    onTertiaryContainer: Color(0xFFFFF3E0),
    error: Color(0xFFEF5350),
    onError: Color(0xFFB71C1C),
    errorContainer: Color(0xFFC62828),
    onErrorContainer: Color(0xFFFFEBEE),
    outline: Color(0xFF938F99),
    surface: Color(0xFF10131A),
    onSurface: Color(0xFFE6E1E5),
    surfaceContainerHighest: Color(0xFF49454F),
    onSurfaceVariant: Color(0xFFCAC4D0),
    inverseSurface: Color(0xFFE6E1E5),
    onInverseSurface: Color(0xFF313033),
    inversePrimary: Color(0xFF1565C0),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    surfaceTint: Color(0xFF90CAF9),
  );
}

/// App themes configuration
class AppThemes {
  /// Get light theme with font scaling
  static ThemeData lightTheme([AppFontSize fontSize = AppFontSize.medium]) =>
      _buildLightTheme(fontSize);

  /// Get dark theme with font scaling
  static ThemeData darkTheme([AppFontSize fontSize = AppFontSize.medium]) =>
      _buildDarkTheme(fontSize);

  /// Light theme
  static ThemeData _buildLightTheme(AppFontSize fontSize) => ThemeData(
    useMaterial3: true,
    colorScheme: AppColorSchemes.lightColorScheme,
    fontFamily: 'Roboto',

    // Text theme with font scaling
    textTheme: _getScaledTextTheme(ThemeData.light().textTheme, fontSize),

    // AppBar theme
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 0,
    ), // Card theme
    cardTheme: CardThemeData(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),

    // Navigation themes
    navigationBarTheme: NavigationBarThemeData(
      elevation: 3,
      height: 80,
      indicatorColor: AppColorSchemes.lightColorScheme.primaryContainer,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(fontSize: 12, fontWeight: FontWeight.w600);
        }
        return const TextStyle(fontSize: 12, fontWeight: FontWeight.w400);
      }),
    ),

    navigationRailTheme: NavigationRailThemeData(
      elevation: 1,
      indicatorColor: AppColorSchemes.lightColorScheme.primaryContainer,
      selectedIconTheme: IconThemeData(
        color: AppColorSchemes.lightColorScheme.onPrimaryContainer,
      ),
      selectedLabelTextStyle: const TextStyle(fontWeight: FontWeight.w600),
    ),

    // List tile theme
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    ),

    // Switch theme
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.white; // Always white thumb when active
        }
        if (states.contains(WidgetState.disabled)) {
          return AppColorSchemes.lightColorScheme.onSurface.withValues(
            alpha: 0.38,
          );
        }
        return AppColorSchemes
            .lightColorScheme
            .outline; // Gray thumb when inactive
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColorSchemes
              .lightColorScheme
              .primary; // Blue track when active
        }
        if (states.contains(WidgetState.disabled)) {
          return AppColorSchemes.lightColorScheme.onSurface.withValues(
            alpha: 0.12,
          );
        }
        return AppColorSchemes.lightColorScheme.outline.withValues(
          alpha: 0.32,
        ); // Gray track when inactive
      }),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return AppColorSchemes.lightColorScheme.primary.withValues(
            alpha: 0.12,
          );
        }
        return null;
      }),
    ),

    // Input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),

    // Elevated button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),

    // Floating action button theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 3,
      highlightElevation: 6,
    ),
  );

  /// Dark theme
  static ThemeData _buildDarkTheme(AppFontSize fontSize) => ThemeData(
    useMaterial3: true,
    colorScheme: AppColorSchemes.darkColorScheme,
    fontFamily: 'Roboto',

    // Text theme with font scaling
    textTheme: _getScaledTextTheme(ThemeData.dark().textTheme, fontSize),

    // AppBar theme
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 1,
    ), // Card theme
    cardTheme: CardThemeData(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),

    // Navigation themes
    navigationBarTheme: NavigationBarThemeData(
      elevation: 3,
      height: 80,
      indicatorColor: AppColorSchemes.darkColorScheme.primaryContainer,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(fontSize: 12, fontWeight: FontWeight.w600);
        }
        return const TextStyle(fontSize: 12, fontWeight: FontWeight.w400);
      }),
    ),

    navigationRailTheme: NavigationRailThemeData(
      elevation: 1,
      indicatorColor: AppColorSchemes.darkColorScheme.primaryContainer,
      selectedIconTheme: IconThemeData(
        color: AppColorSchemes.darkColorScheme.onPrimaryContainer,
      ),
      selectedLabelTextStyle: const TextStyle(fontWeight: FontWeight.w600),
    ),

    // List tile theme
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    ),

    // Switch theme
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.white; // Always white thumb when active for contrast
        }
        if (states.contains(WidgetState.disabled)) {
          return AppColorSchemes.darkColorScheme.onSurface.withValues(
            alpha: 0.38,
          );
        }
        return AppColorSchemes
            .darkColorScheme
            .outline; // Gray thumb when inactive
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColorSchemes
              .darkColorScheme
              .primary; // Light blue track when active
        }
        if (states.contains(WidgetState.disabled)) {
          return AppColorSchemes.darkColorScheme.onSurface.withValues(
            alpha: 0.12,
          );
        }
        return AppColorSchemes.darkColorScheme.outline.withValues(
          alpha: 0.32,
        ); // Gray track when inactive
      }),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return AppColorSchemes.darkColorScheme.primary.withValues(
            alpha: 0.12,
          );
        }
        return null;
      }),
    ),

    // Input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),

    // Elevated button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),

    // Floating action button theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 3,
      highlightElevation: 6,
    ),
  );

  /// Scale text theme based on font size preference
  static TextTheme _getScaledTextTheme(
    TextTheme baseTheme,
    AppFontSize fontSize,
  ) {
    return baseTheme.copyWith(
      displayLarge: baseTheme.displayLarge?.copyWith(
        fontSize: fontSize.scaleSize(baseTheme.displayLarge?.fontSize ?? 57),
      ),
      displayMedium: baseTheme.displayMedium?.copyWith(
        fontSize: fontSize.scaleSize(baseTheme.displayMedium?.fontSize ?? 45),
      ),
      displaySmall: baseTheme.displaySmall?.copyWith(
        fontSize: fontSize.scaleSize(baseTheme.displaySmall?.fontSize ?? 36),
      ),
      headlineLarge: baseTheme.headlineLarge?.copyWith(
        fontSize: fontSize.scaleSize(baseTheme.headlineLarge?.fontSize ?? 32),
      ),
      headlineMedium: baseTheme.headlineMedium?.copyWith(
        fontSize: fontSize.scaleSize(baseTheme.headlineMedium?.fontSize ?? 28),
      ),
      headlineSmall: baseTheme.headlineSmall?.copyWith(
        fontSize: fontSize.scaleSize(baseTheme.headlineSmall?.fontSize ?? 24),
      ),
      titleLarge: baseTheme.titleLarge?.copyWith(
        fontSize: fontSize.scaleSize(baseTheme.titleLarge?.fontSize ?? 22),
      ),
      titleMedium: baseTheme.titleMedium?.copyWith(
        fontSize: fontSize.scaleSize(baseTheme.titleMedium?.fontSize ?? 16),
      ),
      titleSmall: baseTheme.titleSmall?.copyWith(
        fontSize: fontSize.scaleSize(baseTheme.titleSmall?.fontSize ?? 14),
      ),
      bodyLarge: baseTheme.bodyLarge?.copyWith(
        fontSize: fontSize.scaleSize(baseTheme.bodyLarge?.fontSize ?? 16),
      ),
      bodyMedium: baseTheme.bodyMedium?.copyWith(
        fontSize: fontSize.scaleSize(baseTheme.bodyMedium?.fontSize ?? 14),
      ),
      bodySmall: baseTheme.bodySmall?.copyWith(
        fontSize: fontSize.scaleSize(baseTheme.bodySmall?.fontSize ?? 12),
      ),
      labelLarge: baseTheme.labelLarge?.copyWith(
        fontSize: fontSize.scaleSize(baseTheme.labelLarge?.fontSize ?? 14),
      ),
      labelMedium: baseTheme.labelMedium?.copyWith(
        fontSize: fontSize.scaleSize(baseTheme.labelMedium?.fontSize ?? 12),
      ),
      labelSmall: baseTheme.labelSmall?.copyWith(
        fontSize: fontSize.scaleSize(baseTheme.labelSmall?.fontSize ?? 11),
      ),
    );
  }
}
