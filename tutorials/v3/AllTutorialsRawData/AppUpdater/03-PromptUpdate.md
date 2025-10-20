# App Updater - Prompt Update

## What is Prompt Update?

Prompt Update displays native platform dialogs to users, asking them to update your Unity mobile game. It provides a customizable, user-friendly interface that handles the entire update flow, from user decision to download progress tracking.

## Why Use Prompt Update in Unity Mobile Games?

Prompting for updates allows you to:
- **Provide native user experience** with platform-appropriate dialogs
- **Control update messaging** with custom titles and descriptions
- **Implement force updates** for critical app versions
- **Track update progress** in real-time
- **Handle user decisions** gracefully

## PromptUpdate API

The main method for showing update prompts:

```csharp
public static void PromptUpdate(PromptUpdateOptions options, EventCallback<float> callback)
```

**Parameters:**
- `options`: Configuration options for the update prompt
- `callback`: Callback that receives update progress (0.0 to 1.0) or error

## PromptUpdateOptions Builder Pattern

The options are constructed using a builder pattern for flexibility:

```csharp
public class PromptUpdateOptions.Builder
{
    public Builder SetIsForceUpdate(bool isForceUpdate)
    public Builder SetPromptTitle(string promptTitle)
    public Builder SetPromptMessage(string message)
    public Builder SetAllowInstallationIfDownloaded(bool allowInstallation)
    public PromptUpdateOptions Build()
}
```

**Key Properties:**
- `IsForceUpdate`: Makes the update mandatory (user cannot dismiss)
- `Title`: Custom title for the update dialog
- `Message`: Custom message explaining the update
- `AllowInstallationIfDownloaded`: Automatically install if update is already downloaded

## Basic Usage Example

Here's how to prompt users for updates in your Unity mobile game:

```csharp
using VoxelBusters.EssentialKit;
using UnityEngine;

public void PromptForUpdate()
{
    var options = new PromptUpdateOptions.Builder()
        .SetIsForceUpdate(false)
        .SetPromptTitle("Update Available")
        .SetPromptMessage("A new version is available. Update now?")
        .Build();

    AppUpdater.PromptUpdate(options, (progress, error) => {
        if (error == null)
        {
            Debug.Log("Update progress: " + progress);
        }
        else
        {
            Debug.Log("Update failed: " + error);
        }
    });
}
```

This snippet creates customizable update options and displays a native prompt. The callback receives progress updates as a float value between 0.0 and 1.0, allowing you to show download progress to users.

📌 **Video Note**: Show Unity demo of PromptUpdate displaying native dialogs on both iOS simulator and Android device, demonstrating the customizable title/message and progress tracking.

The PromptUpdate method automatically handles platform differences, showing App Store redirects on iOS and using Google Play's In-App Update API on Android for seamless Unity cross-platform development.