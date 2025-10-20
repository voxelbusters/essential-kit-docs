# Remote Notifications (Push Notifications)

## What are Remote Notifications?

Remote notifications (also called push notifications) are messages sent from your server to players' devices through Apple's APNS or Google's FCM services. They enable real-time communication with players even when your Unity mobile game isn't running.

Why use remote notifications in a Unity mobile game? They're crucial for multiplayer engagement - notify players about guild wars, friend requests, tournament results, or time-sensitive events that require immediate attention.

## Essential Kit Remote Notification APIs

### Registering for Push Notifications
Register the device to receive remote notifications and get a device token:

```csharp
using VoxelBusters.EssentialKit;

// Register for push notifications
NotificationServices.RegisterForPushNotifications((result, error) =>
{
    if (error == null)
    {
        Debug.Log($"Device Token: {result.DeviceToken}");
        // Send this token to your server for push messaging
        SendTokenToServer(result.DeviceToken);
    }
    else
    {
        Debug.Log($"Registration failed: {error.Description}");
    }
});
```

This snippet registers the device and provides the token needed for your server to send push notifications.

### Checking Registration Status
Verify if the device is currently registered for push notifications:

```csharp
bool isRegistered = NotificationServices.IsRegisteredForPushNotifications();
Debug.Log($"Device registered for push: {isRegistered}");

// Try to register automatically if user has permissions
NotificationServices.TryRegisterForPushNotifications();
```

This snippet checks registration status and attempts automatic registration when permissions allow.

### Unregistering from Push Notifications
Unregister the device from receiving remote notifications:

```csharp
NotificationServices.UnregisterForPushNotifications();
Debug.Log("Device unregistered from push notifications");
```

This snippet unregisters the device, typically used when players opt out of notifications.

### Handling Received Notifications
Listen for incoming remote notifications:

```csharp
void Start()
{
    // Subscribe to notification received events
    NotificationServices.OnNotificationReceived += OnNotificationReceived;
}

void OnNotificationReceived(NotificationServicesNotificationReceivedResult result)
{
    var notification = result.Notification;
    Debug.Log($"Received notification: {notification.Title}");
    Debug.Log($"Body: {notification.Body}");
    
    // Handle custom data from your server
    if (notification.UserInfo != null)
    {
        foreach (var kvp in notification.UserInfo)
        {
            Debug.Log($"Custom data - {kvp.Key}: {kvp.Value}");
        }
    }
}
```

This snippet handles incoming remote notifications and processes any custom data sent from your server.

### App Icon Badge Management
Control the app icon badge number (especially useful for iOS):

```csharp
// Set badge number (number of unread notifications)
NotificationServices.SetApplicationIconBadgeNumber(5);

// Clear badge
NotificationServices.SetApplicationIconBadgeNumber(0);
```

This snippet manages the red badge number that appears on your app icon.

### Event-Based Registration
Use the static event for registration completion:

```csharp
void Start()
{
    NotificationServices.OnRegisterForPushNotificationsComplete += OnRegistrationComplete;
}

void OnRegistrationComplete(NotificationServicesRegisterForPushNotificationsResult result, Error error)
{
    if (error == null)
    {
        Debug.Log($"Registration completed with token: {result.DeviceToken}");
        // Update server with new device token
    }
}
```

This snippet uses event-based handling for push notification registration completion.

📌 **Video Note**: Show Unity demo of registering for push notifications, displaying the device token, and receiving a test push notification from a server.