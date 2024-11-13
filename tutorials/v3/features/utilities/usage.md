# Usage

Before using any of the **Utilities** class functions, you need to first import the namespace

```csharp
using VoxelBusters.CoreLibrary;
using VoxelBusters.EssentialKit;
```

Once after importing the namespace, you can access **Utilities** class.

### Open App Store Page

```csharp
Utilities.OpenAppStorePage();
```

You can open the app store or market store page by passing the application Id. On Android this is the package name and on iOS its the Apple Id (numeric value) you see in the App store submission page for your app.&#x20;

&#x20;

![Application Id for iOS](../../.gitbook/assets/AppStoreIdIOS.png)

```
string applicationId = "com.package.name" // On Android
//applicationId = "235353553"; // On iOS
Utilities.OpenAppStorePage(applicationId);
```

### Open Application Settings

There are cases where users may decline the permission and you can't programatically prompt the permission again. In those cases, once you check the permission was denied, you can ask the user if he wants to enable it. If he wants to, you can open the application settings and let him enable the permission.

![Open Application Settings if user rejects permission](../../.gitbook/assets/OpenApplicationSettings.PNG)

```
Utilities.OpenApplicationSettings();
```

