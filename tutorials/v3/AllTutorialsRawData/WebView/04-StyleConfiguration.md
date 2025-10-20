# Style Configuration

## What is Style Configuration?

Style Configuration allows you to customize the appearance and behavior of your web view to match your game's design and user experience needs. This includes visual styles, interaction behaviors, and display properties.

## Why Configure Web View Styles in Unity Mobile Games?

Proper style configuration ensures your web view integrates seamlessly with your game's visual design and provides the right user experience. Different styles serve different purposes - from simple content display to full browser-like functionality.

## Web View Style Options

Essential Kit provides three main style options:

```csharp
public enum WebViewStyle
{
    Default,  // No controls, ideal for embedded content
    Popup,    // Close button for dismissible content  
    Browser   // Full browser controls with navigation
}
```

### Default Style

Clean, borderless web view for embedded content:

```csharp
WebView webView = WebView.CreateInstance();
webView.Style = WebViewStyle.Default;

// Configure for embedded content
webView.ScalesPageToFit = true;
webView.CanBounce = false;
webView.BackgroundColor = Color.white;

Debug.Log("Web view configured for embedded content");
```

This snippet creates a clean, embedded web view perfect for displaying content that feels integrated with your game UI.

### Popup Style

Web view with close button for dismissible content:

```csharp
webView.Style = WebViewStyle.Popup;
webView.AutoShowOnLoadFinish = true;

// Load terms of service
webView.LoadURL(URLString.URLWithPath("https://yourgame.com/terms"));
Debug.Log("Loading terms of service in popup style");
```

This approach is ideal for temporary content like legal documents or help pages that users can easily dismiss.

### Browser Style

Full browser experience with navigation controls:

```csharp
webView.Style = WebViewStyle.Browser;
webView.JavaScriptEnabled = true;
webView.ScalesPageToFit = true;

// Load community forum
webView.LoadURL(URLString.URLWithPath("https://community.yourgame.com"));
Debug.Log("Loading community forum with browser controls");
```

This configuration provides full browsing capabilities for complex web applications.

## Behavior Configuration

Customize web view behavior with these properties:

```csharp
// Control page scaling
webView.ScalesPageToFit = true;

// Enable/disable scrolling bounce
webView.CanBounce = false;  

// Control JavaScript execution
webView.JavaScriptEnabled = true;

// Auto-show after loading
webView.AutoShowOnLoadFinish = true;

// Set background color
webView.BackgroundColor = new Color(0.1f, 0.1f, 0.1f, 1f);

Debug.Log("Web view behavior configured");
```

## Frame and Position Management

Control web view positioning and size:

```csharp
// Set exact pixel coordinates
webView.Frame = new Rect(100, 200, 800, 600);

// Use normalized coordinates (0.0 to 1.0)
webView.SetNormalizedFrame(new Rect(0.1f, 0.2f, 0.8f, 0.6f));

// Set to full screen
webView.SetFullScreen();

Debug.Log("Web view positioning configured");
```

📌 Video Note: Show Unity demo of each style option and behavior configuration with visual comparisons.