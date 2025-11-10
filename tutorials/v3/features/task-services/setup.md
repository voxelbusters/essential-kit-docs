---
description: "Configuring Task Services for background execution"
---

# Setup

## Prerequisites
- Essential Kit imported into the project from My Assets section of Package Manager
- iOS and Android build targets configured
- Understanding of async/await patterns in C#

## Setup Checklist
1. Open **Essential Kit Settings** (`Window > Voxel Busters > Essential Kit > Open Settings`), switch to the **Services** tab, and enable **Task Services**
2. Essential Kit automatically configures platform-specific background execution during build
3. Changes to the settings asset are saved automatically. If you use source control, commit the updated `Resources/EssentialKitSettings.asset` file

### Configuration Reference
| Setting | Platform | Required? | Notes |
| --- | --- | --- | --- |
| Enable Task Services | All | Yes | Toggles the feature in builds; disabling strips related native code |

{% hint style="success" %}
**Zero Configuration Required**: Task Services has no additional configuration options. Simply enable the feature and it's ready to use.
{% endhint %}

### Platform-Specific Notes

#### iOS
- Automatically configures `UIKit.framework` during build
- Uses iOS Background Task API (`UIApplication.beginBackgroundTask`)
- **Background Time Limit**: Approximately 30 seconds (system-enforced)
- System may terminate app earlier if resources are critically low
- Background execution does NOT guarantee task completion—always handle quota expiration

#### Android
- Automatically handles background execution configuration during build
- Uses Android foreground service patterns for extended execution
- **Background Time Limit**: Few minutes depending on Android version and device manufacturer
- Android 12+ has stricter background limits
- Consider foreground services (separate feature) for longer-running tasks

{% hint style="warning" %}
**Background Limits Are System-Enforced**: Essential Kit cannot extend platform background execution limits. iOS typically allows 30 seconds, Android allows a few minutes. If your tasks require longer execution, design them to checkpoint progress and resume on next app launch.
{% endhint %}

{% hint style="info" %}
Need a working baseline? Run the sample at `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/TaskServicesDemo.unity` to confirm your settings before wiring the feature into production code. **Note**: Testing requires building to a device as background behavior differs significantly from Unity Editor.
{% endhint %}

## What Happens During Build

Essential Kit's build pipeline automatically:
- **iOS**: Links `UIKit.framework`, configures background capabilities
- **Android**: Adds necessary permissions for background execution, configures manifest entries

You don't need to manually configure Xcode projects or Android manifests—Essential Kit handles all platform setup transparently.

## Next Steps
After enabling Task Services in settings:
1. Review [Usage Guide](usage.md) to understand background task patterns
2. Implement save-on-pause logic in `OnApplicationPause`
3. Test on physical devices to verify background execution behavior
4. Implement quota expiration callbacks for graceful degradation
