# Confirmation Dialog

## Goal
Show a native alert and branch based on which button the user pressed.

## Actions used
- `NativeUIShowAlert`

## Variables
- `pressedButtonIndex` (Int)
- `pressedButtonLabel` (String)

## Flow
1. State: `ShowConfirmation`
   - Action: `NativeUIShowAlert`
   - Example inputs:
     - `title`: `"Delete Item?"`
     - `message`: `"This action cannot be undone."`
     - `buttonLabels`: `["Delete"]`
     - `cancelButtonLabel`: `"Cancel"`
   - Events:
     - `buttonClickedEvent` → `Confirmed`
     - `cancelClickedEvent` → `Cancelled`
2. State: `Confirmed`
   - Perform the action.
3. State: `Cancelled`
   - Do nothing / go back.

## Notes
- `buttonClickedEvent` is sent for any non-cancel button. Use `pressedButtonIndex` / `pressedButtonLabel` if you have multiple buttons.
