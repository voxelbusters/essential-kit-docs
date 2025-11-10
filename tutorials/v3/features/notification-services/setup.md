---
description: "Configuring Notification Services for iOS and Android"
---

# Setup

## Prerequisites
- Essential Kit imported into the project from My Assets section of Package Manager
- iOS builds require notification permission usage description for App Store submission
- Android builds require Firebase project with FCM enabled for push notifications
- Custom notification sounds and icons placed in `Assets/StreamingAssets` folder

## Setup Checklist
1. Open **Essential Kit Settings** (`Window > Voxel Busters > Essential Kit > Open Settings`), switch to the **Services** tab, and enable **Notification Services**
2. Configure **Presentation Options** (Alert, Sound, Badge) for how notifications appear when app is in foreground
3. Set **Push Notification Service Type** to Custom (or None for local-only notifications)
4. **Android only**: Assign white and colored small icons for notification tray display
5. **Android only**: Copy `google-services.json` from Firebase Console to `Assets` folder for FCM integration
6. **iOS only**: Essential Kit automatically configures APNS capabilities during build - no manual setup required
7. Changes to the settings asset are saved automatically. If you use source control, commit the updated `Resources/EssentialKitSettings.asset` file

### Configuration Reference
| Setting | Platform | Required? | Notes |
| --- | --- | --- | --- |
| Enable NotificationServices | All | Yes | Toggles the feature in builds; disabling strips related native code |
| Presentation Options | All | Yes | Controls notification display when app is in foreground: Alert (visual), Sound (audio), Badge (icon number) |
| Push Notification Service Type | All | Yes | Custom = enables push notifications with your server; None = local notifications only |
| White Small Icon | Android | Yes | White transparent icon for devices >= Lollipop. Use [Android Asset Studio](https://romannurik.github.io/AndroidAssetStudio/icons-notification.html) to generate |
| Coloured Small Icon | Android | Yes | Regular colored icon for devices < Lollipop |
| Allow Vibration | Android | Optional | Enable vibration when notification is received |
| Accent Color | Android | Optional | Tint color for the small icon in notification tray |
| Allow Display when Foreground | Android | Optional | Show notifications even when app is running in foreground |
| Exact Timing Settings | Android | Advanced | Allows scheduling at exact specified times (required for alarm-style apps) |
| Can Ignore Doze Mode | Android | Advanced | Allow notifications to fire during device sleep mode when exact timing is enabled |
| Payload Keys | Android | Advanced | Customize server payload field names if your backend uses non-standard keys |

{% hint style="info" %}
Need a working baseline? Run the sample at `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/NotificationServicesDemo.unity` to confirm your settings before wiring the feature into production screens.
{% endhint %}

## Platform-Specific Setup

### iOS Setup
Essential Kit automatically configures notification capabilities during the build process. For push notifications, iOS uses Apple Push Notification service (APNS) which is free and requires no additional configuration.

**What Essential Kit handles automatically:**
- Adds UserNotifications.framework to Xcode project
- Enables Push Notifications capability
- Configures notification categories and actions

**Manual steps required:**
- **For push notifications only**: Create APNS certificates in Apple Developer Portal and configure them with your push notification server
- **Permission description**: While not required by Essential Kit, iOS may reject App Store submissions without a clear notification usage description in your app's marketing materials

{% hint style="success" %}
If you use manual provisioning profile configuration, ensure the **Push Notifications capability** is enabled for your app ID in the Apple Developer Portal.
{% endhint %}

### Android Setup
Android uses Firebase Cloud Messaging (FCM) for push notifications. Essential Kit automatically handles permission injection and notification channel management.

**What Essential Kit handles automatically:**
- Adds required permissions to `AndroidManifest.xml` (VIBRATE, C2DM_RECEIVE)
- Creates default notification channels for Android 8.0+
- Configures FCM service for receiving push notifications

**Manual steps required:**
1. Open [Firebase Console](https://firebase.google.com/)
2. Click **Go to Console** and select your project (or create a new one)
3. Click the settings gear icon next to **Project Overview**
4. Under **General** tab, go to **Your apps** section
5. Select your Android app (or add one if it doesn't exist)
6. Click **google-services.json** button to download the configuration file
7. Copy the downloaded `google-services.json` file to your Unity project's **Assets** folder

{% hint style="success" %}
For extra security, add your app's SHA-1 fingerprint in the Firebase Console before downloading `google-services.json`. This prevents unauthorized apps from receiving your notifications.
{% endhint %}

**Server setup for push notifications:**
Your server needs the **Server Key** to send notifications via FCM:
1. In Firebase Console, go to **Project Settings** > **Cloud Messaging** tab
2. Copy the **Server Key** (or FCM HTTP v1 credentials for newer integrations)
3. Configure your server to send notification payloads to FCM endpoints using this key

## Custom Resources
When creating notifications with custom sounds or large icons, place these files in `Assets/StreamingAssets` folder:

**Supported custom resources:**
- **Sound files**: `.mp3`, `.wav` (reference by filename in NotificationBuilder)
- **Large icons**: `.png`, `.jpg` (for Android expandable notifications)
- **Big pictures**: `.png`, `.jpg` (for Android rich media notifications)

```
Assets/
└── StreamingAssets/
    ├── notification_sound.mp3
    ├── large_icon.png
    └── big_picture.jpg
```

{% hint style="danger" %}
If you are upgrading from Essential Kit 1.x, move your notification resources from `PluginResources` folder to `Assets/StreamingAssets` folder. The old location is no longer supported.
{% endhint %}

## Verification Steps
Before proceeding to usage:
1. Confirm **NotificationServices** is enabled in Essential Kit Settings
2. **Android only**: Verify `google-services.json` exists in `Assets` folder for push notifications
3. **Android only**: Check that white and colored small icons are assigned in settings
4. Build and run the demo scene to verify notification permissions can be requested
5. Check Unity console for any configuration warnings or errors during build

{% hint style="info" %}
Ready to implement? Head to [Usage](usage.md) to start scheduling notifications and handling permissions.
{% endhint %}
