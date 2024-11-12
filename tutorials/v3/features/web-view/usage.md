# Usage

All web view features can be accessed through WebView class. Before using it, we need to import the namespace.

```csharp
using VoxelBusters.CoreLibrary;
using VoxelBusters.EssentialKit;
```

### Register to events

Once after importing the namespace, for getting the events fired from Web View, it's required to register to the events first.

```csharp
private void OnEnable()
{
    // register for events
    WebView.OnShow          += OnWebViewShow;
    WebView.OnHide          += OnWebViewHide;
    WebView.OnLoadStart     += OnWebViewLoadStart;
    WebView.OnLoadFinish    += OnWebViewLoadFinish;
}

private void OnDisable()
{
    // register for events
    WebView.OnShow          -= OnWebViewShow;
    WebView.OnHide          -= OnWebViewHide;
    WebView.OnLoadStart     -= OnWebViewLoadStart;
    WebView.OnLoadFinish    -= OnWebViewLoadFinish;
}
```

Events get fired for various reasons such as when web view hides/shows, when a page loading starts/finishes.

### Create Web View Instance

Create an instance of WebView with CreateInstance. This instance holds the properties of how you want to present and operate with your webview.

```csharp
WebView webview = WebView.CreateInstance();
```

### Set Frame Size

Once after registering the events and creating the WebView instance with CreateInstance, you need to set the frame size of the webview. You can set the frame size in multiple ways.

#### Set normalized size

```csharp
webview.SetNormalizedFrame(new Rect(0f, 0f, 1f, 1.0f));
```

#### Set in terms of screen size

```csharp
webview.Frame = new Rect(0f, 0f, Screen.width, Screen.height);
```

#### Set full screen

```csharp
webview.SetFullScreen();
```

### Show

For showing webview, you need to call Show method. Make sure you set the frame size of the webview else, it won't be visible.

```csharp
webview.Show();
```

You can show the webview anytime but optionally you show only once the page/url is loaded successfully. **AutoShowOnLoadFinish** property of WebView allows to show the webview once the page is loaded.

```csharp
webview.AutoShowOnLoadFinish = true;
```

For getting an event when a webview is shown, you can listen to **WebView.OnShow** event.

```csharp
//Register to WebView.OnShow event

private void OnWebViewShow(WebView result)
{
   Debug.Log("Webview is being displayed : " + result);
}
```

### Hide

Call Hide in-case if you want to hide the webview. Calling a hidden webview is a no-operation.

```
webview.Hide();
```

For getting an event when a webview is hidden, you can listen to **WebView.OnHide** event.\\

```csharp
//Register to WebView.OnHide event

private void OnWebViewHide(WebView result)
{
   Debug.Log("Webview is hidden : " + result);
}
```

### Appearance Styles

It's possible to set different controls to show up with the webview. These controls can help to use WebView based on your use-cases.

{% tabs %}
{% tab title="Default" %}
Default mode doesn't have any controls and this appearance is ideal for ads like use-case

```
webview.Style = WebViewStyle.Default;
```
{% endtab %}

{% tab title="Popup" %}
Popup mode adds a close button at top-right corner of the web view. On clicking the button, the web view will get hidden.

```
webview.Style = WebViewStyle.Popup;
```
{% endtab %}

{% tab title="Browser" %}
Browser mode provides a browser like appearance with 4 buttons for easy navigation.

| Button     | Description                                                            |
| ---------- | ---------------------------------------------------------------------- |
| Back       | On pressing, it takes back to the previous browsed webpage             |
| Forward    | On pressing, it loads the next url in the browser webpage history list |
| Reload     | On pressing, it re-loads the current webpage                           |
| Done/Close | On pressing, it dismisses the current displayed web view               |

```csharp
webview.Style = WebViewStyle.Popup;
```
{% endtab %}
{% endtabs %}

### Load Content

For loading a url, you need to pass well qualified url to **LoadURL** method.

#### Load local file url

```csharp
webview.LoadURL(URLString.FileURLWithPath("local device path"));//Ex: Load from Application.PersistentPath
```

#### Load web url

```csharp
webview.LoadURL(URLString.URLWithPath("https://www.google.com"));
```

#### Load Html string

```csharp
string htmlString = "<html><body><p><b>This text is bold</b></p><p><i>This text is italic</i></p><p>This is<sub> subscript</sub> and <sup>superscript</sup></p></body></html>";
webview.LoadHtmlString(htmlString);
```

####

#### Load data

You can also load data content in the web view. Ex : Loading byte data of a file

```csharp
Texture2D texture; // Load the texture
string  mimeType, textEncodingName;
byte[]  data   = texture.Encode(TextureEncodingFormat.JPG, out mimeType, out textEncodingName);
webView.LoadData(data, mimeType, textEncodingName);
```

#### Load texture

Loading texture loads the texture into the web view.

```csharp
Texture2D texture; // Load the texture
webView.LoadTexture(texture, TextureEncodingFormat.JPG);
```

#### Run Java Script code

You can run javascript code using RunJavaScript method. But before using this method, you need set **JavaScriptEnabled** property of web view to true.

```csharp
// Enable java script first
webview.JavaScriptEnabled = true;

/*
<!DOCTYPE html>
<html>
<body>
    <script>
    function Concat (str1, str2) 
    {
        return str1.concat(str2);
    }
    </script>
</body>
</html>
*/

string htmlString = "<!DOCTYPE html><html><body>    <script>    function Concat (str1, str2)     {        return str1.concat(str2);    }    </script></body></html>"

// Load html data
webview.LoadHtmlString(htmlString);

// Run Java Script
webview.RunJavaScript("Concat("Voxel", "Busters")", (result, error) => {
    if (error == null)
    {
        Debug.Log("Javascript was executed successfully. Result: " + result.Result);
    }
    else
    {
        Debug.Log("Could not run javascript. Error: " + error);
    }
});

```

### Controlling  data

#### Reload

Reload the current web page data with Reload method. It reloads the total web page and resets to default.

```csharp
webview.Reload();
```

#### Stop Loading

Stop loading if you want to abort the current loading of web url.

```csharp
webview.StopLoading();
```

#### Clear Cache

Clear the cached content with **ClearCache.** This will clear the complete browsing history.

```
webview.ClearCache();
```

### Receive messages from web view to unity

For getting messages from web view to unity, you need to register a scheme ahead. Schemes are the first part of a valid url.

For ex:  \
https://www.google.com has **https** as scheme. \
ftp://user:password@host:post/path has **ftp** as scheme

In-case if you need to pass data from web view, you can have your own custom scheme and register it.

Let's say you want to send some data on pressing a button. You can  href to a custom url with scheme unity. For ex: unity://accesstoken?key=value

So first you need to add the scheme

```
webview.AddURLScheme("unity");
```

Once after adding the scheme you can get all of the url's which are getting loaded with unity as scheme. The url's to unity are passed through **OnURLSchemeMatchFound** event. So, make sure you register to **WebView.OnURLSchemeMatchFound** ahead**.**

```
private void OnEnable()
{
     ...
     WebView.OnURLSchemeMatchFound += OnURLSchemeMatchFound;
}

private void OnDisable()
{
     ...
     WebView.OnURLSchemeMatchFound -= OnURLSchemeMatchFound;
}

private void OnURLSchemeMatchFound(string result)
{
     Debug.Log("Found a url scheme match : " + result);
}
```

### Additional settings

There are additional properties which can be controlled with in a web view.

| Property        | Description                                                                                                    |
| --------------- | -------------------------------------------------------------------------------------------------------------- |
| ScalesPageToFit | A boolean value indicating whether web view scales webpages to fit the view and the user can change the scale. |
| CanBounce       | A Boolean value that controls whether the web view bounces past the edge of content and back again.            |
| BackgroundColor | The background color of the webview                                                                            |
| Progress        | The value indicates the progress of load request                                                               |
| IsLoading       | A boolean value indicating whether this webview is loading content                                             |

####
