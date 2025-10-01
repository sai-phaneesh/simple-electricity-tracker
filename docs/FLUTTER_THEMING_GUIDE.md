# Flutter Theming Guide: Complete Reference

## Table of Contents

1. [Theme Basics](#theme-basics)
2. [ColorScheme Deep Dive](#colorscheme-deep-dive)
3. [Component Themes](#component-themes)
4. [Theme Inheritance](#theme-inheritance)
5. [Practical Examples](#practical-examples)
6. [Common Patterns](#common-patterns)

---

## Theme Basics

### What is a Theme?

A theme is a collection of visual properties (colors, fonts, shapes) that define how your app looks. Flutter uses Material Design principles with the `ThemeData` class.

### Basic Theme Structure

```dart
MaterialApp(
  theme: ThemeData(
    // Your theme configuration
  ),
  darkTheme: ThemeData(
    // Your dark theme configuration
  ),
  themeMode: ThemeMode.system, // or .light or .dark
)
```

### Theme Hierarchy

```
ThemeData
├── ColorScheme (colors)
├── TextTheme (typography)
├── Component Themes (widgets)
│   ├── AppBarTheme
│   ├── CardTheme
│   ├── ButtonThemes
│   └── ... many more
└── Other properties
```

---

## ColorScheme Deep Dive

### What is ColorScheme?

`ColorScheme` defines the color palette for your entire app. Material Design 3 uses a **seed color** to generate a harmonious color palette.

### ColorScheme.fromSeed()

**What it does:** Generates a complete color palette from a single seed color.

```dart
// Example: Purple-based color scheme
ColorScheme.fromSeed(
  seedColor: Color(0xFF6750A4), // Purple
  brightness: Brightness.light,
)
```

**What changes:**

- Primary colors (buttons, FABs, active states)
- Secondary colors (chips, sliders)
- Tertiary colors (accents)
- Error colors
- Surface colors
- Background colors
- All derived shades and tints

### ColorScheme Properties Explained

#### 1. **Primary Colors**

```dart
ColorScheme(
  primary: Color(0xFF6750A4),        // Main brand color
  onPrimary: Color(0xFFFFFFFF),      // Text/icons ON primary
  primaryContainer: Color(0xFFEADDFF), // Lighter primary variant
  onPrimaryContainer: Color(0xFF21005D), // Text ON primaryContainer
)
```

**What uses these:**

- `primary`: Filled buttons, FAB, active navigation items
- `onPrimary`: Text on filled buttons
- `primaryContainer`: Chip backgrounds, selected states
- `onPrimaryContainer`: Text on chips

**Example:**

```dart
// FilledButton uses 'primary' as background
FilledButton(
  onPressed: () {},
  child: Text('Click'), // Text uses 'onPrimary'
)

// Chip uses 'primaryContainer'
Chip(
  label: Text('Tag'), // Text uses 'onPrimaryContainer'
)
```

#### 2. **Secondary Colors**

```dart
ColorScheme(
  secondary: Color(0xFF625B71),      // Accent color
  onSecondary: Color(0xFFFFFFFF),    // Text ON secondary
  secondaryContainer: Color(0xFFE8DEF8), // Lighter secondary
  onSecondaryContainer: Color(0xFF1D192B), // Text ON secondaryContainer
)
```

**What uses these:**

- `secondary`: Outlined buttons, some interactive elements
- `secondaryContainer`: Toggle backgrounds, filter chips
- Less prominent than primary

**Example:**

```dart
// OutlinedButton can use secondary
OutlinedButton(
  style: OutlinedButton.styleFrom(
    foregroundColor: colorScheme.secondary,
  ),
  onPressed: () {},
  child: Text('Cancel'),
)
```

#### 3. **Tertiary Colors**

```dart
ColorScheme(
  tertiary: Color(0xFF7D5260),       // Third accent
  onTertiary: Color(0xFFFFFFFF),     // Text ON tertiary
  tertiaryContainer: Color(0xFFFFD8E4), // Lighter tertiary
  onTertiaryContainer: Color(0xFF31111D), // Text ON tertiaryContainer
)
```

**What uses these:**

- Custom accents
- Special highlights
- Variety in UI without overusing primary/secondary

#### 4. **Error Colors**

```dart
ColorScheme(
  error: Color(0xFFB3261E),          // Error/danger color
  onError: Color(0xFFFFFFFF),        // Text ON error
  errorContainer: Color(0xFFF9DEDC), // Light error background
  onErrorContainer: Color(0xFF410E0B), // Text ON errorContainer
)
```

**What uses these:**

- Error messages
- Validation errors in forms
- Delete buttons
- Destructive actions

**Example:**

```dart
// TextField with error
TextField(
  decoration: InputDecoration(
    errorText: 'Required field', // Uses 'error' color
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: colorScheme.error),
    ),
  ),
)

// Destructive button
FilledButton(
  style: FilledButton.styleFrom(
    backgroundColor: colorScheme.error,
    foregroundColor: colorScheme.onError,
  ),
  onPressed: () {},
  child: Text('Delete'),
)
```

#### 5. **Surface Colors** (Material Design 3)

```dart
ColorScheme(
  surface: Color(0xFFFEFBFF),                    // Main surface
  onSurface: Color(0xFF1C1B1F),                 // Text ON surface
  surfaceVariant: Color(0xFFE7E0EC),            // Variant surface
  onSurfaceVariant: Color(0xFF49454F),          // Text ON surfaceVariant

  // Surface containers (elevation levels)
  surfaceContainerLowest: Color(0xFFFFFFFF),    // Lowest elevation
  surfaceContainerLow: Color(0xFFF7F2FA),       // Low elevation
  surfaceContainer: Color(0xFFF3EDF7),          // Medium elevation
  surfaceContainerHigh: Color(0xFFECE6F0),      // High elevation
  surfaceContainerHighest: Color(0xFFE6E0E9),   // Highest elevation
)
```

**What uses these:**

- `surface`: Cards, dialogs, bottom sheets, app bars
- `onSurface`: Body text, icons on surfaces
- `surfaceVariant`: Input field backgrounds, dividers
- `surfaceContainer*`: Layered surfaces at different elevations

**Visual hierarchy example:**

```dart
// Scaffold (base layer)
Scaffold(
  backgroundColor: colorScheme.surface, // or surfaceContainerLowest

  // Card (elevated layer)
  body: Card(
    color: colorScheme.surfaceContainerLow, // Slightly elevated
    child: Text(
      'Content',
      style: TextStyle(color: colorScheme.onSurface),
    ),
  ),

  // Dialog (highest layer)
  // Uses surfaceContainerHigh automatically
)
```

#### 6. **Background Colors** (Deprecated in M3, use Surface)

```dart
// Old Material Design 2
ColorScheme(
  background: Color(0xFFFFFBFE),     // Deprecated
  onBackground: Color(0xFF1C1B1F),   // Deprecated
)
```

**Migration:** Use `surface` and `onSurface` instead.

#### 7. **Outline & Shadow**

```dart
ColorScheme(
  outline: Color(0xFF79747E),             // Borders, dividers
  outlineVariant: Color(0xFFCAC4D0),      // Subtle borders
  shadow: Color(0xFF000000),              // Shadow color
  scrim: Color(0xFF000000),               // Modal scrim/overlay
  surfaceTint: Color(0xFF6750A4),         // Tint for elevated surfaces
)
```

**What uses these:**

- `outline`: TextField borders, card borders
- `outlineVariant`: Subtle dividers
- `shadow`: Drop shadows (usually black)
- `scrim`: Behind dialogs/bottom sheets
- `surfaceTint`: Adds subtle color to elevated white surfaces

**Example:**

```dart
// Outlined TextField
TextField(
  decoration: InputDecoration(
    border: OutlineInputBorder(
      borderSide: BorderSide(color: colorScheme.outline),
    ),
  ),
)

// Divider
Divider(color: colorScheme.outlineVariant)
```

#### 8. **Inverse Colors**

```dart
ColorScheme(
  inverseSurface: Color(0xFF313033),      // Opposite of surface
  onInverseSurface: Color(0xFFF4EFF4),   // Text ON inverseSurface
  inversePrimary: Color(0xFFD0BCFF),     // Opposite of primary
)
```

**What uses these:**

- Snackbars (dark snackbar in light theme)
- Tooltips
- Inverse color situations

**Example:**

```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    backgroundColor: colorScheme.inverseSurface,
    content: Text(
      'Message',
      style: TextStyle(color: colorScheme.onInverseSurface),
    ),
  ),
)
```

### Customizing ColorScheme with copyWith()

```dart
ColorScheme.fromSeed(
  seedColor: Color(0xFF6750A4),
  brightness: Brightness.light,
).copyWith(
  // Override specific colors
  surface: Color(0xFFFEFBFF),
  surfaceContainer: Color(0xFFF3F4F6),
  error: Color(0xFFDC2626), // Custom red
)
```

**When to use:**

- You want most colors from the seed
- But need specific overrides
- Maintains harmony while customizing

---

## Component Themes

### AppBarTheme

**Controls:** Top app bar appearance

```dart
appBarTheme: AppBarTheme(
  backgroundColor: Color(0xFF6750A4),      // Bar background
  foregroundColor: Color(0xFFFFFFFF),      // Title & icon color
  elevation: 0,                             // Shadow depth
  scrolledUnderElevation: 4,               // Elevation when scrolled
  centerTitle: true,                        // Center the title
  titleTextStyle: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  ),
  iconTheme: IconThemeData(
    color: Colors.white,
    size: 24,
  ),
)
```

**Visual changes:**

```dart
// BEFORE (default)
AppBar(title: Text('Title'))
// → White background, black text, elevation 4

// AFTER (with theme above)
AppBar(title: Text('Title'))
// → Purple background, white text, no elevation, centered title
```

### CardTheme

**Controls:** Card widget appearance

```dart
cardTheme: CardTheme(
  color: Color(0xFFFFFFFF),                // Card background
  surfaceTintColor: Color(0xFF6750A4),     // Tint for elevation
  elevation: 0,                             // Shadow depth
  shape: RoundedRectangleBorder(           // Card shape
    borderRadius: BorderRadius.circular(12),
  ),
  margin: EdgeInsets.all(8),               // Default margin
  clipBehavior: Clip.antiAlias,            // Clip children
)
```

**Visual changes:**

```dart
// BEFORE
Card(child: Text('Content'))
// → Gray background, sharp corners, elevation 1

// AFTER (with theme)
Card(child: Text('Content'))
// → White background, 12px rounded corners, no shadow, 8px margin
```

### FilledButtonTheme

**Controls:** FilledButton appearance

```dart
filledButtonTheme: FilledButtonThemeData(
  style: FilledButton.styleFrom(
    backgroundColor: Color(0xFF6750A4),     // Button background
    foregroundColor: Color(0xFFFFFFFF),     // Text/icon color
    disabledBackgroundColor: Color(0xFFE0E0E0), // Disabled state
    disabledForegroundColor: Color(0xFF9E9E9E),
    elevation: 0,                            // Shadow
    padding: EdgeInsets.symmetric(
      horizontal: 24,
      vertical: 12,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    textStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
  ),
)
```

**Visual changes:**

```dart
// BEFORE
FilledButton(
  onPressed: () {},
  child: Text('Click'),
)
// → Purple background (from colorScheme.primary), 20px radius

// AFTER (with theme)
FilledButton(
  onPressed: () {},
  child: Text('Click'),
)
// → Custom purple, 8px radius, 24px horizontal padding, no elevation
```

### OutlinedButtonTheme

```dart
outlinedButtonTheme: OutlinedButtonThemeData(
  style: OutlinedButton.styleFrom(
    foregroundColor: Color(0xFF6750A4),     // Text/icon color
    side: BorderSide(
      color: Color(0xFF6750A4),
      width: 1.5,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
)
```

### TextButtonTheme

```dart
textButtonTheme: TextButtonThemeData(
  style: TextButton.styleFrom(
    foregroundColor: Color(0xFF6750A4),
    textStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
  ),
)
```

### InputDecorationTheme

**Controls:** TextField, TextFormField appearance

```dart
inputDecorationTheme: InputDecorationTheme(
  filled: true,                             // Fill background
  fillColor: Color(0xFFF3F4F6),            // Background color

  // Border styles
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: Color(0xFFCAC4D0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: Color(0xFFCAC4D0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(
      color: Color(0xFF6750A4),
      width: 2,
    ),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: Color(0xFFB3261E)),
  ),

  // Content padding
  contentPadding: EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 12,
  ),

  // Label style
  labelStyle: TextStyle(
    fontSize: 16,
    color: Color(0xFF49454F),
  ),
  floatingLabelStyle: TextStyle(
    fontSize: 12,
    color: Color(0xFF6750A4),
  ),

  // Hint style
  hintStyle: TextStyle(
    fontSize: 16,
    color: Color(0xFF9E9E9E),
  ),
)
```

**Visual changes:**

```dart
// BEFORE
TextField(
  decoration: InputDecoration(labelText: 'Name'),
)
// → No fill, thin border, sharp corners

// AFTER (with theme)
TextField(
  decoration: InputDecoration(labelText: 'Name'),
)
// → Light gray fill, thick purple border when focused, 8px radius
```

### FloatingActionButtonTheme

```dart
floatingActionButtonTheme: FloatingActionButtonThemeData(
  backgroundColor: Color(0xFF6750A4),
  foregroundColor: Color(0xFFFFFFFF),
  elevation: 6,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  ),
)
```

### BottomNavigationBarTheme

```dart
bottomNavigationBarTheme: BottomNavigationBarThemeData(
  backgroundColor: Color(0xFFFEFBFF),
  selectedItemColor: Color(0xFF6750A4),
  unselectedItemColor: Color(0xFF79747E),
  selectedIconTheme: IconThemeData(size: 28),
  unselectedIconTheme: IconThemeData(size: 24),
  showSelectedLabels: true,
  showUnselectedLabels: true,
  type: BottomNavigationBarType.fixed,
  elevation: 8,
)
```

### DialogTheme

```dart
dialogTheme: DialogTheme(
  backgroundColor: Color(0xFFFFFFFF),
  surfaceTintColor: Color(0xFF6750A4),
  elevation: 24,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(28),
  ),
  titleTextStyle: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: Color(0xFF1C1B1F),
  ),
  contentTextStyle: TextStyle(
    fontSize: 14,
    color: Color(0xFF49454F),
  ),
)
```

### ChipTheme

```dart
chipTheme: ChipThemeData(
  backgroundColor: Color(0xFFE8DEF8),
  deleteIconColor: Color(0xFF49454F),
  disabledColor: Color(0xFFE0E0E0),
  selectedColor: Color(0xFF6750A4),
  secondarySelectedColor: Color(0xFFEADDFF),
  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  labelStyle: TextStyle(fontSize: 14),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
  ),
)
```

### SnackBarTheme

```dart
snackBarTheme: SnackBarThemeData(
  backgroundColor: Color(0xFF313033),       // Dark background
  contentTextStyle: TextStyle(
    color: Color(0xFFF4EFF4),
    fontSize: 14,
  ),
  behavior: SnackBarBehavior.floating,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
  ),
  elevation: 6,
)
```

### DividerTheme

```dart
dividerTheme: DividerThemeData(
  color: Color(0xFFCAC4D0),
  thickness: 1,
  space: 16,                                // Space around divider
)
```

---

## Theme Inheritance

### How Widgets Get Theme Values

```dart
// 1. Using Theme.of(context)
final theme = Theme.of(context);
final colorScheme = theme.colorScheme;

Container(
  color: colorScheme.primary,
  child: Text(
    'Hello',
    style: TextStyle(color: colorScheme.onPrimary),
  ),
)

// 2. Widgets automatically use theme
FilledButton(
  onPressed: () {},
  child: Text('Auto-themed'), // Uses theme colors automatically
)

// 3. Override theme locally
Theme(
  data: Theme.of(context).copyWith(
    colorScheme: Theme.of(context).colorScheme.copyWith(
      primary: Colors.red, // Local override
    ),
  ),
  child: FilledButton(
    onPressed: () {},
    child: Text('Red button'),
  ),
)
```

### Accessing Theme Properties

```dart
// ColorScheme
final colorScheme = Theme.of(context).colorScheme;
final primary = colorScheme.primary;
final surface = colorScheme.surface;

// TextTheme
final textTheme = Theme.of(context).textTheme;
final headline = textTheme.headlineLarge;
final body = textTheme.bodyMedium;

// Component themes
final cardTheme = Theme.of(context).cardTheme;
final appBarTheme = Theme.of(context).appBarTheme;
```

---

## Practical Examples

### Example 1: Custom Button with Theme

```dart
// Without theme awareness (BAD)
Container(
  decoration: BoxDecoration(
    color: Color(0xFF6750A4),
    borderRadius: BorderRadius.circular(8),
  ),
  padding: EdgeInsets.all(16),
  child: Text(
    'Click',
    style: TextStyle(color: Colors.white),
  ),
)

// With theme awareness (GOOD)
Container(
  decoration: BoxDecoration(
    color: Theme.of(context).colorScheme.primary,
    borderRadius: BorderRadius.circular(8),
  ),
  padding: EdgeInsets.all(16),
  child: Text(
    'Click',
    style: TextStyle(
      color: Theme.of(context).colorScheme.onPrimary,
    ),
  ),
)

// Best: Use existing button widget
FilledButton(
  onPressed: () {},
  child: Text('Click'),
)
```

### Example 2: Card with Proper Theming

```dart
Card(
  // Uses cardTheme automatically
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Title',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: 8),
        Text(
          'Description',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {},
              child: Text('Cancel'),
            ),
            SizedBox(width: 8),
            FilledButton(
              onPressed: () {},
              child: Text('Save'),
            ),
          ],
        ),
      ],
    ),
  ),
)
```

### Example 3: Form with Theme

```dart
Form(
  child: Column(
    children: [
      TextFormField(
        // Uses inputDecorationTheme automatically
        decoration: InputDecoration(
          labelText: 'Email',
          prefixIcon: Icon(Icons.email),
        ),
        validator: (value) {
          if (value?.isEmpty ?? true) {
            return 'Required'; // Error color from theme
          }
          return null;
        },
      ),
      SizedBox(height: 16),
      TextFormField(
        decoration: InputDecoration(
          labelText: 'Password',
          prefixIcon: Icon(Icons.lock),
          suffixIcon: Icon(Icons.visibility),
        ),
        obscureText: true,
      ),
      SizedBox(height: 24),
      SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: () {},
          child: Text('Login'),
        ),
      ),
    ],
  ),
)
```

### Example 4: Surface Hierarchy

```dart
// Scaffold (lowest surface)
Scaffold(
  backgroundColor: colorScheme.surface, // Base layer

  body: Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      children: [
        // Card (elevated surface)
        Card(
          color: colorScheme.surfaceContainerLow,
          child: ListTile(
            title: Text('Level 1'),
            tileColor: Colors.transparent,
          ),
        ),

        SizedBox(height: 16),

        // More elevated card
        Card(
          color: colorScheme.surfaceContainerHigh,
          child: ListTile(
            title: Text('Level 2'),
          ),
        ),
      ],
    ),
  ),

  // FAB (highest surface)
  floatingActionButton: FloatingActionButton(
    // Automatically uses highest elevation
    onPressed: () {},
    child: Icon(Icons.add),
  ),
)
```

### Example 5: Dark/Light Theme Toggle

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Light theme
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF6750A4),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),

      // Dark theme
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF6750A4),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),

      // Auto-switch based on system
      themeMode: ThemeMode.system,

      home: HomeScreen(),
    );
  }
}

// In your UI
IconButton(
  icon: Icon(
    Theme.of(context).brightness == Brightness.dark
        ? Icons.light_mode
        : Icons.dark_mode,
  ),
  onPressed: () {
    // Toggle theme (requires state management)
  },
)
```

---

## Common Patterns

### Pattern 1: Responsive Theme Colors

```dart
// Automatically adapts to dark/light mode
class ThemedContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: colorScheme.surface,
      child: Text(
        'Auto-themed',
        style: TextStyle(color: colorScheme.onSurface),
      ),
    );
  }
}
```

### Pattern 2: Custom Theme Extension

```dart
// Define custom colors
@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  final Color? success;
  final Color? warning;

  CustomColors({this.success, this.warning});

  @override
  ThemeExtension<CustomColors> copyWith({
    Color? success,
    Color? warning,
  }) {
    return CustomColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
    );
  }

  @override
  ThemeExtension<CustomColors> lerp(
    ThemeExtension<CustomColors>? other,
    double t,
  ) {
    if (other is! CustomColors) return this;
    return CustomColors(
      success: Color.lerp(success, other.success, t),
      warning: Color.lerp(warning, other.warning, t),
    );
  }
}

// Add to theme
ThemeData(
  extensions: [
    CustomColors(
      success: Color(0xFF10B981),
      warning: Color(0xFFF59E0B),
    ),
  ],
)

// Use in UI
final customColors = Theme.of(context).extension<CustomColors>();
Container(color: customColors?.success)
```

### Pattern 3: Theme-aware Icons

```dart
// Icon automatically uses theme color
Icon(
  Icons.favorite,
  color: Theme.of(context).colorScheme.primary,
)

// Or use IconTheme
IconTheme(
  data: IconThemeData(
    color: Theme.of(context).colorScheme.secondary,
    size: 24,
  ),
  child: Row(
    children: [
      Icon(Icons.home),    // Uses theme
      Icon(Icons.search),  // Uses theme
    ],
  ),
)
```

### Pattern 4: Conditional Theming

```dart
// Different colors based on state
Container(
  color: isActive
      ? Theme.of(context).colorScheme.primary
      : Theme.of(context).colorScheme.surfaceVariant,
  child: Text(
    'Status',
    style: TextStyle(
      color: isActive
          ? Theme.of(context).colorScheme.onPrimary
          : Theme.of(context).colorScheme.onSurfaceVariant,
    ),
  ),
)
```

### Pattern 5: Theme Debugging

```dart
// Print all theme colors
void printThemeColors(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;

  print('Primary: ${colorScheme.primary}');
  print('Secondary: ${colorScheme.secondary}');
  print('Surface: ${colorScheme.surface}');
  print('Error: ${colorScheme.error}');
  // ... etc
}

// Visual theme inspector (dev only)
GridView.count(
  crossAxisCount: 3,
  children: [
    _ColorBox('Primary', colorScheme.primary, colorScheme.onPrimary),
    _ColorBox('Secondary', colorScheme.secondary, colorScheme.onSecondary),
    _ColorBox('Surface', colorScheme.surface, colorScheme.onSurface),
    // ... etc
  ],
)

class _ColorBox extends StatelessWidget {
  final String name;
  final Color color;
  final Color onColor;

  _ColorBox(this.name, this.color, this.onColor);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Center(
        child: Text(
          name,
          style: TextStyle(color: onColor),
        ),
      ),
    );
  }
}
```

---

## Quick Reference Table

| Property                  | Affects             | Example Widget                   |
| ------------------------- | ------------------- | -------------------------------- |
| `colorScheme.primary`     | Main brand color    | FilledButton, FAB, AppBar        |
| `colorScheme.secondary`   | Accent color        | OutlinedButton, Icons            |
| `colorScheme.surface`     | Background surfaces | Card, Dialog, BottomSheet        |
| `colorScheme.error`       | Error states        | TextField errors, Delete buttons |
| `colorScheme.outline`     | Borders             | TextField border, Divider        |
| `appBarTheme`             | App bar             | AppBar                           |
| `cardTheme`               | Cards               | Card widget                      |
| `filledButtonTheme`       | Filled buttons      | FilledButton                     |
| `inputDecorationTheme`    | Text inputs         | TextField, TextFormField         |
| `textTheme`               | Typography          | Text widgets                     |
| `scaffoldBackgroundColor` | Screen background   | Scaffold                         |

---

## Best Practices

### ✅ DO

1. **Use ColorScheme for colors**

   ```dart
   // Good
   color: Theme.of(context).colorScheme.primary
   ```

2. **Use TextTheme for typography**

   ```dart
   // Good
   style: Theme.of(context).textTheme.headlineMedium
   ```

3. **Use semantic color names**

   ```dart
   // Good - semantic meaning
   backgroundColor: colorScheme.error,
   foregroundColor: colorScheme.onError,
   ```

4. **Override at component level when needed**
   ```dart
   FilledButton(
     style: FilledButton.styleFrom(
       backgroundColor: Colors.green, // Override for special case
     ),
   )
   ```

### ❌ DON'T

1. **Hard-code colors everywhere**

   ```dart
   // Bad
   color: Color(0xFF6750A4)
   ```

2. **Ignore dark mode**

   ```dart
   // Bad - won't work in dark mode
   Container(
     color: Colors.white,
     child: Text('Text', style: TextStyle(color: Colors.black)),
   )
   ```

3. **Mix theme and hard-coded values**
   ```dart
   // Bad - inconsistent
   Container(
     color: Theme.of(context).colorScheme.primary,
     child: Text('Text', style: TextStyle(color: Colors.white)), // Should use onPrimary
   )
   ```

---

## Summary

### Key Takeaways

1. **ColorScheme is the foundation** - All colors derive from it
2. **Component themes control widgets** - Set once, apply everywhere
3. **Theme inheritance is automatic** - Widgets inherit from ancestor Theme
4. **Use copyWith() for customization** - Override specific properties
5. **Always pair colors** - primary/onPrimary, surface/onSurface, etc.
6. **Test both themes** - Ensure light and dark modes work

### Color Pairing Rules

```
If background is:         Text/icons should be:
─────────────────────────────────────────────
primary                   onPrimary
secondary                 onSecondary
surface                   onSurface
error                     onError
primaryContainer          onPrimaryContainer
```

### Theme Application Flow

```
1. Define ColorScheme (fromSeed or manual)
2. Configure component themes (optional)
3. Set TextTheme (optional)
4. Widgets automatically use theme
5. Override locally when needed (copyWith)
```

---

## Additional Resources

- [Material Design 3 Color System](https://m3.material.io/styles/color/system/overview)
- [Flutter Theme Documentation](https://docs.flutter.dev/cookbook/design/themes)
- [Material Color Utilities](https://pub.dev/packages/material_color_utilities)

---

**Last Updated:** October 2025  
**Flutter Version:** 3.9+  
**Material Design:** Version 3
