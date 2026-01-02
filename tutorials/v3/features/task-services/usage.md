---
description: "Task Services protects critical async operations from app backgrounding interruption"
---

# Usage

Essential Kit's Task Services wraps platform-specific background task APIs into a unified async/await interface. When users background your app, Task Services requests additional execution time from the OS to complete critical operations like saving game state or uploading data.

## Table of Contents

- [Import Namespaces](#import-namespaces)
- [Understanding Background Task Protection](#understanding-background-task-protection)
- [Core API: AllowRunningApplicationInBackgroundUntilTaskCompletion](#core-api-allowrunningapplicationinbackgrounduntiltaskcompletion)
- [Extension Methods for Cleaner Syntax](#extension-methods-for-cleaner-syntax)
- [Pattern 1: Save Game Data on Pause](#pattern-1-save-game-data-on-pause)
- [Pattern 2: Extension Method Syntax](#pattern-2-extension-method-syntax)
- [Pattern 3: Task with Return Value](#pattern-3-task-with-return-value)
- [Pattern 4: Multiple Protected Tasks](#pattern-4-multiple-protected-tasks)
- [Handling Quota Expiration](#handling-quota-expiration)
- [Data Properties](#data-properties)
- [Core APIs Reference](#core-apis-reference)
- [Error Handling](#error-handling)
- [Advanced: Manual Initialization](#advanced-manual-initialization)

## Import Namespaces
```csharp
using VoxelBusters.EssentialKit;
using VoxelBusters.CoreLibrary;
```

## Understanding Background Task Protection

When a user presses the home button or switches apps, mobile operating systems transition your app through lifecycle states:

**Normal Flow (without Task Services)**:
```
User presses Home → App enters Background → OS suspends app after ~1 second → Task interrupted ❌
```

**Protected Flow (with Task Services)**:
```
User presses Home → Task Services requests background time → App continues for 30s (iOS) / minutes (Android) → Task completes ✅
```

{% hint style="warning" %}
**System Limits**: Task Services **extends** background time but cannot eliminate system limits. iOS allows ~30 seconds, Android allows a few minutes. Design tasks to complete within these limits or implement checkpoint/resume patterns.
{% endhint %}

## Core API: AllowRunningApplicationInBackgroundUntilTaskCompletion

The primary method protects any async Task from backgrounding interruption:

```csharp
using System.Threading.Tasks;
using UnityEngine;

// API Signature:
public static Task AllowRunningApplicationInBackgroundUntilTaskCompletion(
    Task task,
    Callback onBackgroundProcessingQuotaWillExpireCallback = null
);
```

| Parameter | Type | Purpose |
| --- | --- | --- |
| `task` | `Task` | The async operation to protect from backgrounding |
| `onBackgroundProcessingQuotaWillExpireCallback` | `Callback` | Optional callback when background time is about to expire |

**Returns**: Continuation task that completes when the original task finishes and handles cleanup.

### Generic Overload for Task\<TResult\>

For tasks that return values:

```csharp
using System.Threading.Tasks;
using UnityEngine;

// Example: Using the generic overload with a task that returns a value
    // Assume you have a PlayerData class and SavePlayerDataAsync() method defined in your game code
    async Task<PlayerData> SavePlayerDataWithBackgroundSupport()
    {
        Task<PlayerData> saveTask = SavePlayerDataAsync();

        return await TaskServices.AllowRunningApplicationInBackgroundUntilTaskCompletion(
            saveTask,
            onBackgroundProcessingQuotaWillExpireCallback: () =>
            {
                Debug.Log("Background time expiring - save operation finishing");
            }
    );
}
```

Preserves the task result while providing background protection.

## Extension Methods for Cleaner Syntax

Task Services provides extension methods on `Task` and `Task<TResult>`:

**API Signatures:**
```csharp
using System.Threading.Tasks;
using UnityEngine;

// Extension method that allows running application in background until task completion
public static Task AllowRunningApplicationInBackgroundUntilCompletion(
            this Task task,
            Callback onBackgroundProcessingQuotaWillExpireCallback = null
);

public static Task<TResult> AllowRunningApplicationInBackgroundUntilCompletion<TResult>(
    this Task<TResult> task,
    Callback onBackgroundProcessingQuotaWillExpireCallback = null
);
```

Extension methods provide identical functionality with more convenient syntax.

## Pattern 1: Save Game Data on Pause

Protect save operations when the user backgrounds the app:

```csharp
using System.Threading.Tasks;
using UnityEngine;
using VoxelBusters.EssentialKit;
using VoxelBusters.CoreLibrary;

public class GameManager : MonoBehaviour
{
    async void OnApplicationPause(bool pauseStatus)
    {
        if (pauseStatus)
        {
            Debug.Log("App backgrounding - initiating protected save");

            // Create save task
            var saveTask = SaveGameDataAsync();

            // Protect with background execution
            await TaskServices.AllowRunningApplicationInBackgroundUntilTaskCompletion(
                saveTask,
                onBackgroundProcessingQuotaWillExpireCallback: () =>
                {
                    Debug.LogWarning("Background time expiring - save may be interrupted");
                    // Perform emergency cleanup if needed
                    MarkSaveAsPartial();
                }
            );

            Debug.Log("Save completed successfully");
        }
        else
        {
            Debug.Log("App resuming from background");
        }
    }

    async Task SaveGameDataAsync()
    {
        Debug.Log("Saving player progress...");
        await SavePlayerProgress();

        Debug.Log("Saving inventory...");
        await SaveInventory();

        Debug.Log("Uploading to cloud...");
        await UploadToCloud();

        Debug.Log("All save operations completed");
    }

    async Task SavePlayerProgress()
    {
        await Task.Delay(1000); // Simulate save operation
        PlayerPrefs.SetInt("PlayerLevel", 10);
        PlayerPrefs.Save();
    }

    async Task SaveInventory()
    {
        await Task.Delay(500); // Simulate inventory save
        // Save inventory data
    }

    async Task UploadToCloud()
    {
        await Task.Delay(2000); // Simulate cloud upload
        // Upload save to cloud service
    }

    void MarkSaveAsPartial()
    {
        PlayerPrefs.SetInt("SaveIncomplete", 1);
        PlayerPrefs.Save();
        Debug.Log("Marked save as incomplete for recovery on next launch");
    }
}
```

{% hint style="info" %}
**OnApplicationPause Timing**: `OnApplicationPause(true)` is called when the app is about to background. This is your opportunity to initiate protected save operations.
{% endhint %}

## Pattern 2: Extension Method Syntax

Use extension methods for cleaner, more readable code:

```csharp
using VoxelBusters.EssentialKit;
using VoxelBusters.CoreLibrary;
using System.Threading.Tasks;

public class AnalyticsManager : MonoBehaviour
{
    public async void UploadAnalytics()
    {
        try
        {
            Debug.Log("Starting analytics upload");

            var uploadTask = PerformAnalyticsUploadAsync();

            // Extension method syntax - cleaner and more natural
            await uploadTask.AllowRunningApplicationInBackgroundUntilCompletion(
                onBackgroundProcessingQuotaWillExpireCallback: () =>
                {
                    Debug.LogWarning("Upload may be interrupted - saving partial data");
                    SavePartialAnalyticsData();
                }
            );

            Debug.Log("Analytics upload completed successfully");
        }
        catch (Exception ex)
        {
            Debug.LogError($"Analytics upload failed: {ex.Message}");
        }
    }

    async Task PerformAnalyticsUploadAsync()
    {
        // Batch analytics events
        var events = GatherAnalyticsEvents();

        // Simulate network upload
        await Task.Delay(3000);

        // Upload to analytics service
        Debug.Log($"Uploaded {events.Count} analytics events");
    }

    List<string> GatherAnalyticsEvents()
    {
        return new List<string> { "level_complete", "item_purchased", "achievement_unlocked" };
    }

    void SavePartialAnalyticsData()
    {
        Debug.Log("Saving analytics events locally for next upload");
        // Save events to local storage for retry
    }
}
```

## Pattern 3: Task with Return Value

Protect operations that return results:

```csharp
using VoxelBusters.EssentialKit;
using VoxelBusters.CoreLibrary;
using System.Threading.Tasks;

public class CloudSyncManager : MonoBehaviour
{
    async void OnApplicationPause(bool pauseStatus)
    {
        if (pauseStatus)
        {
            var syncTask = SyncWithCloudAsync();

            // Generic overload preserves return value
            bool syncSuccess = await TaskServices.AllowRunningApplicationInBackgroundUntilTaskCompletion(
                syncTask,
                onBackgroundProcessingQuotaWillExpireCallback: () =>
                {
                    Debug.LogWarning("Cloud sync may timeout");
                }
            );

            if (syncSuccess)
            {
                Debug.Log("Cloud sync completed successfully");
            }
            else
            {
                Debug.LogError("Cloud sync failed");
            }
        }
    }

    async Task<bool> SyncWithCloudAsync()
    {
        try
        {
            Debug.Log("Starting cloud synchronization");

            // Upload local changes
            await UploadLocalChanges();

            // Download remote changes
            await DownloadRemoteChanges();

            // Merge data
            await MergeCloudData();

            Debug.Log("Cloud sync completed");
            return true;
        }
        catch (Exception ex)
        {
            Debug.LogError($"Cloud sync error: {ex.Message}");
            return false;
        }
    }

    async Task UploadLocalChanges()
    {
        await Task.Delay(1000);
        Debug.Log("Local changes uploaded");
    }

    async Task DownloadRemoteChanges()
    {
        await Task.Delay(1500);
        Debug.Log("Remote changes downloaded");
    }

    async Task MergeCloudData()
    {
        await Task.Delay(500);
        Debug.Log("Data merged successfully");
    }
}
```

## Pattern 4: Multiple Protected Tasks

You can protect multiple independent tasks:

```csharp
using VoxelBusters.EssentialKit;
using VoxelBusters.CoreLibrary;
using System.Threading.Tasks;

public class DataManager : MonoBehaviour
{
    async void OnApplicationPause(bool pauseStatus)
    {
        if (pauseStatus)
        {
            Debug.Log("App backgrounding - protecting multiple operations");

            // Create multiple tasks
            var saveTask = SaveGameDataAsync();
            var uploadTask = UploadAnalyticsAsync();
            var cleanupTask = CleanupResourcesAsync();

            // Protect all tasks with background execution
            // Note: All tasks share the same background time quota
            await Task.WhenAll(
                saveTask.AllowRunningApplicationInBackgroundUntilCompletion(),
                uploadTask.AllowRunningApplicationInBackgroundUntilCompletion(),
                cleanupTask.AllowRunningApplicationInBackgroundUntilCompletion()
            );

            Debug.Log("All background operations completed");
        }
    }

    async Task SaveGameDataAsync()
    {
        await Task.Delay(1000);
        Debug.Log("Game data saved");
    }

    async Task UploadAnalyticsAsync()
    {
        await Task.Delay(1500);
        Debug.Log("Analytics uploaded");
    }

    async Task CleanupResourcesAsync()
    {
        await Task.Delay(500);
        Debug.Log("Resources cleaned up");
    }
}
```

{% hint style="warning" %}
**Shared Background Quota**: All protected tasks share the same background time quota (30s on iOS, minutes on Android). Design tasks to complete within this limit or they may all be terminated together.
{% endhint %}

## Handling Quota Expiration

Always implement quota expiration callbacks for graceful degradation:

```csharp
using VoxelBusters.EssentialKit;
using VoxelBusters.CoreLibrary;
using System.Threading.Tasks;

public class RobustSaveManager : MonoBehaviour
{
    async void OnApplicationPause(bool pauseStatus)
    {
        if (pauseStatus)
        {
            var saveTask = SaveWithCheckpointingAsync();

            await saveTask.AllowRunningApplicationInBackgroundUntilCompletion(
                onBackgroundProcessingQuotaWillExpireCallback: () =>
                {
                    Debug.LogWarning("Background quota expiring - implementing emergency save");

                    // Quick save critical data only
                    SaveCriticalDataSynchronously();

                    // Set flag to resume on next launch
                    PlayerPrefs.SetInt("ResumeIncompleteSave", 1);
                    PlayerPrefs.Save();
                }
            );
        }
    }

    async Task SaveWithCheckpointingAsync()
    {
        // Save in stages with checkpoints
        await SaveStage1();
        SetCheckpoint(1);

        await SaveStage2();
        SetCheckpoint(2);

        await SaveStage3();
        SetCheckpoint(3);

        ClearCheckpoint();
        Debug.Log("Complete save finished");
    }

    async Task SaveStage1()
    {
        await Task.Delay(800);
        Debug.Log("Stage 1: Player stats saved");
    }

    async Task SaveStage2()
    {
        await Task.Delay(800);
        Debug.Log("Stage 2: Inventory saved");
    }

    async Task SaveStage3()
    {
        await Task.Delay(800);
        Debug.Log("Stage 3: World state saved");
    }

    void SetCheckpoint(int stage)
    {
        PlayerPrefs.SetInt("SaveCheckpoint", stage);
        PlayerPrefs.Save();
    }

    void ClearCheckpoint()
    {
        PlayerPrefs.DeleteKey("SaveCheckpoint");
        PlayerPrefs.Save();
    }

void SaveCriticalDataSynchronously()
{
    // Emergency save - only critical data, synchronous
    PlayerPrefs.SetInt("PlayerLevel", 10);
    PlayerPrefs.SetInt("LastKnownHealth", 75);
    PlayerPrefs.Save();
    Debug.Log("Emergency save completed");
}
}
```

## Data Properties

| Item | Type | Notes |
| --- | --- | --- |
| `TaskServices.AllowRunningApplicationInBackgroundUntilTaskCompletion` | Method | Wraps a `Task` so Essential Kit requests platform background time until the work completes. |
| `TaskServices.AllowRunningApplicationInBackgroundUntilTaskCompletion<TResult>` | Method | Same as above but preserves the original task’s return value. |
| `Task.AllowRunningApplicationInBackgroundUntilCompletion` | Extension Method | Fluent syntax for protecting tasks without additional wrappers. |
| `Callback onBackgroundProcessingQuotaWillExpireCallback` | `Callback` | Invoked when the OS is about to reclaim background time; use it for emergency saves or cleanup. |
| `TaskServicesUnitySettings.IsEnabled` | `bool` | Confirms whether Task Services is active. If `false`, the helper methods will log an error instead of protecting the task. |

## Core APIs Reference

| API | Purpose | Returns |
| --- | --- | --- |
| `TaskServices.AllowRunningApplicationInBackgroundUntilTaskCompletion(task, callback)` | Protect async Task from backgrounding | `Task` continuation |
| `TaskServices.AllowRunningApplicationInBackgroundUntilTaskCompletion<T>(task, callback)` | Protect Task\<T\> preserving result | `Task<T>` continuation |
| `task.AllowRunningApplicationInBackgroundUntilCompletion(callback)` | Extension method for Task | `Task` continuation |
| `task.AllowRunningApplicationInBackgroundUntilCompletion<T>(callback)` | Extension method for Task\<T\> | `Task<T>` continuation |

## Error Handling

| Scenario | Trigger | Recommended Action |
| --- | --- | --- |
| Feature disabled or not initialized | Helper logs “Feature is not active or not yet initialised.” | Enable Task Services in Essential Kit Settings or call `TaskServices.Initialize` before awaiting background-protected tasks. |
| Background quota expires early | Long-running operation exceeds OS limit | Use the quota callback to persist critical state synchronously and resume the workload on the next foreground session. |
| Exceptions thrown inside protected task | `await` raises an exception after background completion | Wrap protected calls in `try/catch` blocks so you can surface telemetry, retry on resume, or notify the player. |
| Nested protection | Same task wrapped more than once | Guard against double-wrapping by tracking outstanding tasks or creating helper methods that centralize protection. |
| Android background restrictions | Device kills background work while in Doze/battery saver | Pair protected tasks with user-visible progress (e.g., foreground service) or postpone heavy uploads until the device is active. |

## Important Behaviors

**Background Time Quota**:
- **iOS**: Approximately 30 seconds of background execution time
- **Android**: Few minutes depending on device and Android version
- System may terminate earlier if resources are critically low

**Shared Quota**:
- All tasks protected in a single app share the same background time quota
- Multiple `AllowRunningApplicationInBackgroundUntilTaskCompletion` calls don't multiply available time

**Callback Timing**:
- `onBackgroundProcessingQuotaWillExpireCallback` is called shortly before system termination
- Use this callback for emergency cleanup, not to extend execution time

**Task Lifetime**:
- Protected tasks continue running even when the entire app is in background state
- All other Unity MonoBehaviour code also continues executing during background time

{% hint style="success" %}
**Best Practice**: Design tasks to complete in under 20 seconds to have safety margin before iOS quota expiration. For longer operations, implement checkpoint/resume patterns.
{% endhint %}

## Advanced: Manual Initialization

{% hint style="warning" %}
Manual initialization is only needed for specific runtime scenarios. For most games, Essential Kit's automatic initialization handles everything. **Skip this section unless** you need runtime configuration or custom task monitoring.
{% endhint %}

### Understanding Manual Initialization

**Default Behavior:**
Essential Kit automatically initializes Task Services using global settings from the ScriptableObject configured in Unity Editor.

**Advanced Usage:**
Override settings at runtime when you need:
- Custom background task timeout monitoring
- Different task priority levels for various operations
- Runtime task execution policies based on battery level or device capabilities

### Implementation

```csharp
void Awake()
{
    var settings = new TaskServicesUnitySettings(isEnabled: true);
    TaskServices.Initialize(settings);
}
```

{% hint style="info" %}
Call `Initialize()` once before using Task Services features. Most games should use the [standard setup](setup.md) configured in Essential Kit Settings instead.
{% endhint %}

## Related Guides
- Demo scene: `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/TaskServicesDemo.unity`
- Use with **Cloud Services** to sync game state on backgrounding
- Pair with **Network Services** to verify connectivity before uploads
- See [Testing Guide](testing.md) for device testing checklist
