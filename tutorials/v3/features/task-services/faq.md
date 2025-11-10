---
description: "Common Task Services issues and solutions"
---

# FAQ & Troubleshooting

### Why doesn't background execution work in Unity Editor?
Background task behavior requires native iOS/Android platform APIs that are not available in Unity Editor. **All background task testing must be done on physical devices**. Build and deploy to iOS or Android to test background execution functionality.

### How much background time do I get?
Background execution time is **system-enforced** and varies by platform:

- **iOS**: Approximately **30 seconds** (not guaranteed, may be less if resources are low)
- **Android**: Few **minutes** depending on Android version, device manufacturer, and battery saver settings

Essential Kit cannot extend these limits—they are enforced by the operating system. Design your tasks to complete within these constraints.

### My task takes longer than 30 seconds. What should I do?
Implement a **checkpoint/resume pattern**:

```csharp
async void OnApplicationPause(bool pauseStatus)
{
    if (pauseStatus)
    {
        var saveTask = SaveWithCheckpoints();

        await saveTask.AllowRunningApplicationInBackgroundUntilCompletion(
            onBackgroundProcessingQuotaWillExpireCallback: () =>
            {
                Debug.LogWarning("Quota expiring - saving checkpoint");
                SaveCheckpoint(0); // Save progress so far
                PlayerPrefs.SetInt("ResumeOnNextLaunch", 1);
                PlayerPrefs.Save();
            }
        );
    }
}

async Task SaveWithCheckpoints()
{
    // Stage 1: Critical data
    await SaveCriticalData();
    SaveCheckpoint(1);

    // Stage 2: Secondary data
    await SaveSecondaryData();
    SaveCheckpoint(2);

    // Stage 3: Optional data
    await SaveOptionalData();
    ClearCheckpoint();
}

void SaveCheckpoint(int stage)
{
    PlayerPrefs.SetInt("SaveStage", stage);
    PlayerPrefs.Save();
}

void ClearCheckpoint()
{
    PlayerPrefs.DeleteKey("SaveStage");
    PlayerPrefs.Save();
}
```

On next app launch, check for incomplete saves and resume from the checkpoint.

### Does protecting multiple tasks multiply the background time?
**No**. All tasks share the same background quota (30s on iOS, minutes on Android). Calling `AllowRunningApplicationInBackgroundUntilTaskCompletion` multiple times doesn't extend the total available time.

```csharp
// Both tasks share the same 30-second iOS quota
var task1 = UploadAnalyticsAsync();
var task2 = SaveGameDataAsync();

await Task.WhenAll(
    task1.AllowRunningApplicationInBackgroundUntilCompletion(),
    task2.AllowRunningApplicationInBackgroundUntilCompletion()
); // Total quota: still 30 seconds
```

Design tasks to complete in parallel within the quota, or prioritize critical operations.

### When should I use the quota expiration callback?
Use `onBackgroundProcessingQuotaWillExpireCallback` for **emergency cleanup** when background time is about to expire:

```csharp
    await saveTask.AllowRunningApplicationInBackgroundUntilCompletion(
        onBackgroundProcessingQuotaWillExpireCallback: () =>
        {
            // Quick emergency actions only:
            Debug.Log("Save critical data synchronously.");
            Debug.Log("Set recovery flag for next launch.");
            Debug.Log("Close open file handles.");

        // DON'T try to start new async operations here
        // DON'T expect this to extend execution time
    }
);
```

**Do in callback**:
- Save critical data synchronously (PlayerPrefs)
- Set recovery flags for next launch
- Close file handles and cleanup resources

**Don't do in callback**:
- Start new async operations (won't complete)
- Expect extended execution time (quota is expiring)
- Complex processing (callback executes shortly before termination)

### Can I use Task Services for long-running background uploads?
Not reliably. For uploads exceeding 30 seconds on iOS:

**Better Approach**: Use native platform background upload APIs:
- **iOS**: URLSession background uploads (separate feature)
- **Android**: WorkManager or foreground services

**Task Services Approach** (limited):
```csharp
// Works for quick uploads only (<20 seconds)
async void UploadOnBackground()
{
    var uploadTask = QuickUploadAsync(); // Must complete in <30s

        await uploadTask.AllowRunningApplicationInBackgroundUntilCompletion(
            onBackgroundProcessingQuotaWillExpireCallback: () =>
            {
                Debug.LogWarning("Upload interrupted - will retry on next launch");
                Debug.Log("Persist upload state so it can resume later.");
            }
        );
}
```

For longer uploads, design retry logic and resume on next app launch.

### Does background execution drain battery?
Minimal impact if used correctly. Background execution for 30 seconds consumes negligible battery. However:

**Battery-Efficient**:
- Quick saves (<10 seconds)
- Essential uploads (analytics, save data)
- Cleanup operations

**Battery-Inefficient**:
- Continuous background polling
- Heavy CPU operations in background
- Repeated background wake-ups

Use background execution only for critical operations initiated by user actions (backgrounding app, completing a task).

### Why does my task fail silently when app backgrounds?
Common causes:

**1. Missing await**:
```csharp
// ❌ Wrong - task not awaited
void OnApplicationPause(bool pauseStatus)
{
    if (pauseStatus)
    {
        var saveTask = SaveGameDataAsync();
        TaskServices.AllowRunningApplicationInBackgroundUntilTaskCompletion(saveTask);
        // Task not awaited - may not complete
    }
}

// ✅ Correct - task awaited
async void OnApplicationPause(bool pauseStatus)
{
    if (pauseStatus)
    {
        var saveTask = SaveGameDataAsync();
        await TaskServices.AllowRunningApplicationInBackgroundUntilTaskCompletion(saveTask);
    }
}
```

**2. Task throws exception**:
```csharp
// Add try-catch to see exceptions
async void OnApplicationPause(bool pauseStatus)
{
    if (pauseStatus)
    {
        try
        {
            var saveTask = SaveGameDataAsync();
            await saveTask.AllowRunningApplicationInBackgroundUntilCompletion();
        }
        catch (Exception ex)
        {
            Debug.LogError($"Background task failed: {ex.Message}");
        }
    }
}
```

**3. Logging too late**:
Add logging throughout the task to track progress and identify where it fails.

### Can I test background execution in Unity Editor?
No. Unity Editor doesn't have access to native platform background task APIs. You must build to a physical device to test background execution behavior.

**Testing Workflow**:
1. Build to iOS or Android device
2. Install and launch app
3. Initiate operation requiring background protection
4. Press home button to background app
5. Monitor device logs (Xcode or adb logcat)
6. Resume app and verify operation completed

### How do I verify my task actually ran in background?
Add timestamps and logging:

```csharp
async void OnApplicationPause(bool pauseStatus)
{
    if (pauseStatus)
    {
        float startTime = Time.realtimeSinceStartup;
        Debug.Log($"[Background] Task started at {startTime}");

        var saveTask = SaveGameDataAsync();

        await saveTask.AllowRunningApplicationInBackgroundUntilCompletion(
            onBackgroundProcessingQuotaWillExpireCallback: () =>
            {
                float elapsed = Time.realtimeSinceStartup - startTime;
                Debug.LogWarning($"[Background] Quota expiring after {elapsed}s");
            }
        );

        float endTime = Time.realtimeSinceStartup;
        Debug.Log($"[Background] Task completed in {endTime - startTime}s");
    }
}
```

On iOS: View logs in Xcode → Devices and Simulators → Device Logs
On Android: Use `adb logcat -s Unity:V`

### What's the difference between Task Services and Unity's Application.runInBackground?
Completely different features:

**Unity's `Application.runInBackground`**:
- Controls whether app continues running when **Unity window loses focus** (desktop platforms)
- Only relevant for desktop builds (Windows, Mac, Linux)
- No effect on mobile platforms

**Essential Kit Task Services**:
- Extends mobile app execution when **user backgrounds the app** (iOS/Android)
- Only relevant for mobile platforms
- Requests additional execution time from the operating system

They address different scenarios and platforms.

### Can background tasks access Unity APIs?
**Yes**, but with limitations:

**Safe in Background**:
- `PlayerPrefs` operations
- File I/O operations
- Network requests (HTTP, sockets)
- Most C# standard library operations
- Debug logging

**Unsafe in Background**:
- Rendering operations (may fail if app is suspended)
- Input handling (no user input in background)
- Some Unity APIs that require active rendering context

Stick to data operations (save, load, upload, download) in background tasks.

### How do I handle incomplete saves from quota expiration?
Implement recovery logic on next app launch:

```csharp
void Start()
{
    // Check for incomplete save from previous session
    if (PlayerPrefs.GetInt("SaveIncomplete", 0) == 1)
    {
        Debug.LogWarning("Detected incomplete save from previous session");

        // Check which stage completed
        int lastStage = PlayerPrefs.GetInt("SaveCheckpoint", 0);

        // Resume from checkpoint
        ResumeSaveFromStage(lastStage);

        // Clear flags
        PlayerPrefs.DeleteKey("SaveIncomplete");
        PlayerPrefs.DeleteKey("SaveCheckpoint");
        PlayerPrefs.Save();
    }
}

async void ResumeSaveFromStage(int stage)
{
    Debug.Log($"Resuming save from stage {stage}");

    switch (stage)
    {
        case 1:
            await SaveStage2();
            await SaveStage3();
            break;
        case 2:
            await SaveStage3();
            break;
        default:
            await SaveAllStages();
            break;
    }

    Debug.Log("Save recovery completed");
}
```

### Does Task Services work on all Unity versions?
Task Services requires:
- **Unity 2021.3+** (for C# async/await support)
- **Essential Kit v3+**
- **iOS 11+** or **Android 5.0+**

Older Unity versions may lack proper async/await support, causing compilation errors.

### Where can I confirm plugin behavior versus my implementation?
Run `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/TaskServicesDemo.unity` on a physical device. If the sample works but your implementation doesn't:

- Compare `OnApplicationPause` implementation
- Verify `await` is used on protected tasks
- Check for exceptions in task execution (add try-catch)
- Confirm task duration is under platform limits
- Validate quota expiration callback logic
- Add logging to track execution flow

### Can I use Task Services to keep my app running indefinitely?
**No**. System-enforced limits cannot be bypassed:
- iOS: ~30 seconds maximum
- Android: few minutes maximum
- System may terminate earlier if resources are low

For indefinite background execution, you need:
- **iOS**: Background modes (location, audio, VoIP) - different feature
- **Android**: Foreground services - different feature

Task Services is for **completing specific tasks** when app backgrounds, not continuous background operation.

### What happens if my task completes before quota expires?
Background protection ends immediately when the task completes. No resources are wasted:

```csharp
// Task completes in 5 seconds
var quickTask = SaveQuickDataAsync(); // Completes in 5s

// Background protection ends after 5s, not 30s
await quickTask.AllowRunningApplicationInBackgroundUntilCompletion();

// App can be suspended immediately after task completion
```

The quota expiration callback will **not** be called if the task completes successfully before quota expires.

### How do I test quota expiration callback?
Create a deliberately long task on iOS:

```csharp
async void TestQuotaExpiration()
{
    var longTask = Task.Delay(60000); // 60 seconds - exceeds iOS limit

    await longTask.AllowRunningApplicationInBackgroundUntilCompletion(
        onBackgroundProcessingQuotaWillExpireCallback: () =>
        {
            Debug.LogWarning("QUOTA CALLBACK TRIGGERED - this should happen on iOS");
            // This will be called after ~30 seconds on iOS
        }
    );
}
```

Background app immediately after calling this. On iOS, the callback should trigger after ~30 seconds.
