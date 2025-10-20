# Content Loading

## What is Content Loading?

Content Loading refers to the various ways you can populate your web view with content. Essential Kit supports loading from URLs, HTML strings, raw data, and even Unity textures, giving you complete flexibility in how you present web content.

## Why Use Different Loading Methods in Unity Mobile Games?

Different loading methods serve different purposes:
- **URLs** for live web content, news feeds, and external websites
- **HTML strings** for dynamic content generation and templated pages  
- **Raw data** for offline content and embedded resources
- **Textures** for displaying Unity-generated images in web context

## Content Loading APIs

Essential Kit provides multiple loading methods:

```csharp
// Load from URL
public void LoadURL(URLString url)

// Load from HTML string
public void LoadHtmlString(string htmlString, URLString? baseURL = null)

// Load from raw data
public void LoadData(byte[] data, string mimeType, string textEncodingName, URLString? baseURL = null)

// Load Unity texture (extension method)
public void LoadTexture(Texture2D texture, TextureEncodingFormat format)
```

### Loading from URLs

Load live web content from any URL:

```csharp
using VoxelBusters.EssentialKit;

WebView webView = WebView.CreateInstance();

// Load a website
URLString gameNewsURL = URLString.URLWithPath("https://yourgame.com/news");
webView.LoadURL(gameNewsURL);

Debug.Log("Loading game news from URL");
```

This snippet loads live content from your game's news website.

### Loading HTML Strings

Generate dynamic content with HTML strings:

```csharp
string dynamicHTML = $@"
<html>
<head><title>Player Stats</title></head>
<body>
    <h1>Welcome, {playerName}!</h1>
    <p>Level: {playerLevel}</p>
    <p>Score: {playerScore}</p>
    <style>body {{ font-family: Arial; text-align: center; }}</style>
</body>
</html>";

webView.LoadHtmlString(dynamicHTML);
Debug.Log("Loading dynamic player stats page");
```

This approach creates custom HTML content using player data from your Unity game.

### Loading Raw Data

Load content from embedded resources or downloaded data:

```csharp
// Load image data
Texture2D gameImage = Resources.Load<Texture2D>("Screenshots/Level1");
string mimeType, encoding;
byte[] imageData = gameImage.Encode(TextureEncodingFormat.PNG, out mimeType, out encoding);

webView.LoadData(imageData, mimeType, encoding);
Debug.Log("Loading game image as web content");
```

This snippet displays Unity textures within the web view context.

### Loading Unity Textures

Direct texture loading with convenient extension methods:

```csharp
Texture2D screenshot = CaptureScreenshot();
webView.LoadTexture(screenshot, TextureEncodingFormat.JPG);
Debug.Log("Displaying game screenshot in web view");
```

📌 Video Note: Show Unity demo of each loading method with different types of content appearing in the web view.