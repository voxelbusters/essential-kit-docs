---
description: "Address Book unlocks contact-powered social features for Unity games without custom native plugins"
---

# Address Book for Unity

Essential Kit's Address Book feature lets Unity teams read device contacts, detect friends already playing, and power invite flows without maintaining platform-specific code. This tutorial covers setup, permissions, core APIs, testing, and troubleshooting so you can safely build contact-powered experiences.

{% embed url="https://www.youtube.com/watch?v=Tv85rRIYY_4" %}
Address Book Video Tutorial
{% endembed %}

{% hint style="info" %}
Looking for a working reference? Open the demo scene at `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/AddressBookDemo.unity` and the companion script at `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scripts/AddressBookDemo.cs` to see the full API in action.
{% endhint %}

## What You'll Learn
- Request contacts access with a custom rationale screen and handle every permission state
- Read and filter contacts with `ReadContactsOptions` plus pagination for large address books
- Load contact properties (names, numbers, emails, thumbnails) and recover when access is denied

## Why Address Book Matters
- **Social Growth**: Find friends already playing and drive invite-a-friend loops or referral rewards
- **Faster UX**: Autofill player names, email fields, or support forms directly from saved contacts
- **Cross-Platform**: One API spans iOS Contacts and Android Contacts Provider, including limited access states

## Tutorial Roadmap
1. [Setup](setup.md) – Enable the feature, configure permissions, and assign placeholder assets
2. [Usage](usage.md) – Handle permission prompts, read contacts, filter data, and load images
3. [Testing](testing.md) – Validate behaviour in the simulator and on real devices
4. [FAQ](faq.md) – Troubleshoot permissions, pagination, and missing data

## Key Use Cases
- Detect friends already playing and light up invite buttons in onboarding
- Trigger referral rewards when a player texts or emails selected contacts
- Show contact pickers inside support flows to auto-fill recipient details
- Populate co-op lobbies with verified phone numbers or emails for quick invites

## Prerequisites
- Unity project with Essential Kit v3 installed and Address Book enabled in Essential Kit Settings
- iOS targets require a clear `NSContactsUsageDescription` explaining why contacts are needed
- Android targets rely on system-managed permission prompts; plan supporting UI copy in-game
- Test devices (or the Essential Kit simulator) to validate permission flows before release

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
