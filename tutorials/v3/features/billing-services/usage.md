---
description: Billing Services allows cross-platform in-app purchases on mobile devices
---

# Usage

Essential Kit wraps native iOS StoreKit and Android Google Play Billing APIs into a single Unity interface. Essential Kit automatically initializes Billing Services - you just need to connect to the store and start making purchases.

## Table of Contents

* [Understanding Product Types](usage.md#understanding-product-types)
* [Import Namespaces](usage.md#import-namespaces)
* [Event Registration](usage.md#event-registration)
* [Store Initialization](usage.md#store-initialization)
* [Making Purchases](usage.md#making-purchases)
* [Restoring Purchases](usage.md#restoring-purchases)
* [Subscriptions](usage.md#subscriptions)
* [Core APIs Reference](usage.md#core-apis-reference)
* [Advanced: Manual Transaction Finishing](usage.md#advanced-manual-transaction-finishing)
* [Advanced: Runtime Product Configuration](usage.md#advanced-runtime-product-configuration)
* [Error Handling](usage.md#error-handling)
* [Related Guides](usage.md#related-guides)

## Understanding Product Types

Before diving into implementation, it's important to understand the three types of in-app purchase products:

### Consumable Products

Items that can be purchased multiple times and are "consumed" after use. When a player buys a consumable product, they receive the content, use it, and can purchase it again.

**Examples:**

* 100 gold coins pack
* 5 extra lives
* Health potions
* Ammo packs

**Key characteristics:**

* Can be purchased repeatedly
* Not restored across devices
* `IsProductPurchased()` always returns false (no permanent ownership)

### Non-Consumable Products

Permanent purchases that unlock content or features forever. Once purchased, the player owns it permanently across all their devices.

**Examples:**

* Remove all ads
* Premium features unlock
* Character unlocks
* Level pack access

**Key characteristics:**

* Can only be purchased once
* Automatically restored on new devices
* `IsProductPurchased()` returns true after purchase
* Must provide a "Restore Purchases" button (iOS requirement)

### Subscription Products

Time-bound purchases that provide benefits for a specific period (week, month, year). Subscriptions automatically renew until cancelled by the user.

**Examples:**

* VIP membership (monthly)
* Battle pass (seasonal)
* Premium subscription (yearly)
* Ad-free experience (weekly)

**Key characteristics:**

* Recurring billing until cancelled
* Time-limited access
* Automatically restored on new devices
* `IsProductPurchased()` returns true while subscription is active
* Can include promotional offers (free trial, introductory pricing)

## Import Namespaces

```csharp
using System;
using System.Collections;
using System.Collections.Generic;
using VoxelBusters.EssentialKit;
using VoxelBusters.CoreLibrary;
```

## Event Registration

Register for billing events in `OnEnable` and unregister in `OnDisable`:

```csharp
void OnEnable()
{
    BillingServices.OnInitializeStoreComplete += OnStoreInitialized;
    BillingServices.OnTransactionStateChange += OnTransactionStateChanged;
    BillingServices.OnRestorePurchasesComplete += OnRestoreComplete;
}

void OnDisable()
{
    BillingServices.OnInitializeStoreComplete -= OnStoreInitialized;
    BillingServices.OnTransactionStateChange -= OnTransactionStateChanged;
    BillingServices.OnRestorePurchasesComplete -= OnRestoreComplete;
}
```

| Event                        | Trigger                                               |
| ---------------------------- | ----------------------------------------------------- |
| `OnInitializeStoreComplete`  | After `InitializeStore()` fetches product details     |
| `OnTransactionStateChange`   | When transaction state changes during purchase        |
| `OnRestorePurchasesComplete` | After `RestorePurchases()` fetches previous purchases |

## Store Initialization

### Why Store Initialization is Needed

Product details like pricing, descriptions, and availability are managed in App Store Connect (iOS) and Google Play Console (Android). These details can change at any time - you might update prices, add new products, or modify descriptions without releasing a new app version.

Store initialization connects to the platform stores and fetches the current, localized product information. This ensures:

* Players see accurate prices in their local currency
* Product titles and descriptions match what you configured in store consoles
* Only active/available products are shown
* Pricing changes take effect immediately without app updates

### Implementation

Before accepting purchases, connect to platform stores to retrieve current product pricing and availability.

```csharp
void Start()
{
    BillingServices.InitializeStore();
    Debug.Log("Initializing store...");
}

void OnStoreInitialized(BillingServicesInitializeStoreResult result, Error error)
{
    if (error != null)
    {
        Debug.LogError($"Store init failed: {error.Description}");
        return;
    }

    Debug.Log($"Store ready with {result.Products.Length} products");

    foreach (var product in result.Products)
    {
        Debug.Log($"{product.LocalizedTitle} - {product.Price.LocalizedText}");
    }
}
```

`InitializeStore()` uses products configured in Essential Kit Settings and retrieves localized pricing from stores. This may take several seconds depending on network conditions.

{% hint style="success" %}
Display a loading indicator while initializing. Once complete, show products in your store UI using `product.Price.LocalizedText` for accurate, localized pricing.
{% endhint %}

{% hint style="warning" %}
Store initialization can fail if products are not properly configured in App Store Connect or Google Play Console. See [FAQ](faq.md#why-does-initializestore-return-an-empty-product-list) for common initialization issues and solutions.
{% endhint %}

{% hint style="danger" %}
Products returned in `result.Products` may not match the order you configured in settings. Always use `GetProductWithId()` to retrieve specific products by ID, never by array index.
{% endhint %}

### Getting Product Details

After initialization, retrieve product information to display in your store:

```csharp
void DisplayProduct(string productId)
{
    var product = BillingServices.GetProductWithId(productId);

    if (product == null)
    {
        Debug.LogWarning($"Product {productId} not found");
        return;
    }

    Debug.Log($"Title: {product.LocalizedTitle}");
    Debug.Log($"Description: {product.LocalizedDescription}");
    Debug.Log($"Price: {product.Price.LocalizedText}");
}
```

## Making Purchases

{% hint style="info" %}
Before implementing purchases, ensure you've completed the [platform store setup](setup/ios.md) for iOS and [Android configuration](setup/android.md). Products must be active in store consoles before they can be purchased.
{% endhint %}

### Purchase Flow

Call `BuyProduct()` to initiate a purchase. Essential Kit handles the platform purchase UI automatically.

```csharp
public void OnBuyButtonClicked(string productId)
{
    if (!BillingServices.CanMakePayments())
    {
        Debug.LogWarning("Purchases not available");
        return;
    }

    var product = BillingServices.GetProductWithId(productId);
    if (product == null)
    {
        Debug.LogError($"Product {productId} not found");
        return;
    }

    BillingServices.BuyProduct(product);
    Debug.Log("Purchase initiated...");
}
```

{% hint style="warning" %}
`CanMakePayments()` returns false when purchases are restricted by parental controls or device settings. Always check this before showing purchase UI to avoid confusing users with buttons that won't work.
{% endhint %}

```csharp
void OnTransactionStateChanged(BillingServicesTransactionStateChangeResult result)
{
    foreach (var transaction in result.Transactions)
    {
        Debug.Log($"Transaction {transaction.Product.Id}: {transaction.TransactionState} / {transaction.ReceiptVerificationState}");

        if (transaction.TransactionState == BillingTransactionState.Purchased &&
            transaction.ReceiptVerificationState == BillingReceiptVerificationState.Success)
        {
            Debug.Log($"Grant content for {transaction.Product.Id}");
        }
        else if (transaction.TransactionState == BillingTransactionState.Purchased)
        {
            Debug.LogWarning("Purchase verification failed; skip content grant");
        }
        else if (transaction.TransactionState == BillingTransactionState.Failed)
        {
            Debug.Log($"Purchase failed: {transaction.Error?.Description}");
        }
        else if (transaction.TransactionState == BillingTransactionState.Deferred)
        {
            Debug.Log("Purchase pending approval");
        }
    }
}
```

Always evaluate both `TransactionState` and `ReceiptVerificationState` before granting rewards. Essential Kit performs local verification automatically, and any remote verification workflow should update the verification state before finishing the transaction.

### Transaction States

During a purchase, the transaction goes through different states. Understanding these states helps you handle all scenarios properly:

| State       | Meaning                                                   | Action                                               |
| ----------- | --------------------------------------------------------- | ---------------------------------------------------- |
| `Purchased` | Transaction completed successfully - user paid            | Grant content immediately, save player data          |
| `Failed`    | Transaction failed or user cancelled                      | Show error only if not user cancellation             |
| `Deferred`  | Waiting for approval (e.g., parental control, Ask to Buy) | Inform user to wait, transaction will complete later |

**Purchased vs Restored:**

Use the restore flow (`BillingServices.RestorePurchases`) to handle past purchases. Restored items come back as `Purchased` transactions in the restore callback; there is no `Restored` transaction state to check in code.

**Deferred State:** When "Ask to Buy" is enabled (common for child accounts), the purchase request goes to a parent for approval. The transaction enters `Deferred` state until approved or rejected. Handle this gracefully by informing the user their purchase is pending approval.

{% hint style="success" %}
Always save player data immediately after granting purchased content. If the app crashes before saving, the transaction is already finished and won't be delivered again.
{% endhint %}

### Checking Purchase Status

For non-consumables and subscriptions, check if already purchased:

```csharp
void CheckAdRemovalStatus()
{
    if (BillingServices.IsProductPurchased("remove_ads"))
    {
        Debug.Log("User owns ad removal; disable ads here");
    }
}
```

{% hint style="info" %}
`IsProductPurchased()` only works for non-consumable products and subscriptions. It always returns false for consumable products.
{% endhint %}

### Purchase Options

For advanced scenarios, use `BuyProductOptions`:

Essential Kit expects the optional `Tag` to be a UUID v4 string so it can be relayed safely through native stores. Generate it with `Guid.NewGuid()` if you need to correlate purchases on your backend.

```csharp
var options = new BuyProductOptions.Builder()
    .SetQuantity(5)  // iOS only, Android shows quantity selector
    .SetTag(Guid.NewGuid().ToString())  // Must be UUID v4 when tagging purchases
    .Build();

BillingServices.BuyProduct(product, options);
```

## Restoring Purchases

### What is Purchase Restoration?

Purchase restoration allows users to regain access to their non-consumable products and active subscriptions without paying again. This is essential when users:

* Install your game on a new device
* Reinstall the game after deleting it
* Switch to a different device (phone to tablet)
* Lose their game data

**Important:** Only non-consumable products and subscriptions can be restored. Consumable products (like coins or lives) are not restored because they're meant to be used up and purchased again.

### Why Restore is Required

Apple requires all apps with non-consumable products or subscriptions to provide a visible "Restore Purchases" button. This ensures users can always access content they've already paid for, even after reinstalling or switching devices.

### Implementation

Restore previous purchases for non-consumables and subscriptions. Required for iOS compliance.

```csharp
public void OnRestoreButtonClicked()
{
    BillingServices.RestorePurchases(forceRefresh: true);
    Debug.Log("Restoring purchases...");
}

void OnRestoreComplete(BillingServicesRestorePurchasesResult result, Error error)
{
    if (error != null)
    {
        Debug.LogError($"Restore failed: {error.Description}");
        return;
    }

    Debug.Log($"Restored {result.Transactions.Length} purchases");

    foreach (var transaction in result.Transactions)
    {
        Debug.Log($"Grant content for restored product {transaction.Product.Id}");
    }
}
```

{% hint style="warning" %}
iOS requires a "Restore Purchases" button for all apps with non-consumable products or subscriptions per App Store guidelines.
{% endhint %}

### Force Refresh vs Silent Restore

```csharp
// User-triggered restore button - may show login prompt on iOS
BillingServices.RestorePurchases(forceRefresh: true);

// Silent restore on app start - no login prompt
BillingServices.RestorePurchases(forceRefresh: false);
```

**forceRefresh: true** - Shows interactive login on iOS, contacts server for latest data. Use for explicit user "Restore" button.

**forceRefresh: false** - Silent restore without dialogs. Use for automatic restore on app startup.

## Subscriptions

Subscriptions work like other products but include additional time-based information.

### Subscription Product Information

```csharp
void DisplaySubscription(string productId)
{
    var product = BillingServices.GetProductWithId(productId);

    if (product.SubscriptionInfo != null)
    {
        Debug.Log($"Period: {product.SubscriptionInfo.Period}");
        Debug.Log($"Title: {product.SubscriptionInfo.LocalizedGroupTitle}");
    }
}
```

### Product Offers

After `InitializeStore()`, subscription products may include promotional offers:

```csharp
foreach (var product in result.Products)
{
    var offers = product.Offers;
    if (offers != null)
    {
        foreach (var offer in offers)
        {
            Debug.Log($"Offer: {offer.Id}, Category: {offer.Category}");

            foreach (var phase in offer.PricingPhases)
            {
                Debug.Log($"  Phase: {phase.Price}, Mode: {phase.PaymentMode}");
            }
        }
    }
}
```

### Redeeming Offers

To apply an offer when purchasing:

```csharp
BillingProductOfferRedeemDetails GetOfferDetails(string offerId)
{
    if (string.IsNullOrEmpty(offerId))
        return null;

    var builder = new BillingProductOfferRedeemDetails.Builder();
    builder.SetAndroidPlatformProperties(offerId);
    builder.SetIosPlatformProperties(offerId, keyId: null, nonce: null,
                                      signature: null, timestamp: 0);

    return builder.Build();
}

void PurchaseWithOffer(string productId, string offerId)
{
    var product = BillingServices.GetProductWithId(productId);
    var offerDetails = GetOfferDetails(offerId);

    var options = new BuyProductOptions.Builder()
        .SetOfferRedeemDetails(offerDetails)
        .Build();

    BillingServices.BuyProduct(product, options);
}
```

{% hint style="info" %}
Android subscription data has more constraints than iOS. Some subscription properties may not be available on Android.
{% endhint %}

## Core APIs Reference

| API                                              | Purpose                                     | Returns                               |
| ------------------------------------------------ | ------------------------------------------- | ------------------------------------- |
| `BillingServices.InitializeStore()`              | Connect to store and fetch products         | Triggers `OnInitializeStoreComplete`  |
| `BillingServices.GetProductWithId(id)`           | Get product by ID                           | `IBillingProduct` or null             |
| `BillingServices.CanMakePayments()`              | Check if purchases allowed                  | `bool`                                |
| `BillingServices.IsProductPurchased(id)`         | Check ownership (non-consumables/subs only) | `bool`                                |
| `BillingServices.BuyProduct(product, options)`   | Start purchase flow                         | Triggers `OnTransactionStateChange`   |
| `BillingServices.RestorePurchases(forceRefresh)` | Restore previous purchases                  | Triggers `OnRestorePurchasesComplete` |

## Advanced: Manual Transaction Finishing

{% hint style="danger" %}
Only disable Auto Finish Transactions if you have a server-side verification system ready. Failing to finish transactions will cause them to reappear on every app launch, confusing users and potentially causing duplicate content grants.
{% endhint %}

### Understanding Transaction Finishing

When a purchase completes, the transaction enters a "pending" state in the platform store queue. The transaction must be "finished" (marked as complete) to remove it from this queue. If not finished, the platform will keep trying to deliver it on every app launch.

**Auto Finish Transactions (Default: Enabled):** Essential Kit automatically finishes transactions after firing the `OnTransactionStateChange` event. This works for most games and is the recommended approach.

**Manual Finishing (Advanced):** Only disable Auto Finish Transactions if you need to verify purchases with your own server before granting content. This is typically used for:

* Server-side receipt validation (recommended for Android apps with large user base)
* High-value purchases requiring fraud prevention
* Custom backend verification workflows

### When to Use Manual Finishing

Only needed when **Auto Finish Transactions** is disabled (server verification scenarios).

With manual processing, transactions remain in Essential Kit's internal queue until you call `FinishTransactions()`. Cache the `IBillingTransaction` you receive (either directly from the purchase callback or by calling `GetTransactions()`), send its receipt data to your backend, update `VerificationState`, and only then finish the transaction. Essential Kit handles local verification by default and provides these hooks so you can layer remote verification on top.

### Processing Pending Transactions

Define storage for pending transactions and forward receipts to your backend before finishing them:

```csharp
private readonly Dictionary<string, IBillingTransaction> _pendingTransactions = new();

void QueueTransactionForVerification(IBillingTransaction transaction)
{
    if (_pendingTransactions.ContainsKey(transaction.Id))
        return;

    _pendingTransactions[transaction.Id] = transaction;
    Debug.Log($"Queued {transaction.Product.Id} for server verification");

    SendReceiptToServer(transaction);
}

void SendReceiptToServer(IBillingTransaction transaction)
{
    Debug.Log($"Send receipt for {transaction.Product.Id} to your backend");
    // Call OnServerVerificationComplete once you receive the verification result
}
```

```csharp
void ProcessPendingTransactions()
{
    foreach (var transaction in BillingServices.GetTransactions())
    {
        if (transaction.TransactionState == BillingTransactionState.Purchased &&
            (transaction.ReceiptVerificationState == BillingReceiptVerificationState.NotDetermined || transaction.ReceiptVerificationState == BillingReceiptVerificationState.Success)
        {
            QueueTransactionForVerification(transaction); // helper shown earlier
        }
    }
}
```

### Server-Side Receipt Verification

The following helper reuses the `_pendingTransactions` dictionary defined above.

Trigger a completion method once your backend confirms the receipt status. Update `VerificationState`, grant content when appropriate, then finish the transaction.

```csharp
void OnServerVerificationComplete(string transactionId, bool isValid)
{
    if (!_pendingTransactions.TryGetValue(transactionId, out var transaction))
        return;

    transaction.ReceiptVerificationState = isValid
        ? BillingReceiptVerificationState.Success
        : BillingReceiptVerificationState.Failed;

    if (transaction.ReceiptVerificationState == BillingReceiptVerificationState.Success)
        Debug.Log($"Grant content for {transaction.Product.Id}");

    BillingServices.FinishTransactions(new[] { transaction });
    _pendingTransactions.Remove(transactionId);
    Debug.Log($"Finished transaction {transactionId} with verification {transaction.ReceiptVerificationState}");
}
```

### Receipt Data for Verification

Platform-specific receipt data available in `IBillingTransaction`:

**iOS:**

* `transaction.Receipt` - JWS representation for StoreKit2

**Android:**

* `transaction.Receipt` - Purchase token
* `transaction.RawData` - JSON containing signature and transaction data

```csharp
// Android receipt extraction
var rawData = (IDictionary)ExternalServiceProvider.JsonServiceProvider.FromJson(transaction.RawData);
var purchaseData = rawData["transaction"] as string;
var signature = rawData["signature"] as string;
```

{% hint style="info" %}
Need help implementing server-side verification? See the [FAQ](faq.md#how-do-i-implement-receipt-verification-with-appodeal) for an example integration with third-party verification services.
{% endhint %}

## Advanced: Runtime Product Configuration

Build a runtime catalog and pass it directly to `InitializeStore`:

```csharp
void ConfigureProductsAtRuntime()
{
    var products = new[]
    {
        new BillingProductDefinition(
            id: "coins_100",
            platformId: "coins_100",
            platformIdOverrides: new RuntimePlatformConstantSet(
                ios: "com.yourgame.coins_100",
                android: "coins_100"),
            productType: BillingProductType.Consumable,
            title: "100 Coins",
            description: "Grants 100 soft currency coins")
    };

    BillingServices.InitializeStore(products);
}
```

**Use cases:**

* Server-driven product catalogs
* A/B testing product offerings
* Dynamic pricing experiments
* Season passes or time-limited products

{% hint style="info" %}
Use either `InitializeStore(productDefinitions)` for runtime catalogs or the Billing Settings product definitions in Essential Kit Settings → Billing Services → Products, but not both to avoid confusion. If no products are passed with the `InitializeStore` call, it falls back to the Settings configuration.
{% endhint %}

{% hint style="warning" %}
Runtime product configuration is for advanced scenarios only. For most games, configure products in Essential Kit Settings instead. See [Setup Guide](setup/) for the standard configuration approach.
{% endhint %}

## Error Handling

Common error codes and recommended actions:

| Error Code            | Trigger              | Action                          |
| --------------------- | -------------------- | ------------------------------- |
| `PaymentCancelled`    | User cancelled       | No action needed                |
| `PaymentNotAllowed`   | Purchases disabled   | Show message about restrictions |
| `ProductNotAvailable` | Product not in store | Verify product ID configuration |
| `NetworkNotAvailable` | No connection        | Prompt to check connection      |
| `Unknown`             | Platform error       | Log and retry                   |

{% hint style="success" %}
Ready to test your implementation? Head to the [Testing Guide](testing/) to learn how to test purchases in sandbox environments before going live.
{% endhint %}

## Related Guides

* Demo scene: `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/BillingServicesDemo.unity`
* Pair with **Network Services** to verify connectivity before purchases
* Use **Native UI** for custom purchase confirmation dialogs
