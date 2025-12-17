# Billing Services - PlayMaker

Build an in-app store UI, purchase products, and restore eligible purchases using PlayMaker custom actions.

## Key pattern (listeners)
- Register `BillingServicesOnTransactionStateChange` in a state that stays active **before** calling `BillingServicesBuyProduct`. This listener is what fires `purchasingEvent` / `purchasedEvent` / `failedEvent` / `deferredEvent` and caches transactions for `BillingServicesGetTransactionInfo`.
- Register `BillingServicesOnRestorePurchasesComplete` in a state that stays active **before** calling `BillingServicesRestorePurchases`. This listener is what fires completion events and caches restore results for extractor actions.

## Actions (high level)
- Store setup: `BillingServicesInitializeStore`, `BillingServicesGetInitializeStoreSuccessResult`, `BillingServicesGetInitializeStoreError`, `BillingServicesCanMakePayments`
- Product listing/UI: `BillingServicesGetStoreProductInfo`, `BillingServicesIsProductPurchased`
- Purchase flow: `BillingServicesBuyProduct`, `BillingServicesGetBuyProductError`, `BillingServicesOnTransactionStateChange`, `BillingServicesGetTransactionInfo`
- Restore flow: `BillingServicesRestorePurchases`, `BillingServicesOnRestorePurchasesComplete`, `BillingServicesGetRestorePurchasesSuccessResult`, `BillingServicesGetRestorePurchasesError`, `BillingServicesGetRestoredTransactionInfo`
- Manual completion / verification: `BillingServicesGetTransactions`, `BillingServicesSetReceiptVerificationState`, `BillingServicesFinishTransactions`

## AutoFinishTransactions
- **ON (default):** simplest flow. Grant content on `purchasedEvent`. No manual finishing needed.
- **OFF (advanced):** required for server-side receipt verification. Verify `receipt` from `BillingServicesGetTransactionInfo`, then call `BillingServicesSetReceiptVerificationState(transactionId, Success/Failed)` and finish with `BillingServicesFinishTransactions`.

## Use cases
Start here: `use-cases/README.md`


