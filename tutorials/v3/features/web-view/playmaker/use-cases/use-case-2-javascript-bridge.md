# JavaScript Execution & Communication

## Goal
Execute JavaScript code in the WebView and retrieve results for Unity-WebView interaction.

## Actions Required
| Action | Purpose |
|--------|---------|
| WebViewCreateInstance | Creates WebView instance |
| WebViewLoadURL | Loads web content |
| WebViewShow | Displays WebView |
| WebViewRunJavaScript | Executes JS code |
| WebViewGetRunJavaScriptResult | Retrieves JS result |
| WebViewGetRunJavaScriptError (optional) | Retrieves JS error details |

## Variables Needed
- webViewInstance (Object): Stores the WebView instance
- targetURL (String): URL to load
- jsScript (String): JavaScript code to execute
- jsResult (String): Result from JavaScript execution

## Implementation Steps

### 1. State: CreateAndLoadWebView
Follow Use Case 1 (Basic Browser) to create, load, and show WebView.
Wait for `WebViewOnLoadFinish` success before executing JavaScript.

### 2. State: ExecuteJavaScript
**Action:** WebViewRunJavaScript
- **Inputs:**
  - webViewInstance → From variable
  - script → jsScript variable
- **Events:**
  - successEvent → GetResult
  - failureEvent → GetError (optional) / ShowError

**Example Scripts:**
- Get page title: `"document.title"`
- Get element value: `"document.getElementById('username').value"`
- Call function: `"myFunction('param1', 'param2')"`
- Modify DOM: `"document.body.style.backgroundColor = 'red'"`

### 3. State: GetResult
**Action:** WebViewGetRunJavaScriptResult
- **Outputs:**
  - result → jsResult variable
- **Next:** ProcessResult

### 4. State: ProcessResult
Use the retrieved JavaScript result in Unity (display, save to PlayerPrefs, trigger game logic, etc.)

### Optional: State: GetError
**Action:** WebViewGetRunJavaScriptError
- **Outputs:**
  - errorCode / errorDescription → Use for UI/logging

## Common Issues

- **JavaScript doesn't execute**: Ensure page has finished loading (wait for OnLoadFinish)
- **Result is empty**: Check that JavaScript actually returns a value
- **Security errors**: Some websites block external JavaScript execution
- **Timing issues**: JavaScript must be enabled with `WebViewConfigure(javaScriptEnabled=true)`

## Flow Diagram
```
CreateWebView → LoadURL → Show
    ↓
WaitForLoad (OnLoadFinish success)
    ↓
ExecuteJavaScript
    ├─ Success → GetResult → ProcessResult
    └─ Failure → ShowError
```

## Best Practices
- Wait for page load completion before executing JavaScript
- Test JavaScript in browser console first to verify syntax
- Handle empty/null results gracefully
- Use JSON.stringify() in JavaScript to return complex objects as strings
- Parse JSON strings in Unity using JsonUtility or similar

## Example Use Cases

### Extract User Input
```javascript
// JavaScript to execute
jsScript = "document.getElementById('email').value"

// Result processing
ProcessResult state:
  - Store jsResult in PlayerPrefs
  - Validate email format
  - Continue to next game state
```

### Modify Page Appearance
```javascript
// Change background color
jsScript = "document.body.style.backgroundColor = '#FF5733'; 'success'"

// Hide ads
jsScript = "document.querySelectorAll('.ad').forEach(el => el.style.display = 'none'); 'hidden'"
```

### Get Page Data
```javascript
// Get all link URLs
jsScript = "JSON.stringify(Array.from(document.querySelectorAll('a')).map(a => a.href))"

// Result is JSON array string
ProcessResult state:
  - Parse jsResult with JsonUtility
  - Display links in Unity UI
```

### Call Website Functions
```javascript
// Login through website's JavaScript API
jsScript = "loginUser('username', 'password'); 'login_initiated'"

// Get game state from web game
jsScript = "JSON.stringify(gameState.getCurrentLevel())"
```

## Advanced: Bidirectional Communication

For ongoing communication, combine with Custom URL Schemes (Use Case 3):

1. **Unity → WebView**: Use `WebViewRunJavaScript`
2. **WebView → Unity**: Website calls `window.location = 'unity://callback?data=value'`
3. **Unity receives**: Via `WebViewOnURLSchemeMatchFound` listener

## JavaScript Debugging

If JavaScript fails:
1. Enable `WebViewConfigure(javaScriptEnabled=true)` first
2. Test script in browser DevTools console
3. Check for syntax errors in script string
4. Verify page elements exist (use browser inspector)
5. Use simple `"'test'"` script to verify execution works

## Security Considerations

- Only execute JavaScript on trusted websites
- Validate and sanitize any user input passed to JavaScript
- Be aware that JavaScript can access cookies and local storage
- Some content security policies may block external script execution
