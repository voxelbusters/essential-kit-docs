# Upgrade from V2

1. Delete following folders
   1. Assets/Plugins/VoxelBusters/EssentialKit and Assets/Plugins/VoxelBusters/CoreLibrary
   2. Assets/Plugins/Android/com.voxelbusters.essentialkit (.androidlib)
   3. Assets/ExternalDependencyManager
2. Import latest V3 from Package Manager
3.  In Packages/manifest.json add Newtonsoft dependency (if not existing) - Any version higher than 2.0.0 will also work.

    > <mark style="background-color:purple;">"com.unity.nuget.</mark><mark style="background-color:purple;">**newtonsoft**</mark><mark style="background-color:purple;">-json": "2.0.0"</mark>
4.  Fix compilation errors (if any).&#x20;

    > All obsolete methods are documented with required info.&#x20;
    >
    > If you need any help, please contact our [support](https://link.voxelbusters.com/essential-kit-support).
5. Run Assets -> External Dependency Manager -> Android -> Force Resolve from "top menu bar"

{% hint style="info" %}
Once after importing the package successfully, cross check if Essential Kit Settings has all required data. We have added few new properties which you can fill out (for ex: Payouts in Billing Products).
{% endhint %}

