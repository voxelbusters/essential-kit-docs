# Installation FAQ



### I see this error on installation - The type or namespace name 'Newtonsoft' could not be found (are you missing a using directive or an assembly reference?

The plugin depends on Newtonsoft's json plugin which needs to be added to your packages.

Add the following dependencies in YOUR\_PROJECT\_ROOT/Packages/manifest.json under dependencies block

```json
"com.unity.nuget.newtonsoft-json": "2.0.0"
```

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
