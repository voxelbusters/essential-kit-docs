# Manual Ask For Review

## Goal
Let the user manually request the native review prompt from your Settings/About screen.

## Actions Used
- `RateMyAppAskForReview`

## FSM Steps
1. **On “Rate Us” button**: call `RateMyAppAskForReview`.
2. Optionally set `skipConfirmation`:
   - `false`: show your configured confirmation dialog (if enabled)
   - `true`: go straight to the platform prompt request

## Notes
- The OS can still throttle review prompts; this action cannot guarantee that a dialog is shown.
