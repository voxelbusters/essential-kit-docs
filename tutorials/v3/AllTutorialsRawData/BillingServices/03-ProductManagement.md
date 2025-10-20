# Product Management

## What is Product Management?

Product management involves working with billing products after they're loaded from the store. This includes retrieving specific products, checking their properties, and understanding different product types in your Unity mobile game.

Why use product management in a Unity mobile game? It allows you to dynamically access product information, check availability, and present appropriate purchasing options to players.

## Product Types

Essential Kit supports three main product types:

```csharp
using VoxelBusters.EssentialKit;

void CheckProductTypes()
{
    var products = BillingServices.Products;
    foreach (var product in products)
    {
        switch (product.ProductType)
        {
            case BillingProductType.Consumable:
                Debug.Log($"{product.Id} is consumable (can be purchased repeatedly)");
                break;
            case BillingProductType.NonConsumable:
                Debug.Log($"{product.Id} is non-consumable (purchased once)");
                break;
            case BillingProductType.Subscription:
                Debug.Log($"{product.Id} is subscription (recurring purchase)");
                break;
        }
    }
}
```

This snippet demonstrates how to identify different product types for appropriate handling.

## Retrieving Specific Products

Get individual products by their ID:

```csharp
void GetSpecificProduct()
{
    var coinPackage = BillingServices.GetProductWithId("com.mygame.coins100");
    if (coinPackage != null)
    {
        Debug.Log($"Found product: {coinPackage.LocalizedTitle}");
        Debug.Log($"Price: {coinPackage.Price}");
    }
    else
    {
        Debug.Log("Product not found or store not initialized");
    }
}
```

This snippet shows how to retrieve and validate a specific product by ID.

## Product Properties

Access detailed product information:

```csharp
void DisplayProductDetails(IBillingProduct product)
{
    Debug.Log($"ID: {product.Id}");
    Debug.Log($"Title: {product.LocalizedTitle}");
    Debug.Log($"Description: {product.LocalizedDescription}");
    Debug.Log($"Price: {product.Price}");
    Debug.Log($"Product Type: {product.ProductType}");
}
```

This snippet demonstrates accessing all key properties of a billing product.

## Checking Product Ownership

For non-consumable products, check if already purchased:

```csharp
void CheckProductOwnership()
{
    bool isPremiumOwned = BillingServices.IsProductPurchased("com.mygame.premium");
    if (isPremiumOwned)
    {
        Debug.Log("User owns premium features");
    }
    else
    {
        Debug.Log("Premium features not purchased");
    }
}
```

This snippet shows how to check ownership status for non-consumable products.

📌 **Video Note**: Show Unity demo clip demonstrating product retrieval and property inspection in the game UI.