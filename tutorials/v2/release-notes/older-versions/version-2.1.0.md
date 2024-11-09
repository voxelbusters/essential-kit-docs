# Version 2.1.0

#### Upgrade Steps

1. **Uninstall** existing version from Window -> Voxel Busters -> Essential Kit -> Uninstall
2. Under Assets/Plugins/VoxelBusters folder **delete CoreLibrary, NativePlugins and Parser folders**
3. Delete Assets/External Dependency Manager folder
4. **Import** the new update
5. Run Assets -> External Dependency Manager -> Android -> Force Resolve from "top menu bar"
6. Restart Unity (We moved the path of EssentialKitSettings to Assets/Resources. Restarting Unity will move the asset from old path to new path)

{% hint style="success" %}
You may get an error while exporting on Android like below

**AAPT: error: unexpected element \<queries> found in \<manifest>**

This error happens when you target API 30 and your unity's Android Gradle Version doesn't support queries tag which is required for API 30 support.

To fix this, please do the following.

1. Open Player Settings -> Android -> Publishing Settings
2. Enable Custom Gradle Template option or Base Gradle Template option (> 2018)
3. Open Assets/Plugins/Android/mainTemplate.gradle or baseTemplate.gradle (>2018)
4. Change Android gradle version to any of the following nearest versions - **3.3.3** or **3.4.3** or **3.5.4** or **3.6.4** or **4.0.1**&#x20;

Example: Change classpath 'com.android.tools.build:gradle:**3.4.0**' to classpath 'com.android.tools.build:gradle:**3.4.3**'
{% endhint %}



#### New

* Added flag to detect notification is launched from notification center (IsLaunchNotification)
* Added queries support for all features to be fully compatible with Android 11 and removed QUERY\_ALL\_PACKAGES permission
* \[Android] Updated Native Google Billing Client library to 4.0.0 for Billing Services

#### Fixes

* Fixed default image issue in Address Book Contact
* Fixed documentation urls
* Fixed usage of null coalescing operator by limiting to non-unity objects
* Fixed default image setup for address book contact
* Fixed reset simulator data in Billing Services
* Fixed usage of ?? operator on Unity objects as its not supported on unity objects
* Fixed UserChange event firing in cloud services on simulator
* Fixed bug in Cloud Services where the data is not getting reset from inspector
* Fixed Firebase settings error when making builds by moving the Editor.Android folder out of packages (Need to access DefaultJsonSerializer)
* Fixed issue in sharing services when callback is not set



* \[iOS] Fixed passing UserInfo data
* \[iOS] Fixed crash in Cloud Services when fetching byte array
* \[iOS] Fixed GetByteArray crash issue in Cloud Services
* \[iOS] Fixed popup controller displays on iPad
* \[iOS] Fixed image picker display on iPad with popover controller
* \[iOS] Fixed date picker style for devices > iOS 13.4
* \[iOS] Fixed crash when loading scores in game services leaderboard



* \[Android] Fixed setRecipients call for Mail Services
* \[Android] Fixed passing string arrays to native JNI on some devices
* \[Android] Fixed FileProvider conflict with other plugins by extending to have custom one
* \[Android] Fixed cloud services auth if player logs out and login to fetch new player data
* \[Android] Resetting cloud services data when player changes account
* \[Android] Fixed LoadNextScores paging
* \[Android] Set max resolution of picked images on Android to 1024 to avoid memory crashes
* \[Android] Fixed custom sounds for devices using notification channels
* \[Android] Fixed share sheet sharing on Android 11 devices
* \[Android] Fixed webkit to not pause unity to send the messages to unity instantly
* \[Android] Fixed image compression to allow transparency (using png instead of jpeg) (Achievement images needs transparency)
* \[Android] Fixed deep linking activity launch when app is in foreground
* \[Android] Fixed rate controller crash when rate dialog display fails on native
* \[Android] Fixed network connectivity to make use of event based triggers from native libraries (optimisation)
* \[Android] Fixed custom sound for notification channel supported devices to allow changes from notification channel settings
* \[Android] Fixed notification text to include emojis and supplementary uni-code characters by passing base64 text to native
* \[Android] Fixed exception when sharing fails while using SocialShare
* \[Android] Fixed multiple alerts when sign-in fails in game services
* \[Android] Changed alert to non-cancellable when touching outside of the alert
* \[Android] Fixed bug when setting recipients for message and mail composer
* \[Android] Fixed dependency file generation when only cloud services is enabled
