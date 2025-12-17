# Simple Local Reminder

## Goal
Request permission (if needed) and schedule a local notification after a time interval.

## Actions used
- `NotificationServicesGetSettings`
- `NotificationServicesRequestPermission`
- `NotificationServicesGetRequestPermissionError` (optional)
- `NotificationServicesCreateBuilder`
- `NotificationServicesScheduleNotification`
- `NotificationServicesGetScheduleNotificationError` (optional)

## Variables
- `permissionStatus` (Enum: `NotificationPermissionStatus`) ← `NotificationServicesGetSettings.status`
- `title` (String)
- `body` (String)
- `delaySeconds` (Float)

## Flow
1. State: `GetSettings`
   - Action: `NotificationServicesGetSettings` → `status` (store into `permissionStatus`)
   - Branch using an Enum Compare/Switch on `permissionStatus`:
     - Authorized / Provisional → `BuildNotification`
     - NotDetermined → `RequestPermission`
     - Denied → show “Enable notifications in Settings” and stop
2. State: `RequestPermission`
   - Action: `NotificationServicesRequestPermission` (choose your options, e.g., Alert/Badge/Sound)
   - Events:
     - `grantedEvent` → `BuildNotification`
     - `deniedEvent` → show error
     - `failureEvent` → `GetRequestPermissionError` (optional) then show error
3. State: `BuildNotification`
   - Action: `NotificationServicesCreateBuilder`
   - Example inputs:
     - `notificationId`: `"reminder_1"`
     - `title`: `title`
     - `body`: `body`
     - `triggerType`: `TimeInterval`
     - `timeInterval`: `delaySeconds`
     - `repeats`: `false`
     - `soundFileName`: `"default"` (optional)
4. State: `Schedule`
   - Action: `NotificationServicesScheduleNotification`
   - Events:
     - `successEvent` → done
     - `failureEvent` → `GetScheduleNotificationError` (optional) then show error

## Notes
- `NotificationServicesCreateBuilder` only builds/caches the notification; `NotificationServicesScheduleNotification` actually schedules it.
- If permission is denied, iOS won’t show the system prompt again; users must enable it from device Settings.
