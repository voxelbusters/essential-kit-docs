---
description: Build friend invites and contact-driven flows by accessing players' device address books in Unity.
---

# Address Book for Unity

Essential Kit's Address Book feature lets Unity teams read device contacts, power invite-your-friends funnels, and personalise player outreach without maintaining platform-specific code. This tutorial walks you through setup, key APIs, testing, and troubleshooting so you can add contact-driven experiences with confidence.

{% hint style="info" %}
Looking for a working reference? Open the demo scene at `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/AddressBookDemo.unity` and the companion script at `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scripts/AddressBookDemo.cs` to see the full api in action.
{% endhint %}

## What You'll Learn
- Check contacts permissions and request access gracefully.
- Read and filter device contacts with Essential Kit APIs.
- Handle pagination, limited access, and common error scenarios.

## Why Address Book Matters
- Power invite-a-friend loops and referral campaigns without custom native code.
- Personalise onboarding or support flows with real contact details.
- Build social proof by highlighting friends already playing your game.

## Tutorial Roadmap
1. [Setup](setup.md) – Enable the feature and configure required assets.
2. [Usage](usage.md) – Permissions, reading contacts, filtering, and error handling.
3. [Testing](testing.md) – Simulate in editor and verify on devices.
4. [FAQ](faq.md) – Troubleshoot permission issues and empty results.

## Key Use Cases
- Launch in-game friend invite flows that send e-mail or SMS directly from verified device contacts.
- Surface customer-support shortcuts by pulling a player's own contact info into onboarding or profile screens.
- Sync high-value contacts into a CRM or referral campaign to grow retention and monetisation.

## Prerequisites
- Unity project with Essential Kit v3 installed and Address Book feature included in the build.
- iOS or Android targets with the required contacts permission usage descriptions configured (details in the setup guide below).
- Test device or the Essential Kit simulator to validate permission prompts before release.

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
