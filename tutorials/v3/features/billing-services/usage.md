---
description: Billing Services allows to monetize your app on iOS and Android platforms
---

# Usage

{% hint style="success" %}
Plugin refers Consumable, Non-Consumable and Subscription purchasable items as Billing Products. This makes the api much easier to understand.&#x20;

\
Each Billing product can have an Id, Name, Description, SubscriptionInfo(Not null, if its a subscription), Payouts etc.
{% endhint %}

Once after you setup and add billing products, you can purchase a product by referring them in code.

Before using any of the billing services features, first make sure if it's available on the running platform with IsAvailable method. This returns true if you are allowed to make purchases on the current platform.

```csharp
BillingServices.IsAvailable()
```

## Events

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

## Billing Products Presentation

Billing Products details can be changed anytime even after the app is published. So the details need to be fetched from stores before presenting them to the user.

### Get Billing Product Details

{% hint style="danger" %}
Note that the order of billing products returned in the event callback can be different from the order you sent. **This is intentional**.\
\
As the products can be removed or added once after your app release in native dashboards, we don't guarantee the order or sort the order in the event callbacks. You need to refer a product with it's Id(GetBillingProductWithId) rather than the array index.
{% endhint %}

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

### Product Offers

After fetching the billing products from store with InitializeStore call, Offers property of IBillingProduct contains an array of offers that can be eligible for the corresponding billing product.

Each offer(BillingProductOffer) contains the following details

* Id - Offer Id that needs to be usef for redeeming an offer
* Category - Category in which this offer falls into. Can be Introductory or Promotional
* Pricing Phases - Phases of how the pricing is calculated during the promotion period. On some platforms (ex: Android) there can be more than one pricing phase.

Each Pricing Phase(BillingProductOfferPricingPhase) gives info about the&#x20;

* Payment Mode - Free Trial or PayAsYouGo or PayUpfront
* Price - Price applied during the period
* Period - Period for which pricing is applied
* Repeat Count - How many times this pricing phase is repeated (can be > 1 for PayAsYouGo and 1 for rest)&#x20;

## Handling Purchases

### Making a purchase

Once you have the details about pricing and description of a product, you can check if your device is ready to make payments. **CanMakePayments** returns true when its fine to make purchases. If purchases are not currently allowed, it returns false.

```csharp
BillingServices.CanMakePayments()
```

Consumable products can be purchased multiple time where as Non-Consumable or Subscription products can be bought only once lifetime or for a period of time. To unlock the content purchased with non-consumable or subscription product you can check if its already bought or not with **IsProductPurchased**

```csharp
//product => "Product you got from OnInitializeStoreComplete event (result.Products)" 
BillingServices.IsProductPurchased(product);
```

If the product is not purchased or if its a consumable product you can proceed with the purchase by calling **BuyProduct**. BuyProduct takes the IBillingProduct instance along with BuyProductOptions(optional).

BuyProductOptions instance can be created as below

```csharp
BuyProductOptions options = new BuyProductOptions.Builder().SetQuantity(1)
                                                           .SetTag("uuid-identifier")
                                                           //.SetOfferRedeemDetails(offerDetails)     
                                                           .Build();
```

```csharp
//product => "Product you got from OnInitializeStoreComplete event (result.Products)" 
BillingServices.BuyProduct(product, options);
```

{% hint style="info" %}
If you only have the Id of the product, you can get IBillingProduct instance with BillingServices.GetBillingProductWithId method
{% endhint %}

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



### Redeem an available offer

Offers that can be applied to a product(IBillingProduct) are fetched after a call to InitializeStore.

Once you have the offers, you can select an offer based on the user profile and redeem it when purchasing.&#x20;

To pass which offer to apply for redemption, you can set it in options(BuyProductOptions) you pass to BuyProduct call.&#x20;

1. Create Offer redeem details based on the platform

{% code title="Create Offer Details" fullWidth="false" %}
```csharp
private BillingProductOfferRedeemDetails GetOfferRedeemDetails(string offerId)
{            
    if(string.IsNullOrEmpty(offerId))
    {
        return null;
    }

    BillingProductOfferRedeemDetails.Builder builder = new BillingProductOfferRedeemDetails.Builder();

    if (Application.platform == RuntimePlatform.Android)
    {
        builder.SetAndroidPlatformProperties(offerId);
    }
    else if (Application.platform == RuntimePlatform.IPhonePlayer)
    {
        builder.SetIosPlatformProperties(offerId, keyId: null, nonce: null, signature: null, timestamp: 0);//Fill in the details here by injecting the values
    }

    return builder.Build();
}
```
{% endcode %}

2. Set the redeem details when building BuyProductOptions

{% code title="Purchase with Offer" fullWidth="false" %}
```csharp
IBillingProduct billingProduct;
//...
BillingProductOfferRedeemDetails offerDetails = GetOfferRedeemDetails("offer-id");
//...
BuyProductOptions options = new BuyProductOptions.Builder().SetQuantity(1)
                                                           .SetOfferRedeemDetails(offerDetails)     
                                                           .Build();
//...                                                           
BillingServices.BuyProduct(billingProduct, options); 
```
{% endcode %}

### Get previous purchases (Restore Purchases)

There are scenarios where&#x20;

* The user uninstalls your game and re-installs later
* The user installs the game on multiple devices

As **Non-Consumable** or **Subscription purchases** need to be maintained across devices and installs, you need a way to fetch the old purchases of the user so that you can unlock the content for the user.

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

#### Force fetch restore purchases

On some native platforms, restore purchases are cached/synced internally. So calling Restore Purchases will return that cached data.&#x20;

But if you have a button to restore purchases (a requirement on iOS) and user clicks it multiple times, chances are that he/she finds some data missing. So, to make sure the data is the exact copy of his purchases, plugin offers option to force fetch the details.

```csharp
BillingServices.RestorePurchases(forceFetch: true);
```

{% hint style="info" %}
On iOS, passing forceFetch as true will ask the user to login into his account.&#x20;

In many cases, data cached/synced by native platforms is up-to date. But if the user intentionally clicks on restore UI, it's good to pass forceFetch as true when requesting restore purchases.
{% endhint %}

## Subscriptions

Subscriptions are a type of Billing Products which are bounded to time. The time period unit can be either week or month or year.

### Fetch Subscription Info (for presentation)

Once you call BillingServices.InitializeStore, if you have subscription billing products, the result in the event callback contains IBillingProduct's with SubscriptionInfo property value.

SubscriptionInfo gives details about&#x20;

* Title - Title of this subscription (if available)
* Period - Period for which this subscription is valid

### Subscription Status Details

Once after purchasing a subscription with BuyProduct, you receive a transaction(IBillingTransaction) which contains SubscriptionStatus.

Status details offers option to fetch RenewalInfo to know if the product is auto renewed or not.

{% hint style="info" %}
Unfortunately, due to lots of limited api's on Android for getting the subscription status, the status details offerings are much limited.
{% endhint %}

## Advanced

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

### External Receipt Verification

If you would like to validate a receipt externally and allocate the entitlements to the user, you need to follow the below workflow.

1. Disable Auto Finish Transactions in Billing Settings (Essential Kit Settings)
2. Once you get a change transaction event, pass the required details to your server
3. On receiving success or failure response from your server, set ReceiptVerificationState of IBillingTransaction to BillingReceiptVerificationState.Success or BillingReceiptVerificationState.Failed
4. Call FinishTransactions method with the updated transaction to manually close the transaction

The details that you may require for your external server can be as follows

* Android
  * Purchase Token - <mark style="color:green;">Get from IBillingTransaction.Receipt</mark>
  * Signature - <mark style="color:green;">Get from IBillingTransaction.RawData</mark> (contains signature key and value)
  * Product Identifier - <mark style="color:green;">Get from IBillingTransaction.Product.PlatformId</mark>
  * Purchase Data - Get from IBillingTransaction.RawData (contains transaction key and value)

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

