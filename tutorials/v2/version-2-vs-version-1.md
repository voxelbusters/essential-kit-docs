---
description: Improvements and other changes in Version2 compared to Version 1
---

# Version 2 vs Version 1

## Improvements

#### Less Overload

Complete plugin is [ASMDEF](https://docs.unity3d.com/Manual/ScriptCompilationAssemblyDefinitionFiles.html) compatible. This avoids getting our scripts getting compiled for every change in your project leading to a faster compilation

#### Faster Native Communication

From V2, we communicate to native libraries directly instead of earlier JSON conversion through UnitySendMessage. This helps in efficient data transfer to native libraries.

#### Latest Compatibility

V2 is currently compatible with Android 11 and iOS 14

{% hint style="success" %}
Android Billing now uses [Google Play Billing Library](https://developer.android.com/google/play/billing/integrate) compared to AIDL implementation in v1
{% endhint %}

#### Better API

We did a full write from scratch for V2 and considering the feedback we had from past years we made the API to adapt for better workflows. Also, there are lots of utility functions added for easier usage.

#### Editor Automation

V2 auto saves the settings and only applies the setting changes on export. This avoids saving the settings on every change.

#### Native Platform Automation

V2 adds required capabilities on iOS automatically and this avoids to set it in xcode on export.

#### Stripping Mode Compatibility

We support all levels of stripping as we generate the required link.xml files. This makes the plugin better compatible with your stripping settings.

#### Additional Features

Added [**Deep Links**](deep-link-services/overview.md) and [**Android InApp Reviews** ](rate-my-app/overview.md)as new features along with the below extensions.

* Support for accessing player profiles from you backend server (LoadServerCredentials)
* API's to access notifications for better control (Access scheduled and displayed notifications)
* Utilities to handle fallback cases (when user don't accept permissions now you can open the application settings, Detailed errors)

#### Providing Detailed Results on Each Platform

In V1, we clipped the data to make sure same results exist on every platform we support. From V2, this is modified to give the exact data the platform supports as many of you requested for it.&#x20;

For ex: iOS supports success status of a Mail sharing activity, where as on Android it doesn't provide any. Now in V2, you can access the status on iOS platform which isn't possible on V1 earlier.

#### Consistent Callbacks

We revised the API to have callbacks to follow a standard format. Also this allows us to extend the result data with any additional data in the future.

#### Misc

V2 comes with detailed setup tutorials for each platform, FAQ's ([Video tutorials](https://youtu.be/ZoBO9s-3\_1o)).

## Change Log

* OneSignal Add-on is currently removed and will be added in the coming updates
* Video Play API is removed as Unity has inbuilt video player
* Soomla Add-on is completely removed
* PlayMaker is not yet supported
* Webview is allowed in full screen mode only
* Removed TwitterKit as Fabric got shutdown.

