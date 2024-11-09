# Version 2.7.0

#### Upgrade Process

* **Delete**  **CoreLibrary** and **EssentialKit** folders from`Assets/Plugins/VoxelBusters`
* **Delete** `Assets/Plugins/Android/com.voxelbusters.essentialkit.androidlib` **folder**
* **Delete** `Assets/External Dependency Manager` **folder \[Optional]**
* **Import** the new update
* Run Assets -> External Dependency Manager -> Android -> Force Resolve from "top menu bar"
* Add the following dependencies in manifest.json (if not added)
  * <mark style="background-color:purple;">"com.unity.nuget.</mark><mark style="background-color:purple;">**newtonsoft**</mark><mark style="background-color:purple;">-json": "2.0.0"</mark>

#### Changes

* Added Domain Reload support \[Beta]
* \[Android] Updated Billing client to 5.2.1 to support API 34
* \[Android] Updated EDMU to 1.2.177
* \[Android] Fixed game services login issue where callback isn't called second time
* \[Android] Fixed quantity value in billing services purchases
* \[Android] Setting notification priority to max by default
* \[Android] Fixed file extension while saving png in media services to gallery
* \[Android] Fixed issue when setting title from remote notification
* \[Android] Fixed creating empty notification when no notification title exists
* \[Android] Fixed crash on some devices when notification permission is requested
* \[Android] Fixed zoom issue when setting scalesPageToFit in Webview
* \[iOS] Updated OpenSSL libraries to 1.1.1v and modified libs to avoid conflicts with apple private api method names
* \[iOS] Fixed notification callbacks issue in Unity 2022
* \[iOS] Fixed gamecenter leaderboard presentation issue
* \[iOS] Fixed notification crash when user-info is requested
* Setting Syncronise On Load option to false by default for Cloud services
* Added attachment for share sheet feature (New feature)
* Updated Core Library



