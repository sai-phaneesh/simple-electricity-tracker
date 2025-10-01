# Number Formatting and Decimal Support

## Overview

This document describes the changes made to support decimal values for meter readings and units, along with proper locale-specific number formatting throughout the application.

## Changes Summary

### 1. Database Schema Changes

Updated the database schema to support decimal values:

**Modified Tables:**

- `cycles_table.dart`: Changed `initialMeterReading` from `IntColumn` to `RealColumn`
- `electricity_readings_table.dart`: Changed `meterReading` and `unitsConsumed` from `IntColumn` to `RealColumn`

**Impact:**

- Meter readings can now have decimal precision (e.g., 1234.56 kWh)
- Units consumed are calculated with decimal precision
- More accurate tracking of electricity consumption

### 2. Number Formatter Utility

Created a new utility class for consistent number formatting across the app:

**File:** `lib/core/utils/formatters/number_formatter.dart`

**Features:**

- `formatCurrency(num)`: Formats currency with ₹ symbol and Indian locale (₹1,234.56). Hides `.00` for whole numbers (₹1,234)
- `formatUnits(int)`: Formats whole numbers with thousands separators (1,234)
- `formatNumber(num)`: Formats numbers with optional decimal places (1,234.56). Hides `.00` for whole numbers (1,234)
- `formatMeterReading(num)`: Formats meter readings with thousands separators and decimals (12,345.67). Hides `.00` for whole numbers (12,345)

**Locale:** All formatters use 'en_IN' locale for Indian number format (lakhs/crores system)

**Smart Decimal Handling:** All formatters automatically hide `.00` for whole numbers to keep the UI clean

**Locale:** All formatters use 'en_IN' locale for Indian number format (lakhs/crores system)

### 3. UI Updates

#### CreateConsumptionScreen

**Changes:**

- Removed `setState` on every keystroke for better performance
- Used Form state with `onChanged` validator instead
- Fixed decimal handling - no longer rounds meter reading input
- Added proper locale formatting for:
  - Price per unit display
  - Previous reading display
  - Live preview (units and cost)
- Preview only updates when input is valid

**Benefits:**

- Better performance (no unnecessary rebuilds)
- More accurate calculations with decimal support
- Professional number formatting with thousands separators

#### ConsumptionCard

**Changes:**

- Format meter reading with thousands separators and decimals
- Format units consumed with proper number formatting
- Format total cost with currency formatting
- Display date/time in two separate lines for better readability
- Use relative date format: "Today", "Yesterday", or actual date
- Smart decimal hiding: whole numbers show without `.00` (e.g., ₹650 instead of ₹650.00)

**Date Display Examples:**

- Today's reading: "Today" + time
- Yesterday's reading: "Yesterday" + time
- Older readings: "25-09-2025" + time

#### CycleSummaryCard

**Changes:**

- Format total units with decimal support
- Format total cost with currency formatting
- Format price per unit with currency formatting
- Format meter start with proper formatting
- Format max units with thousands separators

#### CreateCycleScreen

**Changes:**

- Removed `.round()` calls to preserve decimal precision
- Initial meter reading now supports decimals

### 4. Controller and Repository Updates

Updated all method signatures to accept `double` instead of `int` for:

**Controllers (app_providers.dart):**

- `CyclesController.createCycle()` - `initialMeterReading: double`
- `CyclesController.updateCycle()` - `initialMeterReading: double?`
- `ElectricityReadingsController.createReading()` - `meterReading: double`, `unitsConsumed: double`
- `ElectricityReadingsController.updateReading()` - `meterReading: double?`, `unitsConsumed: double?`

**Repositories:**

- `cycles_repository.dart` - Updated interface signatures
- `cycles_repository_impl.dart` - Updated implementation
- `electricity_readings_repository.dart` - Updated interface signatures
- `electricity_readings_repository_impl.dart` - Updated implementation

**Data Sources:**

- `local_cycles_datasource.dart` - Fixed JSON parsing for `initialMeterReading`
- `local_electricity_readings_datasource.dart` - Fixed JSON parsing for `meterReading` and `unitsConsumed`

### 5. Form State Optimization

**Before:**

```dart
_meterReadingController.addListener(() {
  setState(() {}); // Called on every keystroke!
});
```

**After:**

```dart
TextFormField(
  onChanged: (value) {
    // Only updates preview when input is valid
    final inputValue = double.tryParse(value.trim());
    if (inputValue != null && inputValue > previousReading) {
      setState(() {
        _previewUnits = AppNumberFormatter.formatNumber(units);
        _previewCost = AppNumberFormatter.formatCurrency(cost);
      });
    }
  },
)
```

## Examples

### Number Formatting Examples

| Type                    | Input     | Formatted Output | Notes          |
| ----------------------- | --------- | ---------------- | -------------- |
| Currency (decimal)      | 1234.56   | ₹1,234.56        | Shows decimals |
| Currency (whole)        | 1234.00   | ₹1,234           | Hides `.00`    |
| Currency (large)        | 123456.78 | ₹1,23,456.78     | Indian locale  |
| Meter Reading (decimal) | 12345.67  | 12,345.67        | Shows decimals |
| Meter Reading (whole)   | 12345.00  | 12,345           | Hides `.00`    |
| Units (decimal)         | 123.45    | 123.45           | Shows decimals |
| Units (whole)           | 123.00    | 123              | Hides `.00`    |

### Date Display Examples

| Reading Time      | Date Display | Time Display |
| ----------------- | ------------ | ------------ |
| Today 2:30 PM     | Today        | 02:30 PM     |
| Yesterday 5:15 PM | Yesterday    | 05:15 PM     |
| 25 Sept 2025      | 25-09-2025   | (time)       |

### Decimal Support Examples

**Meter Reading:**

- Input: 12345.67
- Stored in DB: 12345.67 (as REAL)
- Displayed: 12,345.67 kWh

**Units Consumed:**

- Previous Reading: 12345.67
- Current Reading: 12445.89
- Units Consumed: 100.22 (calculated with precision)
- Displayed: 100.22 units

**Cost Calculation:**

- Units: 100.22
- Price/Unit: ₹6.50
- Total Cost: ₹651.43 (100.22 × 6.50)
- Displayed: ₹651.43

## Migration Notes

### Database Migration

Since the schema has changed from `INTEGER` to `REAL`, the database will be automatically migrated when the app runs with the updated schema. Existing integer values will be converted to doubles (e.g., 1234 becomes 1234.0).

### Breaking Changes

None for users. The app now supports both integer and decimal values seamlessly.

### Testing Recommendations

1. Test with whole number inputs (backward compatibility)
2. Test with decimal inputs (new feature)
3. Verify formatting on different screen sizes
4. Check calculations with decimal precision
5. Verify data persistence after app restart

## Performance Improvements

1. Reduced unnecessary `setState` calls in form fields
2. Form validation only runs when user interacts
3. Preview calculation only updates when input is valid
4. Better state management with Form state instead of manual listeners

## Future Enhancements

1. Add configuration for number of decimal places
2. Support for multiple currency symbols
3. Optional locale selection (currently hardcoded to en_IN)
4. Add unit tests for number formatting
5. Add integration tests for decimal value handling

## Technical Debt Resolved

1. ✅ Inconsistent number formatting across the app
2. ✅ Performance issues with `setState` on every keystroke
3. ✅ Loss of precision due to rounding meter readings
4. ✅ Hard-coded number formats in UI components
5. ✅ Missing thousands separators for large numbers
