---
description: "Configuring Native UI"
---

# Setup

## Prerequisites
- Essential Kit imported into the project from My Assets section of Package Manager
- No platform-specific requirements - Native UI works out of the box on iOS and Android

## Setup Checklist
1. Open **Essential Kit Settings** (`Window > Voxel Busters > Essential Kit > Open Settings`), switch to the **Services** tab, and enable **Native UI**
2. Changes are saved automatically. If you use source control, commit the updated `Resources/EssentialKitSettings.asset` file

<figure><img src="../../.gitbook/assets/native-ui-settings.gif" alt=""><figcaption><p>Native UI Settings</p></figcaption></figure>

### Configuration Reference

| Setting | Platform | Required? | Notes |
| --- | --- | --- | --- |
| Is Enabled | All | Yes | Toggles Native UI in builds; disabling strips related native code |

{% hint style="info" %}
Native UI requires minimal configuration since it primarily uses platform-standard components. The main setup is just enabling the feature.
{% endhint %}

### Platform-Specific Behavior

**iOS:**
- Uses native UIAlertController for alert dialogs
- Uses UIDatePicker for date/time selection
- Automatically matches iOS Human Interface Guidelines
- Dialogs appear with system animations and styling

**Android:**
- Uses native AlertDialog with Material Design styling
- Uses DatePicker and TimePicker components
- Adapts to different Android versions and manufacturer customizations
- Respects system theme (light/dark mode)

{% hint style="success" %}
Need a working baseline? Run the sample at `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/NativeUIDemo.unity` to confirm your setup before wiring Native UI into production screens.
{% endhint %}
