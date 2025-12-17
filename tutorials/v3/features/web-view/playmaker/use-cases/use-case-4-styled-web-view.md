# Styled WebView with Configuration

## Goal
Customize WebView appearance, size, position, and behavior for branded content integration.

## Actions Required
| Action | Purpose |
|--------|---------|
| WebViewCreateInstance | Creates WebView instance |
| WebViewConfigure | Applies style/frame/background and other options |
| WebViewLoadURL | Loads content |
| WebViewShow | Displays WebView |

## Variables Needed
- webViewInstance (Object): Stores the WebView instance
- webViewStyle (Enum/Int): Style type (0=Default, 1=Popup, 2=Browser)
- frameX, frameY, frameWidth, frameHeight (Float): Position and size
- backgroundColor (Color): Background color
- targetURL (String): URL to load

## Implementation Steps

### 1. State: CreateWebView
**Action:** WebViewCreateInstance
- **Outputs:**
  - webViewInstance → Store in FsmObject variable
- **Next:** ConfigureWebView

### 2. State: ConfigureWebView
**Action:** WebViewConfigure
- **Inputs (all optional):**
  - webViewInstance → From variable
  - style → webViewStyle variable
  - backgroundColor → backgroundColor variable
  - frameX/frameY/frameWidth/frameHeight → set all 4 together
- **Next:** LoadContent

**Style Options:**
- **0 (Default)**: Fullscreen WebView
- **1 (Popup)**: Centered WebView with semi-transparent overlay
- **2 (Browser)**: WebView with navigation controls

**Note:** Coordinates are normalized (0.0 to 1.0), where (0,0) is bottom-left, (1,1) is top-right.

### 3. State: LoadContent
**Action:** WebViewLoadURL
- **Inputs:**
  - webViewInstance → From variable
  - url → targetURL variable
- **Next:** ShowWebView

### 4. State: ShowWebView
**Action:** WebViewShow
- **Inputs:**
  - webViewInstance → From variable
- **Events:**
  - successEvent → End
  - failureEvent → ShowError

## Common Issues

- **WebView wrong size**: Remember coordinates are normalized (0.0-1.0), not pixels
- **Style not applied**: Set style BEFORE showing WebView
- **Background color not visible**: Only shows while content is loading or for transparent areas
- **Frame not updating**: Set frame before showing, or hide/show to refresh

## Flow Diagram
```
CreateWebView
    ↓
ConfigureWebView (style/frame/background)
    ↓
LoadContent (URL)
    ↓
ShowWebView
```

## Best Practices
- Configure all appearance settings BEFORE loading content
- Use normalized coordinates (0.0-1.0) for resolution independence
- Test on multiple screen sizes/orientations
- Match background color to your app theme
- Consider safe areas on notched devices (iOS)

## Example Configurations

### Fullscreen Browser
```
webViewStyle = 0 (Default)
frameX = 0.0, frameY = 0.0
frameWidth = 1.0, frameHeight = 1.0
backgroundColor = White
```

### Centered Popup (70% size)
```
webViewStyle = 1 (Popup)
frameX = 0.15, frameY = 0.15
frameWidth = 0.7, frameHeight = 0.7
backgroundColor = White
```

### Bottom Sheet (40% height)
```
webViewStyle = 0 (Default)
frameX = 0.0, frameY = 0.0
frameWidth = 1.0, frameHeight = 0.4
backgroundColor = White
```

### Side Panel (30% width, right side)
```
webViewStyle = 0 (Default)
frameX = 0.7, frameY = 0.0
frameWidth = 0.3, frameHeight = 1.0
backgroundColor = White
```

### Terms & Conditions Dialog
```
webViewStyle = 1 (Popup)
frameX = 0.1, frameY = 0.1
frameWidth = 0.8, frameHeight = 0.8
backgroundColor = White
Load: "https://example.com/terms"
```

## Advanced: Property Configuration

Beyond basic styling, configure behavior by providing optional fields to `WebViewConfigure`:

### Auto-Show on Load
```
State: ConfigureAutoShow
  WebViewConfigure(webViewInstance, autoShowOnLoadFinish=true)

Effect: WebView automatically shows when content finishes loading
```

### Disable JavaScript (for static content)
```
State: ConfigureJavaScript
  WebViewConfigure(webViewInstance, javaScriptEnabled=false)

Effect: Prevents JavaScript execution (faster, more secure for static HTML)
```

### Enable Scroll Bounce (iOS)
```
State: ConfigureBounce
  WebViewConfigure(webViewInstance, canBounce=true)

Effect: Enables elastic scroll bounce effect (iOS only)
```

### Scale to Fit
```
State: ConfigureScaling
  WebViewConfigure(webViewInstance, scalesPageToFit=true)

Effect: Automatically scales web content to fit viewport width
```

## Responsive Layouts

For landscape/portrait support, use different frame values:

```
State: CheckOrientation
  If Screen.orientation == Portrait:
    → SetPortraitFrame
  Else:
    → SetLandscapeFrame

SetPortraitFrame:
  WebViewConfigure(webViewInstance, frameX=0.1, frameY=0.2, frameWidth=0.8, frameHeight=0.6)

SetLandscapeFrame:
  WebViewConfigure(webViewInstance, frameX=0.2, frameY=0.1, frameWidth=0.6, frameHeight=0.8)
```

## Safe Area Consideration (iOS)

For devices with notches, adjust frame to avoid overlap:

```
Portrait:
  frameY = 0.05 (avoid top notch)
  frameHeight = 0.9 (avoid bottom indicator)

Landscape:
  frameX = 0.05 (avoid left/right notches)
  frameWidth = 0.9
```

## Dynamic Resizing

You can update frame at runtime:

```
State: ResizeWebView
  WebViewHide(webViewInstance)
  WebViewConfigure(webViewInstance, frameX=newX, frameY=newY, frameWidth=newWidth, frameHeight=newHeight)
  WebViewShow(webViewInstance)

Note: Hide/show may cause brief flash but ensures frame updates
```
