---
description: Configuring Address Book Feature
---

# Setup

## Prerequisites
- Essential Kit imported into the project from My Assets section of Package Manager.
- iOS builds require a `NSContactsUsageDescription` entry that explains why you need address book access. Configure it under **Essential Kit Settings > Address Book > iOS Usage Description** before exporting.
- Android uses the system-provided contacts permission dialog copy. Plan to communicate the "why" inside your own UI because the prompt text cannot be customised.

## Setup Checklist
1. Open **Essential Kit Settings** (`Window > Voxel Busters > Essential Kit > Open Settings`), switch to the **Services** tab, and enable **Address Book**.
2. Assign a **Default Image** placeholder if you plan to display contacts without profile photos. Use a square texture for best results.
3. Provide the iOS usage description so the App Store reviewers and players understand why you need contacts access. (Android relies on the platform message.)
4. Changes to the settings asset are saved automatically. If you use source control, commit the updated `Resources/EssentialKitSettings.asset` file.

### Configuration Reference
| Setting | Platform | Required? | Notes |
| --- | --- | --- | --- |
| Enable Address Book | All | Yes | Toggles the feature in builds; disabling strips related native code. |
| Default Image | All | Optional | Placeholder texture returned when a contact lacks an image or while async loading occurs. |
| iOS Usage Description | iOS | Yes | Appears in the contacts permission alert; must clearly state the benefit (e.g., "We use contacts to find friends you can invite"). |
| Android Permission Usage Description | Android | N/A | Android displays system-managed text for contacts permissions; customise messaging inside your own UI instead. |

{% hint style="info" %}
Need a working baseline? Run the sample at `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/AddressBookDemo.unity` to confirm your settings before wiring the feature into production screens.
{% endhint %}
