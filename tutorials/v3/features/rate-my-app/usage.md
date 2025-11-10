---
description: "Rate My App allows requesting app reviews using native platform dialogs"
---

# Usage

Essential Kit wraps native iOS (StoreKit) and Android (In-App Review API) review dialogs into a single Unity interface. Essential Kit automatically initializes Rate My App - no manual initialization needed.

## Table of Contents

- [Understanding Platform Quotas](#understanding-platform-quotas)
- [Import Namespaces](#import-namespaces)
- [Auto-Show Workflow (Recommended for Most Games)](#auto-show-workflow-recommended-for-most-games)
- [Manual Control Workflow](#manual-control-workflow)
- [Handling Confirmation Dialog Actions](#handling-confirmation-dialog-actions)
- [Tracking Engagement Signals](#tracking-engagement-signals)
- [Data Properties](#data-properties)
- [Core APIs Reference](#core-apis-reference)
- [Error Handling](#error-handling)
- [Common Patterns](#common-patterns)
- [Advanced: Custom Runtime Configuration](#advanced-custom-runtime-configuration)

## Understanding Platform Quotas

Native review dialogs are limited by platform quotas to prevent spam:

**iOS Restrictions:**
- Maximum of 3 review prompts per year per user
- TestFlight builds never show the actual dialog
- Development builds have no limit

**Android Restrictions:**
- Limited quota (exact number not publicly disclosed by Google)
- Quota resets are not guaranteed

{% hint style="danger" %}
Platform quotas make every prompt valuable. Use confirmation dialogs to ensure user intent before consuming quota with native dialogs.
{% endhint %}

## Import Namespaces

```csharp
using VoxelBusters.EssentialKit;
```

## Auto-Show Workflow (Recommended for Most Games)

When **Auto Show** is enabled in settings, Essential Kit automatically checks constraints on each app launch and shows the rating prompt when conditions are met.

This workflow requires no code - just configure constraints in [settings](setup.md):
- Min launches, hours, significant events, elapsed days
- Confirmation dialog (recommended)
- Repeat constraints for users who decline

{% hint style="success" %}
Auto-show is perfect for casual games and apps where you want set-it-and-forget-it rating prompts based on engagement thresholds.
{% endhint %}

## Manual Control Workflow

Disable **Auto Show** in settings for full control over when rating prompts appear. This approach gives you precise timing based on gameplay events.

### Check if Allowed to Rate

Use `IsAllowedToRate()` to check if configured constraints are satisfied before showing a prompt:

```csharp
void OnLevelComplete()
{
    if (RateMyApp.IsAllowedToRate())
    {
        // Constraints met - safe to show rating prompt
        RateMyApp.AskForReviewNow();
    }
}
```

This method returns `true` only when all configured constraints (launches, hours, events, days) are satisfied.

### Request Review Immediately

`AskForReviewNow()` shows the rating prompt, optionally skipping the confirmation dialog:

```csharp
// Show with confirmation dialog (recommended)
void ShowRatingPrompt()
{
    RateMyApp.AskForReviewNow(skipConfirmation: false);
}

// Skip confirmation and show native dialog directly (uses quota immediately)
void ShowRatingPromptDirect()
{
    RateMyApp.AskForReviewNow(skipConfirmation: true);
}
```

**Parameters:**
- `skipConfirmation` (bool): `true` bypasses confirmation dialog and shows native prompt directly

{% hint style="warning" %}
Calling `AskForReviewNow(skipConfirmation: true)` consumes platform quota immediately. Use `skipConfirmation: false` to confirm user intent first.
{% endhint %}

## Handling Confirmation Dialog Actions

Subscribe to the confirmation dialog event to track user responses:

```csharp
void OnEnable()
{
    RateMyApp.OnConfirmationPromptAction += HandleConfirmationAction;
}

void OnDisable()
{
    RateMyApp.OnConfirmationPromptAction -= HandleConfirmationAction;
}

void HandleConfirmationAction(RateMyAppConfirmationPromptActionType action)
{
    switch (action)
    {
        case RateMyAppConfirmationPromptActionType.Ok:
            Debug.Log("User chose to rate - native dialog will show");
            // Track analytics event
            break;

        case RateMyAppConfirmationPromptActionType.RemindLater:
            Debug.Log("User wants reminder later");
            // Schedule reminder or track postponement
            break;

        case RateMyAppConfirmationPromptActionType.Cancel:
            Debug.Log("User declined rating");
            // Don't show again according to constraints
            break;
    }
}
```

| Action Type | Trigger |
| --- | --- |
| `Ok` | User clicked positive button - native dialog shows next |
| `RemindLater` | User clicked "Remind Later" button |
| `Cancel` | User clicked cancel/negative button |

## Tracking Engagement Signals

Rate prompts feel earned when you tie them to positive experiences. Track those signals and only call `AskForReviewNow` when the player is immersed.

```csharp
private const string kSignificantEventsKey = "rma_significant_events";

void OnAchievementUnlocked()
{
    Debug.Log("Achievement unlocked!");

    int totalEvents = PlayerPrefs.GetInt(kSignificantEventsKey, 0) + 1;
    PlayerPrefs.SetInt(kSignificantEventsKey, totalEvents);
    PlayerPrefs.Save();

    if (RateMyApp.IsAllowedToRate())
    {
        RateMyApp.AskForReviewNow(skipConfirmation: false);
    }
}
```

You can replace the `PlayerPrefs` logic with your analytics stack or backend-driven counters—what matters is deferring the prompt until the player hits the milestones you care about.

## Data Properties

| Item | Type | Notes |
| --- | --- | --- |
| `RateMyAppUnitySettings.AutoShow` | `bool` | When enabled, the controller evaluates constraints on launch and shows prompts automatically once conditions are satisfied. |
| `RateMyAppUnitySettings.AllowReratingForNewVersion` | `bool` | Lets you ask again after shipping a new app version even if the user already rated. |
| `RateMyAppConstraints.PromptConstraints.MinHours` | `int` | Minimum hours between prompt checks. Use lower values for soft launches, higher for seasoned players. |
| `RateMyAppConstraints.PromptConstraints.MinLaunches` | `int` | Number of app launches required before the prompt can appear. Setting `-1` disables that prompt sequence. |
| `RateMyApp.OnConfirmationPromptAction` | Event | Fires with `RateMyAppConfirmationPromptActionType` so you can reward players, log analytics, or adjust future prompts. |

## Core APIs Reference

| API | Purpose | Returns |
| --- | --- | --- |
| `RateMyApp.IsAllowedToRate()` | Check if configured constraints are satisfied | `bool` - true when conditions met |
| `RateMyApp.AskForReviewNow(skipConfirmation)` | Show rating prompt with optional confirmation skip | Void - shows UI |
| `RateMyApp.OnConfirmationPromptAction` | Event fired when user interacts with confirmation dialog | Event callback with action type |

## Error Handling

| Scenario | Trigger | Recommended Action |
| --- | --- | --- |
| Feature disabled in settings | `RateMyApp.AskForReviewNow` logs `Feature is not active` | Enable Rate My App in Essential Kit Settings or call `Initialize` with custom settings before asking for reviews. |
| Store quota exhausted (iOS) | User previously saw the native dialog 3 times within a year | Rely on the confirmation dialog route to gather feedback or direct players to `Utilities.OpenAppStorePage()` as a fallback. |
| Prompt never appears with Auto Show | Constraints never satisfied (hours/launches too high) | Revisit `MinHours`/`MinLaunches` values and confirm `AutoShow` is enabled. Log the constraint state when checking `IsAllowedToRate()`. |
| Version already rated | `AllowReratingForNewVersion` disabled and player reviewed an older build | Encourage users to review only when you ship a new version or toggle rerating in settings for post-update prompts. |

## Common Patterns

### Pattern 1: Rating After Positive Experience

```csharp
void OnLevelWin()
{
    // Check constraints after positive gameplay moment
    if (RateMyApp.IsAllowedToRate())
    {
        RateMyApp.AskForReviewNow(skipConfirmation: false);
    }
}
```

### Pattern 2: Manual Trigger from Settings

```csharp
public void OnRateButtonClick()
{
    // User manually requested rating from settings menu
    // Skip constraints but keep confirmation to protect quota
    RateMyApp.AskForReviewNow(skipConfirmation: false);
}
```

### Pattern 3: Version-Based Re-Rating

Enable **Allow Re-rating in New Version** in settings to automatically re-prompt users when app version changes. No code needed - Essential Kit detects version changes automatically.

## Advanced: Custom Runtime Configuration

{% hint style="danger" %}
Manual initialization is for advanced scenarios only. Essential Kit auto-initializes Rate My App with settings from the ScriptableObject. Only use `Initialize()` for runtime-generated settings.
{% endhint %}

Override settings at runtime for A/B testing or server-driven configuration:

```csharp
void Awake()
{
    var constraints = new RateMyAppConstraints(
        initialPromptConstraints: new RateMyAppConstraints.PromptConstraints(minHours: 0, minLaunches: 3),
        repeatPromptConstraints: new RateMyAppConstraints.PromptConstraints(minHours: 24, minLaunches: 5));

    var dialogSettings = new RateMyAppConfirmationDialogSettings(
        title: "Enjoying the game?",
        description: "Mind leaving us a quick review?",
        okButtonLabel: "Sure!",
        cancelButtonLabel: "No thanks");

    var settings = new RateMyAppUnitySettings(
        isEnabled: true,
        dialogSettings: dialogSettings,
        defaultValidatorSettings: constraints,
        allowRatingAgainForNewVersion: true,
        autoShowWhenConditionsAreMet: false);

    string storeId = Application.platform == RuntimePlatform.IPhonePlayer
        ? "1234567890" // iOS App Store ID
        : "com.company.gamename"; // Android package name

    RateMyApp.Initialize(settings, storeId);
}
```

**Use cases for manual initialization:**
- A/B testing different constraint thresholds
- Loading settings from remote config/server
- Dynamic configuration based on user segments

{% hint style="warning" %}
Calling `Initialize()` multiple times resets rating state. For most games, configure settings in the ScriptableObject instead.
{% endhint %}

## Related Guides
- Demo scene: `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/RateMyAppDemo.unity`
- Use **Utilities.OpenAppStorePage()** to direct users to store page for leaving reviews manually
- See [Testing Guide](testing.md) to validate rating prompts before submission
