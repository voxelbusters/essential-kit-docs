# FAQ

## Why InitializeStore call returns empty product list in the callback :man\_tipping\_hand:?

This usually happens for two reasons.

* There are no billing products set up in the Essential Kit Settings (Refer [Setup](setup/#billing-products))
* Platform specific issue

| iOS                                                                                                                                       |
| ----------------------------------------------------------------------------------------------------------------------------------------- |
|    :writing\_hand: If you have pending information that needs to be filled in Agreements, **Tax**, and Banking section of iTunes Connect. |
|    :white\_check\_mark: If you haven't accepted the latest Apple Development Programme License Agreement.                                 |

| **Android**                                                                                                                                                                                               |
| --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
|   :x: If you have wrong package name or version code for the side-loaded apk                                                                                                                              |
|    :raised\_back\_of\_hand: If the account is not a valid tester where he/she didn't opt to become a tester from [opt-in testing track link](testing/testing-android.md#testing-with-tester-user-account) |

## **Why** InitializeStore returns products in out of order?

We always recommend to refer a product with its id rather than index. This is for one main reason

> Products can be marked as inactive or delete in the future

If a product is deleted in the future versions, our plugin ordering the products will break older versions. For this reason we always recommend not to rely on the index, but instead on the product id to refer a product.

To get product details for a product id, you can make use of BillingServices.GetProductWithId method.

## **Why on Android, purchases bought with an account are restored  even when logged in with a different account in google play?**

This is usual behaviour on Android.

> Purchases on Android aren't linked to the account which is logged into the google play app. They are "linked to the account which _installs the app"._

So,  if you re-install the app with new account, thats when the restore purchases reflect the new account purchases and stops old purchases.

## **Are the testers charged for testing too?**

On iOS, sandbox testers are not charged any time. For all test flight users, IAP are offered free by default (and they don't need to use sandbox tester accounts too)

On Android, normal testers(who opt-in through test track url) are charged and will be refunded in 14 days. Where as[ license testers](testing/testing-android.md#testing-with-application-licensing-license-tester) won't be charged anytime.

&#x20;

## How to do receipt verification with Appodeal?

```csharp
IBillingTransaction transaction; //Get this value from the Transaction Change callback
//...
IDictionary rawData =  (IDictionary)ExternalServiceProvider.JsonServiceProvider.FromJson(transaction.RawData);
var originalTransaction = rawData != null ? rawData["transaction"] : null;
var signature = rawData != null ? rawData["signature"] : null;

#if UNITY_ANDROID
    var additionalParams = new Dictionary<string, string> { { "key1", "value1" }, { "key2", "value2" } };

    var purchase = new PlayStoreInAppPurchase.Builder(transaction.Product.Type == BillingProductType.Subscription ? PlayStorePurchaseType.Subs : PlayStorePurchaseType.InApp)
        .WithAdditionalParameters(additionalParams)
        .WithPurchaseTimestamp(new DateTimeOffset(transaction.DateUTC).ToUnixTimeSeconds())
        .WithDeveloperPayload("payload")
        .WithPurchaseToken(transaction.Receipt)
        .WithPurchaseData(originalTransaction)
        .WithPublicKey(BillingServices.UnitySettings.AndroidProperties.PublicKey)
        .WithSignature(signature)
        .WithCurrency(transaction.Product.Price.Code)
        .WithOrderId(transaction.Id)
        .WithPrice($"{transaction.Product.Price.Value}")
        .WithSku(transaction.Product.PlatformId)
        .Build();

    Appodeal.ValidatePlayStoreInAppPurchase(purchase, this);
#elif UNITY_IOS
    var additionalParams = new Dictionary<string, string> { { "key1", "value1" }, { "key2", "value2" } };

    var purchase = new AppStoreInAppPurchase.Builder(transaction.Product.Type == BillingProductType.Subscription ? AppStorePurchaseType.AutoRenewableSubscription : transaction.Product.Type == BillingProductType.Consumable ? AppStorePurchaseType.Consumable : AppStorePurchaseType.NonConsumable)
        .WithAdditionalParameters(additionalParams)
        .WithTransactionId(transaction.Id)
        .WithProductId(transaction.Product.PlatformId)
        .WithCurrency(transaction.Product.Price.Code)
        .WithPrice($"{transaction.Product.Price.Value}")
        .Build();

    Appodeal.ValidateAppStoreInAppPurchase(purchase, this);
#endif
```



&#x20;   &#x20;





