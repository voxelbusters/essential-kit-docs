---
description: "Utilities provides cross-platform app store and system settings navigation"
---

# Usage

Essential Kit Utilities wraps native iOS (UIApplication) and Android (Intent) APIs for common navigation tasks. Essential Kit automatically initializes Utilities - no manual setup needed.

## Table of Contents

- [Import Namespaces](#import-namespaces)
- [Opening App Store Pages](#opening-app-store-pages)
- [Opening Application Settings](#opening-application-settings)
- [Requesting Age Compliance Info](#requesting-age-compliance-info)
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

## Requesting Age Compliance Info

Fetch the user's declared age range from native providers to align with your content age gates.

{% hint style="info" %}
Enable **Uses Age Compliance Api** in **Essential Kit Settings → Services → Utilities** before calling this API. Required dependencies are added automatically for iOS (Declared Age APIs) and Android (Play Age Signals).
{% endhint %}

### Example: Map Users to Content Gates

```csharp
public void ApplyAgeGate()
{
    var options = new RequestInfoForAgeComplianceOptions.Builder()
        .AddContentAgeGateRange(3, 7)
        .AddContentAgeGateRange(7, 13)
        .AddContentAgeGateRange(13, 18)
        .Build();

    Utilities.RequestInfoForAgeCompliance(options, (info, error) =>
    {
        if (error != null)
        {
            Debug.LogError($"Age compliance error: {error}");
            return;
        }

        if (info.UserAgeRangeDeclarationMethod == AgeRangeDeclarationMethod.NotDeclared)
        {
            // No declared age available—fall back to your own age gate UI.
            ShowManualAgeGate();
            return;
        }

        var range = info.UserAgeRange;

        if (range.LowerBound == -1)
        {
            LoadUnderAgeExperience();
            return;
        }

        if (range.UpperBound == -1)
        {
            LoadAdultExperience();
            return;
        }

        LoadContentForRange(range);
    });
}
```

### Interpreting Results

- When `UserAgeRangeDeclarationMethod` is `NotDeclared`, `UserAgeRange` is `0-0`; ignore the range and prompt your own gate.
- `LowerBound == -1` means the user is younger than the lowest provided content gate.
- `UpperBound == -1` means no practical upper bound (adult).
- Values are provided by platform signals (Declared Age APIs on iOS, Play Age Signals on Android); there are no extra dependencies beyond enabling the toggle.

## Data Properties

| Item | Type | Notes |
| --- | --- | --- |
| `RuntimePlatformConstant.iOS/Android` | Helper Struct | Wrap platform-specific identifiers so you can provide both IDs in a single `OpenAppStorePage` call. |
| `Utilities.OpenAppStorePage()` | Method | Uses the identifiers configured in Essential Kit Settings to deep link directly to your app’s store listing. |
| `Utilities.OpenApplicationSettings()` | Method | Jumps to the operating system’s settings page for your app, letting players re-enable permissions without manual navigation. |
| `Utilities.RequestInfoForAgeCompliance()` | Method | Fetches `InfoForAgeCompliance` for the current user; requires **Uses Age Compliance Api** enabled in Utilities settings. |
| `UtilityUnitySettings.IsEnabled` | `bool` | Indicates whether the Utilities feature is active; when disabled, navigation helpers do nothing and log an error. |
| `AgeRange` | Struct | Age bounds in years. `-1` marks a bound that doesn’t apply; defaults to `0-0` when age is not declared. |
| `AgeRangeDeclarationMethod` | Enum | How the age was declared (self, guardian, payment, ID, etc.); `NotDeclared` means no reliable age data was provided. |
| `RequestInfoForAgeComplianceOptions` | Class | Supply content age gates so platform signals can map the user to the nearest range; defaults to `0-100` if not provided. |
| `InfoForAgeCompliance` | Class | Returns `UserAgeRange` and `UserAgeRangeDeclarationMethod`; ignore `UserAgeRange` when the declaration method is `NotDeclared`. |

## Core APIs Reference

| API | Purpose | Returns |
| --- | --- | --- |
| `Utilities.OpenAppStorePage()` | Opens current app's store page using configured ID | Void - launches store app |
| `Utilities.OpenAppStorePage(platformConstants)` | Opens store page for specified app with platform IDs | Void - launches store app |
| `Utilities.OpenAppStorePage(appId)` | Opens store page using string identifier | Void - launches store app |
| `Utilities.OpenApplicationSettings()` | Opens system settings for current app | Void - launches settings app |
| `Utilities.RequestInfoForAgeCompliance(options, callback)` | Retrieves declared age info for compliance; maps against provided content age gates | Void - callback receives `InfoForAgeCompliance` or an error |

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

### Pattern 4: Content Segmentation by Age

```csharp
public void RouteUserByAge()
{
    var options = new RequestInfoForAgeComplianceOptions.Builder()
        .AddContentAgeGateRange(0, 12)
        .AddContentAgeGateRange(13, 17)
        .AddContentAgeGateRange(18, 120) // Adult bucket (upper bound may be returned as -1)
        .Build();

    Utilities.RequestInfoForAgeCompliance(options, (info, error) =>
    {
        if (error != null || info.UserAgeRangeDeclarationMethod == AgeRangeDeclarationMethod.NotDeclared)
        {
            ShowManualAgeGate();
            return;
        }

        var ageRange = info.UserAgeRange;
        var isAdult = ageRange.UpperBound == -1;
        var isChild = ageRange.LowerBound == -1;

        if (isChild)
        {
            LoadChildFriendlyMode();
        }
        else if (isAdult)
        {
            LoadAdultMode();
        }
        else
        {
            LoadTeenMode();
        }
    });
}
```

## Error Handling

| Scenario | Trigger | Recommended Action |
| --- | --- | --- |
| Store page opens to “item not found” | App not published or incorrect identifier | Double-check the App Store ID / package name in Essential Kit Settings and test on a device signed into the correct store region. |
| `Utilities.OpenAppStorePage` appears to do nothing | Feature disabled in settings | Ensure Utilities is enabled in Essential Kit Settings or call `Utilities.Initialize` with custom settings at runtime. |
| Settings navigation blocked | User cancels or OS denies request (screen time restrictions) | Explain alternative steps inside the app and provide support contact details if the user cannot adjust settings. |
| Permission still denied after returning from settings | Player didn’t toggle the switch | Re-run your permission check when the app resumes and show a confirmation dialog if access is still missing. |
| `Utilities.RequestInfoForAgeCompliance` returns `NotDeclared` | Platform could not supply a declared age | Run your own age gate UI; treat `UserAgeRange` as `0-0` and do not use it. |
| Age compliance call logs “Uses Age Compliance Api not enabled” | Toggle disabled in settings | Enable **Uses Age Compliance Api** in Utilities settings and rebuild. |

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
