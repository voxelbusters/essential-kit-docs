---
description: "App Updater allows checking for new app versions and prompting users to update."
---

# Usage

Essential Kit wraps native iOS iTunes Store API and Android Google Play In-App Update API into a single Unity interface. Check for updates, show customizable prompts, and guide users through the update process seamlessly.

## Table of Contents

- [Update Flow at a Glance](#update-flow-at-a-glance)
- [Understanding Update Flow](#understanding-update-flow)
- [Import Namespaces](#import-namespaces)
- [Check Availability](#check-availability)
- [Check for Updates](#check-for-updates)
- [Show Update Prompt](#show-update-prompt)
- [Force Updates vs Optional Updates](#force-updates-vs-optional-updates)
- [Platform-Specific Behavior](#platform-specific-behavior)
- [Core APIs Reference](#core-apis-reference)
- [Error Handling](#error-handling)
- [Advanced: Manual Initialization](#advanced-manual-initialization)
- [Related Guides](#related-guides)

## Update Flow at a Glance

```text
[Game session starts or player opens Settings]
                ↓
[AppUpdater.RequestUpdateInfo]
                ↓
[Store response → AppUpdaterUpdateInfo]
                ↓
[Decide prompt type (optional vs force)]
                ↓
[AppUpdater.PromptUpdate]
                ↓
[Platform-specific UI → restart or resume]
```

## Understanding Update Flow

App Updater follows a two-step process:

**1. Request Update Info**
Query the app store to check if a newer version exists.

**2. Prompt Update**
If an update is available, show a prompt and handle the update flow.

**Platform Differences:**
- **iOS**: Shows an alert that redirects users to the App Store
- **Android**: Supports in-app updates with progress tracking, or redirects to Play Store

## Import Namespaces

```csharp
using VoxelBusters.EssentialKit;
using VoxelBusters.CoreLibrary;
```

## Check Availability

Call `IsAvailable()` before making requests so you can gracefully fall back if the feature is stripped from the build:

```csharp
if (!AppUpdater.IsAvailable())
{
    Debug.LogWarning("App Updater is not available on this platform or build.");
    return;
}
```

## Check for Updates

Request update information from the app store:

```csharp
void CheckForUpdates()
{
    if (!AppUpdater.IsAvailable())
    {
        Debug.LogWarning("App Updater is not available on this platform or build.");
        return;
    }

    AppUpdater.RequestUpdateInfo((result, error) =>
    {
        if (error != null)
        {
            Debug.LogError($"Failed to check for updates: {error.Description}");
            return;
        }

        Debug.Log($"Update status: {result.Status}");

        switch (result.Status)
        {
            case AppUpdaterUpdateStatus.Available:
                Debug.Log("Update available!");
                ShowUpdatePrompt(isForceUpdate: false);
                break;

            case AppUpdaterUpdateStatus.Downloaded:
                Debug.Log("Update already downloaded, ready to install");
                InstallDownloadedUpdate();
                break;

            case AppUpdaterUpdateStatus.NotAvailable:
                Debug.Log("App is up to date");
                break;

            case AppUpdaterUpdateStatus.InProgress:
                Debug.Log("Update is already in progress");
                break;

            case AppUpdaterUpdateStatus.Unknown:
                Debug.LogWarning("Could not determine update status");
                break;
        }
    });
}
```

### Update Status Values

| Status | Meaning | Next Action |
| --- | --- | --- |
| `Available` | New version exists on the store | Call `PromptUpdate()` to show update dialog |
| `Downloaded` | Update downloaded but not installed (Android only) | Call `PromptUpdate()` with `AllowInstallationIfDownloaded = true` |
| `NotAvailable` | App is up to date | No action needed |
| `InProgress` | Update is currently downloading | Wait for completion |
| `Unknown` | Unable to determine status | Check error for details |

{% hint style="info" %}
`Downloaded` status appears only on Android when using In-App Update flexible flow. The update is ready to install without additional downloads.
{% endhint %}

## Show Update Prompt

After confirming an update is available, show a prompt:

```csharp
void ShowUpdatePrompt(bool isForceUpdate)
{
    var options = new PromptUpdateOptions.Builder()
        .SetPromptTitle("Update Available")
        .SetPromptMessage("A new version with bug fixes and improvements is ready!")
        .SetIsForceUpdate(isForceUpdate)
        .Build();

    AppUpdater.PromptUpdate(options, (progress, error) =>
    {
        if (error != null)
        {
            Debug.LogError($"Update failed: {error.Description}");
            return;
        }

        Debug.Log($"Update progress: {progress * 100}%");

        if (progress >= 1.0f)
        {
            Debug.Log("Update completed successfully");
        }
    });
}
```

### PromptUpdateOptions Builder

| Method | Parameter | Description |
| --- | --- | --- |
| `SetPromptTitle(string)` | Title text | Title displayed in update dialog |
| `SetPromptMessage(string)` | Message text | Message explaining why user should update |
| `SetIsForceUpdate(bool)` | true/false | If true, user cannot dismiss the prompt (default: false) |
| `SetAllowInstallationIfDownloaded(bool)` | true/false | Android: install immediately if the flexible flow already downloaded the package (default: true) |
| `Build()` | - | Returns configured `PromptUpdateOptions` instance |

### Progress Callback

The progress callback fires multiple times during the update:

**iOS Behavior:**
- Fires once with `progress = 1.0f` if user chose to update
- Fires with `progress = 0.0f` if user dismissed the prompt (only for optional updates)

**Android Behavior:**
- Fires multiple times with progress from `0.0f` to `1.0f` during in-app download
- Falls back to iOS behavior if In-App Update is unavailable

{% hint style="success" %}
Show a loading indicator during Android in-app updates by tracking progress. The callback fires frequently with updated progress values.
{% endhint %}

## Force Updates vs Optional Updates

### Optional Updates (Default)
Allow users to dismiss the prompt and continue using the app:

```csharp
void ShowOptionalUpdate()
{
    var options = new PromptUpdateOptions.Builder()
        .SetPromptTitle("New Features Available!")
        .SetPromptMessage("Update now to try our new tournament mode!")
        .SetIsForceUpdate(false) // User can dismiss
        .Build();

    AppUpdater.PromptUpdate(options, (progress, error) =>
    {
        if (error == null && progress >= 1.0f)
        {
            Debug.Log("User accepted update");
        }
        else if (error == null && progress == 0.0f)
        {
            Debug.Log("User dismissed update");
        }
    });
}
```

### Force Updates (Blocking)
Prevent users from dismissing until they update:

```csharp
void ShowForceUpdate()
{
    var options = new PromptUpdateOptions.Builder()
        .SetPromptTitle("Critical Update Required")
        .SetPromptMessage("This update contains important security fixes and is required to continue.")
        .SetIsForceUpdate(true) // Cannot dismiss
        .Build();

    AppUpdater.PromptUpdate(options, (progress, error) =>
    {
                if (error != null)
                {
                    Debug.LogError($"Force update failed: {error.Description}");
                    Debug.LogError("Show retry UI so the player can attempt the update again.");
                }
        else if (progress >= 1.0f)
        {
            Debug.Log("Force update completed");
        }
    });
}
```

{% hint style="warning" %}
Use force updates sparingly. Users cannot play your game until they update, which may lead to frustration. Reserve for critical bugs or security issues.
{% endhint %}

## Platform-Specific Behavior

### iOS
- Uses iTunes Store API to query for updates
- Shows native alert dialog with App Store redirect
- No progress tracking (binary result: updated or dismissed)
- Requires valid App Store ID in Essential Kit Settings

```csharp
// iOS prompt flow
AppUpdater.PromptUpdate(options, (progress, error) =>
{
    if (progress >= 1.0f)
    {
        // User tapped "Update" and was redirected to App Store
        // App will terminate when user returns after updating
    }
});
```

### Android
- Uses Google Play In-App Update API for seamless updates
- Shows in-app update UI with progress tracking
- Falls back to Play Store redirect if In-App Update fails
- Requires valid package name in Essential Kit Settings

```csharp
// Android prompt flow with progress
AppUpdater.PromptUpdate(options, (progress, error) =>
{
    // Android fires multiple times with increasing progress
        if (progress > 0 && progress < 1.0f)
        {
            Debug.Log($"Downloading: {progress * 100}%");
            Debug.Log($"Update progress bar to {progress * 100}%.");
        }
    else if (progress >= 1.0f)
    {
        Debug.Log("Download complete, installing...");
    }
});
```

### Install Downloaded Update (Android)

If status is `Downloaded`, install without re-downloading:

```csharp
void InstallDownloadedUpdate()
{
    var options = new PromptUpdateOptions.Builder()
        .SetPromptTitle("Install Update")
        .SetPromptMessage("Update is ready to install. App will restart.")
        .SetAllowInstallationIfDownloaded(true)
        .Build();

    AppUpdater.PromptUpdate(options, (progress, error) =>
    {
        if (error == null && progress >= 1.0f)
        {
            Debug.Log("Installing update...");
        }
    });
}
```

## Core APIs Reference

| API | Purpose | Returns |
| --- | --- | --- |
| `AppUpdater.RequestUpdateInfo(callback)` | Query app store for available updates | `AppUpdaterUpdateInfo` with status via callback |
| `AppUpdater.PromptUpdate(options, callback)` | Show update prompt to user | Float progress (0-1) via callback |
| `AppUpdater.IsAvailable()` | Check if App Updater is available on current platform | `bool` |
| `PromptUpdateOptions.Builder()` | Configure update prompt | Chain `.SetX()` methods → `Build()` |

## Error Handling

Handle errors in both `RequestUpdateInfo` and `PromptUpdate` callbacks:

```csharp
void CheckForUpdates()
{
    AppUpdater.RequestUpdateInfo((result, error) =>
    {
        if (error != null)
        {
            HandleUpdateError(error);
            return;
        }

        if (result.Status == AppUpdaterUpdateStatus.Available)
        {
            ShowUpdatePrompt(false);
        }
    });
}

void HandleUpdateError(Error error)
{
    var code = (AppUpdaterErrorCode)error.Code;

    switch (code)
    {
        case AppUpdaterErrorCode.NetworkIssue:
            Debug.LogWarning("No internet connection - cannot check for updates.");
            Debug.LogWarning("Show an in-game network error prompt with retry.");
            break;

        case AppUpdaterErrorCode.UpdateInfoNotAvailable:
            Debug.LogWarning("Call RequestUpdateInfo before prompting the update.");
            break;

        case AppUpdaterErrorCode.UpdateNotAvailable:
            Debug.Log("User already has the latest version.");
            break;

        case AppUpdaterErrorCode.UpdateInProgress:
            Debug.Log("Update is already running in another flow. Show progress UI.");
            break;

        case AppUpdaterErrorCode.UpdateNotCompatible:
            Debug.LogError("Device cannot install the target build (architecture or version mismatch).");
            break;

        case AppUpdaterErrorCode.UpdateCancelled:
            Debug.LogWarning("User cancelled the update.");
            break;

        default:
            Debug.LogError($"Update check failed: {error.Description}");
            break;
    }
}
```

### Common Error Codes

| Error Code | Trigger | Recommended Action |
| --- | --- | --- |
| `NetworkIssue` | No internet connection | Show error message and retry button |
| `UpdateInfoNotAvailable` | `PromptUpdate` called before `RequestUpdateInfo` | Request info first or handle null result |
| `UpdateNotAvailable` | Store reports no newer build | Hide update UI and continue |
| `UpdateInProgress` | Another update flow is already running | Reuse or resume that flow instead of starting a new one |
| `UpdateCancelled` | User backed out of the update UI | Offer a "Try again" button or continue gameplay |
| `UpdateNotCompatible` | Device cannot install the target build | Inform player and prompt them to update their OS/device |
| `Unknown` | Platform-specific error | Log for diagnostics, show generic error to user |

{% hint style="info" %}
Always handle errors gracefully. Update checks can fail due to network issues, store API changes, or configuration problems.
{% endhint %}

## Advanced: Manual Initialization

Essential Kit auto-initializes App Updater from the Essential Kit Settings asset. Only use manual initialization for runtime configuration:

```csharp
void Awake()
{
    var settings = new AppUpdaterUnitySettings(
        isEnabled: true,
        defaultPromptTitle: "Server-driven title",
        defaultPromptMessage: "Server-driven message");

    AppUpdater.Initialize(settings);
}
```

**Use Cases for Manual Initialization:**
- Setting custom update prompt defaults from server configuration
- Configuring different update policies for beta vs production builds
- Loading app store URLs dynamically from server
- Implementing A/B testing for update messaging

{% hint style="warning" %}
Advanced initialization is for specific scenarios only. For most games, use [standard setup](setup.md) with Essential Kit Settings.
{% endhint %}

## Related Guides

- Demo scene: `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/AppUpdaterDemo.unity`
- Pair with **Network Services** to check connectivity before requesting updates
- Use with **Notification Services** to remind users about pending updates
- Combine with **Native UI** for custom update dialog designs

{% hint style="success" %}
Ready to test? Head to the [Testing Guide](testing.md) to validate your implementation.
{% endhint %}
