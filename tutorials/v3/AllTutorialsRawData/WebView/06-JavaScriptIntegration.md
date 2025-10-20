# JavaScript Integration

## What is JavaScript Integration?

JavaScript Integration allows your Unity mobile game to execute JavaScript code within the web view and receive results back. This enables powerful two-way communication between your Unity code and web content, opening up advanced interactive possibilities.

## Why Use JavaScript Integration in Unity Mobile Games?

JavaScript integration enables you to:
- Modify web page content dynamically from Unity
- Extract data from web pages for use in your game
- Implement custom interactions between Unity and web content  
- Create hybrid experiences that blend native game UI with web content
- Control web-based mini-games or interactive elements

## JavaScript Execution API

The main method for running JavaScript:

```csharp
public void RunJavaScript(string script, EventCallback<WebViewRunJavaScriptResult> callback)
```

### Basic JavaScript Execution

Execute simple JavaScript commands:

```csharp
using VoxelBusters.EssentialKit;

WebView webView = WebView.CreateInstance();
webView.LoadURL(URLString.URLWithPath("https://yourgame.com"));

// Execute JavaScript after page loads
webView.RunJavaScript("document.title", (result, error) =>
{
    if (error == null)
    {
        Debug.Log($"Page title: {result.Result}");
    }
    else
    {
        Debug.LogError($"JavaScript error: {error.LocalizedDescription}");
    }
});
```

This snippet retrieves the web page title using JavaScript.

### Modifying Web Content

Change web page content from Unity:

```csharp
string playerName = "SuperGamer123";
string jsCode = $@"
    document.getElementById('player-name').textContent = '{playerName}';
    document.getElementById('player-level').textContent = '{playerLevel}';
    'Player info updated';
";

webView.RunJavaScript(jsCode, (result, error) =>
{
    if (error == null)
    {
        Debug.Log($"JavaScript result: {result.Result}");
    }
});
```

This approach updates web page content with data from your Unity game.

### Extracting Web Data

Get information from web pages for use in Unity:

```csharp
string extractScript = @"
    var scoreElement = document.getElementById('high-score');
    scoreElement ? scoreElement.textContent : 'No score found';
";

webView.RunJavaScript(extractScript, (result, error) =>
{
    if (error == null && int.TryParse(result.Result, out int webScore))
    {
        Debug.Log($"High score from web: {webScore}");
        UpdateGameScore(webScore);
    }
});
```

This snippet extracts score data from a web page to update your game.

### Complex JavaScript Operations

Perform more complex JavaScript operations:

```csharp
string complexScript = @"
    // Create a custom game integration object
    window.unityGameBridge = {
        sendScore: function(score) {
            return 'Score received: ' + score;
        },
        getPlayerData: function() {
            return JSON.stringify({
                currentLevel: 5,
                experience: 1250,
                items: ['sword', 'shield', 'potion']
            });
        }
    };
    
    // Initialize and return status
    'Unity bridge initialized';
";

webView.RunJavaScript(complexScript, (result, error) =>
{
    if (error == null)
    {
        Debug.Log($"Bridge setup: {result.Result}");
        // Now you can call bridge methods
        CallJavaScriptBridge();
    }
});
```

This advanced example creates a JavaScript bridge for complex Unity-web communication.

📌 Video Note: Show Unity demo of JavaScript execution with real-time web page modification and data extraction.