---
description: "Add dynamic app icon shortcuts to boost user engagement and feature access in Unity mobile games"
---

# App Shortcuts for Unity

Essential Kit's App Shortcuts feature lets Unity teams add dynamic shortcuts to the app icon without maintaining platform-specific code. This tutorial walks you through setup, key APIs, testing, and troubleshooting so you can add quick-access shortcuts with confidence.

{% hint style="info" %}
Looking for a working reference? Open the demo scene at `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/AppShortcutsDemo.unity` and the companion script at `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scripts/AppShortcutsDemo.cs` to see the full API in action.
{% endhint %}

## What You'll Learn
- Create dynamic shortcuts that appear when users long-press your app icon
- Handle shortcut taps to deep-link users directly into specific game features
- Manage shortcut lifecycle by adding and removing shortcuts based on player progress

## Why App Shortcuts Matter
- **Boost Engagement**: Surface daily rewards, challenges, or unfinished levels right from the home screen
- **Improve Retention**: Let players jump directly into multiplayer lobbies or continue their last game session
- **Enhance Discovery**: Showcase premium features or limited-time events with prominent shortcuts

## Tutorial Roadmap
1. [Setup](setup.md) – Enable the feature and configure shortcut icons.
2. [Usage](usage.md) – Add shortcuts, handle clicks, and manage lifecycle.
3. [Testing](testing.md) – Simulate in editor and verify on devices.
4. [FAQ](faq.md) – Troubleshoot common issues.

## Key Use Cases
- **Daily Rewards**: Add a "Collect Daily Bonus" shortcut that appears after first login
- **Continue Playing**: Show "Resume Level X" shortcuts for players with active sessions
- **Quick Multiplayer**: Surface "Quick Match" or "Invite Friends" for social engagement
- **Event Promotions**: Highlight limited-time events or new content releases

## Prerequisites
- Unity project with Essential Kit v3 installed and App Shortcuts feature enabled in settings.
- iOS or Android target with proper icon assets configured in Essential Kit Settings.
- Test device to validate long-press shortcuts before release (simulator behavior may differ).

{% content-ref url="setup.md" %}
[Setup](setup.md)
{% endcontent-ref %}

{% content-ref url="usage.md" %}
[Usage](usage.md)
{% endcontent-ref %}

{% content-ref url="testing.md" %}
[Testing](testing.md)
{% endcontent-ref %}

{% content-ref url="faq.md" %}
[FAQ](faq.md)
{% endcontent-ref %}
