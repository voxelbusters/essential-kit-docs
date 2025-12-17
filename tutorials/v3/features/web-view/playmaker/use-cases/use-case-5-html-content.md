# HTML Content Display

## Goal
Display local HTML content (terms & conditions, privacy policies, help documentation, offline content).

## Actions Required
| Action | Purpose |
|--------|---------|
| WebViewCreateInstance | Creates WebView instance |
| WebViewLoadHtmlString | Loads HTML string |
| WebViewShow | Displays WebView |

## Variables Needed
- webViewInstance (Object): Stores the WebView instance
- htmlContent (String): HTML content to display
- baseURL (String): Base URL for relative resources (optional)

## Implementation Steps

### 1. State: PrepareHTML
Load HTML content from file or construct programmatically.

**Option A: From Resources**
```
Use PlayMaker action to load TextAsset from Resources folder
Store in htmlContent variable
```

**Option B: Constructed HTML**
```
Set htmlContent = "<html><body><h1>Terms</h1>...</body></html>"
```

### 2. State: CreateWebView
**Action:** WebViewCreateInstance
- **Outputs:**
  - webViewInstance → Store in FsmObject variable
- **Next:** LoadHTML

### 3. State: LoadHTML
**Action:** WebViewLoadHtmlString
- **Inputs:**
  - webViewInstance → From variable
  - htmlString → htmlContent variable
  - baseURL → Optional (e.g., "file:///android_asset/" for local resources)
- **Next:** ShowWebView

**Note:** baseURL is used to resolve relative paths in HTML (images, CSS, etc.)

### 4. State: ShowWebView
**Action:** WebViewShow
- **Inputs:**
  - webViewInstance → From variable
- **Events:**
  - successEvent → End
  - failureEvent → ShowError

## Common Issues

- **Images don't load**: Provide correct baseURL for relative image paths
- **Styles not applied**: Use inline CSS or embedded `<style>` tags
- **Encoding issues**: Ensure HTML string uses UTF-8 encoding
- **Links don't work**: Relative links require baseURL, external links work normally

## Flow Diagram
```
PrepareHTML (load from file or construct)
    ↓
CreateWebView
    ↓
LoadHTML (with baseURL if needed)
    ↓
ShowWebView
```

## Best Practices
- Keep HTML self-contained (inline CSS, embedded images as base64)
- Use responsive design (viewport meta tag for mobile)
- Test HTML rendering separately before integration
- Provide baseURL when using relative resource paths
- Consider localization (load different HTML per language)

## Example HTML Templates

### Simple Terms & Conditions
```html
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    body {
      font-family: Arial, sans-serif;
      padding: 20px;
      line-height: 1.6;
    }
    h1 {
      color: #333;
      border-bottom: 2px solid #007bff;
      padding-bottom: 10px;
    }
  </style>
</head>
<body>
  <h1>Terms & Conditions</h1>
  <p>Last Updated: January 1, 2025</p>
  <h2>1. Acceptance of Terms</h2>
  <p>By accessing this app, you agree to be bound by these terms...</p>
  <!-- More content -->
</body>
</html>
```

### Privacy Policy
```html
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
      padding: 16px;
      background: #f5f5f5;
    }
    .container {
      background: white;
      padding: 20px;
      border-radius: 8px;
      box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }
  </style>
</head>
<body>
  <div class="container">
    <h1>Privacy Policy</h1>
    <p>We respect your privacy...</p>
  </div>
</body>
</html>
```

### Help Documentation
```html
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    .section {
      margin-bottom: 30px;
    }
    .question {
      font-weight: bold;
      color: #007bff;
      margin-top: 15px;
    }
    .answer {
      margin-left: 20px;
    }
  </style>
</head>
<body>
  <h1>Help & FAQ</h1>

  <div class="section">
    <div class="question">Q: How do I create an account?</div>
    <div class="answer">A: Tap the "Sign Up" button on the main screen...</div>
  </div>

  <div class="section">
    <div class="question">Q: How do I reset my password?</div>
    <div class="answer">A: Go to Settings > Account > Reset Password...</div>
  </div>
</body>
</html>
```

## Advanced: Dynamic Content

Construct HTML dynamically with player data:

```
State: BuildHTML
  Set htmlContent = "<html><body>"
  Concat htmlContent += "<h1>Player Stats</h1>"
  Concat htmlContent += "<p>Name: " + playerName + "</p>"
  Concat htmlContent += "<p>Score: " + playerScore + "</p>"
  Concat htmlContent += "</body></html>"
  → CreateWebView
```

## Localization Support

Load different HTML based on language:

```
State: DetermineLanguage
  If Application.systemLanguage == English:
    → LoadEnglishHTML
  Else If Application.systemLanguage == Spanish:
    → LoadSpanishHTML
  Else:
    → LoadDefaultHTML

LoadEnglishHTML:
  Load TextAsset: "Terms_EN"
  Store in htmlContent
  → CreateWebView
```

## Images in HTML

**Option 1: Base64 Embedded Images**
```html
<img src="data:image/png;base64,iVBORw0KGgoAAAANS..." alt="Logo">
```

**Option 2: Resources with BaseURL**
```html
<!-- HTML -->
<img src="logo.png" alt="Logo">

<!-- PlayMaker -->
baseURL = "file:///android_asset/webview_assets/"
(Place logo.png in StreamingAssets/webview_assets/)
```

**Option 3: External URLs**
```html
<img src="https://example.com/logo.png" alt="Logo">
```

## Styling for Mobile

Always include viewport meta tag:

```html
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
```

Use relative units:

```css
body {
  font-size: 16px; /* Base size */
  padding: 5vw; /* Responsive padding */
}

h1 {
  font-size: 1.5em; /* Relative to body */
}
```

## Interactive HTML

Combine with JavaScript (Use Case 2) for interactive content:

```html
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>
  <h1>Accept Terms?</h1>
  <button onclick="acceptTerms()">I Accept</button>
  <button onclick="declineTerms()">Decline</button>

  <script>
    function acceptTerms() {
      window.location = 'myapp://terms/accepted';
    }
    function declineTerms() {
      window.location = 'myapp://terms/declined';
    }
  </script>
</body>
</html>
```

Then use Custom URL Schemes (Use Case 3) to handle button clicks in Unity.

## File Organization

Recommended structure:
```
Assets/
  Resources/
    WebViewContent/
      Terms_EN.txt
      Terms_ES.txt
      Privacy_EN.txt
      Privacy_ES.txt
      Help_EN.txt
      Help_ES.txt
  StreamingAssets/
    webview_assets/
      logo.png
      icon.png
      style.css
```
