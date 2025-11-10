---
description: "Boost app ratings with smart, native review prompts that respect platform limits and user experience"
---

# Rate My App for Unity

Essential Kit's Rate My App feature lets Unity teams prompt players for app reviews using native store dialogs without maintaining platform-specific code. This tutorial walks you through setup, key APIs, testing, and troubleshooting so you can boost ratings with confidence.

{% hint style="info" %}
Looking for a working reference? Open the demo scene at `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/RateMyAppDemo.unity` and the companion script at `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scripts/RateMyAppDemo.cs` to see the full API in action.
{% endhint %}

## What You'll Learn
- Request app reviews at the right moment with conditional prompting
- Configure smart timing constraints to avoid annoying users
- Handle platform review quotas (iOS 3x/year limit, Android restrictions)
- Use confirmation dialogs to protect against quota waste

## Why Rate My App Matters
- **Business impact**: Higher ratings improve app store visibility and conversion rates
- **UX impact**: Native dialogs feel integrated and trustworthy to users
- **Technical impact**: No custom native code needed - works on iOS and Android

## Tutorial Roadmap
1. [Setup](setup.md) - Enable the feature and configure rating constraints
2. [Usage](usage.md) - Auto-show vs manual prompts, confirmation dialogs, and timing
3. [Testing](testing.md) - Simulate in editor and verify on devices
4. [FAQ](faq.md) - Troubleshoot common issues

## Key Use Cases
- Show rating prompt after major achievements or level completions
- Request reviews when users demonstrate positive engagement patterns
- Protect review quota with optional confirmation dialogs before native prompts
- Re-prompt for ratings when new versions ship

## Prerequisites
- Unity project with Essential Kit v3 installed and Rate My App feature included in the build
- iOS or Android targets with app store IDs configured in Essential Kit Settings
- Understanding of platform review quotas (iOS: 3x/year max, Android: limited but undisclosed)

{% embed url="https://www.youtube.com/watch?v=2V2MMUdmb4o" %}
Rate App Video Tutorial
{% endembed %}

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
