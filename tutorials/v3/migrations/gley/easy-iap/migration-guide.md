# Gley Easy IAP → Essential Kit Billing Services

## Table of Contents

* [Why Essential Kit Instead Of Unity IAP](migration-guide.md#why-essential-kit-instead-of-unity-iap)
* [Quick API Cheat Sheet](migration-guide.md#quick-api-cheat-sheet)
* [Before You Start](migration-guide.md#1-before-you-start)
* [Remove The Old Dependency](migration-guide.md#2-remove-the-old-dependency)
* [Configure Products In Essential Kit](migration-guide.md#3-configure-products-in-essential-kit)
* [Replace Initialisation Code](migration-guide.md#4-replace-initialisation-code)
* [Update Purchase Handling](migration-guide.md#5-update-purchase-handling)
* [Restore Purchases](migration-guide.md#6-restore-purchases)
* [Update UI Helpers (Price, Title, Reward Amount)](migration-guide.md#7-update-ui-helpers-price-title-reward-amount)
* [Optional: Receipt Verification](migration-guide.md#8-optional-receipt-verification)
* [Test And Clean Up](migration-guide.md#9-test-and-clean-up)
* [Quick Checklist](migration-guide.md#10-quick-checklist)
* [What You Gain With Essential Kit](migration-guide.md#what-you-gain-with-essential-kit)
* [Need Help?](migration-guide.md#need-help)

This guide distils the migration into the few changes you actually need to make. When you need deeper feature explanations, refer to `tutorials/v3/features/billing-services/usage.md`.

### Why Essential Kit Instead Of Unity IAP

* Direct native control so fixes and updates ship as soon as we build them (no Unity IAP dependency or review cycle).
* The Essential Kit team owns the roadmap and can respond to platform changes immediately.
* No analytics or telemetry packages bundled in; you keep full control over user data.
* Smaller project footprint with fewer package conflicts to manage.

### Quick API Cheat Sheet

| Task              | Gley Easy IAP                                               | Essential Kit                                                          |
| ----------------- | ----------------------------------------------------------- | ---------------------------------------------------------------------- |
| Namespace         | `using Gley.EasyIAP;`                                       | `using VoxelBusters.EssentialKit; using VoxelBusters.CoreLibrary`      |
| Initialise store  | `API.Initialize(callback)`                                  | `BillingServices.InitializeStore()`                                    |
| Check can pay     | `API.IsInitialized()`                                       | `BillingServices.CanMakePayments()`                                    |
| Buy product       | `API.BuyProduct(ShopProductNames.Item, callback)`           | `BillingServices.BuyProduct("item_id")`                                |
| Purchase callback | `void OnPurchase(IAPOperationStatus, string, StoreProduct)` | `void HandleTransactions(BillingServicesTransactionStateChangeResult)` |
| Get product price | `API.GetLocalizedPriceString(ShopProductNames.Item)`        | `product.Price.LocalizedText`                                          |
| Grant reward      | `product.value`                                             | iterate `product.Payouts` (category/variant)                           |
| Restore purchases | `API.RestorePurchases(callback)`                            | `BillingServices.RestorePurchases(forceRefresh)`                       |
| Receipt string    | `product.receipt`                                           | `transaction.Receipt`                                                  |
| Check ownership   | `API.IsActive(ShopProductNames.RemoveAds)`                  | `BillingServices.IsProductPurchased("remove_ads")`                     |

## 1. Before You Start

* Export your existing product list (name, store IDs, product type, reward amount).
* Search your project for `Gley.EasyIAP` usages; keep this list beside you so nothing is missed.
* Decide when you will remove the Unity IAP and Gley packages (after you test the new flow is safest).

## 2. Remove The Old Dependency

1. In **Package Manager** remove **Unity IAP** if it is only used by Gley.
2. Delete the Gley Easy IAP asset folder from your project.

## 3. Configure Products In Essential Kit

1. Open **Window → Voxel Busters → Essential Kit → Open Settings → Services → Billing Services**.
2. For every product add:
   * **Product ID** – the identifier you use in code (e.g. `coins_100`).
   * **Product Type** – Consumable, NonConsumable, or Subscription.
   * **Store IDs** – iOS and Google Play identifiers exactly as created on each store.
   * **Payouts** (optional)– each reward is `Category + Variant + Quantity`. Use `Currency` for virtual currencies and name the variant clearly (e.g. `coins_primary`).

Example:

```
Product ID: coins_100
Product Type: Consumable
iOS Store ID: com.yourgame.coins_100
Google Play ID: coins_100
Payouts:
  - Category: Currency
    Variant: coins_primary
    Quantity: 100
```

> Essential Kit keeps the category and variant so you can differentiate primary/secondary currencies later.

## 4. Replace Initialisation Code

```csharp
using UnityEngine;
using VoxelBusters.CoreLibrary;
using VoxelBusters.EssentialKit;

public sealed class StoreBootstrap : MonoBehaviour
{
    void OnEnable()
    {
        BillingServices.OnInitializeStoreComplete += HandleStoreInitialised;
    }

    void OnDisable()
    {
        BillingServices.OnInitializeStoreComplete -= HandleStoreInitialised;
    }

    void Start()
    {
        BillingServices.InitializeStore();
    }

    private void HandleStoreInitialised(BillingServicesInitializeStoreResult result, Error error)
    {
        if (error != null)
        {
            Debug.LogError($"Billing store init failed: {error.LocalizedDescription}");
            return;
        }

        if (BillingServices.IsProductPurchased("remove_ads"))
        {
            DisableAds();
        }
    }

    private void DisableAds()
    {
        // Implement your existing remove-ads logic
    }
}
```

## 5. Update Purchase Handling

Subscribe once and centralise transaction handling. Notice the explicit null checks – `IBillingTransaction.Product` can be null if the product was removed from settings, so we guard before using it.

```csharp
using VoxelBusters.EssentialKit;
using VoxelBusters.CoreLibrary;

public sealed class StoreFront : MonoBehaviour
{
    [SerializeField] private int coins;

    void OnEnable()
    {
        BillingServices.OnTransactionStateChange += HandleTransactions;
    }

    void OnDisable()
    {
        BillingServices.OnTransactionStateChange -= HandleTransactions;
    }

    public void BuyCoins()
    {
        BillingServices.BuyProduct("coins_100");
    }

    private void HandleTransactions(BillingServicesTransactionStateChangeResult result)
    {
        foreach (var transaction in result.Transactions)
        {
            if (transaction.TransactionState != BillingTransactionState.Purchased)
                continue;

            var product = transaction.Product;
            if (product == null)
                continue; // Product not configured anymore – nothing to grant

            GrantReward(product);
        }
    }

    private void GrantReward(IBillingProduct product)
    {
        if (product.Id == "remove_ads")
        {
            DisableAds();
            return;
        }

        foreach (var payout in product.Payouts)
        {
            if (payout.Category == BillingProductPayoutCategory.Currency && payout.Variant == "coins_primary")
            {
                coins += (int)payout.Quantity;
            }
        }

        SaveProgress();
    }

    private void DisableAds() { /* existing code */ }
    private void SaveProgress() { /* existing code */ }
}
```

## 6. Restore Purchases

```csharp
void OnEnable()
{
    BillingServices.OnRestorePurchasesComplete += HandleRestoreComplete;
}

void OnDisable()
{
    BillingServices.OnRestorePurchasesComplete -= HandleRestoreComplete;
}

public void RestorePurchases()
{
    // Use forceRefresh:false so iOS does not show the login dialog automatically on launch
    BillingServices.RestorePurchases(forceRefresh: false);
}

private void HandleRestoreComplete(BillingServicesRestorePurchasesResult result, Error error)
{
    if (error != null)
    {
        Debug.LogError($"Restore failed: {error.LocalizedDescription}");
        return;
    }

    foreach (var transaction in result.Transactions)
    {
        var product = transaction.Product;
        if (product != null)
        {
            GrantReward(product);
        }
    }
}
```

Reuse the same `GrantReward` helper from the purchase path so your rewards stay in one place. When a user explicitly taps a “Restore Purchases” button on iOS, re-run `BillingServices.RestorePurchases(forceRefresh: true)` to present the App Store login dialog as required. See the [restore guidance](migration-guide.md#id-6.-restore-purchases) for more detail.

## 7. Update UI Helpers (Price, Title, Reward Amount)

```csharp
var product = BillingServices.GetProductWithId("coins_100");
if (product != null)
{
    string localizedPrice = product.Price.LocalizedText;
    int reward = 0;

    foreach (var payout in product.Payouts)
    {
        if (payout.Category == BillingProductPayoutCategory.Currency && payout.Variant == "coins_primary")
        {
            reward = (int)payout.Quantity;
            break;
        }
    }

    coinsButton.text = $"Buy {reward} coins {localizedPrice}";
}
```

## 8. Optional: Receipt Verification

If you previously sent receipts to a server, keep doing it with the new API. Essential Kit performs local verification automatically; for server-side verification see `tutorials/v3/features/billing-services/usage.md#server-side-receipt-verification`.

```csharp
private void HandleTransactions(BillingServicesTransactionStateChangeResult result)
{
    foreach (var transaction in result.Transactions)
    {
        if (transaction.TransactionState != BillingTransactionState.Purchased)
            continue;

        SendReceiptToServer(transaction.Receipt, isValid =>
        {
            if (isValid && transaction.Product != null)
            {
                GrantReward(transaction.Product);
            }

            BillingServices.FinishTransactions(new[] { transaction });
        });
    }
}
```

## 9. Test And Clean Up

* Run through purchase, restore, and subscription scenarios on iOS and Android sandbox accounts.
* Interrupt a purchase to confirm pending transactions are processed on next launch.
* Once you ship with Essential Kit, delete any unused Gley scripts and `ShopProductNames` enums.

## 10. Quick Checklist

* [ ] Products recreated in Essential Kit settings with category/variant payouts.
* [ ] Code uses `BillingServices.InitializeStore()` and event handlers instead of Gley callbacks.
* [ ] Purchases, restores, and UI price displays updated.
* [ ] Receipt flow (if any) references the new API.
* [ ] Unity IAP and Gley Easy IAP assets removed after validation.

## What You Gain With Essential Kit

* Built-in receipt verification (local) with optional server extensions.
* Purchase quantity support via `BuyProductOptions`.
* Multiple payout definitions per product for multi-currency bundles.
* Pending transaction recovery handled automatically after initialization.
* Runtime configuration support (load product catalog from your backend and call `BillingServices.Initialize(settings)`).

## Need Help?

* Review the [Essential Kit](https://www.voxelbusters.com/products/essential-kit) product overview
* Chat with the team and other adopters on [Discord](https://discord.gg/Rw5SAec4Md)
* Browse the full [Billing Services usage guide](../../../features/billing-services/usage.md)
* [Email](mailto:support@voxelbusters.com) for direct assistance

You are now running on Essential Kit’s native billing system. For advanced features (pending transactions, subscription status, offers) can refer [main tutorial](../../../features/billing-services/usage.md).&#x20;
