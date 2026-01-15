---
description: "Configuring Cloud Services"
---

# Setup

## Prerequisites
- Essential Kit imported into the project from My Assets section of Package Manager
- iOS builds automatically enable iCloud Key-Value Store capability during build process
- Android builds automatically configure Google Play Services dependencies during build

## Setup Checklist
1. Open **Essential Kit Settings** (`Window > Voxel Busters > Essential Kit > Open Settings`), switch to the **Services** tab, and enable **Cloud Services**.
2. **(Android only)** If not using Game Services, you still need to provide the Play Services Application ID in Game Services settings (Cloud Services uses the same Google Play infrastructure).
3. Changes to the settings asset are saved automatically. If you use source control, commit the updated `Resources/EssentialKitSettings.asset` file.

### Configuration Reference
| Setting | Platform | Required? | Notes |
| --- | --- | --- | --- |
| Enable Cloud Services | All | Yes | Toggles the feature in builds; disabling removes related native code. |
| Play Services Application ID | Android | Yes | Set in Game Services settings; Cloud Services shares this configuration. |
| iCloud Key-Value Store | iOS | N/A | Essential Kit automatically enables this capability during iOS builds. |
| Substitute Entitlement Identifiers | iOS | Optional | Replaces entitlement identifiers with your team identifier in the iOS entitlements file during build. |

{% hint style="info" %}
Need a working baseline? Run the sample at `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/CloudServicesDemo.unity` to confirm your settings before integrating into production.
{% endhint %}

{% hint style="warning" %}
If you are NOT using Game Services but need Cloud Services on Android, you still must fill the **Play Services Application Id** entry in Game Services settings. Cloud Services depends on Google Play infrastructure even when Game Services is disabled.
{% endhint %}

## Platform-Specific Setup

### iOS
Essential Kit automatically handles iOS configuration:
- Enables **iCloud** capability in Xcode project during build
- Adds **Key-Value Store** entitlement
- No manual Xcode configuration required
 - Optional: enable **Substitute Entitlement Identifiers** to replace entitlement identifiers with your team identifier in the iOS entitlements file

**Storage Limits:**
- Maximum 1 MB total storage
- Maximum 1024 keys
- Maximum 1 MB per key

**User Requirements:**
- Device must be signed in to iCloud
- iCloud Drive does not need to be enabled (Key-Value Store is separate)

### Android
Essential Kit automatically handles Android configuration:
- Adds Google Play Services dependencies to Gradle
- Configures Saved Games API integration
- Adds required permissions to AndroidManifest.xml

**Storage Limits:**
- Maximum 3 MB per user
- Data stored as single blob (all keys synced together)

**User Requirements:**
- Device must be signed in to Google Play
- First `Synchronize()` call may prompt for Google Play sign-in

{% hint style="success" %}
To maintain similar behavior across iOS and Android, Essential Kit auto-syncs on major app state changes (app pause/resume) on Android. This keeps data current without manual sync calls.
{% endhint %}

## Next Steps
Once setup is complete, proceed to [Usage](usage.md) to learn how to store data and sync with cloud services.
