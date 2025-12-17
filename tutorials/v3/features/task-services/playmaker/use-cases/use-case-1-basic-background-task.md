# Basic Background Task (Save on Suspend)

## Goal
When the app is being suspended, start background allowance, save quickly, then end the task.

## Actions used
- `TaskServicesStartTaskAndAllowInBackground`
- `TaskServicesCancelTask`

## Variables
- `taskId` (String) (optional)

## Flow
1. State: `OnApplicationPause(true)` (or your “app suspending” trigger)
   - Go to `StartBackgroundAllowance`.
2. State: `StartBackgroundAllowance`
   - Action: `TaskServicesStartTaskAndAllowInBackground`
   - Save `taskId` output (optional).
   - Events:
     - `startedEvent` → `DoSave`
     - `failureEvent` → `DoSave` (fallback: still try a minimal save)
3. State: `DoSave`
   - Do your save work (keep it short on iOS).
   - Then go to `EndBackgroundAllowance`.
4. State: `EndBackgroundAllowance`
   - Action: `TaskServicesCancelTask`
   - Input: `taskId` (or leave empty to use `TaskServicesUtils.LastTaskId`)

## Notes
- Assign `quotaWillExpireEvent` on `TaskServicesStartTaskAndAllowInBackground` and add it as a Global Transition if you need an emergency “save minimal” path (see Use Case 2).
