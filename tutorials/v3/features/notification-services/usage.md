---
description: "Schedule local notifications and implement push notifications for player engagement"
---

# Usage

Essential Kit wraps native iOS (Apple Push Notification service, or **APNs**) and Android (Firebase Cloud Messaging, or **FCM**) notification APIs into a single Unity interface. Essential Kit auto-initializes NotificationServices - you can start scheduling notifications immediately after requesting permissions.

## Table of Contents
- [Understanding Core Concepts](#understanding-core-concepts)
- [Import Namespaces](#import-namespaces)
- [Event Registration](#event-registration)
- [How Permissions Work](#how-permissions-work)
- [Local Notifications](#local-notifications)
- [Push Notifications](#push-notifications)
- [Badge Management](#badge-management)
- [Data Properties](#data-properties)
- [Core APIs Reference](#core-apis-reference)
- [Error Handling](#error-handling)
- [Advanced: Manual Initialization](#advanced-manual-initialization)
- [Related Guides](#related-guides)

## Understanding Core Concepts

Before scheduling notifications, understand the two distinct notification types and when to use each.

### Local vs Push Notifications

**Local Notifications** are scheduled on the device and fire even when your app isn't running. Perfect for game-driven events.

**Examples:**
- Energy refill timers (30 minutes after energy depletes)
- Daily reward reminders (every day at 6 PM)
- Building completion timers (when construction finishes)
- Recurring challenges (weekly tournament reminders)

**Key characteristics:**
- Work completely offline - no server required
- Scheduled using time intervals or calendar dates
- Stored on device until fired or cancelled
- Limited to device-scheduled triggers only

**Push Notifications** are sent from your game server to devices in real-time. Perfect for server-driven events.

**Examples:**
- Tournament results and leaderboard updates
- Flash sale announcements
- Friend requests and social interactions
- Server maintenance notices

**Key characteristics:**
- Require server infrastructure (Firebase, OneSignal, or custom backend)
- Can target specific users or broadcast to all players
- Sent in real-time based on server events
- Can carry custom data for deep linking

{% hint style="info" %}
**Rule of thumb**: Use local notifications for predictable game events, push notifications for dynamic server events and social features.
{% endhint %}

### Notification Triggers

Local notifications fire based on triggers you specify when scheduling:

**Time Interval Triggers** fire after a specific delay from scheduling. Use for relative timing like cooldowns and energy refills.

```csharp
void ConfigureTimeIntervalNotifications()
{
    // Create a notification builder instance
    var notificationBuilder = NotificationBuilder.CreateNotification("time_interval_notification")
        .SetTitle("Reminder")
        .SetBody("Your notification message");

    // Fire 30 minutes from now
    notificationBuilder.SetTimeIntervalNotificationTrigger(1800); // seconds

    // Fire every hour repeatedly
    notificationBuilder.SetTimeIntervalNotificationTrigger(3600, repeats: true);
}
```

**Calendar Triggers** fire at specific clock times. Use for daily rewards, weekly events, and scheduled content.

```csharp
void ConfigureCalendarNotification()
{
    // Create a notification builder instance
    var notificationBuilder = NotificationBuilder.CreateNotification("daily_reminder")
        .SetTitle("Daily Reminder")
        .SetBody("Your daily notification");

    // Fire every day at 6 PM
    var components = new DateComponents();
    components.Hour = 18;
    components.Minute = 0;
    notificationBuilder.SetCalendarNotificationTrigger(components, repeats: true);
}
```

### Notification Lifecycle

1. **Creation**: Build notification with NotificationBuilder specifying ID, title, body, and trigger
2. **Scheduling**: Call `ScheduleNotification()` to register with system
3. **Delivery**: System fires notification at trigger time (or immediately for push notifications)
4. **User Interaction**: User taps notification to open app, or dismisses it
5. **Handling**: Your app receives `OnNotificationReceived` event with notification data

## Import Namespaces

```csharp
using System;
using System.Collections.Generic;
using VoxelBusters.EssentialKit;
using VoxelBusters.CoreLibrary;
using VoxelBusters.CoreLibrary.NativePlugins;
```

Include `System` namespaces for DateTime and Dictionary which are commonly used with notification scheduling and custom data.

## Event Registration

Register for notification events in `OnEnable` and unregister in `OnDisable` to receive notifications and permission updates:

```csharp
void OnEnable()
{
    NotificationServices.OnNotificationReceived += OnNotificationReceived;
    NotificationServices.OnSettingsUpdate += OnSettingsUpdate;
}

void OnDisable()
{
    NotificationServices.OnNotificationReceived -= OnNotificationReceived;
    NotificationServices.OnSettingsUpdate -= OnSettingsUpdate;
}
```

| Event | Trigger |
| --- | --- |
| `OnNotificationReceived` | When local or push notification is delivered (foreground or background), or when user taps notification to open app |
| `OnSettingsUpdate` | When user changes notification permissions in device settings |

{% hint style="success" %}
Essential Kit automatically delays delivering launch notifications until you register for `OnNotificationReceived`. This prevents missing notifications that arrived before your code was ready to handle them.
{% endhint %}

## How Permissions Work

Just call `RequestPermission()` directly - no permission checks needed beforehand. On the first call, Essential Kit automatically shows the system permission dialog. If permission is already granted, it completes immediately. When the user denies access, `result.PermissionStatus` becomes `Denied` while the `error` argument stays `null`.

```csharp
void RequestNotificationPermissions()
{
    var options = NotificationPermissionOptions.Alert |
                  NotificationPermissionOptions.Sound |
                  NotificationPermissionOptions.Badge;

    NotificationServices.RequestPermission(options, callback: (result, error) =>
    {
        if (error != null)
        {
            Debug.LogError($"Permission request failed: {error.Description}");
            return;
        }

        Debug.Log($"Permission status: {result.PermissionStatus}");

        if (result.PermissionStatus == NotificationPermissionStatus.Authorized)
        {
            Debug.Log("Notifications enabled - ready to schedule");
        }
        else if (result.PermissionStatus == NotificationPermissionStatus.Denied)
        {
            Debug.LogWarning("User denied notification permissions");
        }
    });
}
```

{% hint style="success" %}
**UX best practice**: Show a custom explanation screen before requesting permissions. Explain benefits like "Get notified when your energy refills" to improve approval rates. iOS users especially appreciate understanding value before seeing system dialogs.
{% endhint %}

### Handling Permission Denial

Handle permission issues in the error callback or by checking the permission status:

```csharp
void OnPermissionResult(NotificationServicesRequestPermissionResult result, Error error)
{
    if (error != null)
    {
        Debug.LogError($"Permission request failed: {error.Description}");
        return;
    }

    if (result.PermissionStatus == NotificationPermissionStatus.Denied)
    {
        Debug.Log("User denied notification permissions");

        // Guide user to settings if they want to re-enable
        // Utilities.OpenApplicationSettings();
        return;
    }

    // Permission granted - can now schedule notifications
}
```

### Optional: Check Permission Status

Use `GetSettings()` only when you need to inspect the exact state **before** calling the main operation, or to customize UI messaging:

```csharp
void CheckNotificationPermissionStatus()
{
    NotificationServices.GetSettings((result) =>
    {
        Debug.Log($"Permission status: {result.Settings.PermissionStatus}");

        if (result.Settings.PermissionStatus == NotificationPermissionStatus.NotDetermined)
        {
            Debug.Log("Permission not requested yet");
        }
        else if (result.Settings.PermissionStatus == NotificationPermissionStatus.Authorized)
        {
            Debug.Log("Permission granted - can schedule notifications");
        }
    });
}
```

**Permission status values:**
- `NotDetermined`: Permission never requested (iOS) or not applicable (Android)
- `Denied`: User explicitly denied permission
- `Authorized`: User granted full notification permissions
- `Provisional`: Limited permissions granted (iOS 12+ quiet notifications)

## Local Notifications

### Creating Notifications

Build notifications using NotificationBuilder with a unique ID, title, body, and trigger:

```csharp
INotification CreateEnergyRefillNotification()
{
    return NotificationBuilder.CreateNotification("energy_refill")
        .SetTitle("Energy Restored!")
        .SetBody("Your energy is full. Come back and continue playing!")
        .SetBadge(1)
        .SetTimeIntervalNotificationTrigger(1800) // 30 minutes in seconds
        .Create();
}
```

{% hint style="success" %}
**Notification IDs** must be unique. Scheduling a notification with an existing ID replaces the previous notification. Use descriptive IDs like `"energy_refill"` or `"daily_reward"` for easier management.
{% endhint %}

### Scheduling Notifications

Schedule the notification to be delivered at the trigger time:

```csharp
void ScheduleEnergyNotification()
{
    INotification notification = CreateEnergyRefillNotification();

    NotificationServices.ScheduleNotification(notification, (success, error) =>
    {
        if (success)
        {
            Debug.Log("Energy refill notification scheduled for 30 minutes");
        }
        else
        {
            Debug.LogError($"Failed to schedule: {error?.Description}");
        }
    });
}
```

### Notification Triggers

#### Time Interval Triggers

Use when timing is relative to the current moment:

```csharp
void ConfigureTimeIntervalNotificationTriggers()
{
    // Create a notification builder instance
    var notificationBuilder = NotificationBuilder.CreateNotification("interval_notification")
        .SetTitle("Scheduled Reminder")
        .SetBody("Your scheduled notification");

    // Fire once after 1 hour
    notificationBuilder.SetTimeIntervalNotificationTrigger(3600);

    // Fire every 24 hours (daily)
    notificationBuilder.SetTimeIntervalNotificationTrigger(86400, repeats: true);

    // Fire once after 30 minutes
    notificationBuilder.SetTimeIntervalNotificationTrigger(TimeSpan.FromMinutes(30).TotalSeconds);
}
```

**Common patterns:**
- Energy refills: 30-60 minutes after depletion
- Lives regeneration: Time until next life available
- Building timers: Construction completion time
- Temporary boosts: When boost expires

#### Calendar Triggers

Use when timing should match specific clock times:

```csharp
// Fire every day at 6 PM
var dailyComponents = new DateComponents();
dailyComponents.Hour = 18;
dailyComponents.Minute = 0;

var notification = NotificationBuilder.CreateNotification("daily_reward")
    .SetTitle("Daily Reward Available!")
    .SetBody("Claim your free daily gems and bonuses!")
    .SetCalendarNotificationTrigger(dailyComponents, repeats: true)
    .Create();
```

**Common patterns:**

```csharp
// Daily notification at specific time
var daily = new DateComponents();
daily.Hour = 18; // 6 PM
daily.Minute = 0;

// Weekly notification (Monday at 9 AM)
var weekly = new DateComponents();
weekly.DayOfWeek = 1; // Monday (ISO 8601: 1=Monday, 7=Sunday)
weekly.Hour = 9;
weekly.Minute = 0;

// Monthly notification (15th of each month at noon)
var monthly = new DateComponents();
monthly.Day = 15;
monthly.Hour = 12;
monthly.Minute = 0;

// Annual notification (birthday, anniversary)
var annual = new DateComponents();
annual.Month = userBirthday.Month;
annual.Day = userBirthday.Day;
annual.Hour = 9;
annual.Minute = 0;
```

{% hint style="info" %}
**Calendar trigger rule**: The most specific component determines repeat frequency. Hour only → repeats hourly; Hour + Minute → repeats daily; Day + Hour + Minute → repeats monthly; Month + Day + Hour + Minute → repeats annually.
{% endhint %}

### Adding Custom Data

Attach custom data to notifications for deep linking or identifying notification types:

```csharp
var notification = NotificationBuilder.CreateNotification("tournament_start")
    .SetTitle("Tournament Starting Soon!")
    .SetBody("PvP Tournament begins in 1 hour. Prepare for battle!")
    .SetUserInfo(new Dictionary<string, string>
    {
        ["type"] = "tournament_reminder",
        ["tournament_id"] = "pvp_2024_10",
        ["deep_link"] = "mygame://tournaments/pvp_2024_10"
    })
    .SetTimeIntervalNotificationTrigger(3600)
    .Create();
```

Access custom data in your event handler:

```csharp
void OnNotificationReceived(NotificationServicesNotificationReceivedResult data)
{
    var notification = data.Notification;

    if (notification.UserInfo is IDictionary<string, string> userInfo)
    {
        if (userInfo.TryGetValue("type", out string notifType))
        {
            Debug.Log($"Notification type: {notifType}");

            if (notifType == "tournament_reminder" &&
                userInfo.TryGetValue("tournament_id", out string tournamentId))
            {
                // Navigate to tournament
                Debug.Log($"Open tournament screen for {tournamentId}.");
            }
        }
    }
}
```

### Managing Scheduled Notifications

#### Get Scheduled Notifications

Retrieve all pending notifications that haven't been delivered yet:

```csharp
NotificationServices.GetScheduledNotifications((result, error) =>
{
    if (error == null)
    {
        INotification[] notifications = result.Notifications;
        Debug.Log($"Total scheduled: {notifications.Length}");

        foreach (var notification in notifications)
        {
            Debug.Log($"{notification.Id}: {notification.Title}");
        }
    }
});
```

#### Cancel Scheduled Notifications

```csharp
// Cancel specific notification by ID
NotificationServices.CancelScheduledNotification("energy_refill");

// Or cancel by notification object
NotificationServices.CancelScheduledNotification(notification);

// Cancel all scheduled notifications
NotificationServices.CancelAllScheduledNotifications();
```

**Common patterns:**

```csharp
// Cancel notification when player returns to game
void OnApplicationFocus(bool hasFocus)
{
    if (hasFocus)
    {
        // Player opened app - cancel energy refill notification
        NotificationServices.CancelScheduledNotification("energy_refill");

        // Update energy notification based on current state
        if (!PlayerEnergy.IsFull())
        {
            ScheduleEnergyNotification();
        }
    }
}
```

### Delivered Notifications

#### Get Delivered Notifications

Retrieve notifications currently visible in the device notification center:

```csharp
NotificationServices.GetDeliveredNotifications((result, error) =>
{
    if (error == null)
    {
        INotification[] delivered = result.Notifications;
        Debug.Log($"Notifications in notification center: {delivered.Length}");
    }
});
```

#### Clear Delivered Notifications

```csharp
// Clear all notifications from notification center when player opens app
void OnApplicationFocus(bool hasFocus)
{
    if (hasFocus)
    {
        NotificationServices.RemoveAllDeliveredNotifications();
        Debug.Log("Cleared notification center");
    }
}
```

## Push Notifications

Push notifications require server infrastructure to send messages. Essential Kit handles device registration and notification reception.

### Understanding Push Notification Flow

```
Player App ──▶ (1) Register & fetch device token
             ▽
      Essential Kit caches token
             ▽
Game Server ─▶ (2) Send payload to APNs/FCM
             ▽
Apple/Google push services ─▶ (3) Deliver to device
             ▽
Player App ──▶ (4) `OnNotificationReceived`
```

1. **Device registration**: Your app requests a push notification device token.
2. **Token storage**: Send the token to your game server (Essential Kit also caches it locally).
3. **Server send**: Your server forwards the payload to APNs (iOS) or FCM (Android).
4. **Platform delivery**: Apple or Google push gateways route the message to the device.
5. **App receives**: Essential Kit surfaces the payload via `OnNotificationReceived`.

### Registering for Push Notifications

Request device token after user grants notification permissions:

```csharp
void RegisterForPushNotifications()
{
    NotificationServices.RegisterForPushNotifications((result, error) =>
    {
        if (error == null)
        {
            string deviceToken = result.DeviceToken;
            Debug.Log($"Device token: {deviceToken}");

            // Send token to your game server for push messaging
            SendTokenToServer(deviceToken);
        }
        else
        {
            Debug.LogError($"Push registration failed: {error.Description}");
        }
    });
}

void SendTokenToServer(string deviceToken)
{
    // Send to your backend API
    Debug.Log($"Sending device token to server: {deviceToken}");

    // Example: POST to your server
    // Include player ID, platform, and device token
}
```

Essential Kit also provides helpers when you want the plugin to manage re-registration or expose a global callback:

```csharp
// Automatically registers again once permissions are confirmed
NotificationServices.TryRegisterForPushNotifications();

// Subscribe once to get notified whenever a token refresh completes
NotificationServices.OnRegisterForPushNotificationsComplete += (result, error) =>
{
    if (error == null)
    {
        Debug.Log($"Push token updated: {result.DeviceToken}");
    }
};
```

{% hint style="success" %}
**Device token caching**: Essential Kit caches the device token after successful registration. Access it anytime with `NotificationServices.CachedSettings.DeviceToken` without making another registration request.
{% endhint %}

### Platform-Specific Token Formats

- **iOS**: Returns APNS device token (send to your APNS server or convert to FCM token)
- **Android**: Returns FCM registration token (send directly to FCM)

For unified backends, use FCM SDK to convert APNS tokens to FCM tokens on iOS, allowing a single FCM endpoint for both platforms.

### Checking Registration Status

```csharp
void CheckPushRegistration()
{
    bool isRegistered = NotificationServices.IsRegisteredForPushNotifications();
    Debug.Log($"Registered for push: {isRegistered}");

    if (isRegistered)
    {
        string cachedToken = NotificationServices.CachedSettings.DeviceToken;
        Debug.Log($"Cached device token: {cachedToken}");
    }
}
```

### Unregistering from Push Notifications

```csharp
void UnregisterFromPush()
{
    NotificationServices.UnregisterForPushNotifications();
    Debug.Log("Unregistered from push notifications");
}
```

{% hint style="info" %}
Unregistering from push notifications can save battery when user disables notifications in your game settings. You can always re-register later.
{% endhint %}

### Handling Push Notification Reception

Push notifications are delivered through the same `OnNotificationReceived` event as local notifications:

```csharp
void OnNotificationReceived(NotificationServicesNotificationReceivedResult data)
{
    var notification = data.Notification;

    Debug.Log($"Received: {notification.Title} - {notification.Body}");
    Debug.Log($"Is launch notification: {notification.IsLaunchNotification}");

    // Check if app was launched from notification tap
    if (notification.IsLaunchNotification)
    {
        Debug.Log("App opened from notification tap");
        Debug.Log("Navigate player based on launch notification.");
    }

    // Process custom data from server
    if (notification.UserInfo != null)
    {
        Debug.Log("Push notification custom data received");
        Debug.Log($"Custom payload: {notification.UserInfo}");
    }

    // Clear badge after handling notification
    NotificationServices.SetApplicationIconBadgeNumber(0);
}
```

### Server Payload Examples

Reference payloads for testing push notifications from your server:

**Android (FCM) Payload:**
```json
{
  "to": "device_token_here",
  "data": {
    "content_title": "Flash Sale!",
    "content_text": "50% off gem packs for the next 2 hours!",
    "ticker_text": "Limited time offer",
    "tag": "flash_sale",
    "badge": 1,
    "user_info": {
      "offer_id": "gems_50_off",
      "expires": "2024-10-06T10:00:00Z"
    }
  }
}
```

**iOS (APNS) Payload:**
```json
{
  "aps": {
    "alert": {
      "title": "Flash Sale!",
      "body": "50% off gem packs for the next 2 hours!"
    },
    "badge": 1,
    "sound": "default"
  },
  "user_info": {
    "offer_id": "gems_50_off",
    "expires": "2024-10-06T10:00:00Z"
  }
}
```

## Badge Management

Update the badge number on your app icon to show notification counts or pending items:

```csharp
// Set badge number
NotificationServices.SetApplicationIconBadgeNumber(5);

// Clear badge
NotificationServices.SetApplicationIconBadgeNumber(0);
```

**Common patterns:**

```csharp
// Clear badge when app gains focus
void OnApplicationFocus(bool hasFocus)
{
    if (hasFocus)
    {
        NotificationServices.SetApplicationIconBadgeNumber(0);
    }
}

// Increment badge when scheduling notification
void ScheduleBadgeNotification()
{
    var notification = NotificationBuilder.CreateNotification("daily_reward")
        .SetTitle("Daily Reward Available!")
        .SetBadge(1) // Show badge count in notification
        .Create();

    NotificationServices.ScheduleNotification(notification);
}
```

{% hint style="warning" %}
Badge numbers require **Badge** permission in `RequestPermission()`. On iOS, badge may not be visible if user disabled badges in device settings. Badge permission is granted independently of alert/sound permissions.
{% endhint %}

## Data Properties

| Item | Type | Notes |
| --- | --- | --- |
| `NotificationServicesNotificationReceivedResult.Notification` | `INotification` | Gives you the fully-populated notification instance (title, body, payload, trigger) whenever `OnNotificationReceived` fires. |
| `INotification.UserInfo` | `IDictionary` | Custom key/value payload from local builders or remote push messages—use it for deep links and contextual routing. |
| `INotification.IsLaunchNotification` | `bool` | Identifies whether the notification launched or re-activated the app so you can branch onboarding flows. |
| `NotificationSettings.PermissionStatus` | `NotificationPermissionStatus` | Reflects the latest permission choice (`Authorized`, `Denied`, etc.) returned by `GetSettings` and cached on `NotificationServices.CachedSettings`. |
| `NotificationSettings.DeviceToken` | `string` | The most recent device token (APNs/FCM). Send it to your backend whenever you register for push notifications. |
| `NotificationSettings.PushNotificationEnabled` | `bool` | Confirms whether the platform currently allows remote notifications—handy before prompting users to re-enable permissions. |

## Core APIs Reference

| API | Purpose | Returns |
| --- | --- | --- |
| `NotificationServices.RequestPermission(options, callback)` | Request notification permissions (Alert, Sound, Badge) | Result via callback with `PermissionStatus` or error |
| `NotificationBuilder.CreateNotification(id)` | Start building a notification with unique identifier | NotificationBuilder instance for method chaining |
| `NotificationServices.ScheduleNotification(notification, callback)` | Schedule local notification for delivery | Success flag via callback |
| `NotificationServices.GetScheduledNotifications(callback)` | Get all pending scheduled notifications | Array of `INotification` via callback |
| `NotificationServices.CancelScheduledNotification(id)` | Cancel specific scheduled notification by ID | No return value |
| `NotificationServices.CancelAllScheduledNotifications()` | Cancel all pending scheduled notifications | No return value |
| `NotificationServices.GetDeliveredNotifications(callback)` | Get notifications currently in notification center | Array of `INotification` via callback |
| `NotificationServices.RemoveAllDeliveredNotifications()` | Clear all notifications from notification center | No return value |
| `NotificationServices.RegisterForPushNotifications(callback)` | Register device for push notifications | Device token via callback |
| `NotificationServices.UnregisterForPushNotifications()` | Unregister from push notifications | No return value |
| `NotificationServices.IsRegisteredForPushNotifications()` | Check if device is registered for push | `bool` - true if registered |
| `NotificationServices.SetApplicationIconBadgeNumber(count)` | Set app icon badge number (0 to clear) | No return value |
| `NotificationServices.GetSettings(callback)` | **Optional:** Get current permission status and settings | `NotificationSettings` via callback |
| `NotificationServices.CachedSettings` | Access cached notification settings without callback | `NotificationSettings` object |

### NotificationBuilder Methods

Chain these methods when building notifications:

| Method | Purpose |
| --- | --- |
| `SetTitle(title)` | Set notification title text |
| `SetSubtitle(subtitle)` | Set notification subtitle (iOS only) |
| `SetBody(body)` | Set notification body message |
| `SetBadge(number)` | Set app icon badge number |
| `SetUserInfo(dictionary)` | Set custom data dictionary |
| `SetPriority(priority)` | Set notification priority (Low/Medium/High/Max) |
| `SetTimeIntervalNotificationTrigger(seconds, repeats)` | Set time-based trigger (seconds from now) |
| `SetCalendarNotificationTrigger(components, repeats)` | Set calendar-based trigger (specific times/dates) |
| `SetSoundFileName(filename)` | Set custom sound file from StreamingAssets |
| `SetAndroidProperties(properties)` | Set Android-specific properties (channels, icons) |
| `SetIosProperties(properties)` | Set iOS-specific properties (thread ID, attachments) |
| `Create()` | Build and return final `INotification` object |

## Error Handling

| Error Code | Trigger | Recommended Action |
| --- | --- | --- |
| `PermissionNotAvailable` | User declined notification permissions | Show explanation of benefits and guide to `Utilities.OpenApplicationSettings()` |
| `TriggerNotValid` | Missing or incompatible trigger configuration | Ensure the trigger type matches the platform requirements |
| `ConfigurationError` | Notification payload missing required data | Ensure title/body/payload are populated before scheduling |
| `ScheduledTimeNotValid` | Scheduled time already elapsed or invalid | Validate the fire time before submitting the request |
| `Unknown` | Platform-specific error occurred | Log error details and retry or contact support |

**Error handling pattern:**

```csharp
NotificationServices.ScheduleNotification(notification, (success, error) =>
{
    if (success)
    {
        Debug.Log("Notification scheduled successfully");
        return;
    }

    // Handle error
    if (error != null)
    {
        Debug.LogError($"Failed to schedule: {error.Description}");

        // Check specific error codes
        if (error.Code == (int)NotificationServicesErrorCode.PermissionNotAvailable)
        {
            // Guide user to re-enable permissions
            Debug.LogWarning("Explain why notifications are needed and direct players to Settings.");
        }
    }
});
```

## Advanced: Manual Initialization

{% hint style="danger" %}
**Advanced users only**: Essential Kit auto-initializes NotificationServices with settings from Essential Kit Settings. Only use manual initialization for runtime configuration changes, feature flags, or server-driven settings.
{% endhint %}

### Understanding Auto-Initialization

**Default behavior** (no action required):
- Essential Kit automatically initializes NotificationServices before scene loads
- Uses settings from `Resources/EssentialKitSettings.asset`
- Notification system is immediately ready for use
- Suitable for 99% of use cases

**Advanced manual initialization:**
Override default settings at runtime for specific scenarios:

```csharp
void Awake()
{
    // Only for advanced scenarios: feature flags, runtime config, server-driven settings
    var settings = new NotificationServicesUnitySettings(
        presentationOptions: NotificationPresentationOptions.Alert | NotificationPresentationOptions.Sound,
        pushNotificationServiceType: PushNotificationServiceType.Custom);

    NotificationServices.Initialize(settings);
}
```

**When to use manual initialization:**
- Feature flag systems controlling notification availability
- Server-driven configuration for presentation options
- Environment-specific push service types (dev/staging/production)
- Runtime permission option configuration based on user preferences

**When NOT to use manual initialization:**
- Standard notification implementation
- Default presentation options work for your game
- Using settings configured in Essential Kit Settings
- No runtime configuration changes needed

{% hint style="warning" %}
Calling `Initialize()` resets all event listeners. Re-register for `OnNotificationReceived` and other events after initialization.
{% endhint %}

## Related Guides
- Demo scene: `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/NotificationServicesDemo.unity`
- Use **Utilities.OpenApplicationSettings()** for permission recovery flows when users deny notifications
- Pair with **DeepLinkServices** to handle notification taps that should navigate to specific in-game content
- Combine with **CloudServices** to sync notification preferences across devices

{% hint style="success" %}
Ready to test? Head to [Testing](testing.md) to validate your notification implementation.
{% endhint %}
