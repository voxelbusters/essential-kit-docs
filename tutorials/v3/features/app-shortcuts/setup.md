---
description: "Configuring App Shortcuts"
---

# Setup

## Prerequisites
- Essential Kit imported into the project from My Assets section of Package Manager.
- Icon assets prepared as Texture2D (PNG recommended) for your shortcuts.
- iOS builds support up to 4 shortcuts; Android varies by device launcher.

## Setup Checklist
1. Open **Essential Kit Settings** (`Window > Voxel Busters > Essential Kit > Open Settings`), switch to the **Services** tab, and enable **App Shortcuts**.
2. Add your shortcut icons to the **Icons** list. These textures will be referenced by filename when creating shortcuts.
3. Changes to the settings asset are saved automatically. If you use source control, commit the updated `Resources/EssentialKitSettings.asset` file.

### Configuration Reference
| Setting | Platform | Required? | Notes |
| --- | --- | --- | --- |
| Enable App Shortcuts | All | Yes | Toggles the feature in builds; disabling strips related native code. |
| Icons | All | Optional | List of Texture2D assets referenced by filename in `SetIconFileName()`. Icons not in this list won't display. |

{% hint style="info" %}
Need a working baseline? Run the sample at `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/AppShortcutsDemo.unity` to confirm your settings before wiring the feature into production screens.
{% endhint %}

## Platform Notes

### iOS
- Maximum of 4 shortcuts displayed via 3D Touch or long-press on devices running iOS 9+.
- Icons should be square (recommended 35x35 pt for single-scale images).

### Android
- Shortcuts supported on Android 7.1 (API level 25) and above.
- Different launchers may display shortcuts differently; test on target devices.
- Icons automatically adapt to device launcher theming.
