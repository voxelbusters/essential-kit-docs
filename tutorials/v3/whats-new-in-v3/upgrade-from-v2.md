# Upgrade from V2

1. Delete following folders
   1. Assets/Plugins/VoxelBusters/EssentialKit and Assets/Plugins/VoxelBusters/CoreLibrary
   2. Assets/Plugins/Android/com.voxelbusters.essentialkit (.androidlib)
   3. Assets/ExternalDependencyManager
2. Import latest V3 from Package Manager
3.  Fix compilation errors (if any).&#x20;

    > All obsolete methods are documented with required info.&#x20;
    >
    > If you need any help, please contact our [support](https://link.voxelbusters.com/essential-kit-support).
4. Run Assets -> External Dependency Manager -> Android -> Force Resolve from "top menu bar"



{% hint style="danger" %}
<mark style="color:orange;">\[Game Services] If you are using LocalPlayer.Id to identify your account, make sure you handle it carefully as it returns gameScopeId instead of old Id(teamScopeId ≥ 2.7.3, legacyId < 2.7.3).</mark>&#x20;



<mark style="color:orange;">If you want to still use old id, please use legacyId or teamScopeId as per the version you are from.</mark>
{% endhint %}

{% hint style="info" %}
Once after importing the package successfully, cross check if Essential Kit Settings has all required data. We have added few new properties which you can fill out (for ex: Payouts in Billing Products).
{% endhint %}

