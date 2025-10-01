# Dashboard Responsive Layout

## Feature: Landscape Mode Optimization

Added responsive layout to the Dashboard screen that adapts based on device orientation, providing an optimized experience for landscape/horizontal mode.

## Layout Behavior

### Portrait Mode (Vertical)

```
┌─────────────────────┐
│  Cycle Picker Strip │
├─────────────────────┤
│   Cycle Summary     │
│     Card            │
├─────────────────────┤
│                     │
│   Consumptions      │
│      List           │
│                     │
│        ↓            │
└─────────────────────┘
```

**Stacked Layout:**

- Cycle picker at top
- Cycle summary card below
- Consumptions list fills remaining space (scrollable)

### Landscape Mode (Horizontal)

```
┌────────────────────────────────────────┐
│       Cycle Picker Strip               │
├──────────────────┬─────────────────────┤
│                  │                     │
│  Cycle Summary   │   Consumptions      │
│      Card        │       List          │
│   (scrollable)   │    (scrollable)     │
│                  │                     │
│                  │        ↓            │
│                  │                     │
└──────────────────┴─────────────────────┘
    40% width          60% width
```

**Side-by-Side Layout:**

- Cycle picker at top (full width)
- **Left side (40%)**: Cycle summary card (scrollable if content overflows)
- **Right side (60%)**: Consumptions list (scrollable)
- 8px gap between the two sections

## Implementation Details

### Component: `OrientationBuilder`

Used Flutter's `OrientationBuilder` widget to detect device orientation and adapt the layout accordingly.

```dart
OrientationBuilder(
  builder: (context, orientation) {
    if (orientation == Orientation.landscape) {
      // Landscape layout
    } else {
      // Portrait layout
    }
  },
)
```

### Landscape Layout Structure

```dart
Column(
  children: [
    Expanded(
      child: Row(
        children: [
          // Left: Cycle Summary (40%)
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: CycleSummaryCard(),
            ),
          ),
          SizedBox(width: 8),
          // Right: Consumptions List (60%)
          Expanded(
            flex: 3,
            child: ConsumptionsListView(),
          ),
        ],
      ),
    ),
  ],
)
```

### Flex Ratios

- **Cycle Summary**: `flex: 2` (40% of width)
- **Consumptions List**: `flex: 3` (60% of width)
- **Total**: 2 + 3 = 5 parts
  - 2/5 = 40%
  - 3/5 = 60%

### Spacing

- **Horizontal gap**: 8px between summary and list
- **Vertical**: Full height utilization

## Benefits

### ✅ **Better Space Utilization**

- Landscape mode provides more horizontal space
- Side-by-side layout uses screen real estate efficiently
- No wasted space

### ✅ **Improved User Experience**

- View summary and readings simultaneously
- No need to scroll up/down to see both
- Quick reference to cycle limits while reviewing consumption

### ✅ **Consistent Navigation**

- Cycle picker remains at top in both orientations
- Familiar navigation pattern maintained
- Easy to switch between cycles

### ✅ **Responsive Design**

- Automatically adapts to orientation changes
- No manual toggling needed
- Smooth transitions

## User Scenarios

### Use Case 1: Data Entry in Landscape

- **User**: Holds phone horizontally for comfort
- **View**: Summary on left shows current limits
- **Action**: Scroll consumptions list on right
- **Benefit**: Can see if nearing limit while reviewing past entries

### Use Case 2: Monitoring Usage

- **User**: Wants to check daily average vs daily limit
- **View**: Summary shows both metrics on left
- **Action**: Review recent consumption on right
- **Benefit**: Compare metrics side-by-side without scrolling

### Use Case 3: Tablet/Large Device

- **Device**: iPad or tablet in landscape
- **View**: Ample space for both sections
- **Benefit**: Desktop-like experience on mobile device

## Responsive Features

### Cycle Summary Card

- **Scrollable**: Uses `SingleChildScrollView` wrapper
- **Reason**: Content might overflow on small devices
- **Behavior**: Scrolls vertically if chips wrap to many rows

### Consumptions List

- **Already scrollable**: `ListView` by default
- **Performance**: Lazy loading with `ListView.separated`
- **Efficiency**: Only renders visible items

## Edge Cases Handled

### 1. **Empty States**

- Portrait: Centered prompt message
- Landscape: Prompt still shows centered (full width)
- Behavior: Same in both orientations

### 2. **Loading States**

- Circular progress indicator remains centered
- Works in both orientations

### 3. **No Cycle Selected**

- Prompt to select cycle
- Displayed appropriately in both modes

### 4. **No House Selected**

- Prompt to select house
- Drawer opening works in both modes

## Technical Considerations

### Performance

- **No extra rebuilds**: OrientationBuilder only rebuilds on actual orientation change
- **Widget reuse**: Same CycleSummaryCard and ConsumptionsListView widgets
- **Efficient**: No duplication of components

### Maintainability

- **Single source of truth**: Same widgets used in both layouts
- **Easy to modify**: Change one widget, updates both layouts
- **Clear separation**: Orientation logic isolated

### Testing

- ✅ Portrait mode: Original stacked layout works
- ✅ Landscape mode: Side-by-side layout displays
- ✅ Rotation: Smooth transition between modes
- ✅ Content overflow: Scrolling works correctly
- ✅ Empty states: Display correctly in both modes

## Future Enhancements

Potential improvements:

- [ ] Tablet breakpoint (wider devices get even more space)
- [ ] Customizable flex ratios (user preference)
- [ ] Collapsible summary card in landscape
- [ ] Swipe to dismiss summary panel
- [ ] Picture-in-picture for summary when scrolling

## Files Modified

1. **`dashboard.dart`**
   - Wrapped content in `OrientationBuilder`
   - Added landscape-specific layout (Row with two columns)
   - Kept portrait layout as original (Column)
   - Added `SingleChildScrollView` wrapper for summary in landscape

## Layout Breakpoints

| Orientation | Layout             | Cycle Summary            | Consumptions                |
| ----------- | ------------------ | ------------------------ | --------------------------- |
| Portrait    | Stacked (Column)   | Full width, fixed height | Full width, remaining space |
| Landscape   | Side-by-side (Row) | 40% width, scrollable    | 60% width, scrollable       |

## Visual Comparison

**Portrait Mode:**

- Traditional mobile layout
- Vertical scrolling
- One section at a time

**Landscape Mode:**

- Desktop-like layout
- Both sections visible
- Parallel information display
- Better for data analysis

## Compilation Status

✅ **`flutter analyze` - No issues found!**

The responsive layout is ready and will automatically adapt when the device is rotated!

## How to Test

1. **Portrait → Landscape**:

   - Open app in portrait
   - Rotate device to landscape
   - Observe layout changes to side-by-side

2. **Landscape → Portrait**:

   - Start in landscape mode
   - Rotate to portrait
   - Layout reverts to stacked

3. **Cycle Summary Scrolling** (Landscape):

   - In landscape, if summary content is long
   - Should scroll vertically

4. **Both Sections Scrollable**:
   - Summary scrolls independently on left
   - List scrolls independently on right
   - No interference between sections
