---
description: "Cloud Services allows cross-device game data synchronization on iOS and Android."
---

# Usage

Essential Kit wraps native iOS (iCloud Key-Value Store) and Android (Google Play Saved Games) APIs into a single Unity interface. Cloud Services automatically initializes with your Essential Kit settings and is ready to use.

## Table of Contents

- [Understanding Cloud Services](#understanding-cloud-services)
- [Import Namespaces](#import-namespaces)
- [Event Registration](#event-registration)
- [Local-Only Storage (No Cloud Sync)](#local-only-storage-no-cloud-sync)
- [Cloud Synchronization](#cloud-synchronization)
- [Storing and Retrieving Data](#storing-and-retrieving-data)
- [Handling Data Conflicts](#handling-data-conflicts)
- [Core APIs Reference](#core-apis-reference)
- [Error Handling](#error-handling)
- [Advanced: Runtime Settings Override](#advanced-runtime-settings-override)
- [Related Guides](#related-guides)

## Understanding Cloud Services

Cloud Services keeps game data in two places:

- **Cloud copy** – Lives in iCloud (iOS) or Google Play Saved Games (Android) and is shared across devices.
- **Device copy** – Stored locally as a JSON cache; all `CloudServices` getters and setters read and write this copy instantly.

Synchronization keeps both copies in step. When you call `Synchronize()` the plugin uploads device changes, downloads cloud updates, and raises change events if the platform copy was newer.

```
Your Scripts ── Get*/Set* ──▶ Device Copy (local cache file)
      │                              │
      └── Synchronize() ◀────────────┤
                                      ▼
                          Cloud Copy (iCloud / Play)
                                      │
                   OnSavedDataChange ─┘ via CloudServicesUtility
```

**Key characteristics:**
- All `Get*/Set*` calls update the device copy immediately
- `Synchronize()` is the only way to push or pull the cloud copy
- If the cloud copy is newer, it overwrites the device copy and fires `OnSavedDataChange`

{% hint style="success" %}
**Two modes of operation:**
- **Local-only storage**: Never call `Synchronize()` - works like enhanced PlayerPrefs
- **Cloud sync**: Call `Synchronize()` to keep data in sync across devices
{% endhint %}

## Import Namespaces

```csharp
using System;
using System.Collections;
using System.Collections.Generic;
using VoxelBusters.EssentialKit;
using VoxelBusters.CoreLibrary;
```

## Event Registration

Register for events in `OnEnable` and unregister in `OnDisable`:

```csharp
void OnEnable()
{
    CloudServices.OnUserChange += OnUserChange;
    CloudServices.OnSavedDataChange += OnSavedDataChange;
    CloudServices.OnSynchronizeComplete += OnSynchronizeComplete;
}

void OnDisable()
{
    CloudServices.OnUserChange -= OnUserChange;
    CloudServices.OnSavedDataChange -= OnSavedDataChange;
    CloudServices.OnSynchronizeComplete -= OnSynchronizeComplete;
}
```

| Event | Trigger |
| --- | --- |
| `OnUserChange` | Cloud account changes (user logs in/out, switches accounts) |
| `OnSavedDataChange` | Cloud data differs from local data during sync (provides changed keys) |
| `OnSynchronizeComplete` | Synchronization request finishes (success or failure) |

## Local-Only Storage (No Cloud Sync)

Use Cloud Services as enhanced PlayerPrefs without any cloud synchronization:

```csharp
void SavePlayerData()
{
    // Saves to local storage only - no cloud involved
    CloudServices.SetLong("high_score", newHighScore);
    CloudServices.SetBool("tutorial_complete", true);
    CloudServices.SetString("player_name", playerName);

    // DON'T call Synchronize() - keeps data local only
}

void LoadPlayerData()
{
    // Loads from local storage - always works offline
    long highScore = CloudServices.GetLong("high_score");
    bool tutorialDone = CloudServices.GetBool("tutorial_complete");
    string name = CloudServices.GetString("player_name");

    Debug.Log($"High Score: {highScore}, Tutorial: {tutorialDone}, Name: {name}");
}
```

{% hint style="info" %}
Perfect for offline games or games that don't need cross-device sync. Data persists locally across sessions but won't sync to other devices.
{% endhint %}

## Cloud Synchronization

### Why Synchronization is Needed

Synchronization downloads the latest cloud data and uploads local changes. This ensures:
- Fresh installs get saved progress from cloud
- Players switching devices see their latest data
- Concurrent device usage detects and resolves conflicts

### First Sync (Authentication)

Call `Synchronize()` when your app starts to authenticate and download cloud data:

```csharp
void Start()
{
    // First call may show login dialog on Android
    CloudServices.Synchronize((result) =>
    {
        if (result.Success)
        {
            Debug.Log("Cloud sync complete - data is current");
        }
        else
        {
            Debug.Log("Sync failed - using local data only");
        }
    });
}
```

{% hint style="warning" %}
**First call behavior:**
- **iOS**: Uses device-level iCloud settings, no login prompt typically shown
- **Android**: May show Google Play sign-in dialog if user not authenticated
{% endhint %}

### Checkpoint-Based Sync

Sync only at appropriate game checkpoints for performance:

```csharp
void OnLevelComplete()
{
    SaveGameProgress();

    // Show syncing UI for better UX
    ShowSyncingIndicator();

    CloudServices.Synchronize((result) =>
    {
        HideSyncingIndicator();

        if (result.Success)
        {
            Debug.Log("Progress synced to cloud");
        }
        else
        {
            Debug.Log("Sync failed - will retry later");
        }
    });
}
```

{% hint style="success" %}
**Best practices:**
- Sync at level completion, major milestones, or app pause
- Show UI feedback during sync operations
- Avoid frequent sync calls during active gameplay
{% endhint %}

## Storing and Retrieving Data

Cloud Services supports primitive types and binary data as key-value pairs.

### Supported Data Types

```csharp
// Boolean
CloudServices.SetBool("sound_enabled", true);
bool soundEnabled = CloudServices.GetBool("sound_enabled"); // false if not found

// Integer (stored as long internally)
CloudServices.SetInt("player_level", 10);
int level = CloudServices.GetInt("player_level"); // 0 if not found

// Long
CloudServices.SetLong("total_coins", 1000000L);
long coins = CloudServices.GetLong("total_coins"); // 0 if not found

// Float (stored as double internally)
CloudServices.SetFloat("volume", 0.75f);
float volume = CloudServices.GetFloat("volume"); // 0.0 if not found

// Double
CloudServices.SetDouble("completion_percentage", 87.5);
double completion = CloudServices.GetDouble("completion_percentage"); // 0.0 if not found

// String
CloudServices.SetString("player_name", "Hero123");
string name = CloudServices.GetString("player_name"); // null if not found

// Byte Array (for serialized objects)
byte[] saveData = SerializeGameState();
CloudServices.SetByteArray("game_save", saveData);
byte[] loadedData = CloudServices.GetByteArray("game_save"); // null if not found
```

### Storing Complex Data

Use a single serialized class for all save data to simplify versioning:

```csharp
[Serializable]
public class GameSaveData
{
    public int level;
    public float[] playerPosition;
    public List<string> unlockedItems;
    public long coins;
    public string version = "1.0";
}

void SaveGame()
{
    GameSaveData saveData = new GameSaveData
    {
        level = currentLevel,
        playerPosition = new float[] { transform.position.x, transform.position.y, transform.position.z },
        unlockedItems = GetUnlockedItems(),
        coins = playerCoins
    };

    // Serialize to JSON
    string json = JsonUtility.ToJson(saveData);
    CloudServices.SetString("complete_save_data", json);

    // Optional: sync to cloud at checkpoints
    CloudServices.Synchronize();
}

void LoadGame()
{
    string json = CloudServices.GetString("complete_save_data");

    if (!string.IsNullOrEmpty(json))
    {
        GameSaveData saveData = JsonUtility.FromJson<GameSaveData>(json);
        currentLevel = saveData.level;
        // Restore other game state
        Debug.Log($"Loaded game at level {saveData.level}");
    }
    else
    {
        Debug.Log("No save data found - starting fresh");
    }
}
```

### Key Management

```csharp
// Check if key exists
if (CloudServices.HasKey("player_name"))
{
    string name = CloudServices.GetString("player_name");
}

// Remove key
CloudServices.RemoveKey("temp_data");

// Get all data snapshot
IDictionary snapshot = CloudServices.GetSnapshot();
foreach (DictionaryEntry entry in snapshot)
{
    Debug.Log($"Key: {entry.Key}, Value: {entry.Value}");
}
```

{% hint style="warning" %}
**Storage limits:**
- **iOS**: 64-byte max key length, 1MB per key, 1MB total, 1024 keys max
- **Android**: 3MB total per user
{% endhint %}

## Handling Data Conflicts

When the same data is modified on multiple devices, Cloud Services detects conflicts and fires `OnSavedDataChange`.

### Understanding Conflict Resolution

Behind the scenes the plugin keeps a snapshot of the previous device values to help you compare changes:

1. Player makes changes on Device A and syncs
2. Player switches to Device B (has old data)
3. Device B calls `Synchronize()` - cloud copy has newer data
4. Local copy is overwritten with cloud copy
5. `OnSavedDataChange` fires with changed keys and reason
6. Your code compares the latest cloud values vs. the previous snapshot using `CloudServicesUtility`
7. Choose winning value and set it back
8. Next sync uploads the resolved data

Use `CloudServicesUtility.TryGetCloudAndLocalCacheValues` inside the event to fetch both values without manually caching them.

### Example: Conflict Resolution

```csharp
void OnEnable()
{
    CloudServices.OnSavedDataChange += OnSavedDataChange;
}

void OnSavedDataChange(CloudServicesSavedDataChangeResult result)
{
    if (result.ChangedKeys == null)
    {
        return;
    }

    Debug.Log($"Data changed - Reason: {result.ChangeReason}");

    foreach (string key in result.ChangedKeys)
    {
        // Use utility to compare the cloud value vs the previous device snapshot
        if (CloudServicesUtility.TryGetCloudAndLocalCacheValues<long>(key, out long cloudValue, out long localValue))
        {
            if (key == "high_score")
            {
                // Keep highest score
                long winnerScore = Math.Max(cloudValue, localValue);
                CloudServices.SetLong(key, winnerScore);
                Debug.Log($"Resolved high_score conflict: cloud={cloudValue}, local={localValue}, winner={winnerScore}");
            }
            else if (key == "total_playtime")
            {
                // Sum playtime from both devices
                long combinedTime = cloudValue + localValue;
                CloudServices.SetLong(key, combinedTime);
                Debug.Log($"Combined playtime: {combinedTime}");
            }
        }
    }
}
```

### Change Reasons

| Reason | Description |
| --- | --- |
| `ServerChange` | Cloud data differs from local data during sync |
| `InitialSyncChange` | First sync after fresh install (cloud data downloaded) |
| `QuotaViolation` | Exceeded storage limits - data reset to cloud copy |
| `AccountChange` | User switched cloud accounts - all keys invalidated |

{% hint style="danger" %}
**Critical**: If you don't handle `OnSavedDataChange`, local changes may be lost when cloud data overwrites the local copy. Always maintain a cache and resolve conflicts.
{% endhint %}

### Conflict Resolution Pattern

```csharp
void OnSavedDataChange(CloudServicesSavedDataChangeResult result)
{
    switch (result.ChangeReason)
    {
        case CloudSavedDataChangeReasonCode.ServerChange:
            // Merge changes from another device
            ResolveConflicts(result.ChangedKeys);
            break;

        case CloudSavedDataChangeReasonCode.InitialSyncChange:
            // First sync - cloud data loaded
            LoadCloudData();
            break;

        case CloudSavedDataChangeReasonCode.AccountChange:
            // User switched accounts - reset local data
            ClearLocalGameData();
            LoadCloudData();
            break;

        case CloudSavedDataChangeReasonCode.QuotaViolation:
            // Exceeded storage - compress data
            Debug.LogWarning("Storage quota exceeded - consider data compression");
            break;
    }
}
```

## Core APIs Reference

| API | Purpose | Returns |
| --- | --- | --- |
| `CloudServices.SetBool(key, value)` | Store boolean value locally | Void - syncs to cloud on next `Synchronize()` |
| `CloudServices.GetBool(key)` | Retrieve boolean value | `bool` (false if not found) |
| `CloudServices.SetInt(key, value)` | Store integer value locally | Void |
| `CloudServices.GetInt(key)` | Retrieve integer value | `int` (0 if not found) |
| `CloudServices.SetLong(key, value)` | Store long value locally | Void |
| `CloudServices.GetLong(key)` | Retrieve long value | `long` (0 if not found) |
| `CloudServices.SetFloat(key, value)` | Store float value locally | Void |
| `CloudServices.GetFloat(key)` | Retrieve float value | `float` (0.0 if not found) |
| `CloudServices.SetDouble(key, value)` | Store double value locally | Void |
| `CloudServices.GetDouble(key)` | Retrieve double value | `double` (0.0 if not found) |
| `CloudServices.SetString(key, value)` | Store string value locally | Void |
| `CloudServices.GetString(key)` | Retrieve string value | `string` (null if not found) |
| `CloudServices.SetByteArray(key, value)` | Store binary data locally | Void |
| `CloudServices.GetByteArray(key)` | Retrieve binary data | `byte[]` (null if not found) |
| `CloudServices.HasKey(key)` | Check if key exists | `bool` |
| `CloudServices.RemoveKey(key)` | Delete key-value pair | Void |
| `CloudServices.GetSnapshot()` | Get all data as dictionary | `IDictionary` |
| `CloudServices.Synchronize(callback)` | Sync local and cloud data | `CloudServicesSynchronizeResult` via callback |
| `CloudServices.ActiveUser` | Get current cloud user info | `CloudUser` (account status and user ID) |
| `CloudServicesUtility.TryGetCloudAndLocalCacheValues<T>(key, out cloud, out local)` | Compare cloud vs cache for conflicts | `bool` (true if both values exist) |

## Error Handling

| Error Code | Trigger | Recommended Action |
| --- | --- | --- |
| Sync failure (result.Success = false) | Network error, user denied authentication | Retry later or continue with local-only data |
| `QuotaViolation` reason | Exceeded storage limits | Compress data or remove unnecessary keys |
| `AccountChange` reason | User switched cloud accounts | Clear local data and reload from new account |
| Null/empty key | Invalid key parameter | Validate keys before calling Get/Set |

```csharp
void OnSynchronizeComplete(CloudServicesSynchronizeResult result)
{
    if (!result.Success)
    {
        Debug.LogWarning("Cloud sync failed - game will continue with local data");
        // Show optional retry UI
        return;
    }

    Debug.Log("Cloud sync successful");
}
```

## Advanced: Runtime Settings Override

{% hint style="danger" %}
Advanced initialization is for server-driven configuration or runtime feature flags only. For standard usage, configure via [Essential Kit Settings](setup.md).
{% endhint %}

### Understanding Advanced Initialization

**Default Behavior:**
Essential Kit automatically initializes Cloud Services with settings from the ScriptableObject asset.

**Advanced Usage:**
Override settings programmatically for:
- Server-driven feature configuration
- A/B testing different sync strategies
- Dynamic platform-specific settings
- Runtime feature flags

### Implementation

```csharp
void Awake()
{
    var settings = ScriptableObject.CreateInstance<CloudServicesUnitySettings>();
    // Configure runtime settings as needed
    CloudServices.Initialize(settings);
}
```

{% hint style="warning" %}
Calling `Initialize()` resets all event listeners and clears cached data. Only use for advanced scenarios requiring runtime configuration.
{% endhint %}

## Related Guides
- Demo scene: `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/CloudServicesDemo.unity`
- Pair with **Game Services** for player authentication and leaderboards
- See [FAQ](faq.md#why-cant-i-see-my-local-changes-after-sync) for common conflict resolution issues
- Check [Testing](testing.md) for cross-device validation procedures
