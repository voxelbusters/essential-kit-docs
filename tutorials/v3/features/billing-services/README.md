---
description: >-
  Cross-platform in-app purchase system for Unity mobile games with consumables,
  non-consumables, subscriptions, and transaction management
---

# 💲 Billing Services

Essential Kit's Billing Services feature lets Unity teams monetize mobile games with in-app purchases without maintaining platform-specific code. This tutorial walks you through setup, key APIs, testing, and troubleshooting so you can add consumables, non-consumables, and subscriptions with confidence.

{% embed url="https://www.youtube.com/watch?v=s1r2wpeIxjU" %}
Billing Services Video Tutorial
{% endembed %}

{% hint style="info" %}
Looking for a working reference? Open the demo scene at `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/BillingServicesDemo.unity` and the companion script at `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scripts/BillingServicesDemo.cs` to see the full API in action.
{% endhint %}

## What You'll Learn

* Configure products in Essential Kit Settings and platform stores (App Store Connect, Google Play Console)
* Initialize the store connection and retrieve localized product pricing
* Purchase products and handle transaction states (success, failure, deferred, restored)
* Restore purchases for non-consumables and subscriptions
* Finish transactions and manage pending purchases (advanced server verification)

## Why Billing Services Matters

* **Revenue Generation**: Primary monetization driver for mobile games with secure, native purchase flows
* **Cross-Platform Consistency**: Single API works across iOS App Store and Google Play Store
* **Security Built-In**: Local receipt verification on iOS (StoreKit2), optional server verification for Android
* **App Store Compliance**: Automatic platform setup with restore functionality required by Apple guidelines

## Tutorial Roadmap

1. [Setup](setup/) - Configure products in Essential Kit Settings and platform stores
2. [Usage](usage.md) - Initialize store, purchase products, restore purchases, handle transactions
3. [Testing](testing/) - Test with sandbox accounts and validate on devices
4. [FAQ](faq.md) - Troubleshoot common purchase and configuration issues

## Key Use Cases

### Sell Virtual Goods

Use consumable products to sell in-game items like coins, gems, lives, or power-ups that players can purchase repeatedly. Offer multiple value tiers ($0.99, $4.99, $9.99) to maximize revenue across different player segments.

### Premium Upgrades

Sell permanent features with non-consumable products like ad removal, character unlocks, or premium level packs. Once purchased, these items are owned forever and automatically restored across devices.

### Subscriptions

Implement VIP memberships, battle passes, or season passes with recurring billing. Offer flexible durations (weekly, monthly, yearly) with introductory offers and free trials to increase conversion.

### Multi-Currency Systems

Support multiple virtual currencies (coins, gems, tickets) using payout definitions. A single purchase can grant multiple currency types for complex economy systems.

### Remove Ads

Offer an ad-free experience with a non-consumable product. Use `IsProductPurchased()` to check ownership status and hide ads permanently for paying users.

## Prerequisites

* Unity project with Essential Kit v3 installed and Billing Services feature included in the build
* **iOS**: App Store Connect account with products configured and banking information complete
* **Android**: Google Play Console account with products configured and app uploaded for testing
* Test device or sandbox accounts to validate purchases before release

{% content-ref url="setup/" %}
[setup](setup/)
{% endcontent-ref %}

{% content-ref url="usage.md" %}
[usage.md](usage.md)
{% endcontent-ref %}

{% content-ref url="testing/" %}
[testing](testing/)
{% endcontent-ref %}

{% content-ref url="faq.md" %}
[faq.md](faq.md)
{% endcontent-ref %}
