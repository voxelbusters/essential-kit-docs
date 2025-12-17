---
description: Guide for upgrading from 1.x version
---

# Version 2.0.0

### Uninstall existing package(1.x) from top menu bar -> Window -> Voxel Busters -> Native Plugins -> Uninstall

> Follow the below changes and then uninstall v1.x so that it's easy to migrate without any compilation errors. Else you can simply uninstall and go with the below changes. Both ways are fine.

### 1. Change NameSpace

Version 2.0 changed the root namespace of the plugin from  ~~VoxelBusters.NativePlugins~~ to **VoxelBusters.EssentialKit.**

| **Version** | Code Changes                          |
| ----------- | ------------------------------------- |
| V1.x        | ~~using VoxelBusters.NativePlugins;~~ |
| V2.x        | **using VoxelBusters.EssentialKit;**  |

### **2. Change Access Interface**

Version 2.0 **dropped NPBinding interface** access and now you can directly use the feature name.

| Version 1.x                        | Version 2.x              |
| ---------------------------------- | ------------------------ |
| ~~NPBinding.GameServices~~         | **GameServices**         |
| ~~NPBinding.AddressBook~~          | **AddressBook**          |
| ~~NPBinding.CloudServices~~        | **CloudServices**        |
| ~~NPBinding.MediaLibrary~~         | **MediaServices**        |
| ~~NPBinding.BillingServices~~      | **BillingServices**      |
| ~~NPBinding.NotificationServices~~ | **NotificationServices** |

### 3. Changed from NPSettings to Essential Kit Settings

V1 used to have all of its settings in the NPSettings asset object. Now this got renamed to [Essential Kit Settings ](../../overview/settings.md#essential-kit-settings)and is moved to **Assets/Plugins/VoxelBusters/EssentialKit/Resources** folder.

![](../../.gitbook/assets/OpenEssentialKitSettings.gif)

### 4. All callbacks follow a standard format

Version 2.0 follows a standard format for callbacks with a Result and Error objects

```
public delegate void EventCallback<TResult>(TResult result, Error error);
```

In the above, result is the data for the operation and Error object is a wrapper for error details.

Example

```
public static void LoadLeaderboards(EventCallback<GameServicesLoadLeaderboardsResult> callback)
```

EventCallback result contains GameServicesLeaderboardResult value an error object if any error occurs while loading the leaderboards.



### 5. Move files in PluginResources folder to StreamingAssets

If you have any custom images (for ex: Large Icon image used for notifications), move it to Assets/StreamingAssets folder.

### 6. Better Folder Structure and .asmdef support

[Folder structure](../../overview/folder-structure.md) of the plugin got changed a lot from v1 and its more cleaner now. All the plugin files will be in Assets/Plugins/VoxelBusters/EssentialKit now compared to earlier version where it was too much distributed.

{% hint style="success" %}
**Now, complete plugin is .asdmdef compatible!** :men\_with\_bunny\_ears\_partying: :men\_with\_bunny\_ears\_partying: :men\_with\_bunny\_ears\_partying:&#x20;
{% endhint %}
