---
description: Cross-platform network connectivity monitoring for Unity mobile games
icon: wifi-slash
---

# Network Services

Essential Kit's Network Services feature lets Unity teams monitor network connectivity and server reachability without maintaining platform-specific code. This tutorial walks you through setup, monitoring APIs, testing, and troubleshooting so you can build offline-first experiences and gracefully handle connectivity changes.

{% hint style="info" %}
Using PlayMaker? See the PlayMaker guide: [PlayMaker](playmaker/README.md).
{% endhint %}

{% embed url="https://www.youtube.com/watch?v=FNYw6eLPK0s" %}
Network Services Video Tutorial
{% endembed %}

{% hint style="info" %}
Looking for a working reference? Open the demo scene at `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/NetworkServicesDemo.unity` and the companion script at `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scripts/NetworkServicesDemo.cs` to see the full API in action.
{% endhint %}

## What You'll Learn

* Monitor internet connectivity status with real-time change detection
* Check specific server reachability for backend availability
* Handle offline scenarios gracefully with proper UI feedback
* Optimize battery usage by controlling when monitoring is active

## Why Network Services Matters

* **Better UX**: Inform users about offline status before they attempt network operations
* **Offline-First Design**: Build features that work offline and sync when connectivity returns
* **Server Monitoring**: Detect when your backend is unreachable separately from general internet status
* **Battery Conscious**: Start/stop monitoring to conserve battery when network status isn't needed

## Tutorial Roadmap

1. [Setup](setup.md) - Enable the feature and configure monitoring options
2. [Usage](usage.md) - Monitor connectivity, handle status changes, check reachability
3. [Testing](testing.md) - Simulate network changes and verify on devices
4. [FAQ](faq.md) - Troubleshoot common issues

## Key Use Cases

* **Multiplayer Games**: Block matchmaking when offline, queue actions for when connectivity returns
* **Live Events**: Disable event features when server is unreachable
* **Content Downloads**: Pause downloads when offline, resume when connectivity returns
* **Social Features**: Show offline indicator for leaderboards, friends, and chat

## Prerequisites

* Unity project with Essential Kit v3 installed and Network Services feature included
* iOS or Android target (no special permissions required)
* Test environment with ability to toggle network connectivity

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
