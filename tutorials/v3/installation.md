---
description: Steps to install the plugin
---

# Installation

1. Open Package Manager from Unity Editor
2. Under My Assets category, Search for "Essential Kit"
3. Import the plugin into your project
4. If you don't have Newtonsoft's Json package installed in your project then follow below additional steps. Else, jump to step 5.
   1. Open manifest.json file in Packages folder
   2.  Add below line in the dependencies block (any version ≥ 2.0.0 is fine)

       ```json
       "com.unity.nuget.newtonsoft-json": "2.0.0"
       ```
5. Do a force resolve from top menu bar -> Assets -> External Dependency Manager -> Android Resolver -> Force Resolve
6. Configure the features you want in [Essential Kit Settings](plugin-overview/settings.md#essential-kit-settings)



{% hint style="warning" %}
If you already have an earlier version of the plugin installed, check the [upgrade guide](upgrade-guide.md).
{% endhint %}

{% hint style="danger" %}
If you have an error related to iOS/XCode assemblies from External Dependency Manager, make sure you have iOS module installed in Unity Editor.
{% endhint %}

## FAQs

### I see this error on installation - The type or namespace name 'Newtonsoft' could not be found (are you missing a using directive or an assembly reference?

The plugin depends on Newtonsoft's json plugin which needs to be added to your packages.

Add the following dependencies in YOUR\_PROJECT\_ROOT/Packages/manifest.json under dependencies block

```json
"com.unity.nuget.newtonsoft-json": "2.0.0"
```

> Any version ≥ 2.0.0 is fine.

### I see this error when making Android build - "Failed to install the following Android SDK packages as some licences have not been accepted.". How to resolve this?

This happens because of not accepting licenses when installing the sdk. Let me get you the steps to accept the license.\
**On Windows**

> ```
> C:\Users\xxx\AppData\Local\Android\Sdk\tools\bin\sdkmanager --licenses
> ```
>
> or
>
> ```
> PATH-TO-UNITY-ANDROID-SDK\tools\bin\sdkmanager --licenses
> ```



&#x20;**On Mac**

> ```
> cd /Users/YOUR_MAC_USER/Library/Android/sdk/tools/bin ./sdkmanager --licenses
> ```
>
> or
>
> ```
> /Applications/Unity/Hub/Editor/UNITY_VERSION/PlaybackEngines/AndroidPlayer/SDK/tools/bin/sdkmanager --licenses
> ```

&#x20;Press 'y' to accept the licenses.
