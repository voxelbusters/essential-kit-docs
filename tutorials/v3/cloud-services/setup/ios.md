---
description: Configuring cloud services on iOS platform
---

# iOS

On iOS, Plugin uses iCloud Key-Value storage for storing data. When you register an app on [iOS dev portal](https://developer.apple.com/account/resources/identifiers/bundleId/add/bundle), you need to enable the iCloud in capabilities section.

![If you have registered app manually and not from xcode, you need to enable iCloud capability](../../.gitbook/assets/CloudServicesiOSEnableiCloud.png)

{% hint style="success" %}
Plugin automatically sets the iCloud capabilities while exporting from Unity on every export.
{% endhint %}

In-case if you have a different setup where you want to enable manually, you can do the following steps

1. Open Xcode project and navigate to Signing & Capabilities tab for the main target
2. Add iCloud capability to the project
3. Enable Key-Value storage option

