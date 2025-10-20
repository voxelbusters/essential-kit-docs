# Advanced Usage

This section covers advanced notification concepts and scenarios for experienced Unity developers working with complex notification requirements.

## Custom Notification Properties

### iOS-Specific Properties
Customize notifications with iOS-specific features:

```csharp
using VoxelBusters.EssentialKit;

var iosProperties = new NotificationIosProperties()
{
    LaunchImageName = "launch_special.png",
    AttachmentUrl = "https://example.com/attachment.jpg"
};

var iosNotification = NotificationServices.CreateNotificationWithId("ios_specific")
    .SetTitle("iOS Enhanced Notification")
    .SetIosProperties(iosProperties)
    .SetTimeIntervalNotificationTrigger(60)
    .Create();
```

### Android-Specific Properties
Utilize Android notification channels and custom icons:

```csharp
var channel = new NotificationChannel()
{
    Id = "game_events",
    Name = "Game Events",
    Description = "Important game events and updates"
};

var androidProperties = new NotificationAndroidProperties()
{
    Channel = channel,
    LargeIcon = "large_game_icon.png",
    BigPicture = "event_banner.jpg",
    Tag = "special_event"
};

var androidNotification = NotificationServices.CreateNotificationWithId("android_enhanced")
    .SetTitle("Special Event Started!")
    .SetAndroidProperties(androidProperties)
    .SetTimeIntervalNotificationTrigger(120)
    .Create();
```

## Custom Initialization with Settings

Initialize Notification Services with custom settings for advanced control:

```csharp
void Start()
{
    // Get your custom settings asset
    var customSettings = Resources.Load<NotificationServicesUnitySettings>("MyNotificationSettings");
    
    // Initialize with custom settings
    NotificationServices.Initialize(customSettings);
    
    Debug.Log("Notification Services initialized with custom settings");
}
```

## Comprehensive Error Handling

Handle specific notification errors using the error code enumeration:

```csharp
NotificationServices.RequestPermission(
    NotificationPermissionOptions.Alert | NotificationPermissionOptions.Sound,
    callback: (result, error) =>
    {
        if (error != null)
        {
            switch (error.Code)
            {
                case NotificationServicesErrorCode.Unknown:
                    Debug.LogError("Unknown notification error occurred");
                    break;
                case NotificationServicesErrorCode.NotSupported:
                    Debug.LogError("Notifications not supported on this device");
                    break;
                case NotificationServicesErrorCode.PermissionDenied:
                    Debug.LogWarning("User denied notification permissions");
                    ShowPermissionDeniedDialog();
                    break;
            }
        }
    });
```

## Advanced Permission Management

Check permission status with detailed analysis:

```csharp
void AnalyzePermissionStatus()
{
    NotificationServices.GetSettings((result, error) =>
    {
        if (error == null)
        {
            var settings = result.Settings;
            
            // Analyze individual permission components
            bool canShowAlerts = settings.AlertSetting == NotificationSettingStatus.Enabled;
            bool canPlaySounds = settings.SoundSetting == NotificationSettingStatus.Enabled;
            bool canUpdateBadge = settings.BadgeSetting == NotificationSettingStatus.Enabled;
            
            Debug.Log($"Alert: {canShowAlerts}, Sound: {canPlaySounds}, Badge: {canUpdateBadge}");
            
            // Handle provisional permissions
            if (settings.PermissionStatus == NotificationPermissionStatus.Provisional)
            {
                Debug.Log("Using provisional permissions - notifications delivered quietly");
            }
        }
    });
}
```

## Complex Notification Scheduling

Schedule multiple related notifications with coordination:

```csharp
void ScheduleGameEventSequence()
{
    // Pre-event notification
    var preEvent = NotificationServices.CreateNotificationWithId("pre_event")
        .SetTitle("Event Starting Soon!")
        .SetBody("Tournament begins in 1 hour. Prepare your strategy!")
        .SetTimeIntervalNotificationTrigger(23 * 60 * 60) // 23 hours from now
        .Create();
    
    // Event start notification
    var eventStart = NotificationServices.CreateNotificationWithId("event_start")
        .SetTitle("Tournament Has Begun!")
        .SetBody("Join the tournament now for exclusive rewards!")
        .SetTimeIntervalNotificationTrigger(24 * 60 * 60) // 24 hours from now
        .Create();
    
    // Schedule both notifications
    NotificationServices.ScheduleNotification(preEvent, (success, error) =>
    {
        if (success)
        {
            NotificationServices.ScheduleNotification(eventStart);
            Debug.Log("Event sequence scheduled successfully");
        }
    });
}
```

## Dynamic Notification Priority

Set notification priority based on game state:

```csharp
void SchedulePriorityNotification(bool isUrgent)
{
    var priority = isUrgent ? NotificationPriority.High : NotificationPriority.Default;
    
    var notification = NotificationServices.CreateNotificationWithId("dynamic_priority")
        .SetTitle(isUrgent ? "URGENT: Guild Under Attack!" : "Guild Update")
        .SetBody(isUrgent ? "Your guild needs help immediately!" : "Check your guild status")
        .SetPriority(priority)
        .SetTimeIntervalNotificationTrigger(60)
        .Create();
        
    NotificationServices.ScheduleNotification(notification);
}
```

## Multi-Platform Conditional Logic

Handle platform-specific notification behavior:

```csharp
void CreatePlatformOptimizedNotification()
{
    var builder = NotificationServices.CreateNotificationWithId("platform_specific")
        .SetTitle("Platform Optimized Notification")
        .SetBody("This notification is optimized for your platform");
    
    #if UNITY_IOS
    var iosProperties = new NotificationIosProperties()
    {
        LaunchImageName = "ios_launch.png"
    };
    builder.SetIosProperties(iosProperties);
    #elif UNITY_ANDROID
    var androidProperties = new NotificationAndroidProperties()
    {
        LargeIcon = "android_large.png",
        Channel = new NotificationChannel()
        {
            Id = "platform_channel",
            Name = "Platform Notifications"
        }
    };
    builder.SetAndroidProperties(androidProperties);
    #endif
    
    var notification = builder.SetTimeIntervalNotificationTrigger(300).Create();
    NotificationServices.ScheduleNotification(notification);
}
```

📌 **Video Note**: Show Unity demo of each advanced scenario - custom properties displaying correctly, error handling in action, and platform-specific features working on different devices.