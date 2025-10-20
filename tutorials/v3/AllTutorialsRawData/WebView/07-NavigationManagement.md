# Navigation Management

## What is Navigation Management?

Navigation Management encompasses controlling web view display, reloading content, stopping loading operations, and managing the web view lifecycle. This gives you complete control over the user's web browsing experience within your Unity mobile game.

## Why Manage Web View Navigation in Unity Mobile Games?

Navigation management allows you to:
- Control when web content is visible or hidden
- Provide refresh functionality for dynamic content
- Cancel slow-loading operations to improve user experience
- Implement custom navigation flows that integrate with your game UI
- Optimize performance by managing web view resources

## Navigation Control APIs

Essential Kit provides comprehensive navigation methods:

```csharp
// Display management
public void Show()
public void Hide()

// Content control
public void Reload()
public void StopLoading()

// Cache management
public void ClearCache()
```

### Basic Display Control

Show and hide web views programmatically:

```csharp
using VoxelBusters.EssentialKit;

WebView webView = WebView.CreateInstance();
webView.LoadURL(URLString.URLWithPath("https://yourgame.com/news"));

// Show the web view
webView.Show();
Debug.Log("Web view is now visible");

// Hide after 10 seconds
StartCoroutine(HideAfterDelay(webView, 10f));

IEnumerator HideAfterDelay(WebView wv, float delay)
{
    yield return new WaitForSeconds(delay);
    wv.Hide();
    Debug.Log("Web view hidden");
}
```

This snippet demonstrates programmatic control of web view visibility.

### Content Refresh Management

Reload web content when needed:

```csharp
// Reload current page
webView.Reload();
Debug.Log("Reloading web content");

// Or load fresh content
webView.LoadURL(URLString.URLWithPath("https://yourgame.com/news?refresh=true"));
Debug.Log("Loading fresh news content");
```

This approach provides refresh functionality for dynamic web content.

### Loading Control

Stop loading operations when needed:

```csharp
// Start loading content
webView.LoadURL(URLString.URLWithPath("https://example.com/large-content"));

// Stop loading if it takes too long
StartCoroutine(StopLoadingIfSlow(webView, 5f));

IEnumerator StopLoadingIfSlow(WebView wv, float timeout)
{
    yield return new WaitForSeconds(timeout);
    
    if (wv.IsLoading)
    {
        wv.StopLoading();
        Debug.Log("Stopped slow loading operation");
        ShowTimeoutMessage();
    }
}
```

This snippet cancels slow loading operations to maintain responsive user experience.

### Progress Monitoring

Track loading progress for user feedback:

```csharp
void Update()
{
    if (webView != null && webView.IsLoading)
    {
        double progress = webView.Progress;
        UpdateLoadingBar(progress);
        Debug.Log($"Loading progress: {progress:P}");
    }
}
```

This approach provides real-time loading progress feedback.

### Cache Management

Clear cached content when needed:

```csharp
// Clear web view cache
webView.ClearCache();
Debug.Log("Web view cache cleared");

// Useful for:
// - Forcing fresh content loading
// - Reducing memory usage
// - Clearing sensitive cached data
```

Cache clearing is useful for ensuring fresh content and managing memory usage.

## State Monitoring

Monitor web view state properties:

```csharp
Debug.Log($"Current URL: {webView.URL}");
Debug.Log($"Page title: {webView.Title}");
Debug.Log($"Is loading: {webView.IsLoading}");
Debug.Log($"Load progress: {webView.Progress}");
```

📌 Video Note: Show Unity demo of navigation control including show/hide, reload, progress monitoring, and cache clearing operations.