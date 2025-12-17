# Notification Services - PlayMaker

Request notification permission, schedule local notifications, and handle received/local+push notifications.

## Actions (14)
- Permission: `NotificationServicesGetSettings`, `NotificationServicesRequestPermission`, `NotificationServicesGetRequestPermissionError`
- Build + schedule: `NotificationServicesCreateBuilder`, `NotificationServicesScheduleNotification`, `NotificationServicesGetScheduleNotificationError`
- Receive: `NotificationServicesOnNotificationReceived`, `NotificationServicesGetReceivedNotificationInfo`
- Scheduled list: `NotificationServicesGetScheduledNotifications`, `NotificationServicesGetScheduledNotificationsSuccessResult`, `NotificationServicesGetScheduledNotificationsError`
- Cancel: `NotificationServicesCancel`, `NotificationServicesCancelAll`
- Push registration: `NotificationServicesOnRegisterForPushNotificationsComplete`

## Key patterns
- `NotificationServicesGetSettings` is async and finishes with outputs; branch using the returned `status`.
- `NotificationServicesCreateBuilder` caches the built notification; `NotificationServicesScheduleNotification` schedules the cached notification.
- Listener actions (`NotificationServicesOnNotificationReceived`, `NotificationServicesOnRegisterForPushNotificationsComplete`) must stay active to receive events.
- `NotificationServicesCancel` / `NotificationServicesCancelAll` are synchronous (no success/failure events). Re-query scheduled notifications to confirm.

## Use cases
Start here: `use-cases/README.md`
