---
description: Cloud services allows to save player data on both iOS and Android seamlessly
---

# Usage

Once you are done with [Setup](setup/#enable-feature) on both [iOS](setup/ios.md) and [Android](setup/android.md#enable-saved-games-on-play-console), you can start implementing cloud services in your application. Cloud services allows you to store your game data on cloud so that your users can access their progress from anywhere.

### How the data sync works

There are two kinds of data copies based on where they are available.

* [Cloud Copy](faq.md#what-is-cloud-copy)
* [Local Copy](faq.md#what-is-local-copy)

**Cloud Copy** always stays remotely on cloud servers. Where as **Local Copy** is "nearly the latest" copy downloaded on the user's device.

When you try to sync data with cloud, as soon as user's device connects to the cloud servers (When you call **Synchronize** for the first time), plugin communicates with the cloud servers and fetches the latest copy available on server and this is our **Local Copy**.

If there is no **Local Copy** available on device, plugin replaces the **Local Copy** with the latest **Cloud Copy** just downloaded and fires **CloudServices.OnSavedDataChange** event with **InitialSyncChange** as the reason along with the changed keys(available in cloud copy). &#x20;

> ## Irrespective of data differences between "Cloud Copy" and "Local Copy", always plugin "overwrites" your device's "Local Copy" with the latest downloaded "Cloud Copy" on Synchronize.

**Once after overwriting**, it fires the event with the changed keys with the related reason.&#x20;

{% hint style="success" %}
As plugin overrides the local copy with cloud copy when there is a difference in the data, you may loss the data which you already set. For this reason we maintain local cache data for facilitating conflict resolution.
{% endhint %}

Once you get **OnSavedDataChange** with the list of **changed keys,** you need to update the data of the Local Copy with the setter functions if you have any updated data in your cache.&#x20;

As soon as you get **CloudServices.OnSavedDataChange** event, compare the cloud values and local cache values with **CloudServicesUtility.TryGetCloudAndLocalCacheValues,** pick the right value and set it back for the key via CloudServices setters.

Once you update the correct data with setters in the **OnSavedDataChange** callback, this data will be pushed to the cloud servers in the next Synchronize call.

You can call **Synchronize** any time to initiate a sync between Cloud and Local copies. However, plugin provides an option to set the [Sync Interval](setup/#properties) to do this sync automatically. You just need to call **Synchronize** only once at start to initiate the first sync.

{% hint style="success" %}
If there are no changes between Cloud Copy and Local Copy, no event will be fired and it means your data is in sync with the cloud servers!
{% endhint %}



|                                        TOC                                       |
| :------------------------------------------------------------------------------: |
|                   [Import Namespace](usage.md#import-namespace)                  |
|                [Register for Events](usage.md#register-for-events)               |
|                         [Sync Data](usage.md#syncronize)                         |
|            [Store and Retrieve Data](usage.md#store-and-retrieve-data)           |
| [Data Consistency](usage.md#handling-data-consistency-and-external-data-changes) |

###

### Import Namespace

Before using Cloud Services feature, you need to import the namespace.

```csharp
using VoxelBusters.CoreLibrary;
using VoxelBusters.EssentialKit;
```

Including the above namespace gives access to **CloudServices** class which is the class responsible for providing cloud services features.

### Register for Events

For getting the callbacks, you need to first register the events in OnEnable of your MonoBehaviour.

```csharp
private void OnEnable()
{
    // register for events
    CloudServices.OnUserChange              += OnUserChange;
    CloudServices.OnSavedDataChange         += OnSavedDataChange;
    CloudServices.OnSynchronizeComplete     += OnSynchronizeComplete;
}

private void OnDisable()
{
    // unregister from events
    CloudServices.OnUserChange              -= OnUserChange;
    CloudServices.OnSavedDataChange         -= OnSavedDataChange;
    CloudServices.OnSynchronizeComplete     -= OnSynchronizeComplete;
}
```

| Event Name                              | Description                                                                                                                                                                                           |
| --------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **CloudServices.OnUserChange**          | This event gets triggered once if there is a change in the underlying cloud account                                                                                                                   |
| **CloudServices.OnSavedDataChange**     | This event gets triggered when there is a change in current cloud data you have access to and provides the reason(CloudSavedDataChangeReasonCode) behind the data change along with the changed keys. |
| **CloudServices.OnSynchronizeComplete** | This event gets triggered in response to **Synchronize** call with **CloudServicesSynchronizeResult** status.                                                                                         |

### Synchronize

{% hint style="success" %}
### You need to call **Synchronize** manually for the first time after the launch of your app (if [Synchronize On Load](setup/#properties) property is off).
{% endhint %}

**Synchronize** initiates authentication login prompt for the user if required and downloads the latest copy from cloud servers.&#x20;

&#x20;This is required as the initial step as once a user installs the app freshly or once user is back to the app after sometime, we need to make sure he/she has the latest data to proceed.

So, call this method in the main menu or at the time of loading so that you will be ready with the data once your user starts the game. Note that the first call to **Synchronize** may show up a pop up on android for google play services login.

```csharp
CloudServices.Synchronize();
```

This call triggers a callback **CloudServices.OnSynchronizeComplete** and it returns success flag as true  if synchronize succeds. If will be false if user deny the authentication or due to network error.

```csharp
// Register for the CloudServices.OnSynchronizeComplete event
// ...
private void OnSynchronizeComplete(CloudServicesSynchronizeResult result)
{
    Debug.Log("Received synchronize finish callback.");
    Debug.Log("Status: " + result.Success);
    // By this time, you have the latest data from cloud and you can start reading.
}
```

### Store and Retrieve Data

Plugin offers to save your data in the form of Key-Value pairs. So, for each data item you want to store on cloud, you need to set a unique key. Currently, we support all commonly used data types to save on cloud.

* Bool
* Long
* Double
* String

Here are some examples on how to set and get different data types.

> Saving and reading a **bool** value

```csharp
bool boolValue;
// ... Update the boolValue as per your code
// Start saving it to cloud
CloudServices.SetBool("bool-unique-key", boolValue);

// ....
// Get the value of the above saved bool value later
bool boolValueFromCloud = CloudServices.GetBool("bool-unique-key");
```

> Saving and reading a **long** value

```csharp
long longValue;

// Start saving it to cloud
CloudServices.SetLong("long-unique-key", longValue);

// ....
// Get the value of the above saved long value later
long longValueFromCloud = CloudServices.GetLong("long-unique-key");
```

> Saving and reading a **string** value

```csharp
string stringValue;

// Start saving it to cloud
CloudServices.SetString("string-unique-key", stringValue);

// ....
// Get the value of the above saved string value later
string stringValueFromCloud = CloudServices.GetString("string-unique-key");
```

> Saving a reading a **Dictionary** value\
> When saving Dictionary or List kind of containers, you can just convert to json string and use SetString method.

```csharp
Dictionary<string, string> dictionaryValue;

// Convert to json (you can make use of our Json service provider available in VoxelBusters.EssentialKit or use your own serializer)
IJsonServiceProvider serializer = new DefaultJsonServiceProvider();
string json = serializer.ToJson(dictionaryValue);

// Start saving it to cloud
CloudServices.SetString("dictionary-unique-key", json);

// ....
// Get the value of the above saved string value later
string stringValueFromCloud = CloudServices.GetString("string-unique-key");
// Convert the jsonString back to dictionary
IJsonServiceProvider serializer = new DefaultJsonServiceProvider();
object dictObject = serializer.FromJson(stringValueFromCloud);
```

### Handling data consistency and external data changes

If the user plays your game on different devices, there is a possibility to shift from one device to another during the game play progress. They do expect the latest data on the current device they are on. To handle these kind of situations, we provide **CloudServices.OnSavedDataChange** which informs the data changes if any with a reason and changed keys.

**CloudServices.OnSavedDataChange** event is triggered when ever there is a change in the data that is accessed by Getter functions (GetBool, GetString etc..). This callback gives you the required information to handle the data state. It gives a reason (CloudSavedDataChangeReasonCode)  and also the changedKeys array to find out the keys that got changed from the current copy.

**CloudServices.OnSavedDataChange** event gets fired for the following reasons:

| Reason                                               | Description                                                                                                                                                |
| ---------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **CloudSavedDataChangeReasonCode.ServerChange**      | This reason is returned when there is a difference between the local copy that is currently used and the latest cloud copy on cloud server.                |
| **CloudSavedDataChangeReasonCode.InitialSyncChange** | This is triggered initially when a new copy is downloaded from the cloud server for the first time.                                                        |
| **CloudSavedDataChangeReasonCode.QuotaViolation**    | This is the reason when excess data is being stored and it resets to the cloud copy available on the server                                                |
| **CloudSavedDataChangeReasonCode.AccountChange**     | This is the reason when user shifts the account that is being used on the device and as the current data is no more valid, it returns all the key changes. |

{% tabs %}
{% tab title="Sequence of events" %}
1. Plugin trying to sync the data
2. Downloaded latest copy from cloud
3. Finds the keys which got changed from cloud copy by comparing with local copy
4. Overwrites the complete Local copy with latest Cloud Copy data
5. If there are any key-value changes in step 3, then fires **CloudServices.OnSavedDataChange** event with changed the changed keys
6. In the callback, you need to check the cloud value with Getters and check the values with your cache
7. If you see the local copy got overwritten with cloud copy and not reflecting your changes, you need to use setters to update it.
8. Data updated in step 7 will be pushed to cloud on next sync.
{% endtab %}
{% endtabs %}

