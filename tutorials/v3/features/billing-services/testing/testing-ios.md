---
description: Testing in-app purchases on iOS using Apple’s sandbox environment
---

# iOS Sandbox Testing

Essential Kit uses Apple’s sandbox automatically for development builds. Use this condensed guide during verification.

## Quick Troubleshooting Reference
| Problem | Likely Cause | Quick Fix |
|---------|-------------|-----------|
| `InitializeStore` returns no products | App Store Connect agreements or product status incomplete | Accept the latest agreements, finish tax/banking forms, ensure products are “Ready to Submit” or “Approved”. |
| Prompt lacks `[Environment: Sandbox]` | Production-signed build or wrong account | Install a development/TestFlight build and sign in with the sandbox tester. |
| Sandbox option missing in Settings | Developer Mode disabled or sandbox build not opened | Connect device to Xcode, enable **Settings → Privacy & Security → Developer Mode**, launch the build once, then re-open Settings. |
| Pending transaction repeats | Manual finishing without valid verification | Leave **Auto Finish Transactions** enabled, or call `GetTransactions()` and finish manually after server verification. |
| Promoted product URL opens app but no sheet | Store init incomplete or wrong identifiers | Wait for `InitializeStore` success and double-check bundle/product IDs used in the URL. |

## Setup Checklist
1. **Create sandbox testers** – App Store Connect → **Users and Access → Sandbox Testers** → add tester → verify email ([guide](https://help.apple.com/app-store-connect/#/dev8b997bee1)).
2. **Enable Developer Mode** – connect the device to Xcode once, approve the prompt, toggle **Settings → Privacy & Security → Developer Mode**.
3. **Launch a sandbox build** – run the development build from Xcode or install your TestFlight build that uses Essential Kit.
4. **Sign in on device** – open **Settings → Developer → Sandbox** (older iOS: **Settings → App Store → Sandbox Account**) and enter the sandbox Apple ID. Keep your personal App Store ID signed in at the top—sandbox credentials are stored separately.

## Run Purchases
1. Start a purchase flow inside the app.
2. Confirm the alert displays `[Environment: Sandbox]` and complete the flow.
3. Verify your Essential Kit callbacks (`OnTransactionStateChange`, reward logic, etc.) fire as expected.

### Interrupted Purchase Tips
- Simulate network loss, backgrounding, or force-quitting mid-purchase.
- With **Auto Finish Transactions** enabled (default), Essential Kit replays pending transactions automatically on next launch.
- If you disable auto finishing for server checks, call `BillingServices.GetTransactions()` on launch and finish transactions with `BillingServices.FinishTransactions()` manually after verification.
- Apple’s reference: [Testing interrupted purchases](https://help.apple.com/app-store-connect/#/dev7e89e149d?sub=dev55ecec74d).

{% hint style="danger" %}
Most “no products” issues stem from unaccepted agreements or incomplete tax setup in App Store Connect. Confirm those pages first.
{% endhint %}

## Promoted In-App Products
Trigger promoted products via Safari:

```
itms-services://?action=purchaseIntent&bundleId=YOUR_BUNDLE_ID&productIdentifier=YOUR_PRODUCT_IDENTIFIER
```

Replace the placeholders with your bundle ID and App Store product identifier, open the URL on the device, then wait for `InitializeStore` to finish—the promoted sheet will appear automatically.

## Checklist
- [ ] Sandbox tester created, verified, and signed in under **Settings → Developer → Sandbox**.
- [ ] Developer Mode enabled and sandbox build launched successfully.
- [ ] Purchase prompts show `[Environment: Sandbox]`.
- [ ] Interrupted purchase recovery confirmed (auto or manual flow).
- [ ] Promoted purchase URL (if applicable) launches the correct sheet.
