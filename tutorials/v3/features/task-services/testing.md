---
description: "Validating background task execution before release"
---

# Testing & Validation

Use these checks to confirm your Task Services integration before release.

{% hint style="danger" %}
**Device Testing Required**: Background task behavior cannot be accurately tested in Unity Editor. All testing must be done on physical iOS or Android devices to verify real platform behavior.
{% endhint %}

## Device Testing Checklist

### Background Task Protection
- [ ] Task continues executing when app backgrounds (press home button)
- [ ] Task completes successfully despite backgrounding
- [ ] Save operations finish before app suspension
- [ ] Upload operations complete when app is backgrounded
- [ ] Multiple protected tasks all complete successfully
- [ ] Task result values are preserved (for `Task<TResult>`)

### Quota Expiration Handling
- [ ] `onBackgroundProcessingQuotaWillExpireCallback` triggers before termination
- [ ] Emergency cleanup executes successfully in quota callback
- [ ] Checkpoint data saves correctly on quota expiration
- [ ] App recovers properly from incomplete tasks on next launch
- [ ] Critical data saves synchronously in expiration callback

### App Lifecycle Integration
- [ ] `OnApplicationPause(true)` triggers background task protection correctly
- [ ] `OnApplicationPause(false)` allows app to resume normally
- [ ] Background tasks don't interfere with foreground app operation
- [ ] App state remains consistent after background execution
- [ ] Memory and resources cleaned up properly after task completion

### Extension Method Syntax
- [ ] Extension method syntax works identically to static method
- [ ] `task.AllowRunningApplicationInBackgroundUntilCompletion()` protects tasks
- [ ] Extension methods preserve task results correctly
- [ ] Extension method callbacks trigger as expected

## Platform-Specific Checks

### iOS Testing
- [ ] Background execution extends approximately 30 seconds
- [ ] Tasks completing under 20 seconds finish successfully
- [ ] Tasks exceeding 30 seconds trigger quota expiration callback
- [ ] System terminates app gracefully after quota expires
- [ ] Background mode works on iOS 13+ devices
- [ ] UIKit.framework links correctly (no missing framework errors)

### Android Testing
- [ ] Background execution extends for minutes (device-dependent)
- [ ] Android 12+ devices respect stricter background limits
- [ ] Longer tasks (1-2 minutes) complete successfully on Android
- [ ] Background execution doesn't drain battery excessively
- [ ] App doesn't violate Android background execution policies
- [ ] Foreground services (if used) display notification correctly

## Performance Validation
- [ ] Background execution doesn't cause excessive battery drain
- [ ] Protected tasks don't block main thread unnecessarily
- [ ] Memory usage remains reasonable during background execution
- [ ] Multiple protected tasks complete efficiently in quota time
- [ ] Checkpoint/resume patterns minimize data loss on timeout
- [ ] Emergency save completes quickly in quota expiration callback

## Common Test Scenarios

### Save Game State on Pause
```
1. Start game and play normally
2. Make significant progress (change level, collect items, etc.)
3. Press home button to background app
4. Wait 5-10 seconds
5. Resume app
6. Verify all progress was saved correctly
```

### Upload Analytics on Background
```
1. Generate analytics events in app
2. Trigger analytics upload
3. Immediately background app (home button)
4. Wait for upload to complete (check server logs)
5. Resume app
6. Verify analytics data uploaded successfully
```

### Cloud Sync with Quota Expiration
```
1. Create large cloud sync task (>30 seconds on iOS)
2. Background app during sync
3. Observe quota expiration callback trigger
4. Verify emergency checkpoint saves
5. Resume app
6. Verify app can resume sync from checkpoint
```

### Multiple Protected Tasks
```
1. Queue multiple background tasks (save, upload, cleanup)
2. Background app
3. Monitor all tasks complete before suspension
4. Resume app
5. Verify all operations completed successfully
```

## Time Limit Testing

### iOS 30-Second Limit
Test tasks with varying durations:
- [ ] 10-second task completes successfully
- [ ] 20-second task completes successfully
- [ ] 30-second task triggers quota expiration callback
- [ ] 40-second task terminates with partial completion

### Android Extended Limits
Test longer operations on Android:
- [ ] 1-minute task completes successfully
- [ ] 2-minute task completes on most devices
- [ ] 5-minute task may trigger expiration on newer Android versions
- [ ] Battery saver mode affects background time limits

## Error Testing

Test error handling for common failures:
- [ ] Network failure during background upload handled gracefully
- [ ] Disk full error during background save handled properly
- [ ] Exception in task propagates correctly to error handlers
- [ ] Task cancellation works correctly
- [ ] Invalid task parameter (null) throws appropriate exception

```csharp
// Test error handling
async void TestBackgroundTaskError()
{
    try
    {
        var faultyTask = ThrowExceptionAsync();
        await faultyTask.AllowRunningApplicationInBackgroundUntilCompletion(
            onBackgroundProcessingQuotaWillExpireCallback: () =>
            {
                Debug.Log("Quota expiring - this should be called");
            }
        );
    }
    catch (Exception ex)
    {
        // Verify exception handling works correctly
        Debug.LogError($"Expected error caught: {ex.Message}");
    }
}

async Task ThrowExceptionAsync()
{
    await Task.Delay(1000);
    throw new InvalidOperationException("Test exception");
}
```

## Pre-Submission Review
- [ ] Test on physical devices (iOS and Android) at minimum supported OS versions
- [ ] Verify background execution completes critical operations (save, upload)
- [ ] Test quota expiration callbacks execute emergency cleanup correctly
- [ ] Test complete user flows: play → background → resume → verify state
- [ ] Verify no background tasks cause excessive battery drain
- [ ] Test with various background time limits (iOS strict, Android variable)
- [ ] Confirm task completion doesn't block app responsiveness

## Troubleshooting Test Failures

If background tasks don't complete or quota expires prematurely:

1. **Verify Device Testing**: Confirm testing on physical device, not Unity Editor or simulator
2. **Check Task Duration**: Verify task completes in under 20 seconds for iOS
3. **Monitor Logs**: Add logging throughout task to track execution progress
4. **Test Quota Callback**: Ensure callback is implemented and logs when triggered
5. **Test with Demo Scene**: Run `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/TaskServicesDemo.unity` on device

### Debugging Background Execution

Add extensive logging to track task progress:

```csharp
async void OnApplicationPause(bool pauseStatus)
{
    if (pauseStatus)
    {
        Debug.Log("[TaskServices] App backgrounding - starting protected save");

        var saveTask = SaveGameDataWithLogging();

        await saveTask.AllowRunningApplicationInBackgroundUntilCompletion(
            onBackgroundProcessingQuotaWillExpireCallback: () =>
            {
                Debug.LogWarning("[TaskServices] QUOTA EXPIRING - emergency save");
                Debug.Log($"[TaskServices] Time elapsed: {Time.realtimeSinceStartup}");
            }
        );

        Debug.Log("[TaskServices] Protected save completed successfully");
    }
}

async Task SaveGameDataWithLogging()
{
    float startTime = Time.realtimeSinceStartup;
    Debug.Log($"[TaskServices] Save started at {startTime}");

    await Task.Delay(1000);
    Debug.Log($"[TaskServices] Stage 1 complete ({Time.realtimeSinceStartup - startTime}s)");

    await Task.Delay(1000);
    Debug.Log($"[TaskServices] Stage 2 complete ({Time.realtimeSinceStartup - startTime}s)");

    await Task.Delay(1000);
    Debug.Log($"[TaskServices] Stage 3 complete ({Time.realtimeSinceStartup - startTime}s)");

    Debug.Log($"[TaskServices] Save finished in {Time.realtimeSinceStartup - startTime}s");
}
```

### Platform-Specific Debugging

**iOS - Check Xcode Console**:
- Connect device to Mac
- Open Xcode → Window → Devices and Simulators
- Select device → View Device Logs
- Monitor background task lifecycle events

**Android - Check Logcat**:
```bash
adb logcat -s Unity:V
```

Monitor for:
- Background task start messages
- Task completion confirmations
- Quota expiration warnings
- System termination events

{% hint style="success" %}
**Testing Tip**: Start with simple 5-second tasks to verify basic functionality before testing edge cases like quota expiration. Add progressive logging to track exactly when and why tasks fail.
{% endhint %}

## Related Guides
- [Setup Guide](setup.md) - Verify configuration before testing
- [Usage Guide](usage.md) - Review implementation patterns
- [FAQ](faq.md) - Solutions for common test failures
