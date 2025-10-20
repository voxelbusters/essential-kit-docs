# Notification Permissions

## What are Notification Permissions?

Notification permissions control whether your Unity mobile game can display notifications to users. Both iOS and Android require explicit user consent before your app can show notifications, play sounds, or update app badges.

Why use notification permissions in a Unity mobile game? Without proper permissions, your game cannot remind players about daily rewards, energy refills, or special events - critical features for player retention and engagement.

## Essential Kit Permission APIs

The Essential Kit provides these key methods for managing notification permissions:

### RequestPermission()
Requests notification permissions from the user with customizable options:

```csharp
using VoxelBusters.EssentialKit;

// Request basic notification permissions
NotificationServices.RequestPermission(
    NotificationPermissionOptions.Alert | NotificationPermissionOptions.Sound | NotificationPermissionOptions.Badge,
    callback: (result, error) =>
    {
        if (error == null)
        {
            Debug.Log($"Permission granted: {result.PermissionStatus}");
        }
        else
        {
            Debug.Log($"Permission error: {error.Description}");
        }
    });
```

This snippet requests alert, sound, and badge permissions and logs the result.

### GetSettings()
Retrieves current notification permission status and settings:

```csharp
NotificationServices.GetSettings((result, error) =>
{
    if (error == null)
    {
        Debug.Log($"Permission Status: {result.Settings.PermissionStatus}");
        Debug.Log($"Alert Setting: {result.Settings.AlertSetting}");
        Debug.Log($"Sound Setting: {result.Settings.SoundSetting}");
    }
});
```

This snippet checks the current permission status and individual notification settings.

### Helper Methods
Essential Kit provides convenient helper methods for permission checks:

```csharp
// Check if permissions are authorized
bool isAuthorized = NotificationServices.IsAuthorized();
Debug.Log($"Notifications authorized: {isAuthorized}");

// Check if permission status is available (not undetermined)
bool hasPermissionInfo = NotificationServices.IsPermissionAvailable();
Debug.Log($"Permission info available: {hasPermissionInfo}");
```

This snippet demonstrates quick permission status checking methods.

## Permission Options

The `NotificationPermissionOptions` enum provides granular control:

- **Alert**: Display notification UI
- **Sound**: Play notification sounds  
- **Badge**: Update app icon badge count
- **CarPlay**: Show notifications in CarPlay
- **CriticalAlert**: Play sounds for critical notifications
- **Provisional**: Deliver notifications quietly initially
- **Announcement**: Siri announcement support
- **ExactTiming**: Precise delivery timing (Android)

📌 **Video Note**: Show Unity demo clip of permission request dialog appearing and different permission combinations in action.