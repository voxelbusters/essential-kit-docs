# Google Play Services Authentication

> <mark style="color:green;">Want to know which games are using</mark> [<mark style="color:blue;">Essential Kit</mark>](https://link.voxelbusters.com/essential-kit)<mark style="color:green;">? Click</mark> [<mark style="color:blue;">here</mark>](https://42matters.com/sdks/ios/voxelbusters-essential-kit)<mark style="color:green;">.</mark>&#x20;
>
> <mark style="color:green;">Includes games from</mark> [<mark style="color:purple;background-color:orange;">**Voodoo**</mark>](https://www.boomboxgames.net/)<mark style="color:purple;background-color:orange;">**,**</mark> [<mark style="color:purple;background-color:orange;">**Azur Games**</mark>](https://azurgames.com/)<mark style="color:purple;background-color:orange;">**,**</mark> [<mark style="color:purple;background-color:orange;">**BoomBox**</mark>](https://www.boomboxgames.net/) <mark style="color:green;">and more!</mark>

### Why sign in fails?&#x20;

For Google Play Services to sign in successfully, you need to make sure the apk from where you are logging in should be allowed to make requests to google servers.

### How to make the APK authorized to make requests to google servers?&#x20;

Each apk built with a keystore has a SHA fingerprint. You need to make sure the SHA fingerprint is added in the google cloud.&#x20;

You can fetch it with keytool command (check [here](../features/game-services/faq.md#what-are-different-sha-fingerprints-that-needs-to-be-used-for-logging-in-successfully-on-different-environments-and-how-to-create-them) on how to get SHA for each environment )

### How many SHA fingerprints I need to add for successful authentication?&#x20;

In Unity,&#x20;

1\. Development build uses android default debug keystore.&#x20;

2\. Release build uses the keystore you set in publishing settings of player settings&#x20;

3\. Google play store build which uses google play signing.&#x20;

So in total 3 environments (dev, release and production). If you want all the above builds to authenticate successfully, add all 3 fingerprints.

### How to get each environment's SHA?&#x20;

1\. Debug ( keytool -list -v -keystore "PATH\_TO\_DEBUG\_KEYSTORE" -alias androiddebugkey -storepass android -keypass android)&#x20;

2\. Release (Get from Google play console -> Your App -> Setup -> App signing -> Upload key certificate )

&#x20;3\. Apk/AAb downloaded from Google play store (Get from Google play console -> Your App -> Setup -> App signing -> App signing key certificate )

### Where to add these SHA fingerprints?&#x20;

Google Play Console. Check [here](../features/game-services/setup/android.md#adding-a-sha-fingerprint) for details on how to add a SHA fingerprint.
