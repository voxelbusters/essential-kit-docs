# Version 2.3.0

### Uninstall Steps:

* **Uninstall** existing version from Window -> Voxel Busters -> Essential Kit -> Uninstall
* Under Assets/Plugins/VoxelBusters folder **delete CoreLibrary, NativePlugins and Parser folders**
* Delete Assets/External Dependency Manager folder
* **Import** the new update
* Run Assets -> External Dependency Manager -> Android -> Force Resolve from "top menu bar"

#### Fixes

* Re-organized folder structure for plugin compatibility. Now all VB Products have a common **CoreLibrary** folder to avoid duplication.
* Added option to migrate to UPM
* \[Android] Fixed issue when using promo codes for billing
* \[Android] Fixed Deep Link Services stripping as per settings (Thanks to Steve - Tiny Bubbles)
* \[Android] Delaying triggering authentication callback until leader and achievement definitions are loaded in Game Services
* \[Android] Fixed exception when unregistering network connectivity
* \[Android] Fixed exceptions in Date Picker
* \[Android] Fixed sound when set to off in Notification Services
* \[Android] Fixed BigPictureStyle display in Notification Services
* \[Android] Fixed tag functionality in Notification Services
* \[Android] Updated FCM api to latest release and removed deprecated methods
* \[Android] Fixed cancelling of notifications functionality (occured in xiaomi models)

