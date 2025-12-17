# Build A Simple Store UI

## Goal
List configured products with localized price text, and gate “Buy” buttons for already-owned non-consumables.

## Actions Required
| Action | Purpose |
|--------|---------|
| BillingServicesInitializeStore | Fetch products from the store |
| BillingServicesGetInitializeStoreSuccessResult | Get `productCount` for looping |
| BillingServicesGetStoreProductInfo | Read localized title/description/price for each product |
| BillingServicesIsProductPurchased | Disable “Buy” for owned non-consumables |

## Variables Needed
- productCount (Int)
- productIndex (Int)
- productId (String)
- localizedTitle (String)
- priceLocalizedText (String)
- isPurchased (Bool)

## Implementation Steps

### 1. InitializeStore (On App Start)
Run `BillingServicesInitializeStore` and wait for `successEvent`.

### 2. GetProductCount
Run `BillingServicesGetInitializeStoreSuccessResult`:
- `productCount` → productCount

### 3. Loop Products
Loop `productIndex` from `0` to `productCount - 1`.

### 4. Read Product Info
Run `BillingServicesGetStoreProductInfo`:
- `productIndex` → productIndex
- Outputs: `productId`, `localizedTitle`, `priceLocalizedText`, `productType`, etc.

Use `localizedTitle` + `priceLocalizedText` to render your UI row.

### 5. Gate Non-Consumable Purchases
If `productType` is non-consumable:
- Run `BillingServicesIsProductPurchased(productId)` to set `isPurchased`.
- If `isPurchased == true`: show “Owned” / disable the Buy button.

## Notes
- `BillingServicesIsProductPurchased` is for non-consumables; don’t use it for consumables.
- After a successful purchase event, refresh your UI row (re-run the check for that `productId`).
