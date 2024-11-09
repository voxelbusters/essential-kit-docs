# Version 2.7.1

#### Upgrade Process

* **Delete**  **CoreLibrary** and **EssentialKit** folders from`Assets/Plugins/VoxelBusters`
* **Delete** `Assets/Plugins/Android/com.voxelbusters.essentialkit.androidlib` **folder**
* **Delete** `Assets/External Dependency Manager` **folder \[Optional]**
* **Import** the new update
* Run Assets -> External Dependency Manager -> Android -> Force Resolve from "top menu bar"
* Add the following dependencies in manifest.json (if not added)
  * <mark style="background-color:purple;">"com.unity.nuget.</mark><mark style="background-color:purple;">**newtonsoft**</mark><mark style="background-color:purple;">-json": "2.0.0"</mark>

{% hint style="info" %}
#### [Have a look at 2.7.0 (Major version) changes here](version-2.7.0.md#changes)
{% endhint %}

#### Changes

* Fixed export of native libraries when few are disabled
* Fixed DebugLogger to respect the settings in Application settings
* \[iOS] Fixed compilation issues when all features are disabled
* \[iOS] Fixed export of xcode project when saved with in Assets folder
* \[Android] Fixed link.xml to support medium level stripping





