# Purchase Restoration

## What is Purchase Restoration?

Purchase restoration allows users to recover previously purchased non-consumable products and subscriptions after reinstalling your Unity mobile game or switching devices. This is a requirement for App Store compliance and essential for user satisfaction.

Why use purchase restoration in a Unity mobile game? It ensures users don't lose premium content they've purchased, improves user experience, and meets App Store guidelines for restorable purchases in Unity iOS and Unity Android applications.

## Restore Purchases API

Initiate purchase restoration:

```csharp
using VoxelBusters.EssentialKit;

public class RestoreManager : MonoBehaviour
{
    void Start()
    {
        BillingServices.OnRestorePurchasesComplete += OnRestoreComplete;
    }
    
    public void RestoreUserPurchases()
    {
        // Basic restore (silent, no login prompt)
        BillingServices.RestorePurchases(forceRefresh: false);
        Debug.Log("Restore purchases initiated");
    }
    
    public void ForceRestoreWithLogin()
    {
        // Force refresh (may show login prompt on iOS)
        BillingServices.RestorePurchases(forceRefresh: true);
        Debug.Log("Force restore with login initiated");
    }
}
```

This snippet demonstrates both silent and forced restore operations.

## Handling Restore Results

Process restoration completion:

```csharp
private void OnRestoreComplete(BillingServicesRestorePurchasesResult result, Error error)
{
    if (error == null)
    {
        var restoredTransactions = result.Transactions;
        Debug.Log($"Restore completed. Transactions found: {restoredTransactions.Length}");
        
        foreach (var transaction in restoredTransactions)
        {
            Debug.Log($"Restored: {transaction.Product.Id}");
            GrantRestoredContent(transaction);
        }
    }
    else
    {
        Debug.Log($"Restore failed: {error}");
        HandleRestoreError(error);
    }
}
```

This snippet shows comprehensive restore result handling.

## Tagged Restoration

Restore purchases for specific users:

```csharp
void RestoreForSpecificUser(string userId)
{
    // Restore purchases associated with a specific user tag
    BillingServices.RestorePurchases(forceRefresh: false, tag: userId);
    Debug.Log($"Restoring purchases for user: {userId}");
}
```

This snippet demonstrates user-specific purchase restoration.

## Granting Restored Content

Safely grant restored purchases:

```csharp
void GrantRestoredContent(IBillingTransaction transaction)
{
    if (transaction.TransactionState == BillingTransactionState.Purchased)
    {
        var product = transaction.Product;
        
        switch (product.ProductType)
        {
            case BillingProductType.NonConsumable:
                Debug.Log($"Restoring non-consumable: {product.Id}");
                UnlockPremiumFeature(product.Id);
                break;
                
            case BillingProductType.Subscription:
                Debug.Log($"Restoring subscription: {product.Id}");
                ActivateSubscription(product.Id);
                break;
                
            case BillingProductType.Consumable:
                Debug.Log("Consumables are not restorable");
                break;
        }
    }
}
```

This snippet demonstrates proper content restoration for different product types.

## Error Handling

Handle restoration errors gracefully:

```csharp
void HandleRestoreError(Error error)
{
    var errorCode = (BillingServicesErrorCode)error.Code;
    
    switch (errorCode)
    {
        case BillingServicesErrorCode.UserCancelled:
            Debug.Log("User cancelled restore operation");
            break;
        case BillingServicesErrorCode.NetworkError:
            Debug.Log("Network error during restore - retry later");
            break;
        case BillingServicesErrorCode.StoreNotInitialized:
            Debug.Log("Store not initialized - initialize first");
            break;
        default:
            Debug.Log($"Restore error: {errorCode}");
            break;
    }
}
```

This snippet shows proper error handling using BillingServicesErrorCode enum.

## UI Integration

Provide restore functionality in your game UI:

```csharp
public void OnRestoreButtonClicked()
{
    // Show loading UI
    ShowRestoreLoadingUI();
    
    // Start restore process
    BillingServices.RestorePurchases(forceRefresh: true);
}

void ShowRestoreLoadingUI()
{
    Debug.Log("Showing restore in progress UI");
    // Update UI to show restore is in progress
}
```

This snippet demonstrates integrating restore functionality with game UI.

📌 **Video Note**: Show Unity demo of restore purchases button and the complete restoration flow.