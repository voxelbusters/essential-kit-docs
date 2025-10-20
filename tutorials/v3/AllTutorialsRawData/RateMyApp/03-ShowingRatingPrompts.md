# Showing Rating Prompts

## What is AskForReviewNow?

`AskForReviewNow()` displays the native platform rating dialog to users. This is the core method Unity mobile game developers use to request ratings, with options to show or skip confirmation dialogs.

## Why Use It in Unity Mobile Games?

This method triggers the actual rating interface, allowing players to rate your Unity mobile game directly within the app. It respects platform quotas while giving you control over the user experience.

## API Reference

```csharp
public static void AskForReviewNow(bool skipConfirmation = false)
```

**Parameters:**
- `skipConfirmation`: If `true`, bypasses the confirmation dialog and shows the native rating dialog directly.

## Code Examples

### Basic Usage (With Confirmation Dialog)

```csharp
using VoxelBusters.EssentialKit;

public void ShowRatingPrompt()
{
    RateMyApp.AskForReviewNow();
    Debug.Log("Rating prompt requested with confirmation dialog");
}
```

This snippet shows the rating prompt with a confirmation dialog first, helping preserve platform quota.

### Skip Confirmation Dialog

```csharp
public void ShowRatingDirectly()
{
    RateMyApp.AskForReviewNow(skipConfirmation: true);
    Debug.Log("Rating prompt shown directly without confirmation");
}
```

This bypasses the confirmation dialog and shows the native rating interface immediately.

### Combined with Condition Check

```csharp
public void SmartRatingPrompt()
{
    if (RateMyApp.IsAllowedToRate())
    {
        RateMyApp.AskForReviewNow();
        Debug.Log("Showing rating prompt - conditions met");
    }
    else
    {
        Debug.Log("Rating conditions not met yet");
    }
}
```

This snippet combines condition checking with the rating prompt for optimal timing in your Unity cross-platform game.

📌 **Video Note**: Show Unity demo of both confirmation dialog and direct rating prompt flows on iOS and Android devices.