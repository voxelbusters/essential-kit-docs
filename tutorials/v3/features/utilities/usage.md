---
description: "Utilities provides cross-platform app store and system settings navigation"
---

# Usage

Essential Kit Utilities wraps native iOS (UIApplication) and Android (Intent) APIs for common navigation tasks. Essential Kit automatically initializes Utilities - no manual setup needed.

## Table of Contents

- [Import Namespaces](#import-namespaces)
- [Opening App Store Pages](#opening-app-store-pages)
- [Opening Application Settings](#opening-application-settings)
- [Data Properties](#data-properties)
- [Core APIs Reference](#core-apis-reference)
- [Common Patterns](#common-patterns)
- [Error Handling](#error-handling)
- [Advanced: Custom Runtime Configuration](#advanced-custom-runtime-configuration)
- [Related Guides](#related-guides)

## Import Namespaces

```csharp
using VoxelBusters.CoreLibrary;
using VoxelBusters.EssentialKit;
```

## Opening App Store Pages

### Open Current App's Store Page

Use the configured app store ID from Essential Kit Settings:

```csharp
public void PromptForReview()
{
    // Opens store page using ID from Essential Kit Settings
    Utilities.OpenAppStorePage();
}
```

This is perfect for directing users to leave reviews manually.

### Open Specific App Store Page

Pass platform-specific identifiers for cross-promotion or companion apps:

```csharp
using VoxelBusters.CoreLibrary;

public void OpenCompanionApp()
{
    var iosId = RuntimePlatformConstant.iOS("1234567890");
    var androidId = RuntimePlatformConstant.Android("com.company.companion");

    Utilities.OpenAppStorePage(iosId, androidId);
}
```

### Open with String ID

Use a simple string identifier when targeting single platform or handling IDs dynamically:

```csharp
public void OpenAppById(string appId)
{
    // iOS: numeric App Store ID like "1234567890"
    // Android: package name like "com.company.appname"
    Utilities.OpenAppStorePage(appId);
}
```

## Opening Application Settings

Direct users to system settings when permissions are denied:

```csharp
public void OnPermissionDenied()
{
    // Show explanation dialog first
    AlertDialog dialog = AlertDialog.CreateInstance();
    dialog.Title = "Permission Required";
    dialog.Message = "Please enable camera access in Settings to use this feature.";
    dialog.AddButton("Open Settings", () =>
    {
        Utilities.OpenApplicationSettings();
    });
    dialog.AddCancelButton("Cancel", () =>
    {
        Debug.Log("User cancelled settings navigation");
    });
    dialog.Show();
}
```

**Platform Behavior:**
- **iOS**: Opens Settings app to the app's dedicated settings page
- **Android**: Opens app info page in device settings where users can manage permissions

{% hint style="success" %}
Always show an explanation before opening settings. Users need context about why they're being redirected and what permission to enable.
{% endhint %}

## Data Properties

| Item | Type | Notes |
| --- | --- | --- |
| `RuntimePlatformConstant.iOS/Android` | Helper Struct | Wrap platform-specific identifiers so you can provide both IDs in a single `OpenAppStorePage` call. |
| `Utilities.OpenAppStorePage()` | Method | Uses the identifiers configured in Essential Kit Settings to deep link directly to your app’s store listing. |
| `Utilities.OpenApplicationSettings()` | Method | Jumps to the operating system’s settings page for your app, letting players re-enable permissions without manual navigation. |
| `UtilityUnitySettings.IsEnabled` | `bool` | Indicates whether the Utilities feature is active; when disabled, navigation helpers do nothing and log an error. |

## Core APIs Reference

| API | Purpose | Returns |
| --- | --- | --- |
| `Utilities.OpenAppStorePage()` | Opens current app's store page using configured ID | Void - launches store app |
| `Utilities.OpenAppStorePage(platformConstants)` | Opens store page for specified app with platform IDs | Void - launches store app |
| `Utilities.OpenAppStorePage(appId)` | Opens store page using string identifier | Void - launches store app |
| `Utilities.OpenApplicationSettings()` | Opens system settings for current app | Void - launches settings app |

## Common Patterns

### Pattern 1: Review Request Fallback

Combine with Rate My App for manual review requests:

```csharp
public void ManualReviewRequest()
{
    // If rate my app quota exhausted, open store directly
    Utilities.OpenAppStorePage();
}
```

### Pattern 2: Permission Recovery Flow

Guide users through permission re-granting:

```csharp
public void RecoverCameraPermission()
{
    // Check permission status first
    var status = MediaServices.GetCameraAccessStatus();

    if (status == CameraAccessStatus.Denied)
    {
        ShowPermissionExplanation(() =>
        {
            Utilities.OpenApplicationSettings();
        });
    }
}

void ShowPermissionExplanation(System.Action onOpenSettings)
{
    AlertDialog dialog = AlertDialog.CreateInstance();
    dialog.Title = "Camera Access Needed";
    dialog.Message = "To scan QR codes, enable Camera in Settings > Permissions.";
    dialog.AddButton("Open Settings", () => onOpenSettings?.Invoke());
    dialog.AddCancelButton("Not Now", () => { });
    dialog.Show();
}
```

### Pattern 3: Cross-Promotion

Promote companion apps or DLC:

```csharp
public void PromoteCompanionApp()
{
    var iosId = RuntimePlatformConstant.iOS("9876543210");
    var androidId = RuntimePlatformConstant.Android("com.company.companion");

    AlertDialog dialog = AlertDialog.CreateInstance();
    dialog.Title = "Check Out Our New Game!";
    dialog.Message = "Download our companion app for exclusive rewards.";
    dialog.AddButton("View in Store", () =>
    {
        Utilities.OpenAppStorePage(iosId, androidId);
    });
    dialog.AddCancelButton("Maybe Later", () => { });
    dialog.Show();
}
```

## Error Handling

| Scenario | Trigger | Recommended Action |
| --- | --- | --- |
| Store page opens to “item not found” | App not published or incorrect identifier | Double-check the App Store ID / package name in Essential Kit Settings and test on a device signed into the correct store region. |
| `Utilities.OpenAppStorePage` appears to do nothing | Feature disabled in settings | Ensure Utilities is enabled in Essential Kit Settings or call `Utilities.Initialize` with custom settings at runtime. |
| Settings navigation blocked | User cancels or OS denies request (screen time restrictions) | Explain alternative steps inside the app and provide support contact details if the user cannot adjust settings. |
| Permission still denied after returning from settings | Player didn’t toggle the switch | Re-run your permission check when the app resumes and show a confirmation dialog if access is still missing. |

## Advanced: Custom Runtime Configuration

{% hint style="danger" %}
Manual initialization is for advanced scenarios only. Essential Kit auto-initializes Utilities using the `EssentialKitSettings` asset. Only use `Initialize()` for runtime-generated settings.
{% endhint %}

Override settings at runtime if needed:

```csharp
void Awake()
{
    var settings = new UtilityUnitySettings(isEnabled: true);
    // Configure additional options here if new fields are added in future versions
    Utilities.Initialize(settings);
}
```

**Use cases for manual initialization:**
- Loading settings from remote configuration
- Environment-specific utility behaviors (dev vs production)
- Custom logging or debug output preferences

{% hint style="warning" %}
For most games, configure settings in the ScriptableObject instead of manual initialization.
{% endhint %}

## Related Guides
- Pair with **Rate My App** to provide fallback review options when quota is exhausted
- Use with **permission-based features** (Camera, Contacts, Notifications) for settings navigation
- Combine with **Native UI** dialogs for user-friendly permission explanations
