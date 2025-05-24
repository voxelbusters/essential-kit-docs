# Testing

**App Updater Testing Guidelines for iOS**

Case 1 : If you have a build live on app store

1. Set a lower version compared to the version on app store in unity
2. Make a build and install on the device
3. Launch to see a prompt about the update

Case 2: If you don't have a build live on app store.

1. Use a dummy storeId in Essential Kit settings - storeId of an app live on appstore.
2. Try setting a lower version compared to the version of live dummy storeId
3. Make a build and install on the device
4. Launch to see a prompt about the update
5. Revert the storeId to actual value in Essential Kit Settings.



**App Updater Testing Guidelines for Android**

1. Can only be tested with [Internal app sharing](https://developer.android.com/guide/playcore/in-app-updates/test#internal-app-sharing) uploaded builds
2. Upload to play console app sharing page with a build having version code X and another with X+1
3. Install the build with version code X
4. Open X+1 link and DON'T install/update
5. Go back to the installed app(X) and request update info





