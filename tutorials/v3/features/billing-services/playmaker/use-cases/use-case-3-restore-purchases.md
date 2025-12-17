# Restore Previous Purchases

## Goal
Restore non-consumables and subscriptions (for example after reinstall or on a new device).

## Actions Required
| Action | Purpose |
|--------|---------|
| BillingServicesInitializeStore | Load product catalog |
| BillingServicesRestorePurchases | Trigger restore process |
| BillingServicesOnRestorePurchasesComplete | Listen for restore completion |
| BillingServicesGetRestorePurchasesSuccessResult | Get restored count |
| BillingServicesGetRestoredTransactionInfo | Read restored transaction details |
| BillingServicesFinishTransactions | Finish restored transactions |
| BillingServicesGetRestorePurchasesError | Read cached restore error after failure (optional) |

## Variables Needed
- restoredCount (Int)
- transactionIndex (Int)
- productId (String)

## Implementation Steps

### 1. InitializeStore
Run `BillingServicesInitializeStore` and wait for `successEvent`.

### 2. RegisterRestoreListener (persistent)
Run `BillingServicesOnRestorePurchasesComplete` in a state that stays active (for example in your settings scene while the restore flow runs).
- This action is what fires the completion events and caches data for the extractor actions.

### 3. TriggerRestore (user taps “Restore Purchases”)
Run `BillingServicesRestorePurchases` (`forceRefresh` optional).

### 4. Wait for completion
Your `BillingServicesOnRestorePurchasesComplete` listener will fire:
- `successEvent` → `GetRestoreResult`
- `failureEvent` → (Optional) `BillingServicesGetRestorePurchasesError`

### 5. GetRestoreResult
Run `BillingServicesGetRestorePurchasesSuccessResult` → `restoredCount`.

### 6. Loop restored items
Loop `transactionIndex = 0..restoredCount-1`:
- `BillingServicesGetRestoredTransactionInfo(transactionIndex)` → `productId` (and transactionId if you need it)
- Grant content based on `productId`

### 7. FinishRestore
Run `BillingServicesFinishTransactions` (either finish all cached/pending, or only the restored IDs you collected).

## Notes
- Consumables are not restorable (by design).
- Prefer showing restore from a Settings screen rather than auto-restoring every launch.
