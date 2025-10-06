---
description: In-App purchases setup for Android platform
---

# Android

{% hint style="warning" %}
To enable billing on Android, you first need to upload your app to play store in any of alpha/beta / internal track's.
{% endhint %}

## Create In-App products

Once after  uploading the app and publish in any of the tracks, you will get an option to add in-app products.&#x20;

![Create in-app product from Monetise -> Products -> In-App products](../../../.gitbook/assets/BillingServicesInAppAndroidCreate.gif)



<figure><img src="../../../.gitbook/assets/android-platform-identifiers.jpg" alt=""><figcaption><p>Identifiers you need to fill for Platform Id's in Essential Kit</p></figcaption></figure>



## Public Key

> ### Public key needs to be set in the [Essential Kit Settings](../README.md#configuration-properties) and can be obtained from Monetisation Setup of Monetise section.

###

![Public key needs to be set in Billing Services under Android in Essential Kit Settings](../../../.gitbook/assets/BillingServicesInAppAndroidPublicKey.png)

{% hint style="info" %}
Public key is used internally by the plugin to validate a purchased receipt on Android
{% endhint %}
