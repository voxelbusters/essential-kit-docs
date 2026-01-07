---
description: "Configuring Billing Services"
---

# Setup

## Prerequisites
- Essential Kit imported into the project from My Assets section of Package Manager
- **iOS**: App Store Connect account with Tax and Banking Information completed
- **Android**: Google Play Console account with signed APK/AAB uploaded for testing
- Product IDs created in both platform stores (use matching IDs for cross-platform consistency)

## Platform Store Setup

Before configuring Essential Kit, you must create products in your platform stores. Detailed platform-specific instructions:

{% content-ref url="ios.md" %}
[iOS Setup](ios.md)
{% endcontent-ref %}

{% content-ref url="android.md" %}
[Android Setup](android.md)
{% endcontent-ref %}

### Quick Overview

**iOS App Store Connect:**
1. Complete Tax and Banking Information
2. Create products in **Features > In-App Purchases**
3. Use unique identifiers like `com.yourgame.coins_100`
4. Set localized pricing tiers

**Google Play Console:**
1. Upload signed APK/AAB (required for testing)
2. Create products in **Monetization > In-app products**
3. Use matching IDs from iOS for consistency
4. Configure local currency pricing

{% hint style="warning" %}
Product IDs must match exactly between iOS, Android, and Essential Kit Settings. Use reverse domain notation (e.g., `com.yourgame.product_name`) for uniqueness.
{% endhint %}

## Essential Kit Configuration

### Enable Feature

Open **Essential Kit Settings** (`Window > Voxel Busters > Essential Kit > Open Settings`), switch to the **Services** tab, and enable **Billing Services**.

<figure><img src="../../../.gitbook/assets/billing-services-settings.gif" alt=""><figcaption><p>Billing Services Settings</p></figcaption></figure>

### Configuration Properties

| Setting | Platform | Required? | Notes |
| --- | --- | --- | --- |
| Enable Billing Services | All | Yes | Toggles the feature in builds; disabling strips related native code |
| Products | All | Yes | Array of product definitions with platform-specific IDs |
| Auto Finish Transactions | All | Optional | Default: true. Set to false only for server-side receipt verification (advanced) |
| Auto Handle External Product Actions | All | Optional | Default: true. If disabled, handle `BillingServices.OnExternalProductPurchaseAction` and start the purchase yourself |
| Android Public Key | Android | Yes | Base64-encoded public key from Google Play Console |

### Adding Billing Products

Click **Add Product** to create a new billing product entry:

#### Billing Product Properties

| Property | Description | Example |
| --- | --- | --- |
| Id | Unique identifier used in code | `coins_100` |
| Platform Id | Common platform ID (if same across platforms) | `com.yourgame.coins_100` |
| Platform Id Overrides | Platform-specific IDs (iOS/Android) | iOS: `com.yourgame.coins_100`<br>Android: `coins_100` |
| Product Type | Consumable / NonConsumable / Subscription | Consumable |
| Title | Display title (fallback if store fetch fails) | 100 Gold Coins |
| Description | Display description (fallback if store fetch fails) | Get 100 gold coins |
| Payouts | Metadata for currency grants (advanced) | See Multi-Currency section below |

#### Product Types

| Type | Description | Examples |
| --- | --- | --- |
| Consumable | Can be purchased multiple times | Coins, lives, power-ups |
| NonConsumable | One-time permanent purchase | Ad removal, premium features |
| Subscription | Time-bound recurring billing | VIP membership, battle pass |

#### Example Configuration

```
Product 1:
  Id: coins_100
  Type: Consumable
  iOS ID: com.yourgame.coins_100
  Android ID: com.yourgame.coins_100

Product 2:
  Id: remove_ads
  Type: NonConsumable
  iOS ID: com.yourgame.remove_ads
  Android ID: com.yourgame.remove_ads

Product 3:
  Id: vip_monthly
  Type: Subscription
  iOS ID: com.yourgame.vip_monthly
  Android ID: com.yourgame.vip_monthly
```

### Auto Finish Transactions

**Default: Enabled** - Essential Kit automatically completes transactions after the `OnTransactionStateChange` event fires.

**When to disable:**
- You need server-side receipt verification (recommended for Android apps with significant user base)
- You want manual control over when transactions are marked complete
- You're implementing custom verification flows

If disabled, you must call `BillingServices.FinishTransactions()` after granting purchased content to the user.

{% hint style="success" %}
For most games, keep Auto Finish Transactions enabled. iOS uses StoreKit2 with built-in local verification. Only disable for advanced server verification scenarios.
{% endhint %}

### Multi-Currency Systems (Advanced)

Use payouts to grant multiple virtual currencies from a single purchase:

```
Product: mega_pack
Payouts:
  - Type: coins, Quantity: 500
  - Type: gems, Quantity: 100
  - Type: tickets, Quantity: 25
```

In your code, process payouts when granting content:

```csharp
var product = BillingServices.GetProductWithId("mega_pack");
foreach (var payout in product.Payouts)
{
    switch (payout.Variant)
    {
        case "coins": PlayerData.AddCoins(payout.Quantity); break;
        case "gems": PlayerData.AddGems(payout.Quantity); break;
        case "tickets": PlayerData.AddTickets(payout.Quantity); break;
    }
}
```

### Android Public Key

For Android builds, you must add your app's Base64-encoded public key:

1. Open Google Play Console
2. Navigate to **Monetization Setup > Licensing**
3. Copy the **Base64-encoded RSA public key**
4. Paste into **Android Properties > Public Key** in Essential Kit Settings

{% hint style="info" %}
Changes to the settings asset are saved automatically. If you use source control, commit the updated `Resources/EssentialKitSettings.asset` file.
{% endhint %}

## Verification

Before proceeding to usage:

1. Verify all product IDs match exactly between platform stores and Essential Kit Settings
2. Confirm product types (Consumable/NonConsumable/Subscription) are correct
3. Test the demo scene (`BillingServicesDemo.unity`) to confirm basic configuration works
4. Check that products are approved and active in App Store Connect and Google Play Console

{% hint style="info" %}
Need a working baseline? Run the sample at `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/BillingServicesDemo.unity` to confirm your settings before wiring the feature into production screens.
{% endhint %}
