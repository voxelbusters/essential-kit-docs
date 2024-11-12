# Android

On Android, Plugin uses FCM (Firebase Cloud Messaging) service under the hood for registering to push notifications.

For making FCM to work, only thing you need to do is to copy the **google-services.json** file from Firebase console to **Assets folder.**&#x20;

Please follow the below steps for getting **google-services.json** file.

1. Open [Firebase](https://firebase.google.com/) website
2. Click on Go to Console
3. Select your project (if you don't find one, create a new one)
4. Next to Project Overview, click on settings gear icon
5. Under General tab, go to "Your apps" (If you don't have an app added, add it)
6. Select your app and click on the "google-services.json" button&#x20;
7. Copy the downloaded **google-services.json** file to your unity project's **Assets** folder

{% hint style="success" %}
For extra security, its good to add your app's fingerprint in the "Your apps" section and then download the json file.
{% endhint %}

### Sending notifications from your server

For sending a notification to user's device from your server, you need to send the message to FCM servers. FCM servers routes the message to the required device.

In order to let your server communicate with FCM servers, they need to be authenticated. For authentication, you need to use the "Server Key". Please check below steps on getting server key

1. Open [Firebase](https://firebase.google.com/) website
2. Click on Go to Console
3. Select your project (if you don't find one, create a new one)
4. Next to Project Overview, click on settings gear icon
5. Select **Cloud Messaging** tab
6. Copy and use **Server Key** in your server

