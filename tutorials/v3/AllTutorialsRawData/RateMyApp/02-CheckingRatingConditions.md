# Checking Rating Conditions

## What is IsAllowedToRate?

`IsAllowedToRate()` is a method that checks if the timing constraints configured in Essential Kit Settings have been met. This is essential for Unity mobile game developers to ensure rating prompts appear at appropriate times based on user engagement.

## Why Use It in Unity Mobile Games?

Before showing a rating prompt, you want to ensure the user has had enough time to experience your game. This method respects the timing constraints you've set up, such as minimum hours played or number of app launches.

## API Reference

```csharp
public static bool IsAllowedToRate()
```

**Returns:** `true` if conditions are met, `false` otherwise.

## Code Example

Here's how to check if rating conditions are satisfied:

```csharp
using VoxelBusters.EssentialKit;

public void CheckIfCanRate()
{
    bool canShowRating = RateMyApp.IsAllowedToRate();
    Debug.Log($"Can show rating prompt: {canShowRating}");
    
    if (canShowRating)
    {
        Debug.Log("Ready to show rating dialog!");
    }
    else
    {
        Debug.Log("Conditions not met yet");
    }
}
```

This snippet checks the current status and logs whether the rating prompt can be shown based on your configured timing constraints.

## Common Usage Pattern

Typically, you'll check this condition before triggering rating prompts:

```csharp
public void OnLevelComplete()
{
    if (RateMyApp.IsAllowedToRate())
    {
        // Show rating prompt
        Debug.Log("Showing rating prompt after level completion");
    }
}
```

This ensures rating prompts only appear when timing conditions are appropriate for your Unity mobile game experience.

📌 **Video Note**: Show Unity demo with different timing constraint configurations and demonstrate when `IsAllowedToRate()` returns true vs false.