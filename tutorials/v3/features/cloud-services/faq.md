# FAQ & Troubleshooting

### Do I need to manually configure iCloud or Google Play settings?
No. Essential Kit automatically injects the required configurations into `Info.plist` (iOS) and `AndroidManifest.xml` (Android) during the build process. You only need to enable Cloud Services in Essential Kit Settings.

### Why can't I see my local changes after sync?
When `Synchronize()` runs, the cloud copy overwrites the device copy if the platform has newer data. Essential Kit also keeps a conflict snapshot and fires `OnSavedDataChange` with the changed keys. Use the snapshot via `CloudServicesUtility.TryGetCloudAndLocalCacheValues` to compare the cloud value with what the device had before the overwrite, then write back the winner with `CloudServices.Set*`. See [Handling Data Conflicts](usage.md#handling-data-conflicts) for examples.

### How much data can I store?
- **iOS**: 1 MB total storage, maximum 1024 keys, 64-byte key length limit
- **Android**: 3 MB total storage per user

These are platform limits from iCloud Key-Value Store and Google Play Saved Games respectively.

### Does using Cloud Services cost money?
No. Cloud Services uses free platform services:
- **iOS**: iCloud Key-Value Storage (included with iCloud)
- **Android**: Google Play Saved Games API (free)

No additional cloud infrastructure or billing required.

### Can data sync between iOS and Android?
No. Cloud Services uses platform-specific storage:
- **iOS**: iCloud (Apple ecosystem only)
- **Android**: Google Play (Google ecosystem only)

Players switching platforms cannot transfer cloud saves. Consider implementing manual backup/export features or server-side storage for cross-platform saves.

### Why does OnSavedDataChange fire with no changed keys?
If the cloud copy and device copy are identical, `OnSavedDataChange` will NOT fire. The event only runs when actual key-value differences are detected. If you log an empty `ChangedKeys` array, double-check your handling code—most often the event executed with `ChangedKeys == null` and your handler should exit early. For sync failures, inspect the `OnSynchronizeComplete` callback instead.

### How does Essential Kit identify changed keys?
Cloud Services uses version tags (similar to ETags) to track data state:
- Each data sync assigns a new tag to the cloud copy
- Local copy stores the tag from the last successful sync
- If tags differ during sync, changed keys are calculated by comparing values
- All changed keys are passed to `OnSavedDataChange` event

### My app doesn't need cloud sync - can I use Cloud Services offline?
Yes! Cloud Services works as enhanced PlayerPrefs without calling `Synchronize()`. Simply use `SetBool`, `SetString`, etc. for local storage that persists across sessions. Data stays on the device and never syncs to cloud. See [Local-Only Storage](usage.md#local-only-storage-no-cloud-sync).

### How do I handle quota violations?
When storage limits are exceeded, `OnSavedDataChange` fires with `QuotaViolation` reason and the local copy resets to the cloud copy. To prevent this:
- Monitor data size before saving large objects
- Use data compression for binary saves
- Remove obsolete keys with `RemoveKey()`
- Design save data to stay well under limits (1MB iOS, 3MB Android)

```csharp
void SaveLargeData(byte[] data)
{
    if (data.Length > 1024 * 1024) // 1MB iOS limit
    {
        Debug.LogWarning("Data exceeds iOS quota - consider compression");
        return;
    }
    CloudServices.SetByteArray("game_save", data);
}
```

### What happens if the user denies cloud access?
If the user denies iCloud (iOS) or Google Play (Android) access:
- `Synchronize()` callback returns `Success = false`
- Local storage continues to work normally
- App can continue using local-only data
- Gracefully handle sync failures and offer retry options

```csharp
CloudServices.Synchronize((result) =>
{
    if (!result.Success)
    {
        Debug.Log("Cloud sync unavailable - using local storage");
        // Continue game with local data only
    }
});
```

### How do I test cloud sync in Unity Editor?
Unity Editor uses a simulator that stores data in local JSON files. This tests API usage but NOT actual cloud synchronization. Always test on real devices with active cloud accounts (iCloud or Google Play) to validate production behavior. See [Testing](testing.md) for device test procedures.

### Why is OnSavedDataChange not firing during development?
Common reasons:
- Cloud and device data are identical (no changes to report)
- Event handler not registered in `OnEnable` before calling `Synchronize()`
- First sync completed before event registration
- Sync request failed—check the `CloudServices.OnSynchronizeComplete` result or console logs for errors

Verify event registration:
```csharp
void OnEnable()
{
    // Register BEFORE calling Synchronize()
    CloudServices.OnSavedDataChange += OnSavedDataChange;
}
```

### Can I use Cloud Services with my existing PlayerPrefs data?
Yes. Migrate PlayerPrefs to Cloud Services during first run:

```csharp
void MigrateFromPlayerPrefs()
{
    if (!CloudServices.HasKey("migrated"))
    {
        // Migrate existing PlayerPrefs data
        int level = PlayerPrefs.GetInt("player_level", 0);
        CloudServices.SetInt("player_level", level);

        string name = PlayerPrefs.GetString("player_name", "");
        CloudServices.SetString("player_name", name);

        // Mark migration complete
        CloudServices.SetBool("migrated", true);
        CloudServices.Synchronize();

        Debug.Log("Migrated PlayerPrefs to Cloud Services");
    }
}
```

### What is the difference between the device copy and the conflict snapshot?
- **Device copy**: The working data you read and write with `GetBool`, `SetString`, etc. Updated instantly and saved to disk locally.
- **Conflict snapshot**: Maintained internally by Essential Kit so that `CloudServicesUtility.TryGetCloudAndLocalCacheValues` can tell you "what the device had before the overwrite" during a sync.

Your code only interacts with the device copy and the helper utility. Essential Kit manages the conflict snapshot for you.

### Where can I confirm the plugin is working vs my implementation?
Run `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/CloudServicesDemo.unity` scene. If the demo works but your scene doesn't:
- Compare event registration timing (register in `OnEnable`)
- Check sync call frequency (avoid over-syncing)
- Verify conflict resolution logic in `OnSavedDataChange`
- Ensure keys are consistent (case-sensitive)
- Review error handling in callbacks

### Do I need Game Services enabled to use Cloud Services on Android?
You need to provide the **Play Services Application ID** in Game Services settings even if Game Services is disabled. Cloud Services uses the same Google Play infrastructure. Get the ID from Google Play Console and enter it in Essential Kit Settings > Services > Game Services.

### How do I handle users switching cloud accounts?
When a user switches cloud accounts (different iCloud or Google Play account):
- `OnSavedDataChange` fires with `AccountChange` reason
- The device copy is cleared automatically
- Cloud data for the new account loads
- Your code should clear any in-memory game state

```csharp
void OnSavedDataChange(CloudServicesSavedDataChangeResult result)
{
    if (result.ChangeReason == CloudSavedDataChangeReasonCode.AccountChange)
    {
        // User switched accounts - reset game state
        ClearAllGameData();
        LoadCloudDataForNewAccount();
    }
}
```

### Can I force a sync instead of waiting for auto-sync on Android?
Yes. Call `CloudServices.Synchronize()` at any time to manually trigger a sync. While Android auto-syncs on app state changes, you can call it explicitly at checkpoints (level complete, settings change, etc.) for immediate synchronization.
