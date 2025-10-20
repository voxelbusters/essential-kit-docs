# App Updater - Update Status

## What is Update Status?

Update Status represents the current state of your Unity mobile game's update process. It provides detailed information about whether updates are available, in progress, or completed, allowing you to make intelligent decisions about how to handle each scenario.

## Why Use Update Status in Unity Mobile Games?

Understanding update status helps you:
- **Implement conditional logic** based on current update state
- **Provide appropriate user messaging** for each status
- **Handle edge cases** like interrupted downloads
- **Optimize update timing** in your game flow
- **Debug update-related issues** effectively

## AppUpdaterUpdateStatus Enum

The status enumeration provides comprehensive state information:

```csharp
public enum AppUpdaterUpdateStatus
{
    Unknown = 0,        // Status cannot be determined
    Available = 1,      // Update is available for download
    NotAvailable = 2,   // App is up to date
    InProgress = 3,     // Update is currently downloading
    Downloaded = 4      // Update downloaded, ready to install
}
```

**Status Values:**
- `Unknown`: Initial state or error condition
- `Available`: New version detected, ready to prompt user
- `NotAvailable`: Current version is latest, no action needed
- `InProgress`: Update actively downloading or installing
- `Downloaded`: Update ready for installation (Android only)

## Status-Based Logic Example

Here's how to handle different update statuses in your Unity mobile game:

```csharp
using VoxelBusters.EssentialKit;
using UnityEngine;

public void HandleUpdateStatus(AppUpdaterUpdateInfo updateInfo)
{
    switch (updateInfo.Status)
    {
        case AppUpdaterUpdateStatus.Available:
            Debug.Log("Update available - showing prompt");
            break;
        
        case AppUpdaterUpdateStatus.NotAvailable:
            Debug.Log("App is up to date");
            break;
        
        case AppUpdaterUpdateStatus.Downloaded:
            Debug.Log("Update downloaded - ready to install");
            break;
    }
}
```

This snippet demonstrates how to implement different behaviors based on the current update status, allowing your Unity mobile game to respond appropriately to each scenario.

📌 **Video Note**: Show Unity demo demonstrating different update statuses, including simulating Available, NotAvailable, and Downloaded states, with appropriate UI responses for each.

The Update Status system provides the foundation for building sophisticated update flows that enhance the user experience while ensuring your Unity iOS and Unity Android games stay current across platforms.