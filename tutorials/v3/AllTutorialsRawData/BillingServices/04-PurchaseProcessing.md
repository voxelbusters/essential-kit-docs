# Purchase Processing

## What is Purchase Processing?

Purchase processing is the core functionality that initiates and handles in-app purchase transactions in your Unity mobile game. This involves validating payment authorization, starting purchase flows, and managing the purchase lifecycle.

Why use purchase processing in a Unity mobile game? It enables monetization through secure, native store transactions while providing a smooth user experience across Unity iOS and Unity Android platforms.

## Payment Authorization

Before processing purchases, check if the user can make payments:

```csharp
using VoxelBusters.EssentialKit;

public class PurchaseManager : MonoBehaviour
{
    void AttemptPurchase(string productId)
    {
        if (BillingServices.CanMakePayments())
        {
            InitiatePurchase(productId);
            Debug.Log("Payment authorization verified, starting purchase");
        }
        else
        {
            Debug.Log("User cannot make payments (parental controls, etc.)");
        }
    }
}
```

This snippet checks payment authorization before initiating a purchase request.

## Basic Purchase Flow

Start a purchase transaction:

```csharp
void InitiatePurchase(string productId)
{
    var product = BillingServices.GetProductWithId(productId);
    if (product != null)
    {
        BillingServices.BuyProduct(product);
        Debug.Log($"Purchase initiated for: {product.LocalizedTitle}");
    }
    else
    {
        Debug.Log("Product not found");
    }
}
```

This snippet demonstrates initiating a purchase for a specific product.

## Purchase with Options

For advanced scenarios, use purchase options:

```csharp
void PurchaseWithOptions(string productId)
{
    var options = new BuyProductOptions.Builder()
        .SetQuantity(5)
        .SetTag("player_id_12345")
        .Build();
        
    BillingServices.BuyProduct(productId, options);
    Debug.Log("Purchase initiated with custom options");
}
```

This snippet shows how to purchase with quantity and user identification.

## Transaction State Handling

Monitor purchase progress through transaction events:

```csharp
void OnEnable()
{
    BillingServices.OnTransactionStateChange += OnTransactionChanged;
}

private void OnTransactionChanged(BillingServicesTransactionStateChangeResult result)
{
    foreach (var transaction in result.Transactions)
    {
        switch (transaction.TransactionState)
        {
            case BillingTransactionState.Purchasing:
                Debug.Log($"Processing purchase for {transaction.Product.Id}");
                break;
            case BillingTransactionState.Purchased:
                Debug.Log($"Purchase successful: {transaction.Product.Id}");
                GrantPurchasedContent(transaction);
                break;
            case BillingTransactionState.Failed:
                Debug.Log($"Purchase failed: {transaction.Error}");
                break;
        }
    }
}
```

This snippet demonstrates comprehensive transaction state monitoring.

## Purchase Validation

Always validate purchases before granting content:

```csharp
void GrantPurchasedContent(IBillingTransaction transaction)
{
    if (transaction.TransactionState == BillingTransactionState.Purchased)
    {
        // Grant the purchased content to the user
        Debug.Log($"Granting content for: {transaction.Product.Id}");
        // Add your content granting logic here
    }
}
```

This snippet shows how to safely validate and grant purchased content.

📌 **Video Note**: Show Unity demo of complete purchase flow from button tap to content delivery.