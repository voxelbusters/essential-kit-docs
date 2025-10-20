# Event Handling

## What is Web View Event Handling?

Event Handling allows you to respond to web view lifecycle events and user interactions. This includes events for showing/hiding, loading progress, completion, and errors, enabling you to create responsive web experiences in your Unity mobile games.

## Why Handle Web View Events in Unity Mobile Games?

Event handling enables you to:
- Show loading indicators while content loads
- Handle loading errors gracefully with fallback content
- Track user engagement and navigation patterns
- Coordinate web view display with your game's UI flow
- Respond to custom URL schemes for Unity-web communication

## Web View Events API

Essential Kit provides these key events:

```csharp
// Lifecycle events
public static event Callback<WebView> OnShow;
public static event Callback<WebView> OnHide;

// Loading events
public static event Callback<WebView> OnLoadStart;
public static event EventCallback<WebView> OnLoadFinish;

// Communication events  
public static event Callback<string> OnURLSchemeMatchFound;
```

### Basic Event Registration

Register for web view events in your Unity script:

```csharp
using VoxelBusters.EssentialKit;

void OnEnable()
{
    WebView.OnShow += OnWebViewShow;
    WebView.OnHide += OnWebViewHide;
    WebView.OnLoadStart += OnWebViewLoadStart;
    WebView.OnLoadFinish += OnWebViewLoadFinish;
}

void OnDisable()
{
    WebView.OnShow -= OnWebViewShow;
    WebView.OnHide -= OnWebViewHide;
    WebView.OnLoadStart -= OnWebViewLoadStart;
    WebView.OnLoadFinish -= OnWebViewLoadFinish;
}

Debug.Log("Web view events registered");
```

This snippet shows proper event registration and cleanup.

### Handling Loading Events

Respond to web content loading progress:

```csharp
private void OnWebViewLoadStart(WebView webView)
{
    if (webView == myWebView)
    {
        Debug.Log($"Started loading: {webView.URL}");
        ShowLoadingIndicator(true);
    }
}

private void OnWebViewLoadFinish(WebView webView, Error error)
{
    if (webView == myWebView)
    {
        ShowLoadingIndicator(false);
        
        if (error == null)
        {
            Debug.Log("Web content loaded successfully");
        }
        else
        {
            Debug.LogError($"Loading failed: {error.LocalizedDescription}");
            ShowErrorMessage("Failed to load web content");
        }
    }
}
```

This approach provides user feedback during the loading process.

### Handling Visibility Events

Track when web views are shown or hidden:

```csharp
private void OnWebViewShow(WebView webView)
{
    if (webView == myWebView)
    {
        Debug.Log("Web view is now visible");
        PauseGameplay();  // Pause game while showing web content
    }
}

private void OnWebViewHide(WebView webView)
{
    if (webView == myWebView)  
    {
        Debug.Log("Web view is now hidden");
        ResumeGameplay();  // Resume game when web content is dismissed
    }
}
```

This snippet demonstrates coordinating web view display with your game's state.

### Error Handling

Handle web view errors using the proper error codes:

```csharp
private void OnWebViewLoadFinish(WebView webView, Error error)
{
    if (error != null && error.Code is WebViewErrorCode errorCode)
    {
        switch (errorCode)
        {
            case WebViewErrorCode.Unknown:
                Debug.LogWarning("Unknown web view error occurred");
                ShowRetryButton();
                break;
        }
    }
}
```

📌 Video Note: Show Unity demo of event handling with visual feedback for loading states and error scenarios.