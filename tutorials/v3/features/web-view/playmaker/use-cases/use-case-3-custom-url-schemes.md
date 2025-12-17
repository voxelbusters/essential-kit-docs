# Custom URL Schemes

## Goal
Register custom URL schemes for WebView-to-Unity communication (OAuth callbacks, deep linking, custom protocols).

## Actions Required
| Action | Purpose |
|--------|---------|
| WebViewCreateInstance | Creates WebView instance |
| WebViewAddURLScheme | Registers custom scheme |
| WebViewLoadURL | Loads web content |
| WebViewOnURLSchemeMatchFound | Listens for scheme matches |

## Variables Needed
- webViewInstance (Object): Stores the WebView instance
- customScheme (String): Custom scheme (e.g., "myapp", "unity", "oauth")
- targetURL (String): URL to load
- matchedURLScheme (String): The full URL that matched the scheme

## Implementation Steps

### 1. State: CreateWebView
**Action:** WebViewCreateInstance
- **Outputs:**
  - webViewInstance → Store in FsmObject variable
- **Next:** RegisterScheme

### 2. State: RegisterScheme
**Action:** WebViewAddURLScheme
- **Inputs:**
  - webViewInstance → From variable
  - urlScheme → customScheme variable (e.g., "myapp")
- **Events:**
  - successEvent → LoadContent
  - failureEvent → ShowError

**Note:** Register schemes BEFORE loading content that might trigger them.

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
  - successEvent → Next
  - failureEvent → ShowError

### 5. State: ListenForScheme (Parallel FSM recommended)
**Action:** WebViewOnURLSchemeMatchFound
- **Inputs:**
  - webViewInstance → From variable (optional filter)
- **Outputs:**
  - matchedURLScheme → Store in an FsmString variable
- **Events:**
  - onMatchEvent → ProcessCallback

**Pattern:** This listener stays active until a matching URL is clicked.

### 6. State: ProcessCallback
Parse `matchedURLScheme` for parameters
- Handle OAuth tokens, deep link data, etc.

## Common Issues

- **Scheme not recognized**: Ensure scheme is registered BEFORE loading URL
- **Wrong URL format**: Schemes must be lowercase, format: `scheme://path?params`
- **Multiple WebViews**: Use instance filter on `WebViewOnURLSchemeMatchFound`
- **Parameters not parsing**: URL decode parameters before using

## Flow Diagram
```
CreateWebView
    ↓
RegisterScheme (e.g., "myapp")
    ↓
LoadContent
    ↓
ShowWebView
    ↓
ListenForScheme (parallel listener)
    ↓
User clicks link: myapp://callback?token=abc123
    ↓
OnURLSchemeMatchFound fires
    ↓
ProcessCallback (parse URL, extract token)
```

## Best Practices
- Use lowercase scheme names (e.g., "myapp", not "MyApp")
- Register all schemes before loading content
- URL encode parameters in web links
- URL decode parameters when processing in Unity
- Use descriptive paths: `myapp://login/success` vs `myapp://callback`
- Handle errors gracefully (invalid tokens, missing parameters)

## Example Configurations

### OAuth Callback
```
customScheme = "myapp"
targetURL = "https://oauth.example.com/authorize?redirect_uri=myapp://oauth/callback"

Website redirects to: myapp://oauth/callback?code=AUTH_CODE_HERE

ProcessCallback state:
  - Extract code parameter
  - Exchange for access token
  - Save token to PlayerPrefs
  - Transition to authenticated state
```

### Deep Linking
```
customScheme = "mygame"
Website contains links:
  - <a href="mygame://level/5">Play Level 5</a>
  - <a href="mygame://shop/item/123">Buy Item</a>

ProcessCallback state:
  - Parse URL path
  - Route to appropriate game screen
  - Hide WebView
```

### Payment Confirmation
```
customScheme = "myapp"
Payment website redirects to: myapp://payment/success?transaction_id=12345

ProcessCallback state:
  - Extract transaction_id
  - Verify payment with server
  - Grant purchased items
  - Show success message
```

### Multi-Action Callbacks
```
customScheme = "unity"
Website buttons:
  - <a href="unity://share">Share Score</a>
  - <a href="unity://invite">Invite Friend</a>
  - <a href="unity://close">Close WebView</a>

ProcessCallback state:
  - Switch on URL path
  - Execute corresponding Unity action
```

## URL Parameter Parsing

Example JavaScript for website to construct callback URLs:

```javascript
// Simple callback
window.location = 'myapp://callback?success=true';

// With multiple parameters
const params = new URLSearchParams({
  token: 'abc123',
  userId: '456',
  status: 'verified'
});
window.location = `myapp://callback?${params.toString()}`;
```

Example Unity processing (in ProcessCallback state):

```
matchedURL = "myapp://callback?token=abc123&userId=456"

Parse with:
  1. Split on "?" to get query string
  2. Split on "&" to get parameter pairs
  3. Split on "=" to get key-value
  4. URL decode values
```

## Security Considerations

- Validate all parameters from callback URLs (don't trust client data)
- Use HTTPS for OAuth flows (protect tokens in transit)
- Implement CSRF protection for sensitive actions
- Verify OAuth state parameters to prevent replay attacks
- Never include secrets in callback URLs (use server-side validation)

## Advanced: Multiple Schemes

Register multiple schemes for different purposes:

```
State: RegisterSchemes
  - WebViewAddURLScheme(webViewInstance, "myapp")
  - WebViewAddURLScheme(webViewInstance, "oauth")
  - WebViewAddURLScheme(webViewInstance, "payment")

Listener filters by URL prefix:
  - "myapp://" → General app actions
  - "oauth://" → Authentication flows
  - "payment://" → Purchase confirmations
```
