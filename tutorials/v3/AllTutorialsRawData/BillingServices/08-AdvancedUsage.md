# Advanced Usage

## Runtime Initialization with Custom Settings

For advanced scenarios, you can initialize BillingServices with custom settings at runtime instead of using the default Essential Kit configuration. This provides complete control over product definitions and billing behavior.

### Step 1: Create BillingServicesUnitySettings

First, create a custom settings object:

```csharp
using VoxelBusters.EssentialKit;

void CreateCustomBillingSettings()
{
    // Create Android properties
    var androidProperties = new AndroidPlatformProperties();
    
    // Create product definitions programmatically
    var products = new BillingProductDefinition[]
    {
        new BillingProductDefinition("premium_upgrade", BillingProductType.NonConsumable),
        new BillingProductDefinition("coin_pack_100", BillingProductType.Consumable),
        new BillingProductDefinition("monthly_vip", BillingProductType.Subscription)
    };
    
    // Create custom settings
    var customSettings = new BillingServicesUnitySettings(
        isEnabled: true,
        products: products,
        autoFinishTransactions: true,
        androidProperties: androidProperties
    );
    
    Debug.Log("Custom billing settings created");
}
```

### Step 2: Configure Product Definitions

Set up detailed product configurations:

```csharp
BillingProductDefinition CreateDetailedProduct()
{
    var productDef = new BillingProductDefinition(
        id: "premium_features",
        productType: BillingProductType.NonConsumable
    );
    
    // Set platform-specific IDs if different
    productDef.SetPlatformId(RuntimePlatform.IPhonePlayer, "com.mygame.premium.ios");
    productDef.SetPlatformId(RuntimePlatform.Android, "com.mygame.premium.android");
    
    // Configure metadata
    productDef.Title = "Premium Features";
    productDef.Description = "Unlock all premium game features";
    
    Debug.Log($"Configured product: {productDef.Id}");
    return productDef;
}
```

### Step 3: Initialize with Custom Settings

Initialize BillingServices with your custom configuration:

```csharp
void InitializeWithCustomSettings()
{
    // Create products array
    var products = new BillingProductDefinition[]
    {
        CreateDetailedProduct(),
        new BillingProductDefinition("energy_refill", BillingProductType.Consumable),
        new BillingProductDefinition("battle_pass", BillingProductType.Subscription)
    };
    
    // Create settings
    var settings = new BillingServicesUnitySettings(
        isEnabled: true,
        products: products,
        autoFinishTransactions: false, // Manual transaction finishing
        androidProperties: new AndroidPlatformProperties()
    );
    
    // Initialize with custom settings
    BillingServices.Initialize(settings);
    Debug.Log("BillingServices initialized with custom settings");
    
    // Now initialize the store
    BillingServices.InitializeStore();
}
```

### Step 4: Runtime Product Management

Dynamically manage products at runtime:

```csharp
void InitializeStoreWithRuntimeProducts()
{
    // Create products based on server configuration
    var serverProducts = GetProductsFromServer();
    var productDefinitions = ConvertToProductDefinitions(serverProducts);
    
    // Initialize store with dynamic products
    BillingServices.InitializeStore(productDefinitions);
    Debug.Log($"Store initialized with {productDefinitions.Length} runtime products");
}

BillingProductDefinition[] ConvertToProductDefinitions(ServerProduct[] serverProducts)
{
    var definitions = new List<BillingProductDefinition>();
    
    foreach (var serverProduct in serverProducts)
    {
        var definition = new BillingProductDefinition(
            id: serverProduct.Id,
            productType: serverProduct.Type
        );
        
        definition.Title = serverProduct.DisplayName;
        definition.Description = serverProduct.Description;
        definitions.Add(definition);
    }
    
    return definitions.ToArray();
}
```

## Advanced Error Handling

Implement comprehensive error handling for production apps:

```csharp
void SetupAdvancedErrorHandling()
{
    BillingServices.OnInitializeStoreComplete += HandleStoreInitialization;
    BillingServices.OnTransactionStateChange += HandleTransactionErrors;
}

void HandleStoreInitialization(BillingServicesInitializeStoreResult result, Error error)
{
    if (error != null)
    {
        var errorCode = (BillingServicesErrorCode)error.Code;
        switch (errorCode)
        {
            case BillingServicesErrorCode.NetworkError:
                Debug.Log("Network error - will retry store initialization");
                StartCoroutine(RetryStoreInitialization());
                break;
            case BillingServicesErrorCode.BillingNotAvailable:
                Debug.Log("Billing not available - disabling IAP features");
                DisableIAPFeatures();
                break;
            default:
                Debug.Log($"Store initialization failed: {errorCode}");
                break;
        }
    }
}
```

## Manual Transaction Management

For server validation scenarios, manage transactions manually:

```csharp
void SetupManualTransactionHandling()
{
    // Ensure auto-finish is disabled in settings
    var settings = new BillingServicesUnitySettings(
        isEnabled: true,
        products: GetProductDefinitions(),
        autoFinishTransactions: false // Disable auto-finish
    );
    
    BillingServices.Initialize(settings);
    BillingServices.OnTransactionStateChange += HandleTransactionsManually;
}

void HandleTransactionsManually(BillingServicesTransactionStateChangeResult result)
{
    foreach (var transaction in result.Transactions)
    {
        if (transaction.TransactionState == BillingTransactionState.Purchased)
        {
            // Validate with server before finishing
            ValidateTransactionWithServer(transaction, OnServerValidationComplete);
        }
    }
}

void OnServerValidationComplete(IBillingTransaction transaction, bool isValid)
{
    if (isValid)
    {
        GrantPurchasedContent(transaction);
        BillingServices.FinishTransactions(new[] { transaction });
        Debug.Log("Transaction validated and finished");
    }
    else
    {
        Debug.Log("Transaction validation failed - not finishing");
    }
}
```

📌 **Video Note**: Show Unity demo of advanced initialization process and custom product configuration.