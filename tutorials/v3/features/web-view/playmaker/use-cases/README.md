# WebView Use Cases

Quick-start guides showing minimal implementations of common WebView tasks using PlayMaker custom actions.

## Available Use Cases

### 1. [Basic Web Browser](use-case-1-basic-web-browser.md)

- **What it does:** Create a simple in-app web browser with navigation
- **Complexity:** Basic
- **Actions:** 4 (Create, LoadURL, Show, OnLoadFinish)
- **Best for:** In-app content viewing, help pages, news feeds

---

### 2. [JavaScript Execution & Communication](use-case-2-javascript-bridge.md)

- **What it does:** Execute JavaScript and retrieve results for Unity-WebView interaction
- **Complexity:** Intermediate
- **Actions:** 5 (Create, LoadURL, Show, RunJavaScript, GetRunJavaScriptResult) + optional error extractor
- **Best for:** Dynamic content manipulation, data extraction, interactive features

---

### 3. [Custom URL Schemes](use-case-3-custom-url-schemes.md)

- **What it does:** Register custom URL schemes for WebView-to-Unity communication
- **Complexity:** Intermediate
- **Actions:** 4 (Create, AddURLScheme, LoadURL, OnURLSchemeMatchFound)
- **Best for:** OAuth callbacks, deep linking, custom protocol handling

---

### 4. [Styled WebView with Configuration](use-case-4-styled-web-view.md)

- **What it does:** Customize WebView appearance, size, and behavior
- **Complexity:** Basic
- **Actions:** 4 (Create, Configure, LoadURL, Show) + optional OnLoadFinish
- **Best for:** Branded content, custom UI integration, responsive layouts

---

### 5. [HTML Content Display](use-case-5-html-content.md)

- **What it does:** Display local HTML content (terms, privacy, help)
- **Complexity:** Basic
- **Actions:** 3 (Create, LoadHtmlString, Show)
- **Best for:** Terms & conditions, privacy policies, offline help

---

## Choosing the Right Use Case

**Start Here:**
- Need to show a website? → **Use Case 1** (Basic Browser)
- Need to interact with web content from Unity? → **Use Case 2** (JavaScript) or **Use Case 3** (URL Schemes)
- Need to customize appearance? → **Use Case 4** (Styled WebView)
- Need to show local HTML? → **Use Case 5** (HTML Content)

## Quick Action Reference

| Action | Purpose | Used In |
|--------|---------|---------|
| WebViewCreateInstance | Create WebView instance | All use cases |
| WebViewConfigure | Configure appearance/behavior | 4 (optional) |
| WebViewLoadURL | Load remote URL | 1, 2, 3, 4 |
| WebViewLoadHtmlString | Load HTML string | 5 |
| WebViewShow | Display WebView | All use cases |
| WebViewHide | Hide WebView | All use cases |
| WebViewRunJavaScript | Execute JS code | 2 |
| WebViewGetRunJavaScriptResult | Get JS result | 2 |
| WebViewGetRunJavaScriptError | Get JS error details | 2 |
| WebViewAddURLScheme | Register custom scheme | 3 |
| WebViewOnURLSchemeMatchFound | Listen for scheme match | 3 |
| WebViewGetInfo | Get URL/title/progress/loading | Optional |
| WebViewOnLoadFinish | Track load completion | 1, 2, 3, 4, 5 |

## Related Documentation

- **[README.md](../README.md)** - Complete actions list + platform notes
