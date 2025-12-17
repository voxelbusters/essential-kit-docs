# Version 2.6.0

#### Upgrade Process

* **Delete**  **CoreLibrary** and **EssentialKit** folders from`Assets/Plugins/VoxelBusters`
* **Delete** `Assets/Plugins/Android/com.voxelbusters.essentialkit.androidlib` **folder**
* **Delete** `Assets/External Dependency Manager` **folder \[Optional]**
* **Import** the new update
* Run Assets -> External Dependency Manager -> Android -> Force Resolve from "top menu bar"
* Add the following dependencies in manifest.json (\*\***NEW**\*\*)
  * <mark style="background-color:purple;">"com.unity.nuget.</mark><mark style="background-color:purple;">**newtonsoft**</mark><mark style="background-color:purple;">-json": "2.0.0"</mark>

#### Changes

* \[Android] Converted from using jar files to aar for plugin library dependencies
* \[Android] Updated FCM library to 23.1.0 (latest)
* \[Android] Updated Review library to 2.0.1 (latest)
* \[Android] Updated Billing Client to 5.1.0 (latest)
* \[Android] Updated External Dependency Manager to 1.2.175 (latest)
* \[Android] Updated play services auth library to 20.4.1 (latest)

#### Features

* \[Android] Android 13 support for Notifications!
* \[Android] Target API 33 support
* \[Android] Exact time notifications support (>= Android 12)
* \[Android] Big picture in notifications support remote urls now
* \[Android] R8 support

#### Fixes

* Fixed interval bounds in NotificationBuilder
* Fixed alert dialog click issue on Android where unity activity getting paused before it sends the button click callback
* Fixed warnings
* \[iOS] Fixed custom notification sound issue
* \[iOS] Fixed user info parsing issue for notification services
* \[Android] Fixed data conversion exceptions in Cloud Services
* \[Android] Fixed issue when returning billing products.
* \[Android] Fixed exceptions in 2022 unity versions when exporting
* \[Android] Fixed exception in LoadAchievements callback in 2022 unity version (issue earlier with not calling callback on unity thread)
* \[Android] Fixed cancel callback for Date and Time pickers
* \[Android] Fixed current modification exception in cloud services when multiple calls to synchronise are made
* \[Android] Fixed tag value in Notifications Services

