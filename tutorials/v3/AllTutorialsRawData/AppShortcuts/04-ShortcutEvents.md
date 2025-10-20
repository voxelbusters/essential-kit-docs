# Shortcut Events

## What are Shortcut Events?

Shortcut Events are notifications that occur when players tap app shortcuts from their device home screen. These events provide the shortcut identifier, allowing your Unity mobile game to respond appropriately by navigating to specific content or triggering relevant actions.

## Why Handle Shortcut Events in Unity Mobile Games?

Handling shortcut events properly creates seamless user experiences. When players tap "Continue Level 5," your game should immediately load that level. When they tap "Daily Reward," the rewards screen should appear instantly. This direct routing increases player satisfaction and engagement.

## Core Event API: OnShortcutClicked

The `AppShortcuts.OnShortcutClicked` event provides shortcut identifiers when shortcuts are activated:

```csharp
void OnEnable()
{
    AppShortcuts.OnShortcutClicked += OnShortcutClicked;
}

void OnDisable()
{
    AppShortcuts.OnShortcutClicked -= OnShortcutClicked;
}
```

This snippet shows the standard Unity pattern for subscribing to shortcut events in your game scripts.

## Handling Shortcut Clicks

Process shortcut identifiers to trigger appropriate game actions:

```csharp
private void OnShortcutClicked(string shortcutId)
{
    Debug.Log($"Player clicked shortcut: {shortcutId}");
    
    switch(shortcutId)
    {
        case "daily-reward":
            OpenDailyRewardsScreen();
            break;
        case "continue-level":
            ContinueLastLevel();
            break;
        default:
            Debug.Log($"Unknown shortcut clicked: {shortcutId}");
            break;
    }
}
```

This snippet demonstrates routing shortcut clicks to specific game features, creating direct access paths for players.

## Event-Driven Game Navigation

Use shortcut events to drive deep linking within your Unity mobile game:

```csharp
private void OnShortcutClicked(string shortcutId)
{
    // Route to appropriate game screen
    GameManager.NavigateToShortcutContent(shortcutId);
    Debug.Log($"Navigated to content for shortcut: {shortcutId}");
}
```

This snippet shows how shortcut events can integrate with your existing game navigation system to provide seamless deep linking functionality.

📌 **Video Note**: Show Unity demo of tapping shortcuts on device home screen and the immediate response in the running game, demonstrating the seamless transition from shortcut to specific game content.