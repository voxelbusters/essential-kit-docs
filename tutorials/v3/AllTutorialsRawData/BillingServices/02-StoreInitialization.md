# Store Initialization

## What is Store Initialization?

Store initialization is the process of loading product information from the native app stores (iOS App Store or Google Play Store) into your Unity mobile game. This retrieves localized product details like prices, descriptions, and availability status.

Why use store initialization in a Unity mobile game? It ensures your game displays current, localized product information without hardcoding prices or descriptions, and validates that your products are properly configured in the store.

## InitializeStore API

The primary method for initializing the store:

```csharp
using VoxelBusters.EssentialKit;

public class ShopManager : MonoBehaviour 
{
    void Start() 
    {
        // Subscribe to completion event
        BillingServices.OnInitializeStoreComplete += OnStoreInitialized;
        
        // Initialize store with configured products
        BillingServices.InitializeStore();
        Debug.Log("Store initialization started");
    }
    
    private void OnStoreInitialized(BillingServicesInitializeStoreResult result, Error error)
    {
        if (error == null)
        {
            Debug.Log($"Store initialized successfully. Products loaded: {result.Products.Length}");
        }
        else
        {
            Debug.Log($"Store initialization failed: {error}");
        }
    }
}
```

This snippet initializes the store using products configured in Essential Kit settings and logs the result.

## Accessing Loaded Products

After successful initialization, access products through the static properties:

```csharp
void DisplayProducts()
{
    var products = BillingServices.Products;
    foreach (var product in products)
    {
        Debug.Log($"Product: {product.Id} - {product.LocalizedTitle} - {product.Price}");
    }
}
```

This snippet shows how to iterate through loaded products and display their localized information.

## Initialization Events

The `OnInitializeStoreComplete` event provides detailed results:

```csharp
private void OnStoreInitialized(BillingServicesInitializeStoreResult result, Error error)
{
    if (error == null)
    {
        // Successfully loaded products
        var validProducts = result.Products;
        var invalidIds = result.InvalidProductIds;
        
        Debug.Log($"Valid products: {validProducts.Length}");
        Debug.Log($"Invalid product IDs: {invalidIds.Length}");
    }
    else
    {
        Debug.Log($"Initialization failed with error: {error}");
    }
}
```

This snippet demonstrates handling both successful initialization and error cases.

📌 **Video Note**: Show Unity demo clip of store initialization process with console output showing loaded products.