# Quota Management (Emergency Save)

## Goal
If background time is about to expire, switch to a minimal “save critical data and stop” path.

## Actions used
- `TaskServicesStartTaskAndAllowInBackground`
- `TaskServicesCancelTask`

## Flow
1. When app is suspending:
   - Start background allowance (`TaskServicesStartTaskAndAllowInBackground`) and do your normal save/upload work.
2. If `quotaWillExpireEvent` fires:
   - State: `EmergencySaveMinimal`
     - Stop optional work.
     - Save only critical state (fastest possible).
     - Call `TaskServicesCancelTask` to end the task and exit quickly.

## Notes
- Assign `quotaWillExpireEvent` on `TaskServicesStartTaskAndAllowInBackground` and add it as a Global Transition to your emergency state.
