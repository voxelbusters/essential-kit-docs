---
description: "Cross-platform cloud save and sync for Unity mobile games using iCloud and Google Play"
---

# Cloud Services for Unity

Essential Kit's Cloud Services feature lets Unity teams sync player data across devices without maintaining platform-specific code. This tutorial walks you through setup, key APIs, testing, and troubleshooting so you can add cloud save functionality with confidence.

{% hint style="info" %}
Looking for a working reference? Open the demo scene at `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/CloudServicesDemo.unity` and the companion script at `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scripts/CloudServicesDemo.cs` to see the full API in action.
{% endhint %}

## What You'll Learn
- Store and retrieve game data using simple key-value pairs
- Sync player progress across devices with automatic conflict detection
- Handle cross-device data consistency with change events
- Choose between local-only storage and cloud synchronization

## Why Cloud Services Matters
- **Player retention**: Let players seamlessly continue progress on any device
- **Cross-device experience**: Single game state across phone, tablet, and reinstalls
- **Simple data persistence**: Replace PlayerPrefs with cloud-backed storage
- **No backend required**: Built on free platform services (iCloud, Google Play)

## Tutorial Roadmap
1. [Setup](setup/) - Enable the feature and configure platform settings.
2. [Usage](usage.md) - Store data, sync with cloud, and handle conflicts.
3. [Testing](testing.md) - Verify cloud sync across devices and reinstalls.
4. [FAQ](faq.md) - Troubleshoot common issues and limitations.

## Key Use Cases
- **Save player progress**: Store game state, achievements, and unlocked content (within 1MB iOS / 3MB Android limits)
- **Cross-device sync**: Let players switch between devices without losing progress
- **Offline-first storage**: Use as enhanced PlayerPrefs that works locally without cloud sync
- **Conflict resolution**: Automatically detect and resolve data conflicts from simultaneous device usage

## Prerequisites
- Unity project with Essential Kit v3 installed and Cloud Services feature enabled
- iOS builds require iCloud capability configuration (handled automatically during build)
- Android builds require Google Play Services integration (handled automatically during build)
- Test devices with active iCloud (iOS) or Google Play account (Android) for cloud sync validation

{% content-ref url="setup/" %}
[Setup](setup/)
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
