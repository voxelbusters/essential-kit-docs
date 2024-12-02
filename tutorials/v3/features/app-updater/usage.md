# Usage

This feature allows you to fetch available updates on store. If the user is not up to date, you receive an update information. You can prompt the user with a dialog to update to latest version either optionally or forcefully.  &#x20;

All App Updater features can be accessible from **AppUpdater** static class.&#x20;

Before using any of the plugin's features, you need to import the below namespace.

```
using VoxelBusters.EssentialKit;
using VoxelBusters.CoreLibrary;
```

After importing the namespace, **AppUpdater** class is available for accessing all of the App Updater's features.

## Request Update Info

Get the latest update info if a new update exists\
\
**RequestUpdateInfo** takes a callback which gets triggered when new update info is fetched. The callback will be triggered with AppUpdaterUpdateInfo instance where you can fetch the AppUpdaterUpdateStatus.

> Note that the callback will have update status as  Available only if an update exists and user hasn't updated yet.

```
AppUpdater.RequestUpdateInfo((AppUpdaterUpdateInfo result, Error error) => 
{
    if(result.Status == AppUpdaterUpdateStatus.Available)
    {
        Debug.Log("A new update is available!");
        //Prompt here the user with update
    }
}); 
```

{% hint style="info" %}
If the update status is AppUpdaterUpdateStatus.Downloaded, it means the new update is already installed and you can install it with a PromptUpdate call + AllowInstallationIfDownloaded set to true in options.
{% endhint %}

## Prompt Update

Once AppUpdaterUpdateStatus is Available, you can prompt an update to user with PromptUpdate call.&#x20;

For calling PromptUpdate, you need to pass PromptUpdateOptions instance.

#### Create PromptUpdateOptions

```csharp
PromptUpdateOptions.Builder optionsBuilder = new PromptUpdateOptions.Builder().
optionsBuilder.SetPromptTitle("Update available");
optionsBuilder.SetPromptMessage("A new version of this app is available.");
optionsBuilder.SetIsForceUpdate(isForceUpdate: false); //Passing true will not let user to dismiss this prompt.
optionsBuilder.SetAllowInstallationIfDownloaded(false);//If you don't want to install as soon as its downloaded. Default value is true

PromptUpdateOptions options = optionsBuilder.Build();
```

#### Pass PromptUpdateOptions to PromptUpdate

Once after creating the PromptUpdateOptions with PromptUpdateOptions.Builder, you can call PromptUpdate to get progress if the platform supports on the fly downloads.

```
PromptUpdateOptions options;

//...Create PromptUpdateOptions using PromptUpdateOptions.Builder
//...

AppUpdater.PromptUpdate(options, (progress, error) => {
    if(error == null)
    {
        Debug.Log("Update download progress : " + progress);
    }
    else
    {
        Debug.Log("Failed to update: " + error);
    }
});
```

> Progress will be reported as 0.0f if the platform doesn't support parallel downloads. But if the callback reports with any progress(>=0f), it means user opted to update the build.
>
> Note the callback can be call multiple times with the latest progress values if the platform supports parallel downloads.

{% hint style="info" %}
On Android, we internally use In-App Update feature offered by Google's Android. Where as on iOS, there is no equivalent feature offered by Apple. So we query with itunes store api and fetch the data to see if an app update exists.
{% endhint %}

{% hint style="warning" %}
Make sure you fill in bundle identifier and appstore id in general settings of Essential Kit Settings.
{% endhint %}

