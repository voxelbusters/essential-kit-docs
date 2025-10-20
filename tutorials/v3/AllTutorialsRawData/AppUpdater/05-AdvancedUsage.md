# App Updater - Advanced Usage

## Custom Initialization

For advanced scenarios, you can initialize the App Updater with custom Unity settings that override default behavior.

```csharp
using VoxelBusters.EssentialKit;

public void CustomInitialization()
{
    var settings = ScriptableObject.CreateInstance<AppUpdaterUnitySettings>();
    AppUpdater.Initialize(settings);
    Debug.Log("App Updater initialized with custom settings");
}
```

This allows you to configure specialized behaviors that aren't available through the default initialization process.

## Force Update Implementation

Implementing mandatory updates ensures critical versions are installed immediately without user dismissal options.

```csharp
public void ForceUpdateFlow()
{
    var options = new PromptUpdateOptions.Builder()
        .SetIsForceUpdate(true)
        .SetPromptTitle("Critical Update Required")
        .SetPromptMessage("This update contains important security fixes.")
        .Build();

    AppUpdater.PromptUpdate(options, (progress, error) => {
        Debug.Log("Force update progress: " + progress);
    });
}
```

When force update is enabled, users cannot dismiss the dialog and must complete the update to continue using the app.

## Error Handling Strategies

Robust error handling ensures your Unity mobile game gracefully handles update failures and network issues.

```csharp
public void RobustUpdateCheck()
{
    AppUpdater.RequestUpdateInfo((result, error) => {
        if (error != null)
        {
            HandleUpdateError(error.Code);
            return;
        }
        ProcessUpdateInfo(result);
    });
}

private void HandleUpdateError(AppUpdaterErrorCode errorCode)
{
    switch (errorCode)
    {
        case AppUpdaterErrorCode.NetworkIssue:
            Debug.Log("Network error - will retry later");
            break;
        case AppUpdaterErrorCode.UpdateNotAvailable:
            Debug.Log("No updates available");
            break;
    }
}
```

This approach provides specific handling for different error scenarios, improving user experience and app reliability.

## Combining Update Information with Prompt

Advanced implementations check update status before prompting, providing more intelligent update flows.

```csharp
public void IntelligentUpdateFlow()
{
    AppUpdater.RequestUpdateInfo((result, error) => {
        if (error == null && result.Status == AppUpdaterUpdateStatus.Available)
        {
            ShowCustomUpdatePrompt();
        }
    });
}

private void ShowCustomUpdatePrompt()
{
    var options = new PromptUpdateOptions.Builder()
        .SetPromptTitle("New Features Available!")
        .SetPromptMessage("Update now to access new game content.")
        .SetAllowInstallationIfDownloaded(true)
        .Build();
    
    AppUpdater.PromptUpdate(options, (progress, error) => {
        Debug.Log("Update progress: " + progress * 100 + "%");
    });
}
```

This pattern combines update checking with conditional prompting for better user experience.

📌 **Video Note**: Show Unity demo of each advanced case: custom initialization in the Unity Inspector, force update dialog that cannot be dismissed, error handling with network simulation, and the intelligent update flow checking status before prompting.