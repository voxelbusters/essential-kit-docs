# Text Input Dialog

## Goal
Prompt for a single text input and validate it.

## Actions used
- `NativeUIShowAlert` (with `enableTextInput = true`)

## Variables
- `enteredText` (String)

## Flow
1. State: `ShowInputPrompt`
   - Action: `NativeUIShowAlert`
   - Example inputs:
     - `enableTextInput`: `true`
     - `placeholder`: `"Username"`
     - `defaultText`: `"Player"`
     - `keyboardType`: `KeyboardInputType.Default`
     - `isSecured`: `false`
     - `buttonLabels`: `["Submit"]`
     - `cancelButtonLabel`: `"Cancel"`
   - Outputs: `enteredText`
   - Events:
     - `buttonClickedEvent` → `ValidateInput`
     - `cancelClickedEvent` → `Cancelled`
2. State: `ValidateInput`
   - If valid → `ProcessInput`
   - If invalid → show error and go back to `ShowInputPrompt`
3. State: `ProcessInput`
   - Use `enteredText`.

## Notes
- For passwords, set `isSecured = true`.
