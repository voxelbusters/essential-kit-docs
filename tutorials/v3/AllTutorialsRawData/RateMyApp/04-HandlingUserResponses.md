# Handling User Responses

## What are Confirmation Dialog Events?

The confirmation dialog shows before the native rating prompt, giving users options to rate now, cancel, or be reminded later. Unity mobile game developers can listen to these events to track user behavior and implement custom logic.

## Why Use Events in Unity Mobile Games?

Tracking user responses helps you understand rating prompt effectiveness and implement features like analytics tracking, custom UI updates, or gameplay adjustments based on user feedback preferences.

## API Reference

```csharp
public static event Callback<RateMyAppConfirmationPromptActionType> OnConfirmationPromptAction;
```

**Event Parameter:** `RateMyAppConfirmationPromptActionType` enum with values:
- `Ok` - User chose to rate the app
- `Cancel` - User cancelled the rating
- `RemindLater` - User chose to be reminded later

## Code Example

Here's how to listen for confirmation dialog responses:

```csharp
using VoxelBusters.EssentialKit;

public class RatingManager : MonoBehaviour
{
    void Start()
    {
        RateMyApp.OnConfirmationPromptAction += OnRatingResponse;
    }

    void OnRatingResponse(RateMyAppConfirmationPromptActionType action)
    {
        switch (action)
        {
            case RateMyAppConfirmationPromptActionType.Ok:
                Debug.Log("User chose to rate the app");
                break;
            case RateMyAppConfirmationPromptActionType.Cancel:
                Debug.Log("User cancelled rating");
                break;
            case RateMyAppConfirmationPromptActionType.RemindLater:
                Debug.Log("User chose to be reminded later");
                break;
        }
    }
}
```

This snippet demonstrates how to track all possible user responses to the confirmation dialog.

## Practical Usage Example

```csharp
void OnRatingResponse(RateMyAppConfirmationPromptActionType action)
{
    if (action == RateMyAppConfirmationPromptActionType.Ok)
    {
        Debug.Log("Thank you for rating!");
        // Maybe show a thank you message or reward
    }
    else if (action == RateMyAppConfirmationPromptActionType.Cancel)
    {
        Debug.Log("Maybe next time!");
        // Continue normal game flow
    }
}
```

This shows how to provide feedback to users based on their rating choice in your Unity cross-platform mobile game.

📌 **Video Note**: Show Unity demo with confirmation dialog interactions and console logs displaying the different response types.