---
description: "Validating WebView integration before release"
---

# Testing & Validation

Use these checks to confirm your WebView integration before release.

{% hint style="danger" %}
**Device Testing Required**: WebView does not work in Unity Editor. All testing must be done on physical iOS or Android devices.
{% endhint %}

## Device Testing Checklist
### Web View Creation and Display
- [ ] Create web view instance without errors
- [ ] Set frame size (full screen, normalized, custom pixels) displays correctly
- [ ] Web view appears on screen when `Show()` is called
- [ ] Web view hides from screen when `Hide()` is called
- [ ] Different styles (Default, Popup, Browser) display correct controls

### Content Loading
- [ ] Load external HTTPS URLs successfully (e.g., https://www.google.com)
- [ ] Load HTML strings with CSS and inline styles
- [ ] Load local HTML files from StreamingAssets
- [ ] Load binary data (images) into web view
- [ ] `OnLoadStart` event fires when loading begins
- [ ] `OnLoadFinish` event fires when loading completes (success or error)

### JavaScript Execution
- [ ] Enable JavaScript with `JavaScriptEnabled = true`
- [ ] Execute simple JavaScript and receive results via callback
- [ ] Call JavaScript functions with parameters from Unity
- [ ] JavaScript errors are reported through error callback
- [ ] Complex return values (JSON objects) can be parsed

### URL Scheme Communication
- [ ] Register custom URL scheme with `AddURLScheme()`
- [ ] Clicking links with custom scheme triggers `OnURLSchemeMatchFound` event
- [ ] URL parameters are correctly received in Unity
- [ ] Multiple different URL schemes can be registered
- [ ] Scheme matching does not interfere with normal web navigation

### Controls and Navigation
- [ ] Browser style back/forward/reload/close buttons work correctly
- [ ] Popup style close button hides web view
- [ ] Android hardware back button behavior (if "Allow Back Navigation Key" enabled)
- [ ] Reload refreshes current page content
- [ ] StopLoading cancels in-progress page loads
- [ ] Clear cache removes cached content

### Loading Progress
- [ ] `Progress` property updates from 0.0 to 1.0 during loading
- [ ] `IsLoading` property returns true during loading, false when complete
- [ ] `URL` property returns currently loaded URL
- [ ] Loading indicators can be shown/hidden based on `IsLoading` state

## Platform-Specific Checks

### iOS Testing
- [ ] HTTPS URLs load correctly (App Transport Security compliance)
- [ ] HTTP URLs are blocked or require ATS exceptions in Info.plist
- [ ] WKWebView navigation works smoothly
- [ ] ScalesPageToFit enables pinch-to-zoom
- [ ] CanBounce enables rubber-band scrolling
- [ ] JavaScript execution returns results correctly

### Android Testing
- [ ] INTERNET permission added automatically to AndroidManifest.xml
- [ ] CAMERA permission added if "Uses Camera" enabled in settings
- [ ] RECORD_AUDIO permission added if "Uses Microphone" enabled
- [ ] Hardware back button behavior matches settings configuration
- [ ] WebView renders with hardware acceleration (smooth scrolling)

## Performance Validation
- [ ] Large web pages load without freezing UI
- [ ] JavaScript-heavy sites run smoothly
- [ ] Multiple page loads don't cause memory leaks
- [ ] Hiding and showing web view repeatedly works without issues
- [ ] Web view memory is released when instance is destroyed

## Common Test Scenarios

### Terms & Conditions Display
```
1. User taps "View Terms"
2. Web view loads hosted terms URL
3. Browser-style controls appear
4. User scrolls through content
5. User taps "Close" button
6. Web view hides, game resumes
```

### OAuth Login Flow
```
1. User taps "Login with Facebook"
2. Web view loads OAuth URL
3. User enters credentials
4. OAuth redirects to custom://callback?token=xyz
5. OnURLSchemeMatchFound receives token
6. Web view hides
7. Game processes authentication
```

### HTML5 Mini-Game
```
1. Web view loads game HTML with JavaScript enabled
2. User interacts with HTML5 canvas/elements
3. Game communicates with Unity via custom URL schemes
4. Score is passed to Unity on game completion
5. Web view hides, Unity shows results
```

### Dynamic News Feed
```
1. Web view loads news URL with auto-show enabled
2. Content displays with images and formatting
3. User taps embedded links for navigation
4. Browser controls allow back/forward navigation
5. Reload button refreshes latest news
```

## Error Testing
Test error handling for common failures:
- [ ] Invalid URL format triggers error callback
- [ ] Network offline when loading URL
- [ ] HTTPS certificate error (expired/invalid SSL)
- [ ] Page load timeout
- [ ] JavaScript execution error
- [ ] Malformed HTML string

```csharp
// Verify error handling
void OnWebViewLoadFinish(WebView view, Error error)
{
    if (error != null)
    {
        // Error should be logged and user-friendly message shown
        Debug.LogError($"Expected error: {error.Description}");
    }
}
```

## Pre-Submission Review
- [ ] Test on physical devices (iOS and Android) at minimum supported OS versions
- [ ] Verify HTTPS usage or proper ATS exceptions for HTTP content
- [ ] Test complete user flows: show web view → interact → communicate → hide
- [ ] Verify no web view instances remain in memory after hiding
- [ ] Test with various network conditions (WiFi, cellular, offline)
- [ ] Confirm all web content displays correctly across device sizes

## Troubleshooting Test Failures
If web view doesn't display or content fails to load:

1. **Build to Device**: Confirm testing on physical device (not editor)
2. **Check Frame Size**: Verify `SetFullScreen()` or `Frame` is called before `Show()`
3. **Validate URL**: Ensure HTTPS for iOS, check URL format
4. **Monitor Events**: Add logging to all event handlers to track lifecycle
5. **Test with Demo Scene**: Run `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/WebViewDemo.unity` on device

{% hint style="success" %}
**Testing Tip**: Start with simple HTTPS URLs (like https://www.google.com) to verify basic functionality before loading complex custom HTML or JavaScript-heavy content.
{% endhint %}

## Related Guides
- [Setup Guide](setup.md) - Verify configuration before testing
- [Usage Guide](usage.md) - Review implementation patterns
- [FAQ](faq.md) - Solutions for common test failures
