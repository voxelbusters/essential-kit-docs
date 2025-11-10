---
description: "WebView displays web content within your Unity mobile application"
---

# Usage

Essential Kit wraps native iOS WKWebView and Android WebView into a single Unity interface. WebView instances can display URLs, HTML strings, and local files with full JavaScript support.

## Table of Contents

- [Understanding Core Concepts](#understanding-core-concepts)
- [Import Namespaces](#import-namespaces)
- [Event Registration](#event-registration)
- [Creating a WebView Instance](#creating-a-webview-instance)
- [Setting Frame Size](#setting-frame-size)
- [Appearance Styles](#appearance-styles)
- [Loading Content](#loading-content)
- [Showing and Hiding WebView](#showing-and-hiding-webview)
- [JavaScript Execution](#javascript-execution)
- [Web-to-Unity Communication](#web-to-unity-communication)
- [Controlling Web View](#controlling-web-view)
- [Monitoring Load Progress](#monitoring-load-progress)
- [Data Properties](#data-properties)
- [Core APIs Reference](#core-apis-reference)
- [Error Handling](#error-handling)
- [Advanced: Manual Initialization](#advanced-manual-initialization)
- [Related Guides](#related-guides)

## Understanding Core Concepts

- **Single-instance model** – Essential Kit surfaces one active web view at a time. Create it once, reuse it, and hide it when not in use.
- **Frames and styles** – Choose between full-screen, normalized, or pixel-perfect frames and pick the style (`Default`, `Popup`, `Browser`) that matches your UX.
- **Content sources** – Web views can render remote URLs, inline HTML strings, or local files bundled with your game.
- **JavaScript bridge** – `RunJavaScript` executes scripts synchronously and custom URL schemes let the page talk back to Unity.
- **Lifecycle** – Register events for load, show, hide, and URL scheme matches so you can pause gameplay and resume when the user closes the web content.

## Import Namespaces
```csharp
using VoxelBusters.EssentialKit;
using VoxelBusters.CoreLibrary;
```

## Event Registration

Register for web view events in `OnEnable` and unregister in `OnDisable`:

```csharp
void OnEnable()
{
    WebView.OnShow += OnWebViewShow;
    WebView.OnHide += OnWebViewHide;
    WebView.OnLoadStart += OnWebViewLoadStart;
    WebView.OnLoadFinish += OnWebViewLoadFinish;
    WebView.OnURLSchemeMatchFound += OnURLSchemeMatchFound;
}

void OnDisable()
{
    WebView.OnShow -= OnWebViewShow;
    WebView.OnHide -= OnWebViewHide;
    WebView.OnLoadStart -= OnWebViewLoadStart;
    WebView.OnLoadFinish -= OnWebViewLoadFinish;
    WebView.OnURLSchemeMatchFound -= OnURLSchemeMatchFound;
}
```

| Event | Trigger |
| --- | --- |
| `OnShow` | Web view becomes visible on screen |
| `OnHide` | Web view is hidden from screen |
| `OnLoadStart` | Web page begins loading |
| `OnLoadFinish` | Web page finishes loading (or fails with error) |
| `OnURLSchemeMatchFound` | Custom URL scheme is detected in web content |

## Creating a WebView Instance

### Why WebView Instances are Needed
WebView instances represent individual web views with their own settings, content, and state. Create an instance before loading any web content.

```csharp
private WebView webView;

void Start()
{
    // Create web view instance
    webView = WebView.CreateInstance();

    Debug.Log("WebView instance created");
}
```

{% hint style="info" %}
**Single Instance**: Essential Kit supports one active web view at a time. Creating a new instance replaces any existing web view.
{% endhint %}

## Setting Frame Size

Configure web view size and position before showing:

### Full Screen
```csharp
void SetupFullScreenWebView()
{
    webView = WebView.CreateInstance();
    webView.SetFullScreen();
}
```

### Normalized Coordinates (0.0 to 1.0)
```csharp
void SetupNormalizedWebView()
{
    webView = WebView.CreateInstance();

    // Half screen centered
    webView.SetNormalizedFrame(new Rect(0.25f, 0.25f, 0.5f, 0.5f));
}
```

### Screen Pixel Coordinates
```csharp
void SetupCustomSizeWebView()
{
    webView = WebView.CreateInstance();

    // Custom pixel size
    webView.Frame = new Rect(0, 0, Screen.width, Screen.height - 100);
}
```

## Appearance Styles

WebView supports three visual styles with different controls:

### Default Style
No controls - clean web content display. Ideal for ads or embedded content.

```csharp
webView.Style = WebViewStyle.Default;
```

### Popup Style
Close button in top-right corner. User can dismiss web view by tapping.

```csharp
webView.Style = WebViewStyle.Popup;
```

### Browser Style
Full browser controls: back, forward, reload, and close buttons.

```csharp
webView.Style = WebViewStyle.Browser;
```

| Button | Action |
| --- | --- |
| Back | Navigate to previous page in history |
| Forward | Navigate to next page in history |
| Reload | Refresh current page |
| Close | Hide the web view |

## Loading Content

### Loading Web URLs
```csharp
void LoadWebPage()
{
    webView = WebView.CreateInstance();
    webView.SetFullScreen();
    webView.Style = WebViewStyle.Browser;

    // Load URL
    webView.LoadURL(URLString.URLWithPath("https://www.example.com"));

    // Optionally auto-show when loaded
    webView.AutoShowOnLoadFinish = true;
}
```

### Loading HTML Strings
```csharp
void LoadCustomHTML()
{
    webView = WebView.CreateInstance();
    webView.SetFullScreen();

    string htmlContent = @"
        <html>
        <head>
            <style>
                body { font-family: Arial; padding: 20px; }
                h1 { color: #4CAF50; }
            </style>
        </head>
        <body>
            <h1>Welcome to My Game!</h1>
            <p>This is custom HTML content.</p>
            <button onclick='window.location=""mygame://button-clicked""'>Click Me</button>
        </body>
        </html>
    ";

    webView.LoadHtmlString(htmlContent);
    webView.Show();
}
```

### Loading Local HTML Files
```csharp
void LoadLocalFile()
{
    webView = WebView.CreateInstance();
    webView.SetFullScreen();

    // Load from StreamingAssets or persistent path
    string filePath = Application.streamingAssetsPath + "/terms.html";
    webView.LoadURL(URLString.FileURLWithPath(filePath));

    webView.Show();
}
```

### Loading Binary Data
```csharp
void LoadImageData()
{
    webView = WebView.CreateInstance();
    webView.SetFullScreen();

    Texture2D texture = GetGameTexture();
    string mimeType, textEncodingName;
    byte[] data = texture.Encode(TextureEncodingFormat.JPG, out mimeType, out textEncodingName);

    webView.LoadData(data, mimeType, textEncodingName);
    webView.Show();
}
```

## Showing and Hiding WebView

### Manual Show/Hide
```csharp
void ShowWebView()
{
    webView.Show();
}

void HideWebView()
{
    webView.Hide();
}
```

### Auto-Show on Load
```csharp
void LoadAndAutoShow()
{
    webView = WebView.CreateInstance();
    webView.SetFullScreen();
    webView.AutoShowOnLoadFinish = true; // Show automatically when loaded

    webView.LoadURL(URLString.URLWithPath("https://www.example.com"));
}
```

### Handling Show/Hide Events
```csharp
void OnWebViewShow(WebView view)
{
    if (webView == view)
    {
        Debug.Log("WebView is now visible");
        Debug.Log("Pause gameplay while the web view is active.");
    }
}

void OnWebViewHide(WebView view)
{
    if (webView == view)
    {
        Debug.Log("WebView was hidden");
        Debug.Log("Resume gameplay after closing the web view.");
    }
}
```

## JavaScript Execution

### Enabling JavaScript
```csharp
void SetupJavaScriptWebView()
{
    webView = WebView.CreateInstance();
    webView.JavaScriptEnabled = true; // Required for RunJavaScript()
}
```

### Running JavaScript Code
```csharp
void ExecuteJavaScript()
{
    webView.JavaScriptEnabled = true;

    string script = @"
        function getMessage() {
            return 'Hello from JavaScript!';
        }
        getMessage();
    ";

    webView.RunJavaScript(script, (result, error) =>
    {
        if (error == null)
        {
            Debug.Log($"JavaScript result: {result.Result}");
        }
        else
        {
            Debug.LogError($"JavaScript error: {error}");
        }
    });
}
```

### JavaScript with Parameters
```csharp
void CallJavaScriptFunction()
{
    string playerName = "Alice";
    int playerScore = 1000;

    string script = $@"
        function updateLeaderboard(name, score) {{
            document.getElementById('player-name').innerText = name;
            document.getElementById('player-score').innerText = score;
            return 'Updated: ' + name + ' - ' + score;
        }}
        updateLeaderboard('{playerName}', {playerScore});
    ";

    webView.RunJavaScript(script, (result, error) =>
    {
        if (error == null)
        {
            Debug.Log($"Leaderboard updated: {result.Result}");
        }
    });
}
```

## Web-to-Unity Communication

### Understanding URL Schemes
URL schemes enable web content to send messages to Unity. Register a custom scheme (like `mygame://`) and Essential Kit intercepts matching URLs.

### Registering URL Schemes
```csharp
void SetupURLScheme()
{
    webView = WebView.CreateInstance();
    webView.JavaScriptEnabled = true;

    // Register custom scheme
    webView.AddURLScheme("mygame");

    string html = @"
        <html>
        <body>
            <h1>Game Communication</h1>
            <button onclick='window.location=""mygame://level-complete?score=1500""'>
                Complete Level
            </button>
            <button onclick='window.location=""mygame://purchase?item=sword""'>
                Buy Sword
            </button>
        </body>
        </html>
    ";

    webView.LoadHtmlString(html);
    webView.Show();
}

void OnURLSchemeMatchFound(string url)
{
    Debug.Log($"Received URL from web: {url}");

    if (url.Contains("mygame://level-complete"))
    {
        // Parse query parameters
        int score = ParseScoreFromURL(url);
        Debug.Log($"Complete level with score {score}.");
    }
    else if (url.Contains("mygame://purchase"))
    {
        string item = ParseItemFromURL(url);
        Debug.Log($"Handle purchase for item: {item}.");
    }
}
```

### Parsing URL Parameters
```csharp
int ParseScoreFromURL(string url)
{
    // Example: mygame://level-complete?score=1500
    var uri = new System.Uri(url);
    string query = uri.Query.TrimStart('?');
    var parameters = System.Web.HttpUtility.ParseQueryString(query);
    return int.Parse(parameters["score"]);
}
```

## Controlling Web View

### Reload Current Page
```csharp
void ReloadPage()
{
    webView.Reload();
    Debug.Log("Reloading web page");
}
```

### Stop Loading
```csharp
void CancelLoading()
{
    webView.StopLoading();
    Debug.Log("Stopped loading web page");
}
```

### Clear Cache
```csharp
void ClearBrowserCache()
{
    webView.ClearCache();
    Debug.Log("Web view cache cleared");
}
```

{% hint style="warning" %}
**ClearCache() Impact**: Clearing cache affects all web view instances globally, not just the current one. Use carefully as it may slow down subsequent page loads.
{% endhint %}

## Monitoring Load Progress

### Track Loading State
```csharp
void CheckLoadingState()
{
    if (webView.IsLoading)
    {
        float progress = webView.Progress; // 0.0 to 1.0
        Debug.Log($"Loading: {progress * 100}%");
        Debug.Log($"Update progress bar to {progress * 100}%.");
    }
}

void OnWebViewLoadStart(WebView view)
{
    if (webView == view)
    {
        Debug.Log($"Started loading: {view.URL}");
        Debug.Log("Show loading indicator.");
    }
}

void OnWebViewLoadFinish(WebView view, Error error)
{
    if (webView == view)
    {
        if (error == null)
        {
            Debug.Log("Page loaded successfully");
            Debug.Log("Hide loading indicator.");
        }
        else
        {
            Debug.LogError($"Page load failed: {error.Description}");
            Debug.LogError("Show in-game error message to the player.");
        }
    }
}
```

## Data Properties

| Property | Type | Notes |
| --- | --- | --- |
| `WebView.URL` | `string` | Last URL that finished loading. Useful for analytics or resuming content after a hide/show cycle. |
| `WebView.IsLoading` | `bool` | `true` while the page is still loading. Pair it with `Progress` to drive loading indicators. |
| `WebView.Progress` | `float` | Normalized progress (0–1) reported by native web views. |
| `WebView.ScalesPageToFit` | `bool` | Enable to allow pinch-to-zoom and automatic scaling on both platforms. |
| `WebView.CanBounce` | `bool` | Controls the iOS rubber-band effect. Disable for full-screen kiosk experiences. |
| `WebView.BackgroundColor` | `Color` | Fills the view while content is loading—set it to match your brand palette. |

```csharp
void ConfigureWebViewProperties()
{
    webView.ScalesPageToFit = true; // Enable zoom
    webView.CanBounce = true; // Enable bounce effect
    webView.BackgroundColor = Color.white; // White loading background
}
```

## Core APIs Reference

| API | Purpose | Returns |
| --- | --- | --- |
| `WebView.CreateInstance(settings)` | Create new web view instance | `WebView` instance |
| `webView.SetFullScreen()` | Set web view to full screen | void |
| `webView.SetNormalizedFrame(rect)` | Set size using normalized coordinates | void |
| `webView.LoadURL(url)` | Load web URL into web view | void |
| `webView.LoadHtmlString(html)` | Load HTML string into web view | void |
| `webView.LoadData(data, mimeType, encoding)` | Load binary data into web view | void |
| `webView.Show()` | Display web view on screen | void |
| `webView.Hide()` | Hide web view from screen | void |
| `webView.RunJavaScript(script, callback)` | Execute JavaScript and get result | void - result via callback |
| `webView.AddURLScheme(scheme)` | Register custom URL scheme for web-to-Unity messaging | void |
| `webView.Reload()` | Reload current page | void |
| `webView.StopLoading()` | Cancel current page load | void |
| `webView.ClearCache()` | Clear all cached web content | void |

## Error Handling

Handle load errors in the `OnLoadFinish` event:

```csharp
void OnWebViewLoadFinish(WebView view, Error error)
{
    if (error != null)
    {
        Debug.LogError($"Web view load error: {error.Description}");

        // Show user-friendly error
        Debug.LogError("Display dialog: Page Load Failed - Unable to load the requested page. Please check your internet connection.");

        // Hide web view on error
        webView.Hide();
    }
}
```

Common error scenarios:
- **No Internet**: Network connection unavailable
- **Invalid URL**: Malformed URL or unreachable host
- **SSL Error**: Certificate validation failure (HTTPS)
- **Timeout**: Page took too long to load

## Advanced: Manual Initialization

{% hint style="warning" %}
Manual initialization is only needed for specific runtime scenarios. For most games, Essential Kit's automatic initialization handles everything. **Skip this section unless** you need runtime configuration or per-instance custom settings.
{% endhint %}

### Understanding Manual Initialization

**Default Behavior:**
Essential Kit automatically initializes WebView using global settings from the ScriptableObject configured in Unity Editor.

**Advanced Usage:**
Override settings at runtime or per-instance when you need:
- Dynamic camera/microphone permissions based on web content
- Different back button behavior for different web views
- Server-driven feature configuration

### Implementation

Configure global settings:
```csharp
void Awake()
{
    var globalSettings = new WebViewUnitySettings(
        isEnabled: true,
        androidProperties: new WebViewUnitySettings.AndroidPlatformProperties()
        {
            UsesCamera = true,
            UsesMicrophone = false,
            AllowBackNavigationKey = true
        }
    );

    WebView.Initialize(globalSettings);
}
```

Create instance with custom settings:
```csharp
void CreateCustomWebView()
{
    var instanceSettings = new WebViewUnitySettings(
        isEnabled: true,
        androidProperties: new WebViewUnitySettings.AndroidPlatformProperties()
        {
            UsesCamera = false, // Override global setting
            UsesMicrophone = false,
            AllowBackNavigationKey = false
        }
    );

    webView = WebView.CreateInstance(instanceSettings);
}
```

{% hint style="info" %}
Call `Initialize()` once before creating instances. Most games should use the [standard setup](setup.md) configured in Essential Kit Settings instead.
{% endhint %}

## Related Guides
- Demo scene: `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/WebViewDemo.unity`
- Use with **Sharing Services** to share web content
- Pair with **Network Services** to detect offline status before loading URLs
- See [Testing Guide](testing.md) for device testing checklist
