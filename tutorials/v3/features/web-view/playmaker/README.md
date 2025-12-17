# WebView - PlayMaker

Embed web content in your app with Essential Kit's WebView feature via PlayMaker custom actions.

## Actions (22)

### Instance Management (3)
- `WebViewCreateInstance` (sync): Creates a new WebView instance and stores it in an FsmObject variable.
- `WebViewShow` (sync): Shows the WebView instance.
- `WebViewHide` (sync): Hides the WebView instance.

### Configuration (3)
- `WebViewConfigure` (sync): Applies common WebView configuration (style, frame, colors, behavior).
- `WebViewGetConfiguration` (sync): Reads current WebView configuration.
- `WebViewAddURLScheme` (sync): Registers a custom URL scheme for Unity-WebView communication.

### Content Loading (3)
- `WebViewLoadURL` (async): Loads a URL in the WebView.
- `WebViewLoadHtmlString` (async): Loads HTML string content.
- `WebViewLoadData` (async): Loads content from byte array (advanced).

### Navigation (2)
- `WebViewReload` (sync): Reloads the current page.
- `WebViewStopLoading` (sync): Stops the current loading operation.

### State Queries (1)
- `WebViewGetInfo` (sync): Gets URL, title, progress, and loading state.

### JavaScript Execution (3)
- `WebViewRunJavaScript` (async): Executes JavaScript code and waits for completion.
- `WebViewGetRunJavaScriptResult` (sync): Retrieves the result from the last JavaScript execution.
- `WebViewGetRunJavaScriptError` (sync): Retrieves error details from the last JavaScript failure.

### Event Listeners (6)
- `WebViewOnShow` (event): Listens for WebView show events.
- `WebViewOnHide` (event): Listens for WebView hide events.
- `WebViewOnLoadStart` (event): Listens for load start events.
- `WebViewOnLoadFinish` (event): Listens for load finish events (success/failure).
- `WebViewGetLoadFinishError` (sync): Retrieves error from the last load finish event.
- `WebViewOnURLSchemeMatchFound` (event): Listens for custom URL scheme matches.

### Utilities (1)
- `WebViewClearCache` (sync): Clears cached URL responses.

## Quick flow
1. `WebViewCreateInstance` → Store FsmObject instance
2. `WebViewLoadURL` or `WebViewLoadHtmlString` → Load content
3. `WebViewShow` → Display to user
4. `WebViewOnLoadFinish` → Handle load completion (optional)
5. `WebViewRunJavaScript` → Execute scripts (optional)
6. `WebViewHide` → Hide when done

## Common uses
- **In-App Browser**: Use `WebViewCreateInstance` → `WebViewLoadURL` → `WebViewShow` for embedded web content
- **Terms & Privacy**: Load HTML policies with `WebViewLoadHtmlString`, customize appearance with `WebViewConfigure`
- **JavaScript Bridge**: Use `WebViewRunJavaScript` + `WebViewAddURLScheme` for Unity-WebView communication
- **OAuth Flows**: Load auth URL, listen for `WebViewOnURLSchemeMatchFound` for callback handling

## Use cases
Start here: `use-cases/README.md`

## Platform notes
- **iOS**: Uses WKWebView, requires iOS 9.0+
- **Android**: Uses WebView, requires API 19+
- **Instance Management**: Store WebView instances in FsmObject variables, pass between actions
- **Event Filtering**: Event listeners can optionally filter by specific WebView instance
- **JavaScript**: Execution is asynchronous, use `WebViewRunJavaScript` + `WebViewGetRunJavaScriptResult` pattern
- **Custom URL Schemes**: Use `scheme://` format (e.g., "unity://action?param=value")

## Important patterns
- Always create instance first with `WebViewCreateInstance` and store in FsmObject variable
- `WebViewCreateInstance` uses the `FINISHED` transition (no success/failure events); verify your instance variable is assigned before using it
- Use event listeners (`WebViewOnLoadFinish`, etc.) to track WebView state changes
- For JavaScript execution, use `WebViewRunJavaScript` (async) then `WebViewGetRunJavaScriptResult` (sync extractor)
- Event listeners fire for ALL WebView instances by default; use optional instance filter to target specific instance
