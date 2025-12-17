# Simple Product Purchase

## Goal
Initialize the billing store and allow users to purchase a product (non-consumable or consumable) with automatic transaction completion.

## Actions Required
| Action | Purpose |
|--------|---------|
| BillingServicesInitializeStore | Load product catalog and initialize billing |
| BillingServicesGetInitializeStoreError | Read cached init error after failure (optional) |
| BillingServicesCanMakePayments | Check if user can make purchases |
| BillingServicesBuyProduct | Initiate purchase flow |
| BillingServicesGetBuyProductError | Read cached buy error after failure (optional) |
| BillingServicesOnTransactionStateChange | Listen for purchase state changes (persistent) |
| BillingServicesGetTransactionInfo | Read transaction details after an event (optional) |

## Variables Needed
- productId (String) = "premium_unlock" or "coins_100"
- canMakePurchase (Bool)
- transactionCount (Int)
- transactionId (String) (optional, from GetTransactionInfo)

## Implementation Steps

### 0. State: RegisterTransactionListener (Persistent)
**Action:** BillingServicesOnTransactionStateChange
- Keep this state active (for example in your bootstrap scene or a DontDestroyOnLoad FSM).
- This action is what actually fires purchase lifecycle events (`purchasingEvent`, `purchasedEvent`, `failedEvent`, `deferredEvent`) and caches transactions for `BillingServicesGetTransactionInfo`.

### 1. State: InitializeStore (On App Startup)
**Action:** BillingServicesInitializeStore
- **Events:**
  - successEvent → CheckPaymentCapability
  - failureEvent → ShowError (billing not available)

**Note:** This caches all configured products from Essential Kit settings.
**Optional:** On `failureEvent`, call `BillingServicesGetInitializeStoreError` to read `errorCode` + `errorDescription`.

### 2. State: CheckPaymentCapability
**Action:** BillingServicesCanMakePayments
- **Outputs:**
  - result → canMakePurchase variable
- **Transition:**
  - If canMakePurchase = true → ShowPurchaseUI
  - If canMakePurchase = false → ShowRestrictionMessage

### 3. State: ShowPurchaseUI
Display purchase button. When user taps "Buy":
- Go to BuyProduct state

### 4. State: BuyProduct
**Action:** BillingServicesBuyProduct
- **Inputs:**
  - productId: productId
  - quantity: 1
- **Events:**
  - successEvent → WaitForTransactionEvents
  - failureEvent → ShowBuyError

**Important:** `BillingServicesBuyProduct` only dispatches the purchase request. The actual purchase outcome comes from your already-registered `BillingServicesOnTransactionStateChange` listener.

### 5. State: ShowBuyError (immediately on failure)
Call `BillingServicesGetBuyProductError` as soon as you enter this state.
- Enter this state from:
  - `BillingServicesBuyProduct.failureEvent` (dispatch failed: invalid input/store not ready/exception)
  - `BillingServicesOnTransactionStateChange.failedEvent` (store purchase failed/cancelled)

### 6. State: WaitForTransactionEvents
No action needed here (optional). Your `BillingServicesOnTransactionStateChange` state will fire:
- `purchasingEvent` → show processing UI
- `purchasedEvent` → grant content
- `failedEvent` → go to `ShowBuyError`
- `deferredEvent` → show pending/deferred UI

### 7. Read Transaction Details
After `purchasedEvent` or `failedEvent`, call `BillingServicesGetTransactionInfo` with `transactionIndex = 0` to read details (transactionId, receipt, etc.).

## Purchase Flow
```
RegisterTransactionListener (keep active)

InitializeStore
    └─ CheckPaymentCapability
        └─ BuyProduct
            └─ (events come from BillingServicesOnTransactionStateChange)
                ├─ purchasingEvent → Show Processing
                ├─ purchasedEvent → Grant Content
                ├─ failedEvent → ShowBuyError (then BillingServicesGetBuyProductError)
                └─ deferredEvent → Show Pending
```

## Common Issues

- **"Cannot connect to store"**: Check internet connection and platform billing setup
- **Purchase Stuck**: Ensure OnTransactionStateChange listener is active before calling BuyProduct
- **Test Purchases**: Use sandbox/test accounts for development
- **AutoFinishTransactions**: If enabled in settings, transactions complete automatically after Purchased state

## Platform Requirements

**iOS:**
- In-app purchases configured in App Store Connect
- Sandbox tester account for testing

**Android:**
- Products configured in Google Play Console
- Use license testing for development builds (and make sure you upload tleast once to play store after enabling billing featute)

## Performance Tip
Initialize store once at app startup and keep products cached. Don't reinitialize on every purchase.
