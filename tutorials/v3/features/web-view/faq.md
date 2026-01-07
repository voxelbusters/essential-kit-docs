---
description: "Common WebView issues and solutions"
---

# FAQ & Troubleshooting

### Why doesn't WebView work in Unity Editor?
WebView requires native iOS WKWebView or Android WebView components which are not available in Unity Editor. **All WebView testing must be done on physical devices**. Build and deploy to iOS or Android to test web view functionality.

### How do I get data from WebView to Unity?
Use custom URL schemes for web-to-Unity communication:

```csharp
// Assume you have a webView instance (WebView) already created
void SetupWebViewCommunication()
{
    // In Unity: Register custom scheme
    webView.AddURLScheme("mygame");

    // In HTML: Use custom URL to send data
    // <button onclick='window.location="mygame://action?data=value"'>Send to Unity</button>
}

// In Unity: Receive the URL
void OnURLSchemeMatchFound(string url)
{
    Debug.Log($"Received from web: {url}");
    // Parse URL parameters and take action
}
```

For complex data, pass JSON as URL parameters and parse in Unity.

### HTTP URLs don't load on iOS. How do I fix this?
iOS App Transport Security (ATS) blocks HTTP URLs by default. Solutions:

**Option 1 (Recommended)**: Use HTTPS URLs
```csharp
webView.LoadURL(URLString.URLWithPath("https://www.example.com"));
```

**Option 2**: Add ATS exception to Info.plist for specific domains (requires Xcode configuration)

**Option 3**: Disable ATS entirely (not recommended for production - security risk)

### Can I display multiple WebViews at once?
No. Essential Kit supports one active web view at a time. Creating a new instance replaces any existing web view. If you need to switch between different web content:

```csharp
void SwitchContent(string url)
{
    // Hide current view
    if (webView != null)
    {
        webView.Hide();
    }

    // Create new instance with different content
    webView = WebView.CreateInstance();
    webView.SetFullScreen();
    webView.LoadURL(URLString.URLWithPath(url));
    webView.Show();
}
```

### JavaScript doesn't execute. What should I check?
Ensure JavaScript is enabled **before** running scripts:

```csharp
void ExecuteJavaScript()
{
    webView.JavaScriptEnabled = true; // Required!

    webView.RunJavaScript("alert('Hello')", (result, error) =>
    {
        if (error != null)
        {
            Debug.LogError($"JS Error: {error}");
        }
    });
}
```

Also verify:
- Page is fully loaded before executing JavaScript (wait for `OnLoadFinish`)
- JavaScript code syntax is correct
- Web view is visible (`Show()` called)

### How do I check the loading progress of a page?
Monitor the `Progress` property and `IsLoading` state:

```csharp
void Update()
{
    if (webView != null && webView.IsLoading)
    {
        double progress = webView.Progress; // 0.0 to 1.0
        Debug.Log($"Update progress bar to {progress * 100}%.");
    }
}

void OnWebViewLoadFinish(WebView view, Error error)
{
    Debug.Log("Hide progress indicator.");
}
```

### Can I customize the native WebView interface?
WebView styles are limited to three options: Default, Popup, and Browser. You cannot fully customize the native interface appearance. For custom UI:
- Use **Default** style (no controls)
- Build your own Unity UI controls
- Control web view via scripts (`Show()`, `Hide()`, `Reload()`, etc.)

```csharp
webView.Style = WebViewStyle.Default; // No native controls
// Add your own Unity buttons for back, forward, close
```

### Web page displays incorrectly (zoomed in/out). How do I fix this?
Enable page scaling:

```csharp
webView.ScalesPageToFit = true; // Allows page to scale properly
```

Also ensure your HTML includes proper viewport meta tag:
```html
<meta name="viewport" content="width=device-width, initial-scale=1.0">
```

### How do I pass complex data from JavaScript to Unity?
Use JSON encoding in JavaScript and parse in Unity:

```javascript
// In JavaScript
var data = {
    score: 1000,
    level: 5,
    items: ["sword", "shield"]
};
window.location = "mygame://data?json=" + encodeURIComponent(JSON.stringify(data));
```

```csharp
// In Unity
void OnURLSchemeMatchFound(string url)
{
    var uri = new System.Uri(url);
    string query = uri.Query.TrimStart('?');
    var parameters = System.Web.HttpUtility.ParseQueryString(query);
    string jsonString = parameters["json"];

    var data = JsonUtility.FromJson<GameData>(jsonString);
    Debug.Log($"Score: {data.score}, Level: {data.level}");
}
```

### Does WebView support cookies and local storage?
Yes, WebView supports cookies, local storage, and session storage. Data persists between web view sessions unless you call `ClearCache()`.

To manually clear all web data:
```csharp
webView.ClearCache(); // Clears cookies, cache, local storage
```

**Note**: `ClearCache()` affects all web view instances globally.

### Can WebView play videos and audio?
Yes, WebView supports HTML5 video and audio playback. For best results:
- Use standard HTML5 `<video>` and `<audio>` tags
- Provide multiple formats for compatibility (MP4, WebM)
- For Android: Enable microphone permission if using audio input
- Test autoplay behavior (some platforms block autoplay)

### How do I handle the Android back button?
Configure back button behavior in Essential Kit Settings:

**Default Behavior** (recommended): Back button hides web view
```
Essential Kit Settings → WebView → Allow Back Navigation Key: OFF
```

**Browser Behavior**: Back button navigates to previous page
```
Essential Kit Settings → WebView → Allow Back Navigation Key: ON
```

You can also handle back button programmatically by detecting `OnHide` event.

### Web content loads slowly. How can I improve performance?
Optimize web view performance:

1. **Show Loading Indicator**: Display progress while loading
```csharp
webView.AutoShowOnLoadFinish = true; // Show only when ready
```

2. **Optimize Web Content**:
- Compress images before serving
- Minimize JavaScript and CSS
- Use CDN for external resources
- Enable browser caching headers

3. **Preload Critical Content**: Load frequently used pages in background

4. **Clear Old Cache Periodically**:
```csharp
webView.ClearCache(); // Call when appropriate (app update, etc.)
```

### Can I load local HTML files from StreamingAssets?
Yes, use `FileURLWithPath`:

```csharp
string filePath = System.IO.Path.Combine(Application.streamingAssetsPath, "index.html");
webView.LoadURL(URLString.FileURLWithPath(filePath));
```

**Android Note**: StreamingAssets are compressed in APK. For complex HTML with relative resources, copy to `persistentDataPath` first:

```csharp
string targetPath = Path.Combine(Application.persistentDataPath, "index.html");
File.Copy(sourcePath, targetPath);
webView.LoadURL(URLString.FileURLWithPath(targetPath));
```

### Where can I confirm plugin behavior versus my implementation?
Run `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/WebViewDemo.unity` on a physical device. If the sample works but your implementation doesn't:
- Compare frame setup (did you call `SetFullScreen()` or set `Frame`?)
- Verify `Show()` is called before expecting web view to appear
- Check event registration (subscribe before loading content)
- Confirm JavaScript is enabled before calling `RunJavaScript()`
- Validate URL format (HTTPS for iOS, proper scheme for custom URLs)

### Can I intercept all URL navigation in WebView?
No direct interception of all URLs, but you can:
1. Register specific custom URL schemes with `AddURLScheme()`
2. Monitor `OnLoadStart` event for URL changes
3. Use JavaScript to control navigation and communicate with Unity

```csharp
void OnWebViewLoadStart(WebView view)
{
    Debug.Log($"Loading URL: {view.URL}");
    // You can conditionally allow/block by hiding web view if needed
}
```

### How do I handle OAuth login flows?
Implement OAuth redirect with custom URL scheme:

```csharp
void StartOAuthLogin()
{
    webView = WebView.CreateInstance();
    webView.SetFullScreen();
    webView.AddURLScheme("myapp"); // Register callback scheme

    // Load OAuth provider URL with redirect_uri
    string oauthURL = "https://provider.com/oauth?redirect_uri=myapp://callback";
    webView.LoadURL(URLString.URLWithPath(oauthURL));
    webView.Show();
}

void OnURLSchemeMatchFound(string url)
{
    if (url.StartsWith("myapp://callback"))
    {
        // Parse token from URL
        string token = ParseTokenFromURL(url);
        Debug.Log($"Process OAuth token: {token}");
        webView.Hide();
    }
}
```
