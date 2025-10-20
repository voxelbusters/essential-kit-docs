# App Shortcut Creation

## What is App Shortcut Creation?

App Shortcut Creation is the process of building dynamic shortcut items that appear on the user's device home screen. In Unity mobile games, this allows players to access key features like daily rewards, continue playing, or customer support directly from their home screen without opening the main app first.

## Why Use App Shortcut Creation in Unity Mobile Games?

Creating strategic app shortcuts increases player engagement by reducing friction to access popular game features. Players are more likely to claim daily rewards or continue their progress when shortcuts provide instant access, leading to improved retention metrics and higher lifetime value.

## Core API: AppShortcutItem.Builder

The `AppShortcutItem.Builder` class uses the builder pattern to create shortcut items with customizable properties:

```csharp
// Create a daily reward shortcut
AppShortcutItem dailyRewardShortcut = new AppShortcutItem.Builder("daily-reward", "Daily Reward")
    .SetSubtitle("Your rewards are waiting!")
    .SetIconFileName("daily-reward.png")
    .Build();

Debug.Log("Created daily reward shortcut with ID: daily-reward");
```

This snippet creates a shortcut with a unique identifier, title, descriptive subtitle, and custom icon that encourages players to return for their daily rewards.

## Building Basic Shortcuts

Start with the required parameters - identifier and title:

```csharp
// Minimal shortcut creation
AppShortcutItem basicShortcut = new AppShortcutItem.Builder("continue-game", "Continue Playing")
    .Build();

Debug.Log("Created basic shortcut: Continue Playing");
```

This creates a functional shortcut with just the essential information needed for player recognition.

## Adding Subtitles and Icons

Enhance shortcuts with additional context and visual appeal:

```csharp
// Enhanced shortcut with subtitle and icon
AppShortcutItem enhancedShortcut = new AppShortcutItem.Builder("level-5", "Continue Level 5")
    .SetSubtitle("Pick up where you left off!")
    .SetIconFileName("continue-game.png")
    .Build();

Debug.Log("Created enhanced shortcut with subtitle and custom icon");
```

This snippet demonstrates how subtitles provide additional context while custom icons improve visual recognition and app branding consistency.

📌 **Video Note**: Show Unity demo clip of creating shortcuts in code, then demonstrate the shortcuts appearing on both iOS and Android device home screens with the custom icons and text.