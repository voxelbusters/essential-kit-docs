---
description: Background task execution and app lifecycle management for Unity mobile games
icon: microchip
---

# Task Services

Essential Kit's Task Services feature lets Unity developers ensure critical operations complete even when users put the app in the background. This tutorial walks you through background task protection, app lifecycle management, and platform-specific limitations so you can implement reliable data persistence and network operations.

{% hint style="info" %}
Using PlayMaker? See the PlayMaker guide: [PlayMaker](playmaker/README.md).
{% endhint %}

{% hint style="danger" %}
**Platform Background Time Limits**: iOS allows approximately 30 seconds of background execution. Android provides a few minutes. Essential Kit cannot extend these system-enforced limits—plan your tasks accordingly.
{% endhint %}

{% hint style="info" %}
Looking for a working reference? Open the demo scene at `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/TaskServicesDemo.unity` and the companion script at `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scripts/TaskServicesDemo.cs` to see the full API in action.
{% endhint %}

## What You'll Learn

* Understand mobile app lifecycle states (Running, Background, Suspended, Terminated)
* Protect critical async operations from backgrounding interruption
* Use extension methods for clean background task syntax
* Handle background quota expiration gracefully
* Implement save-on-pause patterns with async/await

## Why Task Services Matters

* **Data Integrity**: Complete save operations before app suspension prevents data loss
* **Network Reliability**: Finish uploads/downloads even when user switches apps
* **User Experience**: Users can background your app without losing progress
* **Graceful Degradation**: Handle quota expiration to cleanup resources properly

## Tutorial Roadmap

1. [Setup](setup.md) - Enable the feature and understand platform configuration
2. [Usage](usage.md) - Implement background task protection with async/await patterns
3. [Testing](testing.md) - Device testing checklist and validation
4. [FAQ](faq.md) - Troubleshoot common issues and platform limitations

## Key Use Cases

* **Game State Persistence**: Save player progress when app backgrounds
* **Cloud Sync**: Upload save data to cloud without interruption
* **Analytics Upload**: Complete analytics batching before suspension
* **Network Operations**: Finish API calls that started before backgrounding
* **Resource Cleanup**: Ensure proper resource disposal before termination

## Mobile App Lifecycle States

Understanding app lifecycle is critical for using Task Services effectively:

| State          | Processing        | Description                                                             |
| -------------- | ----------------- | ----------------------------------------------------------------------- |
| **Running**    | Active allocation | App is in foreground, receives full CPU and memory                      |
| **Background** | Limited           | App may receive 30 seconds (iOS) or minutes (Android) before suspension |
| **Suspended**  | Paused            | App is in memory but receives no processing time                        |
| **Terminated** | None              | App is removed from memory completely                                   |

{% hint style="warning" %}
**Lifecycle Transitions**: When a user presses the home button, the app transitions: Running → Background → Suspended. Task Services extends the **Background** phase to allow critical operations to complete.
{% endhint %}

## Prerequisites

* Unity project with Essential Kit v3 installed and Task Services feature included
* Async operations that need protection from backgrounding (save, upload, etc.)
* Understanding of C# async/await patterns

{% hint style="info" %}
**When to Use Task Services**: Use background task protection for operations that should complete even if the user switches apps—like saving game state, uploading analytics, or finishing network requests. Not required for immediate operations or simple UI updates.
{% endhint %}

{% content-ref url="setup.md" %}
[setup.md](setup.md)
{% endcontent-ref %}

{% content-ref url="usage.md" %}
[usage.md](usage.md)
{% endcontent-ref %}

{% content-ref url="testing.md" %}
[testing.md](testing.md)
{% endcontent-ref %}

{% content-ref url="faq.md" %}
[faq.md](faq.md)
{% endcontent-ref %}
