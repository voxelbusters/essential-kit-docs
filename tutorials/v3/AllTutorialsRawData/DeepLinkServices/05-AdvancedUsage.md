# Advanced Usage

## Custom Initialization with Settings

Initialize DeepLinkServices with custom Unity settings for advanced control:

```csharp
void Start()
{
    var customSettings = Resources.Load<DeepLinkServicesUnitySettings>("DeepLinkSettings");
    DeepLinkServices.Initialize(customSettings);
    
    DeepLinkServices.OnCustomSchemeUrlOpen += HandleCustomScheme;
    DeepLinkServices.OnUniversalLinkOpen += HandleUniversalLink;
}
```

This advanced pattern allows runtime configuration of Deep Link Services using custom settings assets in your Unity project.

## Custom Link Filtering with Delegate

Implement custom logic to filter which links your Unity game should handle:

```csharp
public class GameDeepLinkDelegate : IDeepLinkServicesDelegate
{
    public bool CanHandleCustomSchemeUrl(System.Uri url)
    {
        // Only handle links with specific hosts
        return url.Host == "game" || url.Host == "menu";
    }
    
    public bool CanHandleUniversalLink(System.Uri url)
    {
        // Only handle links from your domain
        return url.Host.Contains("mygame.com");
    }
}

void Start()
{
    DeepLinkServices.Delegate = new GameDeepLinkDelegate();
}
```

This snippet shows how to implement selective link handling for better security and user experience.

## Availability Checking for Conditional Features

Check if Deep Link Services are available before using advanced features:

```csharp
void InitializeDeepLinks()
{
    if (DeepLinkServices.IsAvailable())
    {
        SetupAdvancedLinkHandling();
        Debug.Log("Deep Link Services available and configured");
    }
    else
    {
        Debug.Log("Deep Link Services not available on this platform");
    }
}
```

This pattern ensures your Unity mobile game gracefully handles platforms where deep linking might not be supported.

## Delayed Event Handling

Handle scenarios where deep links arrive before event subscribers are ready:

```csharp
void Start()
{
    // Events are automatically queued until subscribers are registered
    StartCoroutine(DelayedSetup());
}

IEnumerator DelayedSetup()
{
    yield return new WaitForSeconds(1f);
    
    // Subscribe after game initialization
    DeepLinkServices.OnCustomSchemeUrlOpen += HandleCustomScheme;
    DeepLinkServices.OnUniversalLinkOpen += HandleUniversalLink;
    
    Debug.Log("Deep link handlers registered after delay");
}
```

This approach ensures deep link events are not missed during app startup in Unity iOS and Unity Android builds.

## Error Handling and Validation

Implement robust error handling for malformed or unexpected links:

```csharp
void HandleDeepLink(DeepLinkServicesDynamicLinkOpenResult result)
{
    try
    {
        if (result?.Url == null)
        {
            Debug.LogError("Received null or invalid deep link");
            return;
        }
        
        ProcessValidatedLink(result.Url);
    }
    catch (System.Exception e)
    {
        Debug.LogError($"Deep link processing error: {e.Message}");
        ShowUserErrorMessage("Invalid link received");
    }
}
```

This snippet demonstrates proper error handling for production Unity mobile games.

📌 **Video Note**: Show advanced configuration in Essential Kit Settings and custom delegate implementation

Next: [Best Practices](06-BestPractices.md)