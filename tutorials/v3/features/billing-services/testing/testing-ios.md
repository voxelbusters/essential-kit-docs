---
description: Testing in-app purchases in Sandbox environment
---

# iOS

### Overview

Use the Apple sandbox environment to test your implementation of in-app purchases using the StoreKit framework on devices using real product information from App Store Connect. Your development-signed apps uses the sandbox environment when you sign in to App Store using a Sandbox Apple ID.

To create a Sandbox Apple ID or test account in App Store Connect, see [Create a sandbox tester account](https://help.apple.com/app-store-connect/#/dev8b997bee1).

### Sign In to the App Store with Your Sandbox Apple ID

To run your app using your Sandbox Apple ID, do the following, depending on your device and operating system:

* For iOS 12 or later—Build and run your app from Xcode. The sandbox account in Settings appears after the first time you use the device to attempt a purchase on a development-signed app. Sign in using a Sandbox Apple ID. There’s no need to log out of the non-test Apple ID.

### Make an In-App Purchase

The first time you make a purchase in a development-signed app, the system prompts you to sign in to the App Store. Sign in using your Sandbox Apple ID to begin testing. Note that the text `[Environment: Sandbox]` appears as part of the prompt, indicating that you’ve connected to the test environment. If `[Environment: Sandbox]` doesn’t appear, you’re using the production environment. Make sure you’re running a development-signed build of your app; production-signed builds use the production environment.\


Additionally you can test interrupted purchases. For more details, check the documentation [here](https://help.apple.com/app-store-connect/#/dev7e89e149d?sub=dev55ecec74d).

{% hint style="danger" %}
If you see **InitializeStore** call doesn't return any billing products in the callback, make sure you finish accepting all pending updated terms and conditions and also finish your **tax agreements** on iTunes connect.
{% endhint %}

