# Transaction Handling

## What is Transaction Handling?

Transaction handling manages the complete lifecycle of purchase transactions, including pending transactions, completion acknowledgment, and cleanup. This ensures reliable purchase processing in your Unity mobile game.

Why use proper transaction handling in a Unity mobile game? It prevents duplicate purchases, ensures content delivery even after app crashes, and maintains transaction integrity across Unity cross-platform deployments.

## Transaction States

Understanding transaction states is crucial for proper handling:

```csharp
using VoxelBusters.EssentialKit;

void HandleTransactionState(IBillingTransaction transaction)
{
    switch (transaction.TransactionState)
    {
        case BillingTransactionState.Purchasing:
            Debug.Log("Transaction in progress...");
            break;
        case BillingTransactionState.Purchased:
            Debug.Log("Transaction completed successfully");
            break;
        case BillingTransactionState.Failed:
            Debug.Log($"Transaction failed: {transaction.Error}");
            break;
        case BillingTransactionState.Deferred:
            Debug.Log("Transaction pending approval");
            break;
        case BillingTransactionState.Refunded:
            Debug.Log("Transaction was refunded");
            break;
    }
}
```

This snippet demonstrates handling all possible transaction states.

## Retrieving Pending Transactions

Check for unfinished transactions:

```csharp
void CheckPendingTransactions()
{
    var pendingTransactions = BillingServices.GetTransactions();
    Debug.Log($"Pending transactions: {pendingTransactions.Length}");
    
    foreach (var transaction in pendingTransactions)
    {
        Debug.Log($"Pending: {transaction.Product.Id} - {transaction.TransactionState}");
    }
}
```

This snippet shows how to retrieve and inspect pending transactions.

## Transaction Completion

Manually complete transactions when auto-finish is disabled:

```csharp
void CompleteTransactions()
{
    var transactions = BillingServices.GetTransactions();
    var completableTransactions = new List<IBillingTransaction>();
    
    foreach (var transaction in transactions)
    {
        if (transaction.TransactionState == BillingTransactionState.Purchased)
        {
            completableTransactions.Add(transaction);
        }
    }
    
    if (completableTransactions.Count > 0)
    {
        BillingServices.FinishTransactions(completableTransactions.ToArray());
        Debug.Log($"Finished {completableTransactions.Count} transactions");
    }
}
```

This snippet demonstrates manual transaction completion.

## Error Handling

Handle transaction errors appropriately:

```csharp
void HandleTransactionError(IBillingTransaction transaction)
{
    if (transaction.TransactionState == BillingTransactionState.Failed)
    {
        var errorCode = (BillingServicesErrorCode)transaction.Error.Code;
        switch (errorCode)
        {
            case BillingServicesErrorCode.UserCancelled:
                Debug.Log("User cancelled the purchase");
                break;
            case BillingServicesErrorCode.ProductNotAvailable:
                Debug.Log("Product not available for purchase");
                break;
            case BillingServicesErrorCode.NetworkError:
                Debug.Log("Network error during purchase");
                break;
            default:
                Debug.Log($"Purchase error: {errorCode}");
                break;
        }
    }
}
```

This snippet shows proper error handling using BillingServicesErrorCode enum.

## Receipt Information

Access transaction receipt data:

```csharp
void ProcessTransactionReceipt(IBillingTransaction transaction)
{
    if (transaction.TransactionState == BillingTransactionState.Purchased)
    {
        Debug.Log($"Transaction ID: {transaction.TransactionId}");
        Debug.Log($"Receipt verification: {transaction.ReceiptVerificationState}");
        
        // Use receipt data for server validation if needed
        var receiptData = transaction.TransactionReceiptData;
        Debug.Log("Receipt data available for validation");
    }
}
```

This snippet demonstrates accessing receipt information for validation purposes.

📌 **Video Note**: Show Unity demo of transaction lifecycle management including error scenarios.