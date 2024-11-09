# Version 2.7.3

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

* \[Android] Fixed crash in Billing Services for delayed transaction action
* \[iOS] Fixed Facebook and Twitter share sheet presentation
* \[iOS] Updated Game Services server credentials to use latest game center api
* \[iOS] TeamPlayerID is now returned for LocalPlayer.Id in Game Services. If you need old playerId, please contact our support team for assistance. Also, in V3, we provide api for three different id's including legacy id.





