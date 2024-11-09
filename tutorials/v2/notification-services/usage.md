# Usage

Once after the [setup](setup/), import the namespace to access the features from Notification Services.

```csharp
using VoxelBusters.CoreLibrary;
using VoxelBusters.EssentialKit;
```

### Request Access (for presentation options)

A notification can have a visual display, sound, badge and other properties. You need to request them based on how you want to present the notifications to the user with RequestPermission method.

```csharp
NotificationServices.RequestPermission(NotificationPermissionOptions.Alert | NotificationPermissionOptions.Sound | NotificationPermissionOptions.Badge, callback: (result, error) =>
{
    Debug.Log("Request for access finished.");
    Debug.Log("Notification access status: " + result.PermissionStatus);
});
```

{% hint style="success" %}
Check for other permission options in **NotificationPermissionOptions** available on iOS specifically.
{% endhint %}

### Get Settings

You can check what **settings user allowed** with **GetSettings** method. This will be handy if you want to check if user denied the settings so that you can prompt him with suitable message.

```csharp
NotificationServices.GetSettings((result) =>
{
    NotificationSettings settings    = result.Settings;
    // update console
    Debug.Log(settings.ToString());

    Debug.Log("Permission status : " + settings.PermissionStatus);
});
```

{% hint style="success" %}
If you see user didn't allow the permission earlier, you can use [Utilities. OpenApplicationSettings](../extras/usage.md#open-application-settings) method to let user to enable the permission for using the notifications display feature.
{% endhint %}

## Local Notifications

### Create a Notification Message

For scheduling notifications, you need to create an instance of **INotification**.

```csharp
INotification notification = NotificationBuilder.CreateNotification("notifId")
    .SetTitle("Title")
    .Create();
```

### Schedule Notification

For scheduling a notification, you need to have an instance of **INotification** which contains the details required for a notification. Use **ScheduleNotification** for scheduling the notification.

```csharp
NotificationServices.ScheduleNotification(notification, (error) =>
{
    if (error == null)
    {
        Debug.Log("Request to schedule notification finished successfully.");
    }
    else
    {
        Debug.Log("Request to schedule notification failed with error. Error: " + error);
    }
});
```

The above call will schedule the notification instantly and incase if you want to schedule in the future, you need to set the **Time Interval Trigger**

```csharp
INotification notification = NotificationBuilder.CreateNotification("notif-id-1")
    .SetTitle("Title")
    .SetTimeIntervalNotificationTrigger(10) //Setting the time interval to 10 seconds
    .Create();
```

### Repeat Notifications

When setting the time interval notification you can pass additionally repeat status to repeat the notification. The below notification repeats every 10 seconds.

```csharp
INotification notification = NotificationBuilder.CreateNotification("notif-id-1")
    .SetTitle("Title")
    .SetTimeIntervalNotificationTrigger(interval: 10, repeats: true) //Setting the time interval to 10 seconds
    .Create();
```

### Get Scheduled Notifications

You can get the list of all scheduled notifications and not yet delivered with **GetScheduledNotifications**

```csharp
NotificationServices.GetScheduledNotifications((result, error) =>
{
    if (error == null)
    {
        // show console messages
        INotification[] notifications   = result.Notifications;
        Debug.Log("Request for fetch scheduled notifications finished successfully.");
        Debug.Log("Total notifications scheduled: " + notifications.Length);
        Debug.Log("Below are the notifications:");
        for (int iter = 0; iter < notifications.Length; iter++)
        {
            INotification notification    = notifications[iter];
            Debug.Log(string.Format("[{0}]: {1}", iter, notification));
        }
    }
    else
    {
        Debug.Log("Request for fetch scheduled notifications failed with error. Error: " + error);
    }
});
```

### Cancel Scheduled Notification/Notifications

As each notification has an unique Id (assigned when creating), you can cancel the notification with this id.

```csharp
NotificationServices.CancelScheduledNotification("notif-id-1");
```

Cancel all scheduled notifications

```csharp
NotificationServices.CancelAllScheduledNotifications();
```

### Get Delivered Notifications

**GetDeliveredNotifications** return all the notifications delivered in the Android or iOS notification center.

```csharp
NotificationServices.GetDeliveredNotifications((result, error) =>
{
    if (error == null)
    {
        // show console messages
        INotification[] notifications   = result.Notifications;
        Debug.Log("Request for fetch delivered notifications finished successfully.");
        Debug.Log("Total notifications received: " + notifications.Length);
        Debug.Log("Below are the notifications:");
        for (int iter = 0; iter < notifications.Length; iter++)
        {
            INotification notification    = notifications[iter];
            Debug.Log(string.Format("[{0}]: {1}", iter, notification));
        }
    }
    else
    {
        Debug.Log("Request for fetch delivered notifications failed with error. Error: " + error);
    }
});
```

### Remove Delivered Notifications

**RemoveAllDeliveredNotifications** removes all notifications delivered in the Android or iOS notification center **.**

```
NotificationServices.RemoveAllDeliveredNotifications();
```

## Push Notifications or Remote Notifications

While local notifications are created locally and delivered to the device, Push notifications needs an external/backend server to deliver the notification to device.

Go through the following steps to understand how a push notification works.

1. Device registers for push notifications and receive a token
2. The token(also known as device token or registration token) will be sent to your backend server
3. Your backend server constructs the message payload it wants to pass to your device and sends a request to the platform's notification servers (APNS on iOS and FCM on Android) along with the device token it received in step 2.
4. Platform's notification servers then targets the device with the device token and pushes the message payload to the device.
5. Yay! :men\_with\_bunny\_ears\_partying: Your device will receive a notification!

### Remote Notifications Management

For getting the device token, you first need to register for push notifications. In the callback, you get the device token.

```csharp
NotificationServices.RegisterForPushNotifications((result, error) =>
{
    if (error == null)
    {
        Debug.Log("Remote notification registration finished successfully. Device token: " + result.DeviceToken);
    }
    else
    {
        Debug.Log("Remote notification registration failed with error. Error: " + error.Description);
    }
});
```

{% hint style="success" %}
Once after registration, the plugin caches the device token for your future usability. You can fetch with **NotificationServices.CachedSettings.DeviceToken**
{% endhint %}

Also, you can check if remote notifications are already registered on the device with **IsRegisteredForRemoteNotifications**

```csharp
bool    isRegistered    = NotificationServices.IsRegisteredForPushNotifications();
Debug.Log("Is registered for remote notifications: " + isRegistered);
```

Once you are done with the remote notifications, you can unregister for the push notifications.

```csharp
NotificationServices.UnregisterForPushNotifications();
```

{% hint style="success" %}
If your user disables the push notifications, unregistering for remote notifications will save battery on the device!
{% endhint %}



## Detecting App launch through Notification

There will be cases where you need to identify if the app is launched when user clicked on the notification from Notification Center.

**INotification** has a property **IsLaunchNotification** property which tells if the notification is launched on user tap.

{% hint style="info" %}
Plugin automatically delays delivering the notification until you register for **NotificationServices.OnNotificationReceived** event. Once you register, plugin delivers with IsLaunchNotification variable set to true if it's tapped by the user.
{% endhint %}
