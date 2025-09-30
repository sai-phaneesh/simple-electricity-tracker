# User Guide

## Getting Started

### First Launch

When you first open Electricity Tracker, you'll see an empty dashboard prompting you to create a house.

### Creating Your First House

1. Tap the **menu icon** (☰) in the top-left corner
2. Tap **"Create House"** at the bottom of the drawer
3. Enter house details:
   - **Name**: e.g., "Main House", "Apartment 101"
   - **Address** (optional): Physical address
   - **Notes** (optional): Additional information
4. Tap **"Save"** to create the house

### Creating a Billing Cycle

Once you have a house selected:

1. Look for the **horizontal cycle strip** at the top of the dashboard
2. Tap the **"+"** button (outlined card) on the left
3. Fill in cycle details:
   - **Name**: e.g., "Jan 2025", "Q1-2025"
   - **Start Date**: When the billing period begins
   - **End Date**: When the billing period ends
   - **Initial Meter Reading**: Starting meter value
   - **Max Units**: Unit allocation for this period
   - **Price per Unit**: Cost per kWh (e.g., 7.50)
4. Tap **"Submit"** to create the cycle

### Recording Consumption

With an active cycle selected:

1. Tap the **floating action button (+)** at the bottom-right
2. Enter the current **Meter Reading**
3. Tap **"Submit"**

The app will automatically:

- Calculate units consumed since last reading
- Compute total cost based on cycle pricing
- Update the cycle summary

## Features

### Dashboard

The main dashboard shows:

- **Cycle Picker Strip**: Horizontal scrollable list of cycles for the selected house
  - Tap a cycle to select it
  - Selected cycle appears with a filled style
  - Shimmer animation while loading
- **Cycle Summary Card**: Displays selected cycle information

  - Cycle name and duration (days)
  - Total units consumed and cost
  - Price per unit
  - Initial meter reading and max units
  - Start and end dates
  - **Edit button (✎)**: Tap to edit cycle details

- **Consumption List**: Shows all meter readings for the cycle
  - Date and time of reading
  - Meter reading value
  - Units consumed since last reading
  - Cost for this reading

### House Management

#### Switching Houses

1. Open the drawer (tap ☰)
2. Tap on any house in the list
3. Dashboard updates to show that house's cycles

#### Editing a House

1. Open the drawer
2. Long-press on a house
3. Select **"Edit"**
4. Update details and save

#### Deleting a House

1. Open the drawer
2. Long-press on a house
3. Select **"Delete"**
4. Confirm deletion

> ⚠️ **Warning**: Deleting a house will delete all its cycles and consumption records.

### Cycle Management

#### Viewing Cycle Details

- The cycle summary card shows all cycle information
- Consumption list below shows all readings for the cycle

#### Editing a Cycle

1. Tap the **edit icon (✎)** on the cycle summary card
2. Modify any fields:
   - Name
   - Dates (start/end)
   - Initial meter reading
   - Max units
   - Price per unit
3. Tap **"Submit"** to save changes

> 📝 **Note**: The house cannot be changed when editing a cycle.

#### Deleting a Cycle

1. Open the drawer
2. Find the cycle in the list
3. Long-press on the cycle
4. Select **"Delete"**
5. Confirm deletion

### Consumption Records

#### Viewing All Readings

Readings appear in the consumption list on the dashboard, newest first.

#### Editing a Reading

(Coming soon)

#### Deleting a Reading

(Coming soon)

## Tips & Best Practices

### Recording Readings

- **Regular intervals**: Record readings at consistent times (e.g., daily, weekly)
- **Accuracy**: Double-check meter readings before submitting
- **Notes**: Use the notes field for context (e.g., "After vacation", "AC installed")

### Organizing Cycles

- **Naming**: Use clear, date-based names (e.g., "Jan-2025", "2025-Q1")
- **Duration**: Align cycles with actual billing periods
- **Pricing**: Update price per unit if rates change mid-cycle

### Managing Multiple Houses

- **Descriptive names**: Use names that clearly identify properties
- **Regular switching**: Review all properties periodically
- **Separate cycles**: Each house has independent cycles

## Keyboard Shortcuts

(Desktop only)

| Shortcut       | Action          |
| -------------- | --------------- |
| `Cmd/Ctrl + N` | New cycle       |
| `Cmd/Ctrl + E` | New consumption |
| `Cmd/Ctrl + ,` | Settings        |
| `Cmd/Ctrl + /` | Open drawer     |

## Troubleshooting

### Cycle not showing in picker

- Ensure the cycle belongs to the currently selected house
- Check that the cycle hasn't been deleted
- Try restarting the app

### Consumption button disabled

- Make sure you have a house selected (check drawer)
- Verify a cycle is selected (cycle summary card should be visible)
- If both are selected but button is still disabled, restart the app

### Data not saving

- Check device storage space
- Ensure the app has necessary permissions
- Try clearing app cache (Settings → Apps → Electricity Tracker → Clear Cache)

### Web version slow

- The web version uses IndexedDB by default
- For better performance, see [Web Deployment Guide](WEB_DEPLOYMENT.md)

## FAQ

**Q: Can I export my data?**  
A: Export functionality is planned for a future release.

**Q: Is my data synced to the cloud?**  
A: No, all data is stored locally on your device. Cloud sync is planned.

**Q: Can I track multiple meter types (gas, water)?**  
A: Currently, the app is designed for electricity only.

**Q: Can I have multiple billing rates in one cycle?**  
A: Not yet. Multi-rate pricing is on the roadmap.

**Q: What happens if I delete a house?**  
A: All cycles and consumption records for that house are permanently deleted. This cannot be undone.

## Getting Help

- **Issues**: Report bugs on [GitHub Issues](https://github.com/sai-phaneesh/simple-electricity-tracker/issues)
- **Questions**: Ask in [GitHub Discussions](https://github.com/sai-phaneesh/simple-electricity-tracker/discussions)
