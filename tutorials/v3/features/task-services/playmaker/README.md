# Task Services - PlayMaker

Use Task Services to get a short background execution window when your app is being suspended (ex: user presses Home). This is best for quick critical work (save state, finish a small upload, cleanup).

## Actions (4)
- `TaskServicesStartTaskAndAllowInBackground`: Start background allowance and get a `taskId` (also exposes an optional quota-expiry event).
- `TaskServicesCancelTask`: End the allowance when your work is done.
- `TaskServicesGetError`: Read cached error details after a start failure event.
- `TaskServicesCancelTaskGetError`: Read cached error details after a cancel failure event.

## Key pattern
1. Start: `TaskServicesStartTaskAndAllowInBackground` → store `taskId`.
2. Do work in the next state(s).
3. End: `TaskServicesCancelTask` (pass `taskId`, or leave empty to use `TaskServicesUtils.LastTaskId`).

## Notes
- iOS background time is limited (often around ~30 seconds). Keep work short and always handle quota expiry.
- Use `quotaWillExpireEvent` (on `TaskServicesStartTaskAndAllowInBackground`) as a Global Transition if you need an emergency “save minimal” path.

## Use cases
Start here: `use-cases/README.md`
