# Basic Web Browser

## Goal
Create a simple in-app web browser to display web content with loading feedback.

## Actions Required
| Action | Purpose |
|--------|---------|
| WebViewCreateInstance | Creates WebView instance |
| WebViewLoadURL | Loads URL content |
| WebViewShow | Displays WebView |
| WebViewOnLoadFinish | Handles load completion |

## Variables Needed
- webViewInstance (Object): Stores the WebView instance
- targetURL (String): URL to load (e.g., "https://example.com")

## Implementation Steps

### 1. State: CreateWebView
**Action:** WebViewCreateInstance
- **Outputs:**
  - webViewInstance → Store in FsmObject variable
- **Next:** LoadContent

### 2. State: LoadContent
**Action:** WebViewLoadURL
- **Inputs:**
  - webViewInstance → From variable
  - url → targetURL variable
- **Next:** ShowWebView

**Note:** This starts loading. Use OnLoadFinish for completion.

### 3. State: ShowWebView
**Action:** WebViewShow
- **Inputs:**
  - webViewInstance → From variable
- **Events:**
  - successEvent → WaitForLoad
  - failureEvent → ShowError

### 4. State: WaitForLoad (Parallel FSM recommended)
**Action:** WebViewOnLoadFinish
- **Inputs:**
  - webViewInstance → From variable (optional filter)
- **Events:**
  - onLoadSuccessEvent → ContentReady
  - onLoadFailureEvent → ShowLoadError

**Pattern:** This is an event listener, so it stays active until load completes.

### 5. State: ContentReady
Display success message or continue with app flow.

### 6. State: ShowLoadError
**Action:** WebViewGetLoadFinishError
- **Outputs:**
  - errorDescription → FsmString for display
- Display error to user

## Common Issues

- **WebView doesn't appear**: Ensure `WebViewShow` is called after load starts
- **Instance is null**: Ensure `webViewInstance` is assigned by `WebViewCreateInstance` before using it
- **Load never completes**: Use `WebViewOnLoadFinish` listener, not inline wait
- **Multiple WebViews firing events**: Use instance filter on `WebViewOnLoadFinish`

## Flow Diagram
```
CreateWebView
    ↓
LoadContent

LoadContent
    ↓
ShowWebView

ShowWebView
    ├─ Success → WaitForLoad
    └─ Failure → ShowError

WaitForLoad (listener)
    ├─ Load Success → ContentReady
    └─ Load Failure → ShowLoadError
```

## Best Practices
- Always create instance before any other WebView operations
- Store instance in FsmObject variable for reuse across states
- Use event listeners (`WebViewOnLoadFinish`) rather than polling for completion
- Show loading indicator between `LoadURL` and `OnLoadFinish` success
- Handle both success and failure paths for better user experience

## Example Configuration

### Simple News Feed
```
targetURL = "https://example.com/news"
Create → Load → Show → Wait for load → Display
```

### Help Page
```
targetURL = "https://example.com/help"
Create → Load → Show
(no need to wait for load completion if not critical)
```

## Advanced: Navigation Controls

Add reload and stop functionality:
- State: Reload → **WebViewReload** action
- State: Stop → **WebViewStopLoading** action

Add progress tracking:
- Use **WebViewGetInfo** in Update loop to read progress (0.0 to 1.0)

Add URL display:
- Use **WebViewGetInfo** to read current page URL after navigation
