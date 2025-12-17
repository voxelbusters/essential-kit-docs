# Manage Scheduled Notifications

## Goal
List scheduled notifications and cancel one (by id) or cancel all.

## Actions used
- `NotificationServicesGetScheduledNotifications`
- `NotificationServicesGetScheduledNotificationsSuccessResult` (optional)
- `NotificationServicesGetScheduledNotificationsError` (optional)
- `NotificationServicesCancel`
- `NotificationServicesCancelAll`

## Variables
- `notificationCount` (Int)
- `notificationIds` (Array)
- `notificationTitles` (Array)
- `notificationBodies` (Array)
- `selectedId` (String)

## Flow
1. State: `GetScheduled`
   - Action: `NotificationServicesGetScheduledNotifications`
   - Events:
     - `successEvent` → `ReadScheduled`
     - `failureEvent` → `ReadScheduledError`
2. State: `ReadScheduled` (choose one approach)
   - Option A: use outputs already populated by `NotificationServicesGetScheduledNotifications` (`notificationCount`, `notificationIds`, …)
   - Option B: Action: `NotificationServicesGetScheduledNotificationsSuccessResult` (reads the same data from cache)
3. Show your list UI using `notificationTitles[i]` / `notificationBodies[i]`. When user selects one item, set `selectedId`.
4. State: `CancelOne`
   - Action: `NotificationServicesCancel` (input: `notificationId = selectedId`)
   - This action has no success/failure events; refresh by calling `GetScheduled` again.
5. State: `CancelAll`
   - Action: `NotificationServicesCancelAll`
   - Refresh by calling `GetScheduled` again.
6. State: `ReadScheduledError` (optional)
   - Option A: use `errorCode` / `errorDescription` outputs from `NotificationServicesGetScheduledNotifications`
   - Option B: Action: `NotificationServicesGetScheduledNotificationsError`

## Notes
- On iOS, cancelled notifications disappear from the schedule list; always re-query after cancel operations.
