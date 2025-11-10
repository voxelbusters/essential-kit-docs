---
description: "Keep players engaged with cross-platform local and push notifications for Unity mobile games"
---

# Notification Services for Unity

Essential Kit's Notification Services feature lets Unity teams schedule local notifications and deliver push notifications without maintaining platform-specific code. This tutorial walks you through setup, permission handling, notification scheduling, and testing so you can bring players back to your game with timely, relevant notifications.

{% hint style="info" %}
Looking for a working reference? Open the demo scene at `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/NotificationServicesDemo.unity` and the companion script at `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scripts/NotificationServicesDemo.cs` to see the full API in action.
{% endhint %}

## What You'll Learn
- Request notification permissions and handle user consent gracefully
- Schedule local notifications with time-based and calendar triggers for game timers and daily rewards
- Implement push notifications for server-driven real-time messaging
- Handle notification interactions and manage app badge numbers
- Test notification flows in editor simulator and on devices

## Why Notification Services Matter
- **Player retention**: Remind players about energy refills, daily rewards, and time-limited events
- **Re-engagement**: Bring inactive players back with contextual notifications at optimal times
- **Live operations**: Send real-time updates about tournaments, special offers, and community events
- **Cross-platform**: Single API works across iOS (APNS) and Android (FCM) automatically

## Tutorial Roadmap
1. [Setup](setup.md) - Enable the feature and configure platform-specific requirements
2. [Usage](usage.md) - Permissions, local notifications, push notifications, and event handling
3. [Testing](testing.md) - Simulate in editor and verify on devices
4. [FAQ](faq.md) - Troubleshoot common issues

## Key Use Cases
- **Energy systems**: Schedule notifications when energy refills so players return when they can play
- **Daily rewards**: Send reminders at optimal times to encourage daily login habits
- **Event announcements**: Notify players about limited-time tournaments and special offers
- **Social interactions**: Alert players about friend requests, guild invitations, and multiplayer challenges
- **Server-driven content**: Push real-time announcements for flash sales and surprise events

## Prerequisites
- Unity project with Essential Kit v3 installed and NotificationServices feature included in the build
- iOS or Android target platforms with notification permission descriptions configured
- For push notifications: Server infrastructure or third-party service (Firebase, OneSignal) to send messages
- Test devices to validate permission prompts and notification delivery before release

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
