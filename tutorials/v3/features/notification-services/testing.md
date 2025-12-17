---
description: "Testing notification implementation in editor and on devices"
---

# Testing & Validation

Use these checks to confirm your NotificationServices integration before release.

## Editor Simulation

Essential Kit provides a notification simulator that runs automatically in the Unity Editor, allowing you to test notification flows without building to devices.

**What the simulator provides:**
- Permission request dialog simulation
- Scheduled notification tracking
- Notification delivery simulation with configurable delays
- Push notification registration simulation
- Badge number updates

**How to use the simulator:**
1. Run your scene in the Unity Editor
2. Call `RequestPermission()` to see simulated permission dialog in Unity console
3. Schedule notifications with short time intervals (10-30 seconds) for faster testing
4. Observe notification events firing in `OnNotificationReceived` callback
5. Check Unity console for notification scheduling and delivery logs

**Simulator limitations:**
- Notifications don't appear in system notification center (editor only shows console logs)
- No visual notification banners (use logs to verify content)
- Push notifications simulate device token generation but can't receive real server messages
- Time triggers fire but don't account for app backgrounding behavior

{% hint style="info" %}
**Reset simulator data**: When you need to reset notification permissions or clear scheduled notifications in the editor, click **Reset Simulator** in Essential Kit Settings > Services > Notification Services section.
{% endhint %}

## Device Testing Checklist

Always test on real iOS and Android devices before release. Simulator behavior differs significantly from device behavior.

### Permission Flow Testing
- [ ] Fresh install shows permission dialog on first `RequestPermission()` call
- [ ] Permission dialog displays your configured usage description (iOS only)
- [ ] Denying permissions completes callback with `PermissionDenied` status
- [ ] Granting permissions allows notification scheduling immediately
- [ ] `GetSettings()` returns correct `PermissionStatus` after user choice
- [ ] Re-installing app resets permission state to `NotDetermined` (iOS) or allows re-prompting (Android)

### Local Notification Testing
- [ ] **Time interval notifications** fire at correct delays (test with 1-2 minute intervals)
- [ ] **Calendar notifications** fire at specified clock times (test with near-future times)
- [ ] **Repeating notifications** fire multiple times at correct intervals
- [ ] Notifications display correct **title**, **body**, and **badge** numbers
- [ ] **Custom sounds** play from `StreamingAssets` folder (Android and iOS)
- [ ] **Notification tapping** opens app and triggers `OnNotificationReceived` with `IsLaunchNotification = true`
- [ ] Notifications fire when app is **closed**, **backgrounded**, and **foreground** (check presentation options)
- [ ] **Canceling notifications** prevents them from firing
- [ ] **Badge numbers** update on app icon after notification delivery

**Test with different app states:**
- App completely closed (swiped away from task manager)
- App backgrounded (home button pressed)
- App in foreground (actively running)
- Device locked vs unlocked
- Do Not Disturb mode enabled (notifications may be delayed)

### Push Notification Testing

{% hint style="warning" %}
Push notifications require production builds with valid certificates (iOS) or Firebase configuration (Android). Development builds may not receive push notifications reliably.
{% endhint %}

**iOS push notification testing:**
1. Build to physical iOS device (push doesn't work in simulator)
2. Run app and call `RegisterForPushNotifications()` after granting permissions
3. Copy device token from Unity console or device logs
4. Use [Knuff](https://github.com/KnuffApp/Knuff) or [pusher.io](https://pusher.github.io/push-notifications-swift/) to send test APNS messages
5. Verify notification appears in notification center
6. Tap notification and confirm app opens with `IsLaunchNotification = true`

**Android push notification testing:**
1. Ensure `google-services.json` is in `Assets` folder
2. Build to Android device
3. Run app and register for push notifications
4. Copy FCM device token from Unity console
5. Use [Firebase Console](https://console.firebase.google.com/) > Cloud Messaging > Send test message
6. Enter device token and compose notification
7. Send and verify notification appears on device

**Push notification checklist:**
- [ ] Device token successfully generated and logged
- [ ] Device token sent to your game server
- [ ] Test notification sent from server/Firebase appears on device
- [ ] Notification with **custom data** (UserInfo) delivers correctly
- [ ] Tapping notification opens app and processes custom data
- [ ] Badge numbers update from server-sent notifications
- [ ] Notifications appear when app is closed, backgrounded, and foreground

### Platform-Specific Testing

**iOS-specific tests:**
- [ ] Notification badges update correctly on home screen app icon
- [ ] Notification subtitle displays (iOS 10+)
- [ ] Provisional permissions work (iOS 12+ quiet notifications)
- [ ] Critical alerts require special entitlement and show "Critical Alert" label
- [ ] Location-based notifications fire at geographic boundaries (if enabled)
- [ ] Notification actions and categories work correctly

**Android-specific tests:**
- [ ] White small icon displays correctly on Android 5.0+ (Lollipop)
- [ ] Colored small icon displays on Android 4.x devices
- [ ] Large icon loads from `StreamingAssets` for expandable notifications
- [ ] Notification channels appear in device settings (Android 8.0+)
- [ ] Vibration patterns work when enabled in settings
- [ ] Notification priority affects display order in notification shade
- [ ] Notifications respect "Do Not Disturb" mode settings
- [ ] Custom payload keys map correctly if using non-standard server format

### Performance and Edge Cases
- [ ] Scheduling 50+ notifications doesn't crash or slow down app
- [ ] Canceling all notifications completes quickly
- [ ] App handles notification events during scene loading
- [ ] Rapid permission requests don't cause issues
- [ ] Notification events fire correctly after app restart
- [ ] Badge numbers persist across app restarts
- [ ] Memory usage remains stable with active notification event listeners

## Pre-Submission Review

Before submitting to App Store or Google Play:

### App Store Checklist (iOS)
- [ ] Permission usage description clearly explains notification benefits
- [ ] Test fresh install on multiple iOS versions (minimum supported version to latest)
- [ ] Verify push notification certificates are valid and not expired
- [ ] Test on both iPhone and iPad (if supporting both)
- [ ] Confirm notifications respect user's system notification settings
- [ ] Verify badge numbers clear appropriately
- [ ] Screenshot notification permission flow for App Store review notes
- [ ] Test with different iOS notification settings (banners vs alerts, sounds on/off)

### Google Play Checklist (Android)
- [ ] `google-services.json` is from correct Firebase project
- [ ] Test on multiple Android versions (minimum SDK to latest)
- [ ] Verify notification icons follow Material Design guidelines
- [ ] Test on devices from different manufacturers (Samsung, Google, OnePlus)
- [ ] Confirm notification channels are created and configurable in device settings
- [ ] Verify notifications work with battery optimization enabled
- [ ] Test exact timing settings on Android 12+ (requires special permission)
- [ ] Confirm notifications respect Doze mode restrictions (if applicable)

### Common Testing Scenarios
Test these scenarios that commonly cause issues:

**Timezone changes:**
- [ ] Calendar notifications fire at correct local time after timezone change
- [ ] Repeating notifications adjust properly to daylight saving time

**App updates:**
- [ ] Scheduled notifications persist after app update
- [ ] Push notification device token remains valid after update

**Permission recovery:**
- [ ] `Utilities.OpenApplicationSettings()` opens correct settings screen
- [ ] Re-enabling permissions in settings allows notifications to work immediately
- [ ] App detects permission changes via `OnSettingsUpdate` event

**Resource constraints:**
- [ ] Notifications work correctly on devices with low storage
- [ ] System limits on scheduled notifications don't cause silent failures (iOS: ~64 notifications)

## Debugging Tips

**Enable detailed logging:**
```csharp
// Check notification scheduling status
NotificationServices.GetScheduledNotifications((result, error) =>
{
    if (error == null)
    {
        Debug.Log($"Scheduled notifications: {result.Notifications.Length}");
        foreach (var notif in result.Notifications)
        {
            Debug.Log($"  - {notif.Id}: {notif.Title} (fires at: {notif.Trigger})");
        }
    }
});

// Monitor permission status
NotificationServices.GetSettings((result) =>
{
    Debug.Log($"Permission: {result.Settings.PermissionStatus}");
    Debug.Log($"Device token: {result.Settings.DeviceToken}");
});
```

**Common issues and solutions:**

| Issue | Possible Cause | Solution |
| --- | --- | --- |
| Notifications not firing | Permissions denied | Check `GetSettings()` permission status |
| Push token not generated | Permissions not granted before registration | Request permissions first, then register for push |
| Calendar notifications fire at wrong time | Timezone not considered | Use local time components, test across timezones |
| Notifications don't wake app | Normal iOS/Android behavior | App only wakes when user taps notification |
| Badge numbers not updating | Badge permission not requested | Include `NotificationPermissionOptions.Badge` in request |
| Android icon appears as white square | Wrong icon format | Use white transparent icon generator |

{% hint style="success" %}
If you encounter unexpected behavior, run `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/NotificationServicesDemo.unity` to verify the plugin works correctly. This helps isolate whether issues originate from your implementation or the plugin.
{% endhint %}

## Automated Testing

For CI/CD pipelines, consider these automated checks:

```csharp
// Unit test style example: Verify notification creation
public void ExampleNotificationCreationTest()
{
    var notification = NotificationBuilder.CreateNotification("test_id")
        .SetTitle("Test Title")
        .SetBody("Test Body")
        .Create();

    bool isValid = notification != null &&
                   notification.Id == "test_id" &&
                   notification.Title == "Test Title";
    Debug.Log($"Notification creation valid: {isValid}");
}

// Integration-style example: Verify permission request flow
public IEnumerator ExamplePermissionRequestCheck()
{
    bool callbackReceived = false;
    NotificationPermissionStatus status = NotificationPermissionStatus.NotDetermined;

    NotificationServices.RequestPermission(
        NotificationPermissionOptions.Alert,
        (result, error) =>
        {
            callbackReceived = true;
            if (error == null) status = result.PermissionStatus;
        });

    yield return new WaitForSeconds(2f);

    Debug.Log($"Permission callback fired: {callbackReceived}, status: {status}");
}
```

{% hint style="info" %}
Ready to troubleshoot? Check the [FAQ](faq.md) for common issues and solutions.
{% endhint %}
