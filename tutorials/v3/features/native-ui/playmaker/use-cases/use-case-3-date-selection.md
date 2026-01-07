# Date and Time Selection

## Goal
Show a native date/time picker and use the selected date.

## Actions used
- `NativeUIShowDatePicker`

## Variables
- `selectedDate` (`FsmString`, ISO 8601 UTC string)
- `wasCancelled` (Bool)

## Flow
1. State: `ShowDatePicker`
   - Action: `NativeUIShowDatePicker`
   - Events:
     - `dateSelectedEvent` → `ProcessDate`
     - `cancelledEvent` → `Cancelled`
2. State: `ProcessDate`
   - Parse `selectedDate` as ISO 8601 and convert to local time for display if needed.

## Notes
- `minimumDate`, `maximumDate`, and `initialDate` are optional.
