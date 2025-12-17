# Rate My App - PlayMaker

Request store reviews with optional gating and an optional confirmation prompt.

## Actions (3)
- `RateMyAppIsAllowed` (sync bool check)
- `RateMyAppAskForReview` (fires `promptShownEvent` / `failureEvent`)
- `RateMyAppOnConfirmationPrompt` (persistent listener when confirmation dialog is enabled)

## Key patterns
- Gate review requests with `RateMyAppIsAllowed` and a good in-game moment.
- `RateMyAppAskForReview` requests the OS prompt; the OS may throttle and not show UI.
- If you use the built-in confirmation dialog, keep `RateMyAppOnConfirmationPrompt` active before calling `RateMyAppAskForReview(skipConfirmation=false)`.

## Use cases
Start here: `use-cases/README.md`
