# Handling Conflicts & Synchronization

Cloud Services in Essential Kit let you save and retrieve simple key-value pairs that automatically sync between local and cloud storage. It’s designed to be simple, fast, and reliable – with built-in support for detecting conflicts during synchronization.

Let’s explore how it works using an example.

***

### 🎮 Use Case: Saving Player Settings

Imagine you’re working on a game where the player can configure their settings – like the selected language, sound volume, or preferred difficulty. You want to store these preferences in the cloud, so that if the player installs the game on another device, their settings come along.

#### Step 1: Save Settings to Cloud

Let’s assume the player updates their preferred language setting.

```csharp
CloudServices.SetString("player.language", "en");
```

This will **immediately update the device copy** with the value `"en"` for the key `player.language`. At this point, the value is still only available locally – it has not yet been pushed to the cloud.

> ✅ Tip: All `Set*` methods update the device copy immediately.

***

#### Step 2: Synchronize with Cloud

When you want to push or pull the latest data to/from the cloud, call:

```csharp
CloudServices.Synchronize();
```

This will:

* Fetch the latest copy of cloud data.
* Compare the local and cloud versions.
* Detect if any keys have changed in both locations since last sync.

If a **conflict** is detected (i.e., both local and cloud versions were modified), Essential Kit **overwrites the local value** with the cloud copy and triggers an event **CloudServices.OnSavedDataChange**

***

#### Step 3: Handle Conflict in `OnSavedDataChange`

You can listen for this event and inspect which keys had conflicting values:

```csharp
void OnSavedDataChange(CloudServicesSavedDataChangeResult result)
{
    if (result.ChangedKeys == null)
    {
        return;
    }

    //📌 Important: CloudServices.GetString(key) now returns the cloud value because the device copy was overwritten.
    for (int i = 0; i < result.ChangedKeys.Length; i++)
    {
        string key = result.ChangedKeys[i];
        string cloudValue;
        string previousDeviceValue;

        // Retrieve the latest cloud value and the device snapshot saved before the overwrite
        CloudServicesUtility.TryGetCloudAndLocalCacheValues(key, out cloudValue, out previousDeviceValue, "default");

        Debug.LogFormat("[{0}] Key: {1}\n  [Cloud Value]: {2}\n  [Previous Device Value]: {3}", i, key, cloudValue, previousDeviceValue);

        // Decide what to do: keep the cloud value or restore the previous device value
        if (ShouldKeepLocalValue(key, previousDeviceValue, cloudValue))
        {
            CloudServices.SetString(key, previousDeviceValue);
        }
    }
}
```

***

#### Step 4: Finalize with `SynchronizeComplete`

After the sync is completed (and any conflict resolution is done), the `SynchronizeComplete` event fires:

```csharp
CloudServices.OnSynchronizeComplete += (result) =>
{
    Debug.Log($"Cloud sync complete. Success: {result.Success}");
};
```

If you restored a value during conflict resolution using `SetString`, the updated value will be pushed to the cloud on the next sync cycle – either manually triggered or automatically (e.g., app going to background).

***

### ⚡ Quick Recap

| Action                           | Description                                                               |
| -------------------------------- | ------------------------------------------------------------------------- |
| `SetString("key", value)`        | Immediately updates the device copy                                       |
| `Synchronize()`                  | Syncs data, resolves conflicts, and fires events                          |
| `OnSavedDataChange`              | Fires **after a conflict**, providing changed keys and the reason         |
| `TryGetCloudAndLocalCacheValues` | Lets you inspect both the cloud value and the previous device value       |
| `SetString(...)` inside event    | Lets you restore the preferred value before the next sync                 |
| `OnSynchronizeComplete`          | Fires after sync and conflict resolution is done                          |

***

### Example Conflict Flow

Let’s say:

1. Player changes `"player.language"` to `"en"` locally.
2. On another device, the same key is changed to `"fr"`.
3. Player syncs both devices.

During sync, the cloud value `"fr"` is fetched and overwrites the local `"en"`, triggering `OnSavedDataChange`. Now you can use the utility function `CloudServicesUtility.TryGetCloudAndLocalCacheValues` to retrieve both the cloud value (`"fr"`) and the old local value (`"en"`), allowing you to decide whether to keep the cloud version or restore your original local data.
