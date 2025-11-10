---
description: "Configuring Rate My App"
---

# Setup

## Prerequisites
- Essential Kit imported into the project from My Assets section of Package Manager
- App Store ID configured for iOS builds (numeric ID from App Store Connect)
- Package name configured for Android builds (com.company.appname format)

## Setup Checklist
1. Open **Essential Kit Settings** (`Window > Voxel Busters > Essential Kit > Open Settings`), switch to the **Services** tab, and enable **Rate My App**
2. Configure app store IDs in the **General** tab under **Application Settings**
3. Set timing constraints for when rating prompts should appear
4. Optionally configure confirmation dialog to protect against quota waste
5. Changes to the settings asset are saved automatically. If you use source control, commit the updated `Resources/EssentialKitSettings.asset` file

<figure><img src="../../.gitbook/assets/rate-my-app-settings.gif" alt=""><figcaption></figcaption></figure>

### Configuration Reference

| Setting | Platform | Required? | Notes |
| --- | --- | --- | --- |
| Is Enabled | All | Yes | Toggles the feature in builds; disabling strips related native code |
| Auto Show | All | Optional | Automatically shows rating prompt when constraints are met (default: true) |
| Allow Re-rating in New Version | All | Optional | Prompts users to rate again when app version changes (default: false) |

#### Confirmation Dialog Settings

Confirmation dialogs ask users if they want to rate before showing the native review dialog. This protects your platform quota.

| Setting | Platform | Required? | Notes |
| --- | --- | --- | --- |
| Can Show | All | Optional | Shows confirmation before native dialog (recommended to avoid quota waste) |
| Prompt Title | All | Optional | Title for confirmation dialog (e.g., "Enjoying the game?") |
| Prompt Description | All | Optional | Description text (e.g., "Help us grow by rating on the store!") |
| Ok Button Label | All | Optional | Text for positive action (default: "Rate Now") |
| Cancel Button Label | All | Optional | Text for negative action (default: "No Thanks") |
| Remind Later Button Label | All | Optional | Text for postpone option (default: "Remind Me Later") |
| Can Show Remind Later Button | All | Optional | Adds "Remind Later" option to confirmation dialog |

#### Default Controller Settings

Controls when the rating prompt appears based on app usage patterns.

| Setting | Platform | Description |
| --- | --- | --- |
| **Initial Prompt Constraints** | All | Conditions that must be met before first rating prompt |
| Min Hours | All | Hours since first app launch (e.g., 24 for 1 day) |
| Min Launches | All | Number of app launches required (e.g., 5) |
| Min Significant Events | All | Custom events you track (e.g., 3 levels completed) |
| Min Elapsed Days | All | Days since installation (e.g., 7) |
| **Repeat Prompt Constraints** | All | Conditions for showing prompts again after user declines |
| Min Hours | All | Hours to wait before re-prompting |
| Min Launches | All | App launches before re-prompting |

{% hint style="info" %}
Need a working baseline? Run the sample at `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/RateMyAppDemo.unity` to confirm your settings before wiring the feature into production screens.
{% endhint %}

{% hint style="success" %}
**Best Practice**: Use confirmation dialogs to protect your limited native review quota. iOS allows only 3 native prompts per year, so confirming user intent first prevents wasted quota on accidental or poorly-timed prompts.
{% endhint %}
