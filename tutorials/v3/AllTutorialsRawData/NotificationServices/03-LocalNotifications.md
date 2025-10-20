# Local Notifications

## What are Local Notifications?

Local notifications are messages that your Unity mobile game schedules locally on the player's device. They trigger at specified times without requiring a server connection, making them perfect for daily rewards, energy refills, or reminding players to return to your game.

Why use local notifications in a Unity mobile game? They're essential for player retention - you can remind players about completed building upgrades, available daily bonuses, or limited-time events, even when your game isn't running.

## Essential Kit Local Notification APIs

### Creating Notifications
Use the `NotificationBuilder` to create notifications with the fluent API:

```csharp
using VoxelBusters.EssentialKit;

// Create a simple local notification
var notification = NotificationServices.CreateNotificationWithId("daily_reward")
    .SetTitle("Daily Reward Available!")
    .SetBody("Collect your daily coins and gems now!")
    .SetBadge(1)
    .SetTimeIntervalNotificationTrigger(24 * 60 * 60) // 24 hours
    .Create();
```

This snippet creates a daily reward notification that triggers in 24 hours.

### Scheduling Notifications
Schedule created notifications for delivery:

```csharp
NotificationServices.ScheduleNotification(notification, (success, error) =>
{
    if (success)
    {
        Debug.Log("Notification scheduled successfully!");
    }
    else
    {
        Debug.Log($"Failed to schedule: {error.Description}");
    }
});
```

This snippet schedules the notification and handles the result.

### Notification Content Methods
The NotificationBuilder provides methods to customize notification content:

```csharp
var gameNotification = NotificationServices.CreateNotificationWithId("game_event")
    .SetTitle("Special Event Started!")
    .SetSubtitle("Limited Time Offer")
    .SetBody("Double XP weekend has begun. Join now!")
    .SetBadge(5)
    .SetSoundFileName("special_event.wav")
    .Create();
```

This snippet creates a rich notification with title, subtitle, body, badge count, and custom sound.

### User Info for Custom Data
Add custom data to notifications for advanced handling:

```csharp
var levelUpNotification = NotificationServices.CreateNotificationWithId("level_complete")
    .SetTitle("Building Complete!")
    .SetBody("Your castle is now level 5!")
    .SetUserInfo(new KeyValuePair<string, string>("building_type", "castle"),
                new KeyValuePair<string, string>("new_level", "5"))
    .SetTimeIntervalNotificationTrigger(30 * 60) // 30 minutes
    .Create();
```

This snippet adds custom game data that you can access when the notification is received.

### Managing Scheduled Notifications
Retrieve and cancel scheduled notifications:

```csharp
// Get all scheduled notifications
NotificationServices.GetScheduledNotifications((result, error) =>
{
    Debug.Log($"Found {result.Notifications.Length} scheduled notifications");
    foreach (var notification in result.Notifications)
    {
        Debug.Log($"Notification: {notification.Title}");
    }
});

// Cancel a specific notification
NotificationServices.CancelScheduledNotification("daily_reward");

// Cancel all scheduled notifications  
NotificationServices.CancelAllScheduledNotifications();
```

This snippet shows how to retrieve scheduled notifications and cancel them individually or all at once.

📌 **Video Note**: Show Unity demo of creating a notification, scheduling it, and seeing it appear in the device notification center.