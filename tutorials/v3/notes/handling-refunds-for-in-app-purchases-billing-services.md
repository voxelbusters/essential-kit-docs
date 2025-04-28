---
description: Learn how refunds are handled across Google Play and iOS for in-app purchases.
---

# Handling Refunds for In-App Purchases (Billing Services)

### Overview

Different app stores handle refunds and entitlement revocation in different ways. Here’s a clear breakdown for both **Google Play** and **Apple App Store** platforms.

***

### Refund Support Matrix

<table><thead><tr><th width="173.40625">Product Type</th><th width="258.50537109375">Google Play: Refundable &#x26; Revocable</th><th>Apple App Store: Refundable &#x26; Revocable</th></tr></thead><tbody><tr><td><strong>Consumables</strong></td><td><p>✅ Refund via play store, </p><p>❌ No control on blocking the content after restore without a backend server</p></td><td><p>✅ Refund via App Store Support, </p><p>❌ No control on blocking the content after restore without a backend server</p></td></tr><tr><td><strong>Non-Consumables</strong></td><td>✅ Refund with <strong>Revoke Entitlement (in play console at the time of refunding from orders page)</strong></td><td>✅ Refund auto-removes from <code>RestorePurchases</code></td></tr><tr><td><strong>Subscriptions</strong></td><td>✅ Refund with <strong>Revoke Entitlement</strong></td><td>✅ Refund auto-removes from <code>RestorePurchases</code></td></tr></tbody></table>

***

### 📌 Important: Platform Refund & Entitlement Behavior

**Google Play**

* When issuing a refund via the Google Play Console for **non-consumables** or **subscriptions**:
  * You **must enable "Revoke entitlement"** for the app to detect the refund.
  * If enabled:
    * `IsProductPurchased(productId)` → `false`
    * User’s entitlement will be removed.

**Apple App Store**

* On iOS, when a refund is processed by Apple (usually via **App Store Support** or user refund requests):
  * **Automatically revoked** — no manual revoke option needed.
  * The product will **not appear in subsequent `RestorePurchases` calls**.
  * `IsProductPurchased(productId)` will also return `false`.
  * Works seamlessly for **non-consumables** and **subscriptions**.

{% hint style="danger" %}
⚠️ **Consumables on both platforms**:\
Refunds can be processed, but once consumed, they’re not restorable and entitlement status cannot be tracked post-consumption. \
\
If you really want to track these purchases, for every entitlement you provide to the user of a purchase, log the transaction id and check from your backend if the purchase is revoked or still valid. Based on that you can control refunds for consumable purchases.
{% endhint %}
