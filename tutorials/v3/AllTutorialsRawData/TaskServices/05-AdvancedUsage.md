# Advanced Usage

## Initialize Method with Custom Settings

For advanced scenarios, you can initialize Task Services with custom settings using the `Initialize` method:

```csharp
using VoxelBusters.EssentialKit;

// Initialize with custom settings
TaskServicesUnitySettings customSettings = ScriptableObject.CreateInstance<TaskServicesUnitySettings>();
TaskServices.Initialize(customSettings);
```

This advanced initialization allows you to configure Task Services behavior beyond the default settings, useful when you need specific platform optimizations or custom background processing parameters.

## Multiple Task Coordination

When protecting multiple related tasks, all tasks benefit from the background processing window:

```csharp
Task upload1 = UploadPlayerStats();
Task upload2 = UploadGameProgress(); 
Task upload3 = UploadAchievements();

// Protect the main coordination task
Task allUploads = Task.WhenAll(upload1, upload2, upload3);
await allUploads.AllowRunningApplicationInBackgroundUntilCompletion(() =>
{
    Debug.Log("Multiple uploads may be interrupted");
});
```

This snippet shows how protecting one task extends background processing time for all concurrent operations within the same protection window.

## Availability Checking

Check if Task Services are available before use:

```csharp
if (TaskServices.IsAvailable())
{
    await criticalTask.AllowRunningApplicationInBackgroundUntilCompletion();
}
else
{
    Debug.LogWarning("Task Services not available - task may be interrupted");
    await criticalTask;
}
```

This approach provides fallback behavior when Task Services cannot be initialized on certain platforms or configurations.

## Cancellation Token Integration

Combine Task Services with cancellation tokens for robust task management:

```csharp
using System.Threading;

CancellationTokenSource cts = new CancellationTokenSource();
Task cancellableTask = ProcessDataWithCancellation(cts.Token);

await cancellableTask.AllowRunningApplicationInBackgroundUntilCompletion(() =>
{
    Debug.Log("Background quota expiring - cancelling task");
    cts.Cancel();
});
```

This advanced pattern allows you to gracefully cancel long-running operations when background time expires.

📌 Video Note: Show Unity demo of each advanced case including initialization, multiple task coordination, and cancellation token usage.