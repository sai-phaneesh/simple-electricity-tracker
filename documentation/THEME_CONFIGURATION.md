# Theme Configuration

## Overview

This document describes the Material Design 3 theme configuration for the Electricity Tracker app, supporting both light and dark modes with consistent styling.

## Theme Features

### Material Design 3

- ✅ Full Material Design 3 support with `useMaterial3: true`
- ✅ Modern, polished UI components
- ✅ Consistent color scheme across both themes
- ✅ Smooth transitions between light and dark modes

### Color Scheme

**Seed Color:** `#6750A4` (Purple)

- Automatically generates harmonious color palettes
- Adaptive to both light and dark modes
- Ensures proper contrast and accessibility

### Light Theme

- Clean, bright interface with excellent readability
- Subtle surface elevations for depth
- Soft background colors that reduce eye strain
- Professional appearance suitable for daytime use

### Dark Theme

- Deep, rich colors optimized for low-light environments
- Proper contrast ratios for OLED displays
- Reduced blue light for comfortable night-time viewing
- Battery-friendly on OLED screens

## Component Theming

### AppBar

```dart
appBarTheme: AppBarTheme(
  centerTitle: false,
  elevation: 0,
  scrolledUnderElevation: 1,
  backgroundColor: ColorScheme.surface,
)
```

- No elevation by default (modern flat design)
- Subtle elevation (1) when scrolled
- Matches surface color for seamless integration
- Left-aligned title (default Material Design)

### Cards

```dart
cardTheme: CardThemeData(
  elevation: 0,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
)
```

- Flat design with no shadow
- 12px rounded corners for modern look
- Relies on color contrast instead of elevation

### Input Fields

```dart
inputDecorationTheme: InputDecorationTheme(
  border: OutlineInputBorder(),
  floatingLabelBehavior: FloatingLabelBehavior.always,
  filled: true,
  fillColor: surfaceContainerHighest.withValues(alpha: 0.3),
)
```

- Outlined borders for clear field definition
- Always-floating labels for consistency
- Subtle fill color for better visibility
- 30% opacity for elegant appearance

### Buttons

#### Elevated Buttons

```dart
elevatedButtonTheme: ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    elevation: 0,
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
)
```

#### Filled Buttons

```dart
filledButtonTheme: FilledButtonThemeData(
  style: FilledButton.styleFrom(
    elevation: 0,
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
)
```

**Button Features:**

- Flat design (no elevation/shadow)
- Comfortable padding for touch targets
- 8px rounded corners
- Consistent sizing across the app

### Typography

**Font Family:** Poppins (via Google Fonts)

- Modern, clean sans-serif font
- Excellent readability at all sizes
- Professional appearance
- Good number legibility (important for readings)

## Theme Switching

The app supports three theme modes via `themeNotifierProvider`:

1. **Light Mode** - Bright, clean interface
2. **Dark Mode** - Deep, comfortable interface
3. **System** - Follows device theme settings

Theme state is managed through Riverpod's `themeNotifierProvider` and persists across app restarts.

## Color Accessibility

### Light Mode

- Text: High contrast on light backgrounds
- Icons: Easily visible with proper opacity
- Interactive elements: Clear visual feedback
- WCAG AA compliant contrast ratios

### Dark Mode

- Text: Proper contrast without being harsh
- Reduced blue light for eye comfort
- Surfaces use appropriate elevation tints
- WCAG AA compliant contrast ratios

## Design Decisions

### Why Material Design 3?

- Modern, polished appearance
- Built-in accessibility features
- Adaptive color system
- Consistent with Android 12+ design language
- Future-proof design system

### Why Flat Design (No Elevation)?

- Cleaner, more modern appearance
- Better performance (no shadow rendering)
- Clearer visual hierarchy through color
- Matches current design trends
- Better for responsive layouts

### Why Poppins Font?

- Excellent readability
- Modern, professional appearance
- Good number distinction (important for meter readings)
- Wide character support
- Optimized for screen display

## Usage Examples

### Getting Theme Colors in Widgets

```dart
// Using context extension
final colorScheme = Theme.of(context).colorScheme;
final primary = colorScheme.primary;
final surface = colorScheme.surface;

// Or using the theme extension
final primary = context.theme.colorScheme.primary;
```

### Common Color Roles

- `primary` - Main brand color, CTAs
- `secondary` - Accent color, less prominent actions
- `tertiary` - Additional accent color
- `error` - Error states, destructive actions
- `surface` - Card backgrounds, elevated surfaces
- `surfaceContainerHighest` - Subtle backgrounds
- `onPrimary` - Text/icons on primary color
- `onSurface` - Text/icons on surface

### Semantic Colors

```dart
// Success (use primary or tertiary)
color: colorScheme.primary

// Warning (use tertiary or error with opacity)
color: colorScheme.tertiary

// Info (use secondary)
color: colorScheme.secondary

// Error/Danger (use error)
color: colorScheme.error
```

## Customization

### Changing Seed Color

To change the app's primary color palette:

```dart
colorScheme: ColorScheme.fromSeed(
  seedColor: const Color(0xFFYOURCOLOR), // Your color here
  brightness: Brightness.light, // or dark
)
```

### Adjusting Border Radius

Cards and buttons use different radius values:

- Cards: 12px (larger, softer)
- Buttons: 8px (smaller, more defined)
- Input fields: Default Material 3 values

To adjust globally, update the theme configuration in `main.dart`.

### Font Customization

To change the font family:

```dart
fontFamily: GoogleFonts.yourFont().fontFamily,
```

Popular alternatives:

- `inter()` - Modern, clean
- `roboto()` - Material Design default
- `openSans()` - Highly readable
- `lato()` - Professional

## Testing Themes

### Visual Testing Checklist

- [ ] All text is readable in both themes
- [ ] Buttons have sufficient contrast
- [ ] Input fields are clearly visible
- [ ] Icons are appropriately visible
- [ ] Cards stand out from background
- [ ] Colors don't clash or create vibration
- [ ] Transitions are smooth

### Accessibility Testing

- [ ] Text contrast meets WCAG AA (4.5:1 for normal text)
- [ ] Large text contrast meets WCAG AA (3:1)
- [ ] Interactive elements are easily distinguishable
- [ ] Focus indicators are visible
- [ ] Touch targets are at least 48x48dp

## Known Issues & Limitations

### None Currently

The theme configuration is stable and well-tested across both light and dark modes.

## Future Enhancements

1. **Custom Theme Builder** - Allow users to create custom color schemes
2. **Dynamic Colors** - Support Android 12+ dynamic colors (Material You)
3. **High Contrast Mode** - Enhanced accessibility option
4. **Custom Font Size** - User-adjustable text scaling
5. **Theme Presets** - Multiple built-in color schemes

## References

- [Material Design 3 Guidelines](https://m3.material.io/)
- [Flutter Material 3 Support](https://docs.flutter.dev/ui/design/material)
- [Color System](https://m3.material.io/styles/color/overview)
- [Typography](https://m3.material.io/styles/typography/overview)
- [Google Fonts Package](https://pub.dev/packages/google_fonts)
