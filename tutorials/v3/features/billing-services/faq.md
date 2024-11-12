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

## **Are the testers charged for a testing too?**

On iOS, sandbox testers are not charged any time. For all test flight users, IAP are offered free by default (and they don't need to use sandbox tester accounts too)

On Android, normal testers(who opt-in through test track url) are charged and will be refunded in 14 days. Where as[ license testers](testing/testing-android.md#testing-with-application-licensing-license-tester) won't be charged anytime.

&#x20;

&#x20;   &#x20;





