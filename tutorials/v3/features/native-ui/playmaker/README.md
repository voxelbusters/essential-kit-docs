# Native UI - PlayMaker

Show native alerts (with optional text input) and date/time pickers.

## Actions (2)
- `NativeUIShowAlert` (buttons + optional single text input)
- `NativeUIShowDatePicker` (date/time picker)

## Key patterns
- `NativeUIShowAlert`:
  - Configure buttons using `buttonLabels` (array) and optional `cancelButtonLabel`.
  - Use `buttonClickedEvent` for any non-cancel button, and `cancelClickedEvent` for cancel.
  - Read `pressedButtonIndex`, `pressedButtonLabel`, and `enteredText` (when `enableTextInput = true`).
- `NativeUIShowDatePicker`:
  - Use `dateSelectedEvent` / `cancelledEvent`.
  - `selectedDate` is stored as an ISO 8601 UTC string in `FsmString`.

## Use cases
Start here: `use-cases/README.md`
