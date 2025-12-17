# Confirmation Prompt Handler

## Goal
Handle what the user chose in the RateMyApp confirmation dialog (Rate Now / Remind Later / Cancel).

## Actions Used
- `RateMyAppOnConfirmationPrompt`

## Variables
- `actionType` (Enum) - optional output

## FSM Steps
1. Keep `RateMyAppOnConfirmationPrompt` in an active state (listener).
2. On `rateNowEvent`: continue normally (the native prompt request is already triggered by `RateMyAppAskForReview`).
3. On `remindLaterEvent`: optionally schedule your own reminder UI.
4. On `cancelEvent`: do nothing.

## Notes
- This listener only fires when the confirmation dialog is enabled/configured for RateMyApp.
