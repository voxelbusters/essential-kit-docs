# Notification Management

## What is Notification Management?

Notification management involves retrieving, monitoring, and controlling notifications that are scheduled, delivered, or active on the device. This is essential for Unity mobile games to track notification states and provide players with control over their notification experience.

Why use notification management in a Unity mobile game? Players appreciate being able to see upcoming notifications (like building completion times), clear delivered notifications, and understand their current notification settings without leaving your game.

## Essential Kit Notification Management APIs

### Getting Scheduled Notifications
Retrieve all notifications that are scheduled but not yet delivered:

```csharp
using VoxelBusters.EssentialKit;

NotificationServices.GetScheduledNotifications((result, error) =>
{
    if (error == null)
    {
        Debug.Log($"Total scheduled notifications: {result.Notifications.Length}");
        
        foreach (var notification in result.Notifications)
        {
            Debug.Log($"ID: {notification.Id}, Title: {notification.Title}");
            
            // Show next trigger time if available
            if (notification.Trigger != null && notification.Trigger is TimeIntervalNotificationTrigger timeInterval)
            {
                Debug.Log($"Next trigger: {timeInterval.NextTriggerDate}");
            }
        }
    }
});
```

This snippet retrieves and displays all scheduled notifications with their details.

### Getting Delivered Notifications
Retrieve notifications currently visible in the device notification center:

```csharp
NotificationServices.GetDeliveredNotifications((result, error) =>
{
    if (error == null)
    {
        Debug.Log($"Delivered notifications in notification center: {result.Notifications.Length}");
        
        foreach (var notification in result.Notifications)
        {
            Debug.Log($"Delivered: {notification.Title} - {notification.Body}");
        }
    }
});
```

This snippet shows notifications currently displayed in the system notification center.

### Removing Delivered Notifications
Clear notifications from the device notification center:

```csharp
// Remove all delivered notifications from notification center
NotificationServices.RemoveAllDeliveredNotifications();
Debug.Log("All delivered notifications cleared from notification center");
```

This snippet removes all your app's notifications from the device notification center.

### Accessing Cached Settings
Get cached notification settings without making an async call:

```csharp
var settings = NotificationServices.CachedSettings;
if (settings != null)
{
    Debug.Log($"Permission Status: {settings.PermissionStatus}");
    Debug.Log($"Push Notifications Enabled: {settings.PushNotificationEnabled}");
    Debug.Log($"Device Token: {settings.DeviceToken}");
    Debug.Log($"Alert Setting: {settings.AlertSetting}");
    Debug.Log($"Sound Setting: {settings.SoundSetting}");
    Debug.Log($"Badge Setting: {settings.BadgeSetting}");
}
```

This snippet accesses cached notification settings for quick status checking.

### Settings Change Monitoring
Monitor when notification settings change:

```csharp
void Start()
{
    NotificationServices.OnSettingsUpdate += OnSettingsUpdated;
}

void OnSettingsUpdated(NotificationSettings newSettings)
{
    Debug.Log($"Settings updated - Permission: {newSettings.PermissionStatus}");
    Debug.Log($"Push enabled: {newSettings.PushNotificationEnabled}");
    
    // Update your UI or game logic based on new settings
    if (newSettings.PermissionStatus == NotificationPermissionStatus.Denied)
    {
        Debug.Log("User disabled notifications - adjust game features accordingly");
    }
}
```

This snippet monitors notification settings changes and responds accordingly.

### Cached Notification Access
Access the last retrieved scheduled notifications without an API call:

```csharp
var scheduledNotifications = NotificationServices.ScheduledNotifications;
if (scheduledNotifications != null)
{
    Debug.Log($"Cached scheduled notifications count: {scheduledNotifications.Length}");
    
    foreach (var notification in scheduledNotifications)
    {
        Debug.Log($"Cached notification: {notification.Title}");
    }
}
```

This snippet accesses cached scheduled notifications for immediate use.

### Canceling Specific Notifications
Remove specific notifications by ID:

```csharp
// Cancel a specific notification by ID
NotificationServices.CancelScheduledNotification("daily_reward_1");

// Cancel using the notification object
var notification = NotificationServices.CreateNotificationWithId("temp_event").Create();
NotificationServices.CancelScheduledNotification(notification);
```

This snippet demonstrates different ways to cancel specific scheduled notifications.

📌 **Video Note**: Show Unity demo of retrieving scheduled notifications, viewing delivered notifications in the notification center, and clearing them programmatically.