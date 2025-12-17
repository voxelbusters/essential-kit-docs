# Upload Completion (Finish or Defer)

## Goal
When the app is suspending and an upload is pending, try to finish quickly; if time is about to expire, save-for-retry.

## Actions used
- `TaskServicesStartTaskAndAllowInBackground`
- `TaskServicesCancelTask`

## Flow
1. When `uploadPending == true` and app is suspending:
   - Start background allowance (`TaskServicesStartTaskAndAllowInBackground`)
   - Do the upload in the next state.
   - On success/failure, call `TaskServicesCancelTask` and clear/set your pending flags.
2. If `quotaWillExpireEvent` fires:
    - Cancel/stop the upload work if possible.
    - Save the payload locally and set a “retry on next launch” flag.
    - Call `TaskServicesCancelTask`.

## Notes
- Keep the upload small and bounded; don’t rely on long background time.
- Assign `quotaWillExpireEvent` on `TaskServicesStartTaskAndAllowInBackground` and add it as a Global Transition to your “SaveForRetryNow” state.
