# Receipt Verification

## What is Receipt Verification?

Receipt verification validates purchase authenticity to prevent fraud and unauthorized transactions. Essential Kit provides built-in verification states and receipt data for both local and server-side validation in your Unity mobile game.

Why use receipt verification in a Unity mobile game? It protects against fraudulent purchases, ensures transaction integrity, and helps maintain fair monetization across Unity iOS and Unity Android platforms.

## Verification States

Check transaction verification status:

```csharp
using VoxelBusters.EssentialKit;

void CheckVerificationState(IBillingTransaction transaction)
{
    switch (transaction.ReceiptVerificationState)
    {
        case BillingReceiptVerificationState.Success:
            Debug.Log("Receipt verified successfully");
            GrantContent(transaction);
            break;
        case BillingReceiptVerificationState.Failed:
            Debug.Log("Receipt verification failed - possible fraud");
            break;
        case BillingReceiptVerificationState.NotDetermined:
            Debug.Log("Receipt verification not available");
            break;
    }
}
```

This snippet demonstrates checking receipt verification status before granting content.

## Local Receipt Validation

Essential Kit automatically handles basic receipt validation:

```csharp
void ProcessVerifiedTransaction(IBillingTransaction transaction)
{
    if (transaction.TransactionState == BillingTransactionState.Purchased)
    {
        if (transaction.ReceiptVerificationState == BillingReceiptVerificationState.Success)
        {
            Debug.Log("Transaction verified locally");
            ProcessPurchase(transaction);
        }
        else
        {
            Debug.Log("Transaction verification failed, investigate further");
        }
    }
}
```

This snippet shows safe transaction processing with verification checks.

## Receipt Data Access

Access raw receipt data for server validation:

```csharp
void GetReceiptData(IBillingTransaction transaction)
{
    var receiptData = transaction.TransactionReceiptData;
    if (receiptData != null && receiptData.Length > 0)
    {
        Debug.Log($"Receipt data length: {receiptData.Length} bytes");
        // Send to your server for validation
        SendToServerForValidation(receiptData, transaction.TransactionId);
    }
    else
    {
        Debug.Log("No receipt data available");
    }
}
```

This snippet demonstrates accessing receipt data for external validation.

## Server Validation Integration

Integrate with your server validation system:

```csharp
void ValidateWithServer(IBillingTransaction transaction)
{
    var receiptData = transaction.TransactionReceiptData;
    var transactionId = transaction.TransactionId;
    var productId = transaction.Product.Id;
    
    // Create validation request
    var validationRequest = new ReceiptValidationRequest
    {
        ReceiptData = receiptData,
        TransactionId = transactionId,
        ProductId = productId
    };
    
    Debug.Log("Sending receipt for server validation");
    // Send to your validation endpoint
}
```

This snippet shows preparing receipt data for server-side validation.

## Handling Verification Failures

Respond appropriately to verification failures:

```csharp
void HandleVerificationFailure(IBillingTransaction transaction)
{
    if (transaction.ReceiptVerificationState == BillingReceiptVerificationState.Failed)
    {
        Debug.Log("Receipt verification failed - potential fraud detected");
        
        // Log the incident
        LogSecurityEvent(transaction);
        
        // Do not grant content
        Debug.Log("Content not granted due to verification failure");
        
        // Still finish the transaction to avoid repeated processing
        BillingServices.FinishTransactions(new[] { transaction });
    }
}
```

This snippet demonstrates secure handling of verification failures.

📌 **Video Note**: Show Unity demo of receipt verification process and security considerations.