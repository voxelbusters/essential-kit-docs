# Social Share Composer

Plugin supports sharing to three social networks.

* Facebook
* Twitter
* Whats App

When creating an instance of SocialShareComposer you can pass the **SocialShareComposerType** for sharing to specific social network.

You can check the availability of a composer by calling IsComposerAvailable.

```csharp
bool isFacebookAvailable = SocialShareComposer.IsComposerAvailable(SocialShareComposerType.Facebook);
```

The above returns true if the app is installed on the device and ready to accept any sharing.

{% hint style="success" %}
On some social networks,  it's not possible to share multiple data at same time. For example sharing url and image may lead to share only one of those.
{% endhint %}

## Facebook

{% hint style="danger" %}
As per [**facebook policy**](https://developers.facebook.com/docs/apps/review/prefill/), it's not possible to share a pre-filled text.
{% endhint %}

### Share screenshot

```csharp
SocialShareComposer composer = SocialShareComposer.CreateInstance(SocialShareComposerType.Facebook);
composer.AddScreenshot();
composer.SetCompletionCallback((result, error) => {
    Debug.Log("Social Share Composer was closed. Result code: " + result.ResultCode);
});
composer.Show();
```

### Share image

```csharp
Texture2D texture = Resources.Load<Texture2D>("texture name");

SocialShareComposer composer = SocialShareComposer.CreateInstance(SocialShareComposerType.Facebook);
composer.AddImage(texture);
composer.SetCompletionCallback((result, error) => {
    Debug.Log("Social Share Composer was closed. Result code: " + result.ResultCode);
});
composer.Show();
```

### Share URL

```csharp
SocialShareComposer composer = SocialShareComposer.CreateInstance(SocialShareComposerType.Facebook);
composer.AddURL(URLString.URLWithPath("https://www.google.com"));
composer.SetCompletionCallback((result, error) => {
    Debug.Log("Social Share Composer was closed. Result code: " + result.ResultCode);
});
composer.Show();
```

## Twitter

### Share text

```csharp
SocialShareComposer composer = SocialShareComposer.CreateInstance(SocialShareComposerType.Twitter);
composer.SetText("Share text");
composer.SetCompletionCallback((result, error) => {
    Debug.Log("Social Share Composer was closed. Result code: " + result.ResultCode);
});
composer.Show();
```

### Share screenshot

```csharp
SocialShareComposer composer = SocialShareComposer.CreateInstance(SocialShareComposerType.Twitter);
composer.AddScreenshot();
composer.SetCompletionCallback((result, error) => {
    Debug.Log("Social Share Composer was closed. Result code: " + result.ResultCode);
});
composer.Show();
```

### Share image

```csharp
Texture2D texture = Resources.Load<Texture2D>("texture name");

SocialShareComposer composer = new SocialShareComposer(SocialShareComposerType.Twitter);
composer.AddImage(texture);
composer.SetCompletionCallback((result, error) => {
    Debug.Log("Social Share Composer was closed. Result code: " + result.ResultCode);
});
composer.Show();
```

### Share URL

```csharp
SocialShareComposer composer = SocialShareComposer.CreateInstance(SocialShareComposerType.Twitter);
composer.AddURL(URLString.URLWithPath("https://www.google.com"));
composer.SetCompletionCallback((result, error) => {
    Debug.Log("Social Share Composer was closed. Result code: " + result.ResultCode);
});
composer.Show();
```

## Whats App

### Share text

```csharp
SocialShareComposer composer = SocialShareComposer.CreateInstance(SocialShareComposerType.WhatsApp);
composer.SetText("Share text");
composer.SetCompletionCallback((result, error) => {
    Debug.Log("Social Share Composer was closed. Result code: " + result.ResultCode);
});
composer.Show();
```

### Share text with screenshot

```csharp
SocialShareComposer composer = SocialShareComposer.CreateInstance(SocialShareComposerType.WhatsApp);
composer.SetText("Share text");
composer.AddScreenshot();
composer.SetCompletionCallback((result, error) => {
    Debug.Log("Social Share Composer was closed. Result code: " + result.ResultCode);
});
composer.Show();
```

{% hint style="danger" %}
On iOS, sharing both text and screenshot are not possible. Only either one of those is possible on WhatsApp.
{% endhint %}

### Share screenshot

```csharp
SocialShareComposer composer = SocialShareComposer.CreateInstance(SocialShareComposerType.WhatsApp);
composer.AddScreenshot();
composer.SetCompletionCallback((result, error) => {
    Debug.Log("Social Share Composer was closed. Result code: " + result.ResultCode);
});
composer.Show();
```

### Share image

```csharp
Texture2D texture = Resources.Load<Texture2D>("texture name");

SocialShareComposer composer = SocialShareComposer.CreateInstance(SocialShareComposerType.WhatsApp);
composer.AddImage(texture);
composer.SetCompletionCallback((result, error) => {
    Debug.Log("Social Share Composer was closed. Result code: " + result.ResultCode);
});
composer.Show();
```

### Share URL

```csharp
SocialShareComposer composer = SocialShareComposer.CreateInstance(SocialShareComposerType.WhatsApp);
composer.AddURL(URLString.URLWithPath("https://www.google.com"));
composer.SetCompletionCallback((result, error) => {
    Debug.Log("Social Share Composer was closed. Result code: " + result.ResultCode);
});
composer.Show();
```
