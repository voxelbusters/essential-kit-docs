---
description: >-
  Deep Link Services for Unity mobile games - handle custom URL schemes and
  universal links to drive user engagement and retention
---

# 🔗 Deep Link Services

Essential Kit's Deep Link Services feature lets Unity teams handle custom URL schemes and universal links without maintaining platform-specific code. This tutorial walks you through setup, key APIs, testing, and troubleshooting so you can add seamless deep linking with confidence.

{% hint style="info" %}
Using PlayMaker? See the PlayMaker guide: [PlayMaker](playmaker/README.md).
{% endhint %}

{% hint style="info" %}
Looking for a working reference? Open the demo scene at `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/DeepLinkServicesDemo.unity` and the companion script at `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scripts/DeepLinkServicesDemo.cs` to see the full API in action.
{% endhint %}

## What You'll Learn

* Register for deep link events and handle incoming links
* Navigate users directly to specific in-game content
* Implement URL schemes for simple deep linking
* Configure universal links for professional user acquisition

## Why Deep Link Services Matter

* **User Acquisition**: Power friend invites and referral campaigns with trackable links
* **Retention**: Bring players back to specific events, tournaments, or limited offers
* **Seamless UX**: Take users directly to content instead of forcing them to navigate manually

## Tutorial Roadmap

1. [Setup](setup/) – Enable the feature and configure URL schemes and universal links
2. [Usage](usage.md) – Event registration, link handling, and navigation patterns
3. [Testing](testing.md) – Test deep links in editor and verify on devices
4. [FAQ](faq.md) – Troubleshoot common issues

## Key Use Cases

* **Friend Invitations**: Send 1v1 match invites that open directly to the match lobby
* **Promotional Campaigns**: Deep link from social media ads to specific shop offers
* **Tournament Entry**: Share tournament links that auto-join players when clicked
* **Content Sharing**: Let players share levels, achievements, or game moments
* **Re-engagement**: Send push notifications with deep links to bring players back

## Prerequisites

* Unity project with Essential Kit v3 installed and Deep Link Services feature included in the build
* iOS or Android target platform
* Test device or Essential Kit simulator to validate deep link handling

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
