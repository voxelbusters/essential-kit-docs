# Version 2.5.0

#### Uninstall Steps:

* **Delete**  **CoreLibrary** and **EssentialKit** folders from`Assets/Plugins/VoxelBusters`
* **Delete** `Assets/Plugins/Android/com.voxelbusters.essentialkit.androidlib` **folder**
* **Delete** `Assets/External Dependency Manager` **folder**
* **Import** the new update
* Run Assets -> External Dependency Manager -> Android -> Force Resolve from "top menu bar"
* Delete XCode projects created earlier as there are native files which got renamed.

#### Feat

* \[Android] Upgraded billing client to v5 (5.0.0)
* Now all of our plugins uses a common module (CoreLibrary). No more duplication.
* Added custom .gitignore internal to the plugin for generated files
* \[Android] Added special key to selectively process a notification when multiple notification clients exist
* Added utilities feature selection for controlling rate libraries inclusion

#### Fixes

* \[Android] Fixed data fetching offline in cloud services
* \[Android] Temp fix for "Object must be an array of primitives" when using IL2CPP until unity fixes it.
* Updated CoreLibrary to have compatibility with all of our plugins
* \[Android] Fixed exception in Billing services for products not listed in essential kit settings
* \[Android] Appending url and text if both are shared via share sheet
* \[iOS] Fixed issue when fetching delivered notifications
* \[Android] Fixed issue when a billing transaction enters finished state
* \[Android] Fixed issue when not providing host in Deep Links Services(thanks to gameburke for reporting)
* \[iOS] Placing popup view on iPad at the center
* \[Android] Fixed webview file dialog display
* \[Android] Fix for saving image to gallery in jpeg format
* \[Android] Updated play core dependencies to latest
* \[Android] Updated FCM libraries to latest
* \[iOS] Fixed date picker controller display on ios 15&#x20;
* \[iOS] Fixed mail composer display on ios 15&#x20;
* \[Simulator] Fixed serialization of dictionary in cloud services for simulator

