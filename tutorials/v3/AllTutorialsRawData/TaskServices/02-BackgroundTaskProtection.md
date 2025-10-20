# Background Task Protection

## What is Background Task Protection?

Background Task Protection ensures your critical operations complete even when your Unity mobile game goes to the background. This is essential for operations like uploading player progress, downloading content, or processing purchases that shouldn't be interrupted by app lifecycle changes.

## Why Use Background Task Protection in Unity Mobile Games?

Mobile platforms aggressively suspend apps to preserve battery life. Without protection, your important operations might be interrupted mid-process, leading to:
- Lost player progress
- Incomplete downloads  
- Failed payment processing
- Corrupted save data

## Task Services API

The main method for protecting tasks:

```csharp
public static Task AllowRunningApplicationInBackgroundUntilTaskCompletion(
    Task task, 
    Callback onBackgroundProcessingQuotaWillExpireCallback = null)
```

### Basic Usage

Here's how to protect a simple network request:

```csharp
using VoxelBusters.EssentialKit;
using System.Threading.Tasks;

// Create your task
Task uploadTask = UploadPlayerScore();

// Protect it from background interruption
Task protectedTask = TaskServices.AllowRunningApplicationInBackgroundUntilTaskCompletion(
    uploadTask,
    onBackgroundProcessingQuotaWillExpireCallback: () =>
    {
        Debug.Log("Background time running low - cleanup if needed");
    });

await protectedTask;
Debug.Log("Upload completed successfully");
```

This snippet wraps your existing task with background protection, ensuring the upload completes even if the player switches apps.

### Generic Task Support

For tasks that return values:

```csharp
Task<string> downloadTask = DownloadGameContent();
Task<string> protectedDownload = TaskServices.AllowRunningApplicationInBackgroundUntilTaskCompletion(
    downloadTask,
    onBackgroundProcessingQuotaWillExpireCallback: () =>
    {
        Debug.Log("Download may pause soon");
    });

string content = await protectedDownload;
Debug.Log($"Downloaded: {content}");
```

This approach protects tasks while preserving their return values.

📌 Video Note: Show Unity demo clip of a task continuing to run when the app goes to background.