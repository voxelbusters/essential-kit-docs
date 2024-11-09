# Share Sheet

Share sheet allows you to share your content to any app in general. What ever apps that support to share your content will be shown to the user and user can select the service he/she wants to share on.

### Share text

```csharp
ShareSheet shareSheet = ShareSheet.CreateInstance();
shareSheet.AddText("Text");
shareSheet.SetCompletionCallback((result, error) => {
    Debug.Log("Share Sheet was closed. Result code: " + result.ResultCode);
});
shareSheet.Show();
```

### Share text with screenshot

```csharp
ShareSheet shareSheet = ShareSheet.CreateInstance();
shareSheet.AddText("Text");
shareSheet.AddScreenshot();
shareSheet.SetCompletionCallback((result, error) => {
    Debug.Log("Share Sheet was closed. Result code: " + result.ResultCode);
});
shareSheet.Show();
```

### Share screenshot

```csharp
ShareSheet shareSheet = ShareSheet.CreateInstance();
shareSheet.AddScreenshot();
shareSheet.SetCompletionCallback((result, error) => {
    Debug.Log("Share Sheet was closed. Result code: " + result.ResultCode);
});
shareSheet.Show();
```

### Share image

```csharp
Texture2D texture = Resources.Load<Texture2D>("texture name");

ShareSheet shareSheet = ShareSheet.CreateInstance();
shareSheet.AddImage(texture);
shareSheet.SetCompletionCallback((result, error) => {
    Debug.Log("Share Sheet was closed. Result code: " + result.ResultCode);
});
shareSheet.Show();
```

### Share URL with text

```csharp
ShareSheet shareSheet = ShareSheet.CreateInstance();
shareSheet.AddText("Text");
shareSheet.AddURL(URLString.URLWithPath("https://www.google.com"));
shareSheet.SetCompletionCallback((result, error) => {
    Debug.Log("Share Sheet was closed. Result code: " + result.ResultCode);
});
shareSheet.Show();
```
