# ✅ Version 2.7.4

> If you are upgrading from 2.7.3, just update on existing plugin. However, it's safe to follow general below upgrade process.

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

* \[Android] Fixed common properties of Game Services to default values when only Cloud Services is enabled&#x20;
* \[Android] Fixed READ\_PHONE\_STATE permission inclusion issue when latest gradle version is used
* \[Android] Fixed an issue where unused/obsolete billing products are fetched when querying past purchases.
* External Dependency Manager updated to 1.2.182





