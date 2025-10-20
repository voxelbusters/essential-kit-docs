# App Updater - Update Information

## What is Update Information?

Update Information represents the current update status of your Unity mobile game. It tells you whether an update is available, what the current status is, and provides metadata about the update process. This is essential for making informed decisions about when and how to prompt users for updates.

## Why Use Update Information in Unity Mobile Games?

Checking update information allows you to:
- **Proactively detect** when newer versions are available
- **Customize update flows** based on update availability 
- **Implement conditional logic** for different update scenarios
- **Provide better user experience** by checking before prompting

## RequestUpdateInfo API

The primary method for checking update information:

```csharp
public static void RequestUpdateInfo(EventCallback<AppUpdaterUpdateInfo> callback)
```

**Parameters:**
- `callback`: Callback that receives the update information result or error

## AppUpdaterUpdateInfo Class

The result object containing update status information:

```csharp
public class AppUpdaterUpdateInfo
{
    public AppUpdaterUpdateStatus Status { get; private set; }
}
```

**Properties:**
- `Status`: Current update status (Available, NotAvailable, InProgress, Downloaded, Unknown)

## Basic Usage Example

Here's how to check for available updates in your Unity mobile game:

```csharp
using VoxelBusters.EssentialKit;
using UnityEngine;

public void CheckForUpdates()
{
    AppUpdater.RequestUpdateInfo((result, error) => {
        if (error == null)
        {
            Debug.Log("Update Status: " + result.Status);
        }
        else
        {
            Debug.Log("Failed to get update info: " + error);
        }
    });
}
```

This snippet requests update information from the platform's update service. The callback receives either an `AppUpdaterUpdateInfo` object with the current status, or an error if the request failed.

📌 **Video Note**: Show Unity demo clip of calling RequestUpdateInfo in the Unity Editor simulator, displaying the console output showing different update statuses.

The RequestUpdateInfo method works asynchronously and handles all platform-specific communication with app stores automatically, making update checking simple and reliable in your Unity mobile games.