# How Non-Consumable and Subscription product statuses are maintained?

### Overview

Essential Kit simplifies in-app purchase handling in Unity by abstracting platform-specific billing APIs into a consistent and efficient interface. One key aspect of this system is how non-consumable purchases are tracked and verified during runtime.

This document explains how Essential Kit manages the state of non-consumable products using an internal runtime cache, how this behavior differs across platforms, and what developers should consider in edge cases such as offline usage.

***

### Internal Purchase Tracking Logic

All caching, querying, and synchronization of purchase data is handled **internally by Essential Kit**. Developers do **not** need to manage or manually query the platform-specific billing services.

When calling `BillingServices.IsProductPurchased`, Essential Kit automatically uses the appropriate mechanism to return the current purchase state:

* On **Android**, it uses a **runtime memory cache** populated during store initialization.
* On **iOS**, it queries **StoreKit directly** each time to check the current transaction list.

These implementation details are fully abstracted away. As a developer, you only need to be aware of how `BillingServices.IsProductPurchased` behaves under different runtime conditions.

***

### Edge Case: Offline Behavior

If the device is **offline**, platform behavior may vary:

* On Android, Google Play may return cached purchase data during store initialization, allowing Essential Kit to build its internal cache.
* On iOS, since there is no runtime cache, and StoreKit relies on native transaction history, results may still be accessible if the platform caches transactions locally.

However, in rare cases where **no cached data is available**, and the device is offline, Essential Kit may **not be able to confirm a previous purchase**. As a result, `BillingServices.IsProductPurchased` may return `false`, even for products the user already owns.

***

### Developer Note

> **Important:**\
> All purchase tracking and cache management is handled **internally** by Essential Kit.\
> Developers should be aware that **`BillingServices.IsProductPurchased` may return `false` when the device is offline**, regardless of the platform.\
> To ensure a smooth user experience in such scenarios, developers are encouraged to implement fallback strategies as outlined below.

***

### Recommendations for Handling Offline and Edge Cases

To improve reliability and user experience, consider the following:

1. **Delay access to gated content** until the store is successfully initialized.
2. **Display fallback UI or messaging** when purchase validation cannot be confirmed due to lack of connectivity.
3. Optionally, **persist a lightweight list** of previously validated purchases on your side and reconcile once the device is back online.
4. Design your UI to handle temporary unknown purchase states (e.g., loading indicators or retry options).

***

### Summary

* Essential Kit handles purchase tracking and runtime caching **automatically**.
* On Android, a runtime memory cache is used. On iOS, the StoreKit transaction list is queried directly.
* Developers do not need to manage platform-specific logic.
* In rare offline cases, `BillingServices.IsProductPurchased` may return `false` for valid purchases.
* Implementing fallback strategies ensures a consistent and user-friendly experience.
