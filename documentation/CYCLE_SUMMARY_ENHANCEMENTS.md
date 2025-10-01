# Cycle Summary Card Enhancements

## Overview

This document describes the enhanced cycle summary card that now displays consumption tracking metrics including units consumed vs max units and daily consumption analysis.

## New Features

### 1. Units Consumed/Max Display

Shows the current consumption against the maximum allowed units for the cycle.

**Format:** `{consumed}/{max}`
**Example:** `150/300` (150 units consumed out of 300 max)

**Visual Indicators:**

- **Normal State:** Default primary color background
- **Over Limit:** Red/error color background when consumed > max units
  - Helps users immediately identify when they've exceeded their limit
  - Bold text for emphasis

### 2. Daily Average Consumption

Calculates and displays the average units consumed per day since the cycle started.

**Calculation:**

```dart
dailyAverage = totalUnitsConsumed / daysPassed
```

**Examples:**

- 150 units consumed over 10 days = 15 units/day average
- Updates automatically as new readings are added
- Shows 0 if no days have passed yet

**Display Format:** `{value} units`
**Example:** `15.5 units`

### 3. Daily Consumption Limit

Calculates the maximum units that can be consumed per day for the remaining cycle duration to stay within the limit.

**Calculation:**

```dart
remainingUnits = maxUnits - totalUnitsConsumed
daysRemaining = cycle.endDate - today (clamped to 0)
dailyLimit = remainingUnits / daysRemaining
```

**Examples:**

- 150 units remaining, 10 days left = 15 units/day limit
- If already over limit, shows 0
- If cycle ended, shows 0

**Visual Indicators:**

- **Normal State:** Default primary color background
- **Warning State:** Yellow/tertiary color when `dailyLimit < dailyAverage`
  - Alerts users they need to reduce consumption
  - Bold text for emphasis
  - Only shows warning if there are days remaining

**Display Format:** `{value} units`
**Example:** `12.3 units`

## UI Layout

### Summary Chips Order

1. **Units** - Consumed/Max with overflow indicator
2. **Daily Avg** - Average consumption per day
3. **Daily Limit** - Recommended daily limit
4. **Cost** - Total cost so far
5. **Price / unit** - Rate per unit
6. **Meter start** - Initial meter reading

### Color Coding

| State       | Background Color       | Text Color | Use Case                    |
| ----------- | ---------------------- | ---------- | --------------------------- |
| Normal      | Primary (8% opacity)   | Default    | Regular metrics             |
| Warning     | Tertiary (12% opacity) | Tertiary   | Daily limit < daily average |
| Error/Alert | Error (12% opacity)    | Error      | Consumed > max units        |

### Visual Examples

**Normal State:**

```
Units: 150/300
Daily Avg: 15 units
Daily Limit: 15 units
```

**Warning State (exceeding pace):**

```
Units: 200/300
Daily Avg: 20 units        (normal)
Daily Limit: 16.7 units    (⚠️ warning - yellow/tertiary)
```

_User is consuming faster than recommended pace_

**Over Limit State:**

```
Units: 320/300            (🚨 error - red)
Daily Avg: 22.9 units
Daily Limit: 0 units      (⚠️ warning - no units left)
```

_User has exceeded maximum units_

## Implementation Details

### Date/Time Calculations

**Days Passed:**

```dart
final now = DateTime.now();
final cycleStart = cycle.startDate;
final daysPassed = now.isBefore(cycleStart)
    ? 0
    : (now.isAfter(cycle.endDate)
        ? durationDays
        : now.difference(cycleStart).inDays + 1);
```

**Days Remaining:**

```dart
final daysRemaining = cycle.endDate
    .difference(now)
    .inDays
    .clamp(0, durationDays);
```

### Edge Cases Handled

1. **Cycle Not Started:**

   - Days passed = 0
   - Daily average = 0
   - Daily limit = calculated from full cycle

2. **Cycle Ended:**

   - Days passed = total cycle duration
   - Daily average = final average
   - Days remaining = 0, daily limit = 0

3. **Over Limit:**

   - Shows red indicator on Units chip
   - Remaining units becomes negative
   - Daily limit shows 0 (can't consume more)

4. **Future Cycle:**
   - Days passed = 0
   - Shows initial state
   - Daily limit based on full duration

### Component Structure

```dart
_SummaryChip(
  label: 'Chip Label',
  value: 'Formatted Value',
  isHighlighted: false,  // Red/error state
  isWarning: false,      // Yellow/tertiary state
)
```

**Parameters:**

- `label` (required): Display label text
- `value` (required): Formatted value to display
- `isHighlighted` (optional): Error state (red background)
- `isWarning` (optional): Warning state (yellow background)

## User Benefits

### 1. **Consumption Awareness**

- See at a glance how much has been consumed vs total limit
- Immediate visual feedback if over limit

### 2. **Pace Monitoring**

- Track daily average to understand consumption patterns
- Compare with daily limit to adjust usage

### 3. **Proactive Alerts**

- Warning state shows when consumption pace is too high
- Error state shows when limit is exceeded
- Helps prevent bill shock

### 4. **Better Planning**

- Know how many units can be used per day
- Adjust consumption to stay within budget
- Track progress throughout the cycle

## Number Formatting

All numbers use the `AppNumberFormatter` for consistent formatting:

- **Units consumed/max:** `150/300` or `150.5/300`
- **Daily metrics:** `15.5 units` (hides .00 for whole numbers)
- **Currency:** `₹1,234.56` (with thousands separators)

## Accessibility

### Color Coding

- Not solely reliant on color for information
- Labels clearly describe the metric
- Bold text for warning/error states
- Sufficient contrast ratios in both themes

### Screen Readers

- Descriptive labels for each metric
- Values are properly announced
- Warning/error states can be inferred from context

## Future Enhancements

1. **Progress Bars**

   - Visual bar showing consumption vs limit
   - Color-coded segments for clarity

2. **Trend Indicators**

   - Up/down arrows showing consumption trend
   - Percentage change from previous period

3. **Predictions**

   - Estimated end-of-cycle consumption
   - Days until limit reached at current pace
   - Suggested daily consumption to stay in budget

4. **Historical Comparison**

   - Compare with previous cycles
   - Show improvement/regression

5. **Customizable Alerts**
   - User-defined warning thresholds
   - Notification when approaching limit
   - Custom alert messages

## Testing Scenarios

### Manual Testing Checklist

- [ ] Units display correctly in format X/Y
- [ ] Daily average calculated correctly
- [ ] Daily limit shows warning when pace too high
- [ ] Over limit shows error state on Units chip
- [ ] Numbers format properly with/without decimals
- [ ] Visual states clear in both light/dark themes
- [ ] Chip colors appropriate for each state
- [ ] Edge cases (future cycle, ended cycle) handled

### Test Cases

**Normal Consumption:**

- Total: 150 units, Max: 300 units
- Days passed: 15, Days remaining: 15
- Expected: Daily avg 10, Daily limit 10, no warnings

**High Pace:**

- Total: 200 units, Max: 300 units
- Days passed: 10, Days remaining: 20
- Expected: Daily avg 20, Daily limit 5, warning on Daily Limit

**Over Limit:**

- Total: 320 units, Max: 300 units
- Expected: Units chip shows error state (red)

## Related Documentation

- [Number Formatting](./NUMBER_FORMATTING_AND_DECIMAL_SUPPORT.md)
- [Theme Configuration](./THEME_CONFIGURATION.md)
- [Dashboard Components](./DASHBOARD_COMPONENTS.md)
