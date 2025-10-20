# Task Extensions

## What are Task Extensions?

Task Extensions provide a more natural, fluent syntax for adding background protection to your existing tasks. Instead of wrapping tasks with static methods, you can call extension methods directly on your Task objects.

## Why Use Task Extensions in Unity Mobile Games?

Extension methods make your code more readable and integrate seamlessly with existing async/await patterns. This reduces cognitive load and makes background protection feel like a natural part of the Task API rather than an external wrapper.

## Extension Methods API

Essential Kit provides these extension methods:

```csharp
// For Task objects
public static Task AllowRunningApplicationInBackgroundUntilCompletion(
    this Task task, 
    Callback onBackgroundProcessingQuotaWillExpireCallback = null)

// For Task<T> objects  
public static Task<TResult> AllowRunningApplicationInBackgroundUntilCompletion<TResult>(
    this Task<TResult> task,
    Callback onBackgroundProcessingQuotaWillExpireCallback = null)
```

### Basic Extension Usage

Here's the cleaner syntax using extensions:

```csharp
using VoxelBusters.EssentialKit;

// Original approach
Task uploadTask = UploadPlayerData();
await uploadTask.AllowRunningApplicationInBackgroundUntilCompletion(() =>
{
    Debug.Log("Background processing quota expiring");
});
```

This snippet shows how extension methods provide a more natural flow compared to the static method approach.

### Chaining with Other Operations

Extensions work beautifully with method chaining:

```csharp
string result = await DownloadGameUpdate()
    .AllowRunningApplicationInBackgroundUntilCompletion(() =>
    {
        Debug.Log("Download may be interrupted soon");
    })
    .ConfigureAwait(false);

Debug.Log($"Update downloaded: {result}");
```

This approach creates a fluent, readable chain of operations where background protection is just another step in the process.

### Comparison

Both approaches are functionally identical - choose based on your coding style preference:

```csharp
// Static method approach
await TaskServices.AllowRunningApplicationInBackgroundUntilTaskCompletion(myTask);

// Extension method approach  
await myTask.AllowRunningApplicationInBackgroundUntilCompletion();
```

📌 Video Note: Show Unity demo demonstrating the difference in coding style between static methods and extensions.