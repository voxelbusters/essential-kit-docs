# FAQ

## How to get data from Web View to Unity?

You can add a scheme you want to capture and add with AddScheme method. All url's with the specified scheme will be passed as messages to Unity (OnURLSchemeMatchFound)

## Are there any events for page loading status?

**WebView.OnLoadStart** is the event that gets triggered when page loading starts.

**WebView.OnLoadFinish** is the event that gets triggered when page loading is done.

## &#x20;How to check the progress of a url load request?

You can use **Progress** property of **WebView** instance  to check the web page loading progress value.

