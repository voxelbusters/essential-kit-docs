---
description: "Common notification issues and solutions"
---

# FAQ & Troubleshooting

## Do I need to add notification permissions manually in my project settings?

No. Essential Kit automatically injects required permissions into `AndroidManifest.xml` (Android) and `Info.plist` (iOS) during the build process. You only need to configure presentation options and usage descriptions in Essential Kit Settings.

**What Essential Kit handles automatically:**
- Android: `VIBRATE`, `RECEIVE_BOOT_COMPLETED`, `C2DM_RECEIVE` permissions
- iOS: `UserNotifications.framework`, Push Notifications capability
- Android: Notification channel creation and management
- iOS: Notification category registration

**What you need to configure:**
- Presentation options (Alert, Sound, Badge) in Essential Kit Settings
- iOS usage description (shown in permission dialog)
- Android notification icons (white and colored small icons)
- Firebase `google-services.json` for push notifications (Android)

## Users denied notification permissions - how do I let them re-enable?

Use `Utilities.OpenApplicationSettings()` to deep link into the device settings screen where users can manually enable notifications:

```csharp
void OnPermissionDenied()
{
    Debug.Log("Explain why notifications are useful, then open Settings.");
    Utilities.OpenApplicationSettings();
    Debug.Log("Opened device settings for user to enable notifications.");
}
```

**UX best practices:**
- Explain the specific benefit before opening settings
- Don't repeatedly prompt users who have explicitly denied
- Provide value even without notifications (graceful degradation)
- Only ask to re-enable when contextually relevant (e.g., when they try to enable a notification-dependent feature)

{% hint style="warning" %}
On iOS, permission dialogs appear only once per app installation. If denied, the only way to re-enable is through device Settings. Plan your permission request timing carefully.
{% endhint %}

## How can I test notifications on iOS simulator?

**Short answer:** You can't fully test on iOS simulator. Real device testing is required.

**What works in simulator:**
- Unity Editor simulator (console logging only)
- Permission request flows (simulated)
- Notification scheduling logic

**What doesn't work in simulator:**
- Local notifications don't appear in notification center
- Push notifications can't receive real messages from APNS
- Badge numbers don't update on app icon
- Notification sounds don't play
- `IsLaunchNotification` behavior can't be tested

**Recommended approach:**
1. Test logic and scheduling in Unity Editor simulator
2. Build to physical iOS device for actual notification testing
3. Use debug builds with detailed logging to verify notification payloads
4. Use [Knuff](https://github.com/KnuffApp/Knuff) or similar tools to send test push notifications to physical devices

## My scheduled notifications aren't firing - what should I check?

**Checklist for troubleshooting:**

1. **Verify permissions were granted:**
```csharp
NotificationServices.GetSettings((result) =>
{
    Debug.Log($"Permission status: {result.Settings.PermissionStatus}");
    if (result.Settings.PermissionStatus != NotificationPermissionStatus.Authorized)
    {
        Debug.LogWarning("Notifications won't fire - permissions not granted");
    }
});
```

2. **Confirm notification was scheduled:**
```csharp
NotificationServices.GetScheduledNotifications((result, error) =>
{
    if (error == null)
    {
        Debug.Log($"Currently scheduled: {result.Notifications.Length} notifications");
        foreach (var notif in result.Notifications)
        {
            Debug.Log($"  - {notif.Id}: {notif.Title}");
        }
    }
});
```

3. **Check notification trigger timing:**
- Time interval triggers: Did you use seconds, not minutes? (1800 seconds = 30 minutes)
- Calendar triggers: Are components set correctly? (Hour=18 for 6 PM, not 18:00)
- Is the trigger time in the past? Notifications with past triggers may fire immediately or not at all

4. **Verify app isn't canceling notifications:**
- Check for `CancelScheduledNotification()` or `CancelAllScheduledNotifications()` calls
- Verify `OnApplicationFocus()` or similar lifecycle methods aren't canceling unintentionally

5. **Platform-specific issues:**
- **iOS**: System limits scheduled notifications to ~64. Older notifications may be dropped if limit exceeded
- **Android**: Battery optimization may delay notifications. Test with optimization disabled
- **Android**: Do Not Disturb mode can suppress notifications entirely
- **iOS**: Low Power Mode may delay notification delivery

## On Android, how do I make each notification appear as a separate entry in notification center?

Use the **Tag** property in Android-specific properties. Notifications with different tags create separate entries; same tag replaces the previous notification:

```csharp
var androidProperties = new NotificationAndroidProperties();
androidProperties.Tag = $"unique_tag_{System.Guid.NewGuid()}"; // Each notification gets unique tag

var notification = NotificationBuilder.CreateNotification("notif_id")
    .SetTitle("New Message")
    .SetBody("You have a new message!")
    .SetAndroidProperties(androidProperties)
    .Create();
```

**Common patterns:**

```csharp
// Separate notification for each event
androidProperties.Tag = $"tournament_{tournamentId}";

// Replace previous notification of same type
androidProperties.Tag = "energy_refill"; // Always replaces previous energy notification

// Grouped notifications (same tag)
androidProperties.Tag = "daily_reward"; // All daily rewards use same notification slot
```

**On iOS**, use thread identifiers to group related notifications:

```csharp
var iosProperties = new NotificationIosProperties();
iosProperties.ThreadIdentifier = "tournament_updates"; // Groups tournament notifications together

var notification = NotificationBuilder.CreateNotification("notif_id")
    .SetTitle("Tournament Update")
    .SetIosProperties(iosProperties)
    .Create();
```

## Can I show notifications when the app is in foreground on Android?

Yes. Enable **"Allow Notification Display when Foreground"** in Essential Kit Settings under Android Properties.

**Configuration:**
1. Open Essential Kit Settings (`Window > Voxel Busters > Essential Kit > Open Settings`)
2. Go to **Services** tab > **Notification Services**
3. Expand **Android Properties**
4. Enable **"Allow Notification Display when Foreground"**

**Default behavior:**
- **Foreground off**: Notifications only appear when app is backgrounded or closed
- **Foreground on**: Notifications appear as banners even when app is actively running

{% hint style="success" %}
On iOS, control foreground display using `PresentationOptions` in settings (Alert, Sound, Badge). Set these to control how notifications appear when app is in foreground.
{% endhint %}

## Our server uses custom payload keys for push notifications - how do I configure them?

Essential Kit lets you map custom server payload keys to standard notification fields in Android properties.

**Configuration:**
1. Open Essential Kit Settings > Services > Notification Services
2. Expand **Android Properties** > **Payload Keys**
3. Set your custom keys for each field:

| Standard Key | Default | Your Custom Key |
| --- | --- | --- |
| Content Title | `content_title` | Your server's title field name |
| Content Text | `content_text` | Your server's body field name |
| Ticker Text | `ticker_text` | Your server's ticker field name |
| User Info | `user_info` | Your server's custom data field name |
| Tag | `tag` | Your server's tag field name |
| Badge | `badge` | Your server's badge count field name |

**Example server payload with custom keys:**
```json
{
  "to": "device_token",
  "data": {
    "title": "Flash Sale!", // Custom key instead of "content_title"
    "message": "50% off!", // Custom key instead of "content_text"
    "metadata": {          // Custom key instead of "user_info"
      "offer_id": "gems_50"
    }
  }
}
```

**Configure in settings:**
- Content Title → `title`
- Content Text → `message`
- User Info → `metadata`

{% hint style="info" %}
iOS uses standard APNS payload format and doesn't support custom key mapping. Structure iOS payloads according to [Apple's APNS documentation](https://developer.apple.com/documentation/usernotifications/setting_up_a_remote_notification_server/generating_a_remote_notification).
{% endhint %}

## What are the payload formats for reference?

### Android FCM Payload Example

```json
{
  "to": "APA91bE38IGujnSN5...",
  "data": {
    "content_title": "Tournament Reminder",
    "content_text": "PvP Tournament starts in 30 minutes!",
    "ticker_text": "Tournament Alert",
    "tag": "tournament_123",
    "custom_sound": "notification.mp3",
    "large_icon": "tournament_icon.png",
    "badge": 3,
    "user_info": {
      "type": "tournament",
      "tournament_id": "pvp_2024_10",
      "deep_link": "mygame://tournaments/pvp_2024_10"
    }
  }
}
```

### iOS APNS Payload Example

```json
{
  "aps": {
    "alert": {
      "title": "Tournament Reminder",
      "body": "PvP Tournament starts in 30 minutes!"
    },
    "badge": 3,
    "sound": "notification.mp3",
    "thread-id": "tournament_updates"
  },
  "user_info": {
    "type": "tournament",
    "tournament_id": "pvp_2024_10",
    "deep_link": "mygame://tournaments/pvp_2024_10"
  }
}
```

**Field explanations:**

| Field | Purpose | Platform |
| --- | --- | --- |
| `content_title` / `alert.title` | Notification title | Both |
| `content_text` / `alert.body` | Notification body message | Both |
| `ticker_text` | Status bar text (Android only) | Android |
| `badge` | App icon badge number | Both |
| `tag` | Notification grouping key | Android |
| `thread-id` | Notification grouping identifier | iOS |
| `user_info` | Custom data for deep linking | Both |
| `sound` | Custom sound filename | Both |
| `large_icon` / `big_picture` | Expandable notification images | Android |

## I'm migrating from Unity Mobile Notifications - how difficult is the transition?

Essential Kit provides a simpler, more unified API compared to Unity Mobile Notifications. Migration is straightforward:

**Key differences:**

| Unity Mobile Notifications | Essential Kit |
| --- | --- |
| `AndroidNotificationCenter` + `iOSNotificationCenter` | Single `NotificationServices` class |
| Platform-specific notification classes | Unified `INotification` interface |
| Manual channel management (Android) | Automatic channel creation |
| Separate permission flows per platform | Single `RequestPermission()` for both |
| Manual initialization required | Auto-initialization, optional override |

**Migration steps:**

1. **Replace platform-specific code:**
```csharp
// OLD: Unity Mobile Notifications
#if UNITY_ANDROID
AndroidNotificationCenter.SendNotification(notification, "channel_id");
#elif UNITY_IOS
iOSNotificationCenter.ScheduleNotification(notification);
#endif

// NEW: Essential Kit
NotificationServices.ScheduleNotification(notification, (success, error) => {
    Debug.Log($"Scheduled: {success}");
});
```

2. **Update permission requests:**
```csharp
// OLD: Platform-specific
#if UNITY_IOS
var authOptions = AuthorizationOption.Alert | AuthorizationOption.Badge;
using (var req = new AuthorizationRequest(authOptions, false))
{
    while (!req.IsFinished) yield return null;
}
#endif

// NEW: Cross-platform
NotificationServices.RequestPermission(
    NotificationPermissionOptions.Alert | NotificationPermissionOptions.Badge,
    (result, error) => { /* handle result */ }
);
```

3. **Migrate notification creation:**
```csharp
// OLD: Platform-specific builders
#if UNITY_ANDROID
var notification = new AndroidNotification();
notification.Title = "Title";
notification.Text = "Body";
#endif

// NEW: Unified builder
var notification = NotificationBuilder.CreateNotification("unique_id")
    .SetTitle("Title")
    .SetBody("Body")
    .Create();
```

{% hint style="success" %}
Need migration help? Contact Essential Kit support team with your specific use cases for personalized migration guidance.
{% endhint %}

## Calendar notifications fire at the wrong time after timezone changes

Calendar notifications use the device's current local time. When timezone changes occur, ensure your DateComponents are set for local time, not absolute UTC time:

**Correct approach (local time):**
```csharp
// This fires at 6 PM local time, regardless of timezone
var components = new DateComponents();
components.Hour = 18;  // 6 PM local time
components.Minute = 0;

var notification = NotificationBuilder.CreateNotification("daily_reward")
    .SetCalendarNotificationTrigger(components, repeats: true)
    .Create();
```

**Avoid using absolute timestamps:**
```csharp
// DON'T DO THIS - Breaks with timezone changes
var specificTime = new DateTime(2024, 10, 6, 18, 0, 0, DateTimeKind.Utc);
// Convert to local components instead
```

**Daylight saving time considerations:**
- Calendar notifications automatically adjust to DST changes
- If DST transition skips your notification time (e.g., 2:00 AM on spring forward), notification may not fire
- Avoid scheduling notifications during DST transition hours (typically 2:00-3:00 AM)

## Where can I confirm plugin behavior versus my implementation?

Run the demo scene to isolate issues:

1. Open `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/NotificationServicesDemo.unity`
2. Run the demo scene and test the exact feature causing issues
3. Compare demo scene behavior to your implementation

**If demo works but your scene doesn't:**
- Compare Essential Kit Settings configuration between projects
- Verify event registration (OnEnable/OnDisable pattern)
- Check for conflicting code canceling notifications
- Review error callbacks and Unity console logs

**If demo also fails:**
- Verify Essential Kit Settings has NotificationServices enabled
- Confirm platform setup (Firebase config for Android, certificates for iOS)
- Check device permissions were granted
- Contact Essential Kit support with demo scene reproduction steps

{% hint style="info" %}
The demo scene includes comprehensive examples of every notification feature. It's the best reference for correct API usage patterns.
{% endhint %}

## Notifications work locally but fail in production builds

**Common causes:**

1. **iOS: Invalid or expired push certificates**
   - Verify APNS certificates in Apple Developer Portal
   - Ensure production certificates match release builds
   - Regenerate certificates if expired

2. **Android: Wrong `google-services.json` file**
   - Confirm JSON file matches production Firebase project
   - Verify SHA-1 fingerprint in Firebase Console matches release keystore
   - Don't use development Firebase projects for production

3. **Build configuration mismatches:**
   - Essential Kit Settings must be identical between development and production
   - Verify notification icons are included in production builds
   - Check that custom sounds exist in `StreamingAssets`

4. **Platform-specific issues:**
   - **iOS**: Production builds require production APNS environment
   - **Android**: Release builds require properly signed APK/AAB with matching Firebase configuration

**Debugging production issues:**
```csharp
// Add detailed logging to production builds
NotificationServices.GetSettings((result) =>
{
    Debug.Log($"[PRODUCTION] Permission: {result.Settings.PermissionStatus}");
    Debug.Log($"[PRODUCTION] Device token: {result.Settings.DeviceToken}");
});

NotificationServices.RegisterForPushNotifications((result, error) =>
{
    if (error != null)
    {
        Debug.LogError($"[PRODUCTION] Push registration failed: {error.Description}");
    }
    else
    {
        Debug.Log($"[PRODUCTION] Push token: {result.DeviceToken}");
    }
});
```

Enable remote logging or analytics to capture production errors users encounter.
