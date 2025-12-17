# Version 2.0.3

1. Uninstall existing version from Window -> Voxel Busters -> Essential Kit -> Uninstall
2. Delete Assets/External Dependency Manager folder
3. Import the new update
4. Run once Window -> Voxel Busters -> Essential Kit -> Force Update Library Dependencies



**New**

* Exposed GetSnapshot api method in Cloud Services
* Updated External Dependency Manager to new version 1.2.164
* [Video Tutorials](https://www.youtube.com/playlist?list=PLWeGoBm1YHVgj4\_MbltHcmhY3d00iirk3) live now!

**Fixes**

* Fixed report progress issue in Achievements on Android
* Fixed multiple load finish event in Webview on Android
* Considering to set data before calling first synchronize in cloud services on Android
* Fixed player log crash when auth fails in Game Services Demo
* Billing Services locale fix on iOS
* Billing Services crash fix on iOS when network is off
* Epoch timestamp fix on Android
* UserInfo null case handling on Android
* Image login fixes in GameServices on Android
* Game Services achievements filtering fix on Android as per last reported date
* Incremental achievements fix to allow 0-100 range values on Android for reporting progress
* Added contratint on iOS for webview frame positioning
* UserInfo payload parsing fix on Android for Notifications
* Alias name fix on Android for Game Services
* Reversing changes done during last temporary commit
* Temporarily named Json folder as Json2 to fix meta conflict
* Fixed issue related to missing verification state information
* Fixed retrieving correct completed status for achievement on Android
* Fixed compiler issues caused by.net language compatiiblity issue
* Fixed exception while generating android manifest when play services application id is null



