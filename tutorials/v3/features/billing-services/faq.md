# FAQ & Troubleshooting

{% hint style="success" %}
If you haven't tried [**Essential Kit**](https://link.voxelbusters.com/essential-kit) yet, now's the perfect time! Our plugin simplifies **in-app purchases** with support for **Consumables, Non-Consumables, Subscriptions (with multiple offers), and Store Promotions**—all through a **unified API** for **iOS and Android**.

And the best part? **No analytics, no tracking—just a privacy-focused solution built for game developers.** 🚀 [Give it a try today](https://link.voxelbusters.com/essential-kit)!
{% endhint %}

## Why does InitializeStore return an empty product list?

This usually happens for two reasons:
- No billing products configured in Essential Kit Settings
- Platform-specific store issues

### iOS Issues

| Issue | Solution |
| --- | --- |
| Pending Agreements, Tax, or Banking information | Complete all required information in App Store Connect |
| Latest Apple Developer Program License Agreement not accepted | Accept the agreement in App Store Connect |
| Paid Agreements not in Active status | Ensure status shows as "Active" |

### Android Issues

| Issue | Solution |
| --- | --- |
| Wrong package name or version code | Ensure APK package name and version match Google Play Console |
| Tester account not opted in | Use the opt-in testing track link to become a valid tester |
| App not uploaded to testing track | Upload signed APK/AAB to Internal or Closed Testing |

## Why does InitializeStore return products out of order?

Products can be marked as inactive or deleted after your app is released. If we ordered products by array index, deleting a product in the store console would break older app versions.

**Recommended approach:**
```csharp
// Always use GetProductWithId, never array index
var product = BillingServices.GetProductWithId("coins_100");
```

This ensures your code works regardless of product ordering changes.

## On Android, why do purchases from one account appear when logged in with a different account?

This is standard Android behavior. Purchases on Android are linked to the account that **installs the app**, not the account logged into the Google Play app.

To restore a different account's purchases, uninstall and reinstall the app while logged in with the new account.

## Are testers charged for testing?

**iOS:**
- Sandbox testers: Never charged
- TestFlight users: IAP offered free by default, no sandbox account needed

**Android:**
- Normal testers (opt-in via test track): Charged but refunded within 14 days
- License testers: Never charged

## How do I implement receipt verification with Appodeal?

```csharp
IBillingTransaction transaction; // From OnTransactionStateChange

var rawData = (IDictionary)ExternalServiceProvider.JsonServiceProvider.FromJson(transaction.RawData);
var originalTransaction = rawData?["transaction"] as string;
var signature = rawData?["signature"] as string;

#if UNITY_ANDROID
var purchase = new PlayStoreInAppPurchase.Builder(
    transaction.Product.Type == BillingProductType.Subscription
        ? PlayStorePurchaseType.Subs
        : PlayStorePurchaseType.InApp)
    .WithPurchaseTimestamp(new DateTimeOffset(transaction.DateUTC).ToUnixTimeSeconds())
    .WithPurchaseToken(transaction.Receipt)
    .WithPurchaseData(originalTransaction)
    .WithPublicKey(BillingServices.UnitySettings.AndroidProperties.PublicKey)
    .WithSignature(signature)
    .WithCurrency(transaction.Product.Price.Code)
    .WithOrderId(transaction.Id)
    .WithPrice($"{transaction.Product.Price.Value}")
    .WithSku(transaction.Product.PlatformId)
    .Build();

Appodeal.ValidatePlayStoreInAppPurchase(purchase, this);

#elif UNITY_IOS
var purchaseType = transaction.Product.Type == BillingProductType.Subscription
    ? AppStorePurchaseType.AutoRenewableSubscription
    : transaction.Product.Type == BillingProductType.Consumable
        ? AppStorePurchaseType.Consumable
        : AppStorePurchaseType.NonConsumable;

var purchase = new AppStoreInAppPurchase.Builder(purchaseType)
    .WithTransactionId(transaction.Id)
    .WithProductId(transaction.Product.PlatformId)
    .WithCurrency(transaction.Product.Price.Code)
    .WithPrice($"{transaction.Product.Price.Value}")
    .Build();

Appodeal.ValidateAppStoreInAppPurchase(purchase, this);
#endif
```

## Why does IsProductPurchased always return false for consumables?

This is expected behavior. `IsProductPurchased()` only works for **non-consumable products and subscriptions**. Consumable products can be purchased multiple times, so there's no permanent ownership state to check.

## When should I disable Auto Finish Transactions?

Only disable Auto Finish Transactions if you need server-side receipt verification, typically for:
- Android apps with significant user base (Google recommends server verification)
- High-value purchases requiring additional fraud prevention
- Custom verification flows with your backend

For most games, keep it enabled. iOS uses StoreKit2 with built-in local verification.

## My purchases work in sandbox but fail in production. Why?

Common causes:
- Product not approved or active in production store
- App Store Connect / Google Play Console agreements not signed
- Tax and banking information incomplete
- Product ID mismatch between sandbox and production configurations

Verify all store setup steps are complete and products are live in production.

## How do I handle multiple virtual currencies?

Use the `Payouts` property in product definitions:

```csharp
void ConfigureAndGrantMultiCurrencyProduct()
{
    // In Essential Kit Settings or runtime configuration
    var productDef = new BillingProductDefinition(
        id: "mega_pack",
        platformId: "mega_pack",
        productType: BillingProductType.Consumable,
        payouts: new[]
        {
            new BillingProductPayoutDefinition(BillingProductPayoutCategory.Currency, subtype: "coins", quantity: 500),
            new BillingProductPayoutDefinition(BillingProductPayoutCategory.Currency, subtype: "gems", quantity: 100),
        });

    // In your grant content code
    var product = BillingServices.GetProductWithId("mega_pack");
    foreach (var payout in product.Payouts)
    {
        switch (payout.Variant)
        {
            case "coins": PlayerData.AddCoins(payout.Quantity); break;
            case "gems": PlayerData.AddGems(payout.Quantity); break;
        }
    }
}
```

## What's the difference between forceRefresh true and false in RestorePurchases?

**forceRefresh: true**
- Shows interactive login dialog on iOS
- Contacts server for latest purchase data
- Use for user-triggered "Restore Purchases" button

**forceRefresh: false**
- Silent restore without dialogs
- Uses cached data
- Use for automatic restore on app startup

## Where can I confirm plugin behavior versus my implementation?

Run the demo scene at `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/BillingServicesDemo.unity`.

If the sample works but your scene does not, compare:
- Product ID configuration in settings
- Event subscription timing (subscribe in `OnEnable`, unsubscribe in `OnDisable`)
- Error handling in transaction callbacks
- Transaction finishing logic if Auto Finish is disabled

## How do I implement season passes or time-limited products?

Use non-consumable products with custom time tracking:

```csharp
void CheckSeasonPassAccess()
{
    string currentSeasonId = "season_pass_2024_q1";

    if (BillingServices.IsProductPurchased(currentSeasonId))
    {
        if (IsSeasonActive(currentSeasonId))
        {
            Debug.Log("Grant season pass rewards to the player.");
        }
    }
}

bool IsSeasonActive(string seasonId)
{
    DateTime now = DateTime.Now;
    DateTime seasonStart = new DateTime(2024, 1, 1);
    DateTime seasonEnd = new DateTime(2024, 3, 31);
    return now >= seasonStart && now <= seasonEnd;
}
```

Each season should have a unique product ID to prevent conflicts.

## Can I change product prices after release?

Yes. Change prices in App Store Connect and Google Play Console at any time. New prices appear in `product.Price.LocalizedText` after `InitializeStore()` completes. Players who already purchased keep their access at the old price.

## My transactions stay in pending state. What's wrong?

If you disabled Auto Finish Transactions, you must manually call:
```csharp
BillingServices.FinishTransactions(new[] { transaction });
```

Call this after granting purchased content. Transactions in `Purchasing` or `Deferred` state cannot be finished until they complete.

## How do I test subscription renewals and expirations?

**iOS sandbox:**
- Subscriptions renew every few minutes instead of monthly/yearly
- Fast testing of renewal flows

**Android testing:**
- Use Google Play's test card for subscription testing
- Inspect the transaction's `SubscriptionStatus` when processing subscription purchases

Note: Subscription properties may have limited data on Android.

## How does Essential Kit track Non-Consumable/Subscription purchases?

For details on how Essential Kit maintains purchase states across platforms, see:

{% content-ref url="notes/how-non-consumable-and-subscription-product-statuses-are-maintained.md" %}
[How Non-Consumable and Subscription Product Statuses Are Maintained](notes/how-non-consumable-and-subscription-product-statuses-are-maintained.md)
{% endcontent-ref %}
