# Cycle Update and Consumption Recalculation

## Overview

When editing a cycle, certain changes require recalculating all associated consumption readings. This document explains how the system handles these updates.

## Why Recalculation is Needed

Consumption readings store calculated values that depend on cycle properties:

1. **`unitsConsumed`**: Calculated as `currentMeterReading - previousMeterReading`

   - First reading: `meterReading - cycle.initialMeterReading`
   - Subsequent readings: `meterReading - previousReading.meterReading`

2. **`totalCost`**: Calculated as `unitsConsumed * cycle.pricePerUnit`

### What Triggers Recalculation

The system automatically recalculates all readings when:

- **`initialMeterReading`** is changed (affects all consumption calculations)
- **`pricePerUnit`** is changed (affects all cost calculations)

### What Doesn't Trigger Recalculation

These changes don't affect stored consumption data:

- Cycle name
- Start/End dates
- Max units
- Notes
- Active status

## Implementation Details

### Backend Logic (`cycles_repository_impl.dart`)

The `updateCycle` method includes:

```dart
// Detect if recalculation is needed
final needsRecalculation = pricePerUnit != null || initialMeterReading != null;

// Update the cycle
await _cyclesDataSource.updateCycle(...);

// Recalculate readings if needed
if (needsRecalculation) {
  await _recalculateReadingsForCycle(id);
}
```

### Recalculation Process (`_recalculateReadingsForCycle`)

1. Fetches the updated cycle data
2. Gets all readings for the cycle (ordered by date)
3. Iterates through readings chronologically
4. For each reading:
   - Calculates `unitsConsumed = meterReading - previousReading`
   - Calculates `totalCost = unitsConsumed * pricePerUnit`
   - Updates the reading in the database
   - Marks it for sync (if using cloud sync)

### Frontend Feedback (`create_cycle_screen.dart`)

The UI provides different success messages:

- If price or initial reading changed: "Cycle updated and consumptions recalculated"
- Otherwise: "Cycle updated successfully"

## Example Scenarios

### Scenario 1: Correcting Initial Meter Reading

**Before:**

- Initial reading: 10,000 kWh
- Reading 1: 10,100 kWh → 100 units consumed
- Reading 2: 10,250 kWh → 150 units consumed

**After updating initial reading to 10,050:**

- Initial reading: 10,050 kWh
- Reading 1: 10,100 kWh → **50 units consumed** (recalculated)
- Reading 2: 10,250 kWh → **150 units consumed** (unchanged, based on Reading 1)

### Scenario 2: Updating Price Per Unit

**Before:**

- Price: ₹5.00/unit
- Reading 1: 100 units → ₹500.00
- Reading 2: 150 units → ₹750.00

**After updating price to ₹6.00/unit:**

- Price: ₹6.00/unit
- Reading 1: 100 units → **₹600.00** (recalculated)
- Reading 2: 150 units → **₹900.00** (recalculated)

### Scenario 3: Updating Only Name

**Before:**

- Name: "Jan-24"
- Reading 1: 100 units → ₹500.00
- Reading 2: 150 units → ₹750.00

**After updating name to "January 2024":**

- Name: "January 2024"
- Reading 1: 100 units → ₹500.00 (no change)
- Reading 2: 150 units → ₹750.00 (no change)

## Performance Considerations

- Recalculation happens synchronously during the update operation
- For cycles with many readings (100+), there may be a slight delay
- All updates are performed in a single database transaction
- The UI shows a loading indicator during the update

## Data Integrity

The system ensures:

- All readings are recalculated atomically (all or nothing)
- Chronological order is maintained (readings sorted by date)
- Chain calculation is correct (each reading uses the previous one)
- Sync flags are set appropriately for cloud synchronization

## Testing Recommendations

When testing cycle updates:

1. **Test with no readings**: Update should work without recalculation
2. **Test with single reading**: Verify initial reading affects calculation
3. **Test with multiple readings**: Verify chain calculation is correct
4. **Test price update**: Verify all costs are recalculated
5. **Test initial reading update**: Verify first consumption recalculates
6. **Test non-triggering updates**: Verify no unnecessary recalculation

## Future Enhancements

Potential improvements:

- Background recalculation for large datasets
- Progress indicator for cycles with many readings
- Bulk cycle updates with batched recalculation
- Undo/redo functionality for accidental changes
