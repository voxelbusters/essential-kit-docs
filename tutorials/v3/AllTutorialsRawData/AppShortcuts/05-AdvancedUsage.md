# Advanced Usage

This section covers advanced App Shortcuts concepts for experienced Unity developers looking to implement sophisticated shortcut management strategies.

## Custom Initialization with Settings

For advanced configuration control, initialize App Shortcuts with custom settings:

```csharp
// Initialize with custom settings
AppShortcutsUnitySettings customSettings = ScriptableObject.CreateInstance<AppShortcutsUnitySettings>();
AppShortcuts.Initialize(customSettings);
Debug.Log("App Shortcuts initialized with custom settings");
```

This approach allows you to override default configurations and use project-specific App Shortcuts settings files for different build configurations or testing scenarios.

## Availability Checking for Robust Implementation

Check feature availability before performing shortcut operations:

```csharp
// Verify shortcuts are available before use
if (AppShortcuts.IsAvailable())
{
    AppShortcuts.Add(myShortcut);
    Debug.Log("Shortcut added successfully");
}
else
{
    Debug.Log("App Shortcuts not available on this platform/device");
}
```

This pattern ensures your Unity cross-platform game handles edge cases gracefully, such as older device versions or unsupported platforms.

## Conditional Shortcut Management Based on Game State

Implement sophisticated shortcut logic that responds to complex game states:

```csharp
private void UpdateShortcutsForGameSession()
{
    // Remove all existing dynamic shortcuts
    AppShortcuts.Remove("daily-reward");
    AppShortcuts.Remove("continue-game");
    AppShortcuts.Remove("special-event");
    
    // Add context-appropriate shortcuts
    if (PlayerData.HasUnclaimedRewards())
    {
        var rewardShortcut = new AppShortcutItem.Builder("daily-reward", "Claim Rewards")
            .SetSubtitle($"{PlayerData.GetRewardCount()} rewards waiting!")
            .SetIconFileName("reward-icon.png")
            .Build();
        AppShortcuts.Add(rewardShortcut);
    }
    
    Debug.Log("Updated shortcuts based on current game session");
}
```

This advanced pattern demonstrates dynamic shortcut management that adapts to player progress, available content, and time-sensitive events in your Unity mobile game.

📌 **Video Note**: Show Unity demo of each advanced case, including the settings initialization process and conditional shortcut updates responding to different game states.