# NotificationServices Use Cases

Quick-start guides showing minimal implementations of notification features using PlayMaker custom actions.

## Available Use Cases

### 1. [Simple Local Reminder](use-case-1-simple-reminder.md)

- **What it does:** Schedule a notification to fire after a time interval (e.g., 1 hour)
- **Complexity:** Basic
- **Actions:** 4 (GetSettings, RequestPermission, CreateBuilder, ScheduleNotification)
- **Best for:** Reminders, timers, delayed alerts

---

### 2. [Listen and Respond to Notifications](use-case-2-listen-and-respond.md)

- **What it does:** Handle notifications received while app is active or from user tap
- **Complexity:** Intermediate
- **Actions:** 2 (OnNotificationReceived, GetReceivedNotificationInfo)
- **Best for:** Deep linking, content navigation, foreground alerts

---

### 3. [Manage Scheduled Notifications](use-case-3-manage-scheduled.md)

- **What it does:** View, cancel specific, or clear all scheduled notifications
- **Complexity:** Basic
- **Actions:** 3 (GetScheduledNotifications, Cancel, CancelAll) + optional (GetScheduledNotificationsSuccessResult, GetScheduledNotificationsError)
- **Best for:** Settings panels, notification management UI

---

### 4. [Push Notification Registration](use-case-4-push-registration.md)

- **What it does:** Register device for remote push and get device token
- **Complexity:** Advanced
- **Actions:** 2 (RequestPermission, OnRegisterForPushNotificationsComplete)
- **Best for:** Server-driven notifications, multiplayer alerts, campaigns

---

## Choosing the Right Use Case

**Start Here:**
- New to notifications? → **Use Case 1** (Simple Reminder)
- Need user interaction? → **Use Case 2** (Listen and Respond)
- Managing existing notifications? → **Use Case 3** (Manage Scheduled)
- Server-based push? → **Use Case 4** (Push Registration)

## Quick Action Reference

| Action | Purpose | Used In |
|--------|---------|---------|
| NotificationServicesGetSettings | Check permission status | Use Case 1 |
| NotificationServicesRequestPermission | Request user permissions | Use Cases 1, 4 |
| NotificationServicesGetRequestPermissionError | Read cached permission request error | Use Cases 1, 4 |
| NotificationServicesCreateBuilder | Build notification object | Use Case 1 |
| NotificationServicesScheduleNotification | Schedule notification | Use Case 1 |
| NotificationServicesGetScheduleNotificationError | Read cached schedule error | Use Case 1 |
| NotificationServicesOnNotificationReceived | Listen for notifications | Use Case 2 |
| NotificationServicesGetReceivedNotificationInfo | Extract notification data | Use Case 2 |
| NotificationServicesGetScheduledNotifications | List scheduled | Use Case 3 |
| NotificationServicesGetScheduledNotificationsSuccessResult | Read cached scheduled list | Use Case 3 |
| NotificationServicesGetScheduledNotificationsError | Read cached scheduled list error | Use Case 3 |
| NotificationServicesCancel | Cancel specific notification | Use Case 3 |
| NotificationServicesCancelAll | Clear all notifications | Use Case 3 |
| NotificationServicesOnRegisterForPushNotificationsComplete | Get push token | Use Case 4 |

## Permission Flow

All notification features require user permission. Basic flow:
1. Check permission status with GetSettings
2. Request permission if needed
3. Handle granted/denied events
4. Proceed with notification operations

## Related Documentation

- Feature overview: `../README.md`
