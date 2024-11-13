---
description: Billing Services allows to monetize your app on iOS and Android platforms
---

# Usage

Once after you setup and add billing products, you can purchase a product by referring them in code.

Before using any of the billing services features, first make sure if it's available on the running platform with IsAvailable method. This returns true if you are allowed to make purchases on the current platform.

```csharp
BillingServices.IsAvailable()
```

### Events

Once you see that billing services are available, you should register for the billing services events.

```csharp
private void OnEnable()
{
    // register for events
    BillingServices.OnInitializeStoreComplete   += OnInitializeStoreComplete;
    BillingServices.OnTransactionStateChange    += OnTransactionStateChange;
    BillingServices.OnRestorePurchasesComplete  += OnRestorePurchasesComplete;
}

private void OnDisable()
{
    // unregister from events
    BillingServices.OnInitializeStoreComplete   -= OnInitializeStoreComplete;
    BillingServices.OnTransactionStateChange    -= OnTransactionStateChange;
    BillingServices.OnRestorePurchasesComplete  -= OnRestorePurchasesComplete;
}
```

| Event Name                 | Description                                                                |
| -------------------------- | -------------------------------------------------------------------------- |
| OnInitializeStoreComplete  | Event triggered when products are fetched from the store                   |
| OnTransactionStateChange   | Event triggered when there is a change in state for an ongoing transaction |
| OnRestorePurchasesComplete | Event triggered once restored products are available                       |

Events are triggered based on an action initiated by the plugin's api calls, asynchronously. For ex: Calling InitializeStore triggers OnInitializeStoreComplete with the product details if it's successful.

### Get Billing Product Details

After event registration, you need to call **InitializeStore** to fetch the complete details of the in-app purchase billing products.

This call fetches the details(you set in iTunes connect and google play) and triggers **BillingServices.OnInitializeStoreComplete** callback with the details.&#x20;

{% hint style="info" %}
Optionally, you can pass your own BillingProducts created at runtime to InitializeStore call. This will be handy if you have an API to fetch platform id's runtime.
{% endhint %}

```csharp
BillingServices.InitializeStore();
```

```csharp
// Register for the BillingServices.OnInitializeStoreComplete event
// ...

private void OnInitializeStoreComplete(BillingServicesInitializeStoreResult result, Error error)
{
    if (error == null)
    {
        // update UI
        // show console messages
        var     products    = result.Products;
        Debug.Log("Store initialized successfully.");
        Debug.Log("Total products fetched: " + products.Length);
        Debug.Log("Below are the available products:");
        for (int iter = 0; iter < products.Length; iter++)
        {
            var     product = products[iter];
            Debug.Log(string.Format("[{0}]: {1}", iter, product));
        }
    }
    else
    {
        Debug.Log("Store initialization failed with error. Error: " + error);
    }

    var     invalidIds  = result.InvalidProductIds;
    Debug.Log("Total invalid products: " + invalidIds.Length);
    if (invalidIds.Length > 0)
    {
        Debug.Log("Here are the invalid product ids:");
        for (int iter = 0; iter < invalidIds.Length; iter++)
        {
            Debug.Log(string.Format("[{0}]: {1}", iter, invalidIds[iter]));
        }
    }
}
```

{% hint style="info" %}
The platform product id's you set in Essential Kit Settings will be used internally by the plugin to fetch the complete details of the product on current platform.&#x20;
{% endhint %}

### Making a purchase

Once you have the details about pricing and description of a product, you can check if your device is ready to make payments. **CanMakePayments** returns true when its fine to make purchases. If purchases are not currently allowed, it returns false.

```csharp
BillingServices.CanMakePayments()
```

Consumable products can be purchased multiple time where as Non-Consumable products can be bought only once. To unlock the content purchased with non-consumable product you can check if its already bought or not with **IsProductPurchased**

```csharp
//product => "Product you got from OnInitializeStoreComplete event (result.Products)" 
BillingServices.IsProductPurchased(product);
```

If the product is not purchased or if its a consumable product you can proceed with the purchase by calling **BuyProduct**. BuyProduct takes the BillingProduct instance you got from **OnInitializeStoreComplete** event.

```csharp
//product => "Product you got from OnInitializeStoreComplete event (result.Products)" 
BillingServices.BuyProduct(product);
```

**BuyProduct** shows native purchase dialogs to proceed with the purchase and fires **BillingServices.OnTransactionStateChange** event callback  during the purchase process.

```csharp
private void OnTransactionStateChange(BillingServicesTransactionStateChangeResult result)
{
    var     transactions    = result.Transactions;
    for (int iter = 0; iter < transactions.Length; iter++)
    {
        var     transaction = transactions[iter];
        switch (transaction.TransactionState)
        {
            case BillingTransactionState.Purchased:
                Debug.Log(string.Format("Buy product with id:{0} finished successfully.", transaction.Payment.ProductId));
                break;

            case BillingTransactionState.Failed:
                Debug.Log(string.Format("Buy product with id:{0} failed with error. Error: {1}", transaction.Payment.ProductId, transaction.Error));
                break;
        }
    }
}
```

Once you **BillingServices.OnTransactionStateChange** event fired, you will get a list of transactions that are currently getting processed. You can check if the transaction state is **BillingTransactionState.Purchased** or **BillingTransactionState.Failed.**

If its **Purchased** state, you can proceed with unlocking the content to the user. If **Failed,** It could be because the user cancelled the payment or due a failed transaction. You can get more details from Error property of a transaction.

### Get previous purchases (Restore Purchases)

There are scenarios where&#x20;

* The user uninstalls your game and re-installs later
* The user installs the game on multiple devices

As **Non-Consumable product purchases** need to be maintained across devices and installs, you need a way to fetch the old purchases of the user so that you can unlock the content for the user.

This can be achieved through **RestorePurchases** call.

```csharp
BillingServices.RestorePurchases();
```

Calling RestorePurchases fetches the old purchase transactions linked to the user account and fires **BillingServices.OnRestorePurchasesComplete** event with all purchase details.

```csharp
private void OnRestorePurchasesComplete(BillingServicesRestorePurchasesResult result, Error error)
{
    if (error == null)
    {
        var     transactions    = result.Transactions;
        Debug.Log("Request to restore purchases finished successfully.");
        Debug.Log("Total restored products: " + transactions.Length);
        for (int iter = 0; iter < transactions.Length; iter++)
        {
            var     transaction = transactions[iter];
            Debug.Log(string.Format("[{0}]: {1}", iter, transaction.Payment.ProductId));
        }
    }
    else
    {
        Debug.Log("Request to restore purchases failed with error. Error: " +  error);
    }
}
```

Once you get the old purchase transactions, you can unlock the content for the user.

{% hint style="danger" %}
On iOS, it's required to have an explicit button to restore purchases as per Apple guidelines.
{% endhint %}

> It's always good to call Restore Purchases once you are done with **InitializeStore** call as the user will be available with unlocked content if he/she has purchased any earlier.

### Manually handling transactions (Auto Finish Transactions disabled)

There are scenarios where you want to validate a purchase receipt on your server and unlock the content to the user. If you have such requirement, you need to **disable** **"Auto Finish Transactions"** in Billing Services settings and close the transactions manually.

**GetTransactions** gives the list of all pending transactions and you need to&#x20;

1. Process each transaction returned from **GetTransactions**
2. Pass the transaction receipt details to your backend server
3. Set **ReceiptVerificationState** of the transaction to **BillingReceiptVerificationState.Success** or **BillingReceiptVerificationState.Failed**
4. Call **FinishTransactions** with the updated transaction verification details

{% hint style="success" %}
If you have "Auto Finish Transactions"  enabled in Essential Kit Settings -> Billing Services, you don't need to call GetTransactions as we handle this automatically.
{% endhint %}

```csharp
// Fetch all pending transactions
var     transactions   = BillingServices.GetTransactions();
// Process each transaction
foreach (var each in transactions)
{
    // Verify the receipt with your server - This is an async call usually
    // Set the ReceiptVerificationState to Success or Failed
}

// Call Finish Transactions to clear the pending transaction queue
BillingServices.FinishTransactions(transactions);
```

## Platform Specific (Advanced)

### Android

Have a look at the below table for the BillingTransaction to [Google Play purchase response](https://developer.android.com/google/play/billing/billing\_reference#getBuyIntent) mapping.

| Property Name of BillingTransaction | Mapped Property on Native Platform  |
| ----------------------------------- | ----------------------------------- |
| Id                                  | INAPP\_PURCHASE\_DATA.orderId       |
| Receipt                             | INAPP\_PURCHASE\_DATA.purchaseToken |
| Payment.ProductId                   | INAPP\_PURCHASE\_DATA.productId     |
| AndroidProperties.PurchaseData      | INAPP\_PURCHASE\_DATA               |
| AndroidProperties.Signature         | INAPP\_DATA\_SIGNATURE              |

