# Shortcut Management

## What is Shortcut Management?

Shortcut Management involves adding and removing app shortcuts dynamically based on your Unity mobile game's current state. This allows you to keep shortcuts relevant and useful by showing shortcuts for available actions while removing outdated or completed ones.

## Why Use Dynamic Shortcut Management in Unity Mobile Games?

Dynamic shortcut management keeps your game's shortcuts fresh and contextually relevant. For example, you can add a "Claim Daily Reward" shortcut when rewards are available and remove it after claiming, or show "Continue Boss Fight" during active boss encounters while removing it after completion.

## Core Management APIs

Essential Kit provides two simple methods for shortcut lifecycle management:

### Adding Shortcuts

```csharp
// Add a new shortcut to the home screen
AppShortcutItem newShortcut = new AppShortcutItem.Builder("boss-fight", "Continue Boss Fight")
    .SetSubtitle("Defeat the Fire Dragon!")
    .SetIconFileName("boss-icon.png")
    .Build();

AppShortcuts.Add(newShortcut);
Debug.Log("Added boss fight shortcut");
```

This snippet adds a contextual shortcut when a boss fight is in progress, giving players quick access to continue their challenge.

### Removing Shortcuts

```csharp
// Remove a shortcut by its identifier
AppShortcuts.Remove("boss-fight");
Debug.Log("Removed boss fight shortcut after completion");
```

This snippet removes the boss fight shortcut after the player completes or abandons the encounter, keeping shortcuts clean and relevant.

## Dynamic Shortcut Updates

Update shortcuts based on game state changes:

```csharp
// Update shortcuts when player progresses
private void UpdateLevelShortcuts(int currentLevel)
{
    // Remove old level shortcut
    AppShortcuts.Remove("continue-level");
    
    // Add new level shortcut
    AppShortcutItem levelShortcut = new AppShortcutItem.Builder("continue-level", $"Continue Level {currentLevel}")
        .SetSubtitle("Resume your adventure!")
        .SetIconFileName("level-icon.png")
        .Build();
    
    AppShortcuts.Add(levelShortcut);
    Debug.Log($"Updated shortcut for level {currentLevel}");
}
```

This snippet demonstrates how to keep level-based shortcuts current as players progress through your Unity mobile game.

📌 **Video Note**: Show Unity demo of shortcuts being added and removed dynamically, with before/after shots of the device home screen showing the changes in real-time.