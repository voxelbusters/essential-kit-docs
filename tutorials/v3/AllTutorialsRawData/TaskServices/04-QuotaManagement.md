# Quota Management

## What is Background Processing Quota?

Background Processing Quota refers to the limited amount of time mobile platforms allow apps to run in the background. iOS typically provides 10-30 seconds, while Android varies based on device settings and API level. When this quota expires, your background tasks may be suspended.

## Why Handle Quota Expiration in Unity Mobile Games?

Proper quota management allows you to:
- Clean up resources before suspension
- Save partial progress to prevent data loss
- Notify users about interrupted operations
- Schedule completion for when the app returns to foreground

## Quota Expiration Callback

The quota callback provides early warning before suspension:

```csharp
Task protectedTask = TaskServices.AllowRunningApplicationInBackgroundUntilTaskCompletion(
    longRunningTask,
    onBackgroundProcessingQuotaWillExpireCallback: () =>
    {
        Debug.Log("Background quota expiring - cleanup time!");
    });
```

### Graceful Cleanup Example

Here's how to handle cleanup before suspension:

```csharp
bool isCleanupComplete = false;

Task uploadTask = UploadLargeFile();
await uploadTask.AllowRunningApplicationInBackgroundUntilCompletion(() =>
{
    if (!isCleanupComplete)
    {
        Debug.Log("Saving partial upload progress");
        SaveUploadProgress();
        CancelPendingOperations();
        isCleanupComplete = true;
    }
});
```

This snippet demonstrates saving progress and cleaning up resources when background time is about to expire.

### User Notification Strategy

Consider notifying users about interrupted operations:

```csharp
await ProcessInAppPurchase().AllowRunningApplicationInBackgroundUntilCompletion(() =>
{
    Debug.Log("Purchase processing may pause - will resume when app reopens");
    // Could trigger a local notification here
    ScheduleResumeNotification("Purchase processing will resume when you return");
});
```

This approach keeps users informed about operations that may pause and resume later.

## Platform Differences

Different platforms handle quotas differently:
- **iOS**: Strict time limits with warning callbacks
- **Android**: More flexible but still limited by battery optimization
- **Editor**: No quota limits for testing convenience

📌 Video Note: Show Unity demo of quota expiration callback being triggered during background processing.