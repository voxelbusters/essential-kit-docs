---
description: "App Shortcuts lets you add dynamic quick actions to your app icon on mobile devices"
---

# Usage

Essential Kit wraps native iOS Quick Actions and Android App Shortcuts into a single Unity interface. Shortcuts appear when users long-press your app icon and persist across app launches until explicitly removed.

## Table of Contents
- [Understanding App Shortcuts](#understanding-app-shortcuts)
- [Import Namespaces](#import-namespaces)
- [Event Registration](#event-registration)
- [Creating Shortcuts](#creating-shortcuts)
- [Handling Shortcut Clicks](#handling-shortcut-clicks)
- [Removing Shortcuts](#removing-shortcuts)
- [Core APIs Reference](#core-apis-reference)
- [Advanced: Runtime Initialization](#advanced-runtime-initialization)
- [Related Guides](#related-guides)

## Understanding App Shortcuts

App Shortcuts are quick actions that appear when users long-press your app icon on the home screen. They provide direct access to specific features without navigating through your app's UI.

**Key characteristics:**
- Shortcuts persist until explicitly removed or app is uninstalled
- iOS supports up to 4 shortcuts; Android varies by launcher
- Each shortcut has a unique identifier, title, optional subtitle, and optional icon
- Clicking a shortcut launches your app and triggers the `OnShortcutClicked` event

**Examples:**
- Daily reward collection shortcuts
- Continue game shortcuts showing current level
- Quick access to multiplayer or leaderboards

## Import Namespaces
```csharp
using VoxelBusters.EssentialKit;
using VoxelBusters.CoreLibrary;
```

## Event Registration

Register for the shortcut click event in `OnEnable` and unregister in `OnDisable`:

```csharp
void OnEnable()
{
    AppShortcuts.OnShortcutClicked += OnShortcutClicked;
}

void OnDisable()
{
    AppShortcuts.OnShortcutClicked -= OnShortcutClicked;
}

void OnShortcutClicked(string shortcutId)
{
    Debug.Log($"Shortcut clicked: {shortcutId}");
}
```

| Event | Trigger |
| --- | --- |
| `OnShortcutClicked` | When user taps a shortcut from the app icon menu |

{% hint style="success" %}
Essential Kit caches shortcut clicks that occur during app launch. The event fires once you register the listener, ensuring you never miss a click even if the app wasn't running.
{% endhint %}

## Creating Shortcuts

### Why Shortcuts Improve Engagement

Shortcuts reduce friction by letting players jump directly into features they care about. A "Continue Level 5" shortcut is more compelling than opening the app and navigating through menus.

This ensures:
- Faster access to frequently used features
- Higher conversion rates for daily rewards or events
- Better discovery of premium or multiplayer content

### Implementation

Use `AppShortcutItem.Builder` to configure shortcuts before adding them:

```csharp
void AddDailyRewardShortcut()
{
    var shortcut = new AppShortcutItem.Builder("daily-reward", "Daily Reward")
        .SetSubtitle("Your rewards are waiting!")
        .SetIconFileName("daily-reward.png")
        .Build();

    AppShortcuts.Add(shortcut);
}
```

**AppShortcutItem.Builder Properties:**
- `identifier` (required): Unique ID to identify this shortcut in click events
- `title` (required): Primary text displayed in the shortcut menu
- `SetSubtitle(string)`: Secondary text (may not display on all Android launchers)
- `SetIconFileName(string)`: Filename matching a texture in Essential Kit Settings → Icons list
- `Builder.Build()`: Finalize the builder and return an `AppShortcutItem` instance

**AppShortcutItem Properties (read-only):**
- `Identifier`: String identifier returned when the shortcut is tapped
- `Title`: Primary label shown in the shortcut menu
- `Subtitle`: Optional secondary label (can be null if not set or not supported)
- `IconFileName`: Filename used to bind to an icon from settings (null if omitted)

{% hint style="warning" %}
Icons must be added to the **Icons** list in App Shortcuts settings. If the filename doesn't match an entry in that list, the shortcut appears without an icon. See [Setup](setup.md) for configuration details.
{% endhint %}

### Dynamic Shortcuts Based on Game State

Update shortcuts to reflect player progress:

```csharp
void UpdateContinueShortcut(int currentLevel)
{
    // Remove old continue shortcut
    AppShortcuts.Remove("continue-game");

    // Add updated shortcut with current level
    var shortcut = new AppShortcutItem.Builder("continue-game", $"Continue Level {currentLevel}")
        .SetSubtitle("Pick up where you left off!")
        .SetIconFileName("continue-game.png")
        .Build();

    AppShortcuts.Add(shortcut);
}
```

### Multiple Shortcuts

Add multiple shortcuts in sequence. They display in the order added (platform-dependent):

```csharp
void SetupGameShortcuts()
{
    var quickMatch = new AppShortcutItem.Builder("quick-match", "Quick Match")
        .SetSubtitle("Jump into a quick game")
        .SetIconFileName("quick-match.png")
        .Build();
    AppShortcuts.Add(quickMatch);

    var dailyChallenge = new AppShortcutItem.Builder("daily-challenge", "Daily Challenge")
        .SetSubtitle("Complete today's challenge")
        .SetIconFileName("challenge.png")
        .Build();
    AppShortcuts.Add(dailyChallenge);
}
```

## Handling Shortcut Clicks

When a user taps a shortcut, the app launches (or resumes) and the `OnShortcutClicked` event fires with the shortcut's identifier:

```csharp
void OnShortcutClicked(string shortcutId)
{
    switch (shortcutId)
    {
        case "daily-reward":
            Debug.Log("Open the daily rewards screen.");
            break;

        case "continue-game":
            Debug.Log("Load the last saved level.");
            break;

        case "quick-match":
            Debug.Log("Start multiplayer matchmaking.");
            break;

        default:
            Debug.LogWarning($"Unknown shortcut: {shortcutId}");
            break;
    }
}
```

{% hint style="info" %}
The event may fire before your game UI is ready. Consider queueing the action and executing it after scene loads or UI initialization completes.
{% endhint %}

## Removing Shortcuts

Remove shortcuts by identifier when they're no longer relevant:

```csharp
void RemoveShortcut(string shortcutId)
{
    AppShortcuts.Remove(shortcutId);
}

// Example: Remove continue shortcut when level is completed
void OnLevelComplete()
{
    AppShortcuts.Remove("continue-game");
}
```

Removing a non-existent shortcut ID is safe and produces no error.

## Core APIs Reference
| API | Purpose | Returns |
| --- | --- | --- |
| `AppShortcuts.Add(AppShortcutItem)` | Add a shortcut to the app icon menu | None |
| `AppShortcuts.Remove(string)` | Remove a shortcut by identifier | None |
| `AppShortcuts.OnShortcutClicked` | Event fired when user taps a shortcut | `string` (shortcut identifier) |
| `AppShortcutItem.Builder(id, title)` | Create a shortcut with required properties | Builder instance for chaining |
| `Builder.SetSubtitle(string)` | Add optional subtitle text | Builder instance |
| `Builder.SetIconFileName(string)` | Reference icon from settings | Builder instance |
| `Builder.Build()` | Construct the final `AppShortcutItem` | `AppShortcutItem` |

## Advanced: Runtime Initialization

{% hint style="danger" %}
Most projects should use the automatic initialization via Essential Kit Settings. Only use manual initialization if you need to dynamically configure shortcut icons at runtime based on server data or user preferences.
{% endhint %}

### Understanding Manual Initialization

**Default Behavior:**
Essential Kit automatically initializes App Shortcuts using the settings configured in the inspector.

**What `Initialize` does:**
Calling `AppShortcuts.Initialize(AppShortcutsUnitySettings settings)` assigns the settings to `AppShortcuts.UnitySettings`, creates the native interface, and hooks the internal listener that later raises `AppShortcuts.OnShortcutClicked`.

**When to call it manually:**
Use `AppShortcuts.Initialize()` only when you need to:
- Load shortcut icon configurations from a remote server
- Change shortcut icons based on user preferences or A/B tests
- Dynamically configure icons without modifying the settings asset

**Guidelines:**
- Call `Initialize` once before adding or removing shortcuts.
- Reusing it later replaces the native interface, so avoid repeated calls during gameplay.
- Keep a reference to the settings instance if you need to inspect or reuse the icons list.

### Implementation

Override default settings at runtime before adding any shortcuts:

```csharp
void Awake()
{
    var settings = new AppShortcutsUnitySettings(
        isEnabled: true,
        icons: runtimeIconList); // Populate from Addressables, remote configs, etc.

    AppShortcuts.Initialize(settings);
}
```

{% hint style="warning" %}
Call `Initialize()` only once—ideally during startup and before adding shortcuts. For most games, prefer [standard setup](setup.md) via Essential Kit Settings.
{% endhint %}

## Related Guides
- Demo scene: `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/AppShortcutsDemo.unity`
- Pair with **Deep Link Services** to handle shortcut actions that require specific app states
- Use with **Notification Services** to create shortcuts for notification-driven features
