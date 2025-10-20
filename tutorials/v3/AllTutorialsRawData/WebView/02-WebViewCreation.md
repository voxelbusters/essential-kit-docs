# Web View Creation

## What is Web View Creation?

Web View Creation is the process of instantiating and configuring a web view instance in your Unity mobile game. This creates a native web view control that can display web content within your Unity application.

## Why Create Web Views in Unity Mobile Games?

Creating web views allows you to:
- Display dynamic web content without leaving your game
- Show in-game news, updates, and community content
- Integrate web-based features like forums or help systems
- Present terms of service, privacy policies, and legal documents
- Embed web-based mini-games or interactive content

## Web View Creation API

The main method for creating web view instances:

```csharp
public static WebView CreateInstance(WebViewUnitySettings settings = null)
```

### Basic Creation

Here's how to create a simple web view:

```csharp
using VoxelBusters.EssentialKit;

// Create a basic web view instance
WebView webView = WebView.CreateInstance();

// Set the frame (position and size)
webView.Frame = new Rect(0, 0, Screen.width, Screen.height * 0.8f);

Debug.Log("Web view created successfully");
```

This snippet creates a web view that takes up 80% of the screen height.

### Creation with Custom Settings

For advanced configuration, you can provide custom settings:

```csharp
// Create custom settings (if needed)
WebViewUnitySettings customSettings = ScriptableObject.CreateInstance<WebViewUnitySettings>();

// Create web view with custom settings
WebView webView = WebView.CreateInstance(customSettings);
Debug.Log("Web view created with custom settings");
```

This approach allows you to configure specialized behavior for your web view.

### Convenient Frame Setup

Essential Kit provides helper methods for common layouts:

```csharp
WebView webView = WebView.CreateInstance();

// Set to full screen
webView.SetFullScreen();

// Or set normalized frame (0.0 to 1.0 coordinates)
webView.SetNormalizedFrame(new Rect(0f, 0.2f, 1f, 0.6f));

Debug.Log("Web view frame configured");
```

This snippet shows convenient methods for positioning your web view on screen.

## Global Settings

You can also configure global settings that apply to all web views:

```csharp
// Configure global settings for all web views
WebViewUnitySettings globalSettings = ScriptableObject.CreateInstance<WebViewUnitySettings>();
WebView.Initialize(globalSettings);
```

📌 Video Note: Show Unity demo of creating a web view instance and watching it appear in the Unity Editor simulator.