---
description: "Configuring App Updater"
---

# Setup

## Prerequisites
- Essential Kit imported into the project from My Assets section of Package Manager
- iOS or Android build target configured in Unity
- Published app on App Store or Google Play (required for testing actual update detection)
- Valid bundle identifier matching your published app

## Setup Checklist

### 1. Enable App Updater
Open **Essential Kit Settings** (`Window > Voxel Busters > Essential Kit > Open Settings`), switch to the **Services** tab, and enable **App Updater**.

<figure><img src="../../.gitbook/assets/app-updater-settings.gif" alt=""><figcaption><p>App Updater Settings</p></figcaption></figure>

### 2. Configure Default Prompt Messages (Optional)
In the App Updater section, you can customize the default update prompt text:

| Setting | Description | Default |
| --- | --- | --- |
| **Default Prompt Title** | Title shown in update prompts if not overridden at runtime | "New version available" |
| **Default Prompt Message** | Message shown in update prompts if not overridden at runtime | "A new version of this app is available with exciting new features and improvements." |

{% hint style="success" %}
These defaults are used when you don't provide custom text via `PromptUpdateOptions.Builder`. You can override them per-prompt for specific update campaigns.
{% endhint %}

### 3. Configure App Store Identifiers
Switch to the **General** tab in Essential Kit Settings and configure platform-specific identifiers:

**iOS:**
- **Bundle Identifier**: Must match your App Store app (e.g., `com.yourstudio.yourgame`)
- **App Store ID**: Your app's numeric ID from App Store Connect (e.g., `123456789`)

**Android:**
- **Package Name**: Must match your Google Play app (e.g., `com.yourstudio.yourgame`)

{% hint style="warning" %}
App Updater queries iTunes Store API on iOS and Google Play API on Android. Without valid identifiers, update checks will fail. Ensure these match your published app exactly.
{% endhint %}

### 4. Save and Build
Changes to the settings asset are saved automatically. If you use source control, commit the updated `Resources/EssentialKitSettings.asset` file.

Essential Kit handles platform integration automatically during build - no manual configuration needed.

## Configuration Reference

| Setting | Platform | Required? | Notes |
| --- | --- | --- | --- |
| Enable App Updater | All | Yes | Toggles the feature in builds; disabling strips related native code |
| Default Prompt Title | All | Optional | Used when not providing custom title in `PromptUpdateOptions` |
| Default Prompt Message | All | Optional | Used when not providing custom message in `PromptUpdateOptions` |
| Bundle Identifier (General) | iOS | Yes | Must match App Store Connect bundle ID for iTunes API queries |
| App Store ID (General) | iOS | Yes | Numeric ID from App Store Connect; required for update detection |
| Package Name (General) | Android | Yes | Must match Google Play package name for update queries |

## Platform-Specific Behavior

### iOS
- Uses iTunes Store API to check for updates
- Shows native alert dialog to redirect users to App Store
- No in-app update downloads - users must visit App Store manually
- Update detection works for published apps only (not TestFlight)

### Android
- Uses Google Play In-App Update API for seamless updates
- Supports flexible and immediate update flows with progress tracking
- Falls back to Play Store redirect if In-App Update fails
- Update detection works for published apps and internal testing tracks

{% hint style="info" %}
Need a working baseline? Run the sample at `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/AppUpdaterDemo.unity` to confirm your settings before integrating into production.
{% endhint %}

{% hint style="warning" %}
Update detection only works with published apps. During development, use the editor simulator or test with an older version of your published app installed.
{% endhint %}
