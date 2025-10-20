# Advanced Features

## Initialize Method with Custom Settings

For advanced scenarios, you can initialize Web View with custom global settings:

```csharp
using VoxelBusters.EssentialKit;

// Initialize with custom global settings
WebViewUnitySettings globalSettings = ScriptableObject.CreateInstance<WebViewUnitySettings>();
WebView.Initialize(globalSettings);

// All subsequently created web views will use these settings
WebView webView = WebView.CreateInstance();
```

This advanced initialization allows you to configure default behavior for all web views in your Unity mobile game, useful for maintaining consistent behavior across multiple web view instances.

## Custom URL Scheme Handling

Register custom URL schemes for Unity-web communication:

```csharp
// Register custom scheme
webView.AddURLScheme("unitygame");

// Listen for scheme matches
WebView.OnURLSchemeMatchFound += OnCustomURLScheme;

private void OnCustomURLScheme(string url)
{
    Debug.Log($"Custom URL intercepted: {url}");
    
    // Parse custom commands from web content
    if (url.StartsWith("unitygame://action"))
    {
        string action = ExtractActionFromURL(url);
        ExecuteGameAction(action);
    }
}
```

This advanced pattern enables web content to trigger Unity game actions through custom URL schemes.

## Multiple Web View Coordination

Manage multiple web view instances simultaneously:

```csharp
List<WebView> activeWebViews = new List<WebView>();

// Create multiple web views for different purposes
WebView newsView = WebView.CreateInstance();
newsView.SetNormalizedFrame(new Rect(0f, 0f, 0.5f, 0.5f));
activeWebViews.Add(newsView);

WebView helpView = WebView.CreateInstance(); 
helpView.SetNormalizedFrame(new Rect(0.5f, 0f, 0.5f, 0.5f));
activeWebViews.Add(helpView);

// Coordinate visibility
foreach(var webView in activeWebViews)
{
    webView.AutoShowOnLoadFinish = false; // Manual control
}
```

This approach allows you to manage multiple web views for complex UI layouts or tabbed interfaces.

## Availability Checking

Check if Web View is available before use:

```csharp
WebView webView = WebView.CreateInstance();

if (webView.IsAvailable())
{
    webView.LoadURL(URLString.URLWithPath("https://yourgame.com"));
}
else
{
    Debug.LogWarning("Web View not available on this platform");
    ShowAlternativeContent();
}
```

This provides fallback behavior when Web View cannot be initialized on certain platforms or configurations.

## Performance Optimization

Optimize web view performance for better user experience:

```csharp
// Configure for optimal performance
webView.JavaScriptEnabled = false; // Disable if not needed
webView.ScalesPageToFit = true;    // Reduce rendering load
webView.CanBounce = false;         // Disable unnecessary animations

// Preload content
webView.LoadURL(URLString.URLWithPath("https://yourgame.com/preload"));
webView.AutoShowOnLoadFinish = false; // Control visibility manually

// Clear cache periodically
StartCoroutine(ClearCachesPeriodically(webView, 300f)); // Every 5 minutes
```

This configuration optimizes web view performance by disabling unnecessary features and managing resources efficiently.

## Error Recovery Strategies

Implement robust error handling and recovery:

```csharp
int retryCount = 0;
const int maxRetries = 3;

private void OnWebViewLoadFinish(WebView webView, Error error)
{
    if (error != null && retryCount < maxRetries)
    {
        retryCount++;
        Debug.Log($"Load failed, retry {retryCount}/{maxRetries}");
        
        StartCoroutine(RetryAfterDelay(webView, 2f));
    }
    else if (error != null)
    {
        Debug.LogError("Web view loading failed after all retries");
        ShowOfflineContent();
    }
}

IEnumerator RetryAfterDelay(WebView webView, float delay)
{
    yield return new WaitForSeconds(delay);
    webView.Reload();
}
```

This advanced error handling provides automatic retry logic and graceful degradation for network issues.

📌 Video Note: Show Unity demo of each advanced feature including custom URL schemes, multiple web view coordination, and performance optimizations.