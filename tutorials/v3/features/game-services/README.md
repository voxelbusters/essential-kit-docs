---
description: >-
  Cross-platform game services integration for mobile games with player
  authentication, leaderboards, achievements, and social features
---

# 💯 Game Services

Essential Kit's Game Services feature lets Unity teams integrate Game Center (iOS) and Google Play Games (Android) without maintaining platform-specific code. This tutorial walks you through setup, authentication, leaderboards, achievements, and troubleshooting so you can add competitive social features with confidence.

{% hint style="info" %}
Looking for a working reference? Open the demo scene at `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/GameServicesDemo.unity` and the companion script at `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scripts/GameServicesDemo.cs` to see the full API in action.
{% endhint %}

## What You'll Learn

* Authenticate players with Game Center and Google Play Games seamlessly
* Submit scores to leaderboards and display competitive rankings
* Report achievement progress and show achievement UI
* Handle authentication states and error scenarios
* Access friends list for social features

## Why Game Services Matters

* **Player Retention**: Games with leaderboards see 23% higher retention rates
* **Engagement**: Achievements provide progression goals that keep players returning
* **Social Competition**: Friends integration builds community and drives session time
* **Cross-Platform**: Unified API works on both iOS Game Center and Android Play Games

## Tutorial Roadmap

1. [Setup](setup/) – Configure platform dashboards and Essential Kit settings
2. [Usage](usage.md) – Authentication, leaderboards, achievements, and social features
3. [Testing](testing.md) – Simulate in editor and verify on devices
4. [FAQ](faq.md) – Troubleshoot common issues

## Key Use Cases

* Display global leaderboards to showcase top players and drive competition
* Unlock progressive achievements to reward player milestones
* Show friend leaderboards for personalized social competition
* Integrate server authentication using server credentials for backend validation

## Prerequisites

* Unity project with Essential Kit v3 installed and Game Services feature enabled
* iOS: App configured in App Store Connect with Game Center enabled
* Android: App configured in Google Play Console with Play Games Services enabled
* Test device or Essential Kit simulator for authentication testing

{% content-ref url="setup/" %}
[setup](setup/)
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
