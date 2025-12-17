# BillingServices Use Cases

Quick-start guides showing minimal implementations of in-app purchase features using PlayMaker custom actions.

## Important (listener actions)
Event listener actions like `BillingServicesOnTransactionStateChange` and `BillingServicesOnRestorePurchasesComplete` should be added to a state that stays active and registered **before** you start the corresponding flow (buy/restore). The “trigger” actions only dispatch requests; results are delivered via these listeners.

## Available Use Cases

### 1. [Build a Simple Store UI](use-case-1-build-store-ui.md)
**What it does:** List products with localized prices and gate owned non-consumables
**Complexity:** Basic
**Actions:** 4 (InitializeStore, GetInitializeStoreSuccessResult, GetStoreProductInfo, IsProductPurchased)
**Best for:** Store screens, premium unlock UI, product listing

---

### 2. [Simple Product Purchase](use-case-2-simple-purchase.md)
**What it does:** Complete purchase flow with automatic transaction finishing
**Complexity:** Basic
**Actions:** 4 (InitializeStore, CanMakePayments, BuyProduct, OnTransactionStateChange)
**Best for:** Basic IAP implementation, non-consumables, simple consumables

---

### 3. [Restore Previous Purchases](use-case-3-restore-purchases.md)
**What it does:** Restore non-consumable and subscription purchases on reinstall
**Complexity:** Intermediate
**Actions:** 6 (InitializeStore, RestorePurchases, OnRestorePurchasesComplete, GetRestorePurchasesSuccessResult, GetRestoredTransactionInfo, FinishTransactions)
**Best for:** Account recovery, device transfers, non-consumables

---

### 4. [Purchase with Manual Verification](use-case-4-manual-verification.md)
**What it does:** Purchase with server-side receipt verification before granting content
**Complexity:** Advanced
**Actions:** 6 (InitializeStore, BuyProduct, OnTransactionStateChange, GetTransactionInfo, SetReceiptVerificationState, FinishTransactions)
**Best for:** Fraud prevention, high-value purchases, consumable currencies

---

### 5. [Process Pending Transactions (AutoFinishTransactions OFF)](use-case-5-process-pending-transactions.md)
**What it does:** Recover and finish pending transactions after a restart/network retry (manual verification setups)
**Complexity:** Advanced
**Actions:** 5 (InitializeStore, GetTransactions, GetTransactionInfo, SetReceiptVerificationState, FinishTransactions)
**Best for:** AutoFinishTransactions OFF, external receipt verification, “stuck in queue” recovery

---

## Choosing the Right Use Case

**Start Here:**
- Building your store screen first? → **Use Case 1** (Store UI)
- First-time IAP setup? → **Use Case 2** (Simple Purchase)
- Supporting account recovery? → **Use Case 3** (Restore Purchases)
- Need security/fraud prevention? → **Use Case 4** (Manual Verification)
- AutoFinishTransactions OFF recovery? → **Use Case 5** (Process Pending)

## Quick Action Reference

| Action | Purpose | Used In |
|--------|---------|---------|
| BillingServicesInitializeStore | Load products, start billing | All use cases |
| BillingServicesGetInitializeStoreSuccessResult | Read productCount/invalid IDs after init success | (Optional) |
| BillingServicesGetInitializeStoreError | Read cached init error after failure | Use Case 2 |
| BillingServicesCanMakePayments | Check purchase restrictions | Use Case 2 |
| BillingServicesBuyProduct | Start purchase flow | Use Cases 2, 4 |
| BillingServicesGetBuyProductError | Read cached buy error after failure | Use Cases 2, 4 |
| BillingServicesOnTransactionStateChange | Monitor purchase state | Use Cases 2, 4 |
| BillingServicesGetTransactionInfo | Read receipt + transaction details | Use Cases 4, 5 |
| BillingServicesSetReceiptVerificationState | Set verification result from server | Use Cases 4, 5 |
| BillingServicesFinishTransactions | Finish transactions | Use Cases 3, 4, 5 |
| BillingServicesGetTransactions | Get pending transaction queue | Use Case 5 |
| BillingServicesRestorePurchases | Restore previous purchases | Use Case 3 |
| BillingServicesOnRestorePurchasesComplete | Listen for restore completion | Use Case 3 |
| BillingServicesGetRestorePurchasesSuccessResult | Get restore count | Use Case 3 |
| BillingServicesGetRestorePurchasesError | Read cached restore error after failure | Use Case 3 |
| BillingServicesGetRestoredTransactionInfo | Get restored product info | Use Case 3 |
| BillingServicesGetStoreProductInfo | Read localized title/price for UI | Use Case 1 |
| BillingServicesIsProductPurchased | Gate non-consumable “Buy” buttons | Use Case 1 |

## Transaction States

**Purchasing**: User is in payment flow
**Purchased**: Payment successful, ready to grant content
**Failed**: Purchase failed or cancelled
**Deferred**: Awaiting approval (parental controls)

## AutoFinishTransactions Setting

**Enabled (Default):**
- Transactions finish automatically after Purchased state
- Simpler implementation
- Use for basic purchases

**Disabled (Advanced):**
- Manual control over transaction completion
- Required for receipt verification
- Use for fraud prevention

## Product Types

**Non-Consumable:**
- One-time purchases (premium unlock, level packs)
- Can be restored
- Example: "Remove Ads"

**Consumable:**
- Can be purchased multiple times (coins, gems)
- Cannot be restored
- Example: "100 Coins"

**Subscription:**
- Recurring payments
- Can be restored
- Auto-renewing

## Platform Setup Requirements

**iOS:**
- Products configured in App Store Connect
- In-App Purchase capability enabled
- Test with Sandbox accounts

**Android:**
- Products in Google Play Console
- Billing library integrated
- Test with license testers

## Related Documentation

- **[README.md](../README.md)** - Actions + key patterns + use-cases
