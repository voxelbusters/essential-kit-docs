# Version 2.6.1

#### Upgrade Process

* **Delete**  **CoreLibrary** and **EssentialKit** folders from`Assets/Plugins/VoxelBusters`
* **Delete** `Assets/Plugins/Android/com.voxelbusters.essentialkit.androidlib` **folder**
* **Delete** `Assets/External Dependency Manager` **folder \[Optional]**
* **Import** the new update
* Run Assets -> External Dependency Manager -> Android -> Force Resolve from "top menu bar"
* Add the following dependencies in manifest.json (\*\***NEW**\*\*)
  * <mark style="background-color:purple;">"com.unity.nuget.</mark><mark style="background-color:purple;">**newtonsoft**</mark><mark style="background-color:purple;">-json": "2.0.0"</mark>

#### Fixes

* \[iOS] Fixed auto adding capabilities
* \[Android] Fixed issue in notification services where custom large picture was not working.
* \[Android] Fixed issue in Game Services where authenticated flag is true after Signout

