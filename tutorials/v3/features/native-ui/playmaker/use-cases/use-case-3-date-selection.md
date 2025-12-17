# Date and Time Selection

## Goal
Show a native date/time picker and use the selected date.

## Actions used
- `NativeUIShowDatePicker`

## Variables
- `selectedDate` (`FsmDateTime`, stored as UTC)
- `wasCancelled` (Bool)

## Flow
1. State: `ShowDatePicker`
   - Action: `NativeUIShowDatePicker`
   - Events:
     - `dateSelectedEvent` → `ProcessDate`
     - `cancelledEvent` → `Cancelled`
2. State: `ProcessDate`
   - Use `selectedDate.Value` (convert to local time for display if needed).

## Notes
- `minimumDate`, `maximumDate`, and `initialDate` are optional.
