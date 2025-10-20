# Social Share Composer

## What is Social Share Composer?

Social Share Composer provides direct integration with specific social media platforms for Unity mobile games. It enables targeted sharing to platforms like Facebook, Twitter, and other social networks through their dedicated native interfaces, offering platform-specific features and optimizations.

## Why Use Social Share Composer in Unity Mobile Games?

Social Share Composer is essential for Unity mobile games because it enables viral marketing through dedicated social platforms, provides platform-specific sharing optimizations, supports targeted social media campaigns, and leverages native social app features for maximum engagement.

## Core Social Share Composer APIs

### Availability Check

Verify if a specific social platform is available:

```csharp
if (SocialShareComposer.IsComposerAvailable(SocialShareComposerType.Facebook))
{
    Debug.Log("Facebook sharing is available");
}
```

### Basic Social Sharing

Share text content to a social platform:

```csharp
SocialShareComposer composer = SocialShareComposer.CreateInstance(SocialShareComposerType.Facebook);
composer.SetText("Just achieved a new high score in this Unity game!");
composer.Show();
```

This snippet creates a Facebook-specific composer with text content.

### Social Share with Screenshot

Share game achievements with visual proof:

```csharp
SocialShareComposer composer = SocialShareComposer.CreateInstance(SocialShareComposerType.Twitter);
composer.SetText("Level 10 completed! #UnityGame #Achievement");
composer.AddScreenshot();
composer.Show();
```

This snippet shares to Twitter with hashtags and an automatically captured screenshot.

### Social Share with Custom Image

Share promotional or achievement images:

```csharp
Texture2D badgeImage = GetAchievementBadge();
SocialShareComposer composer = SocialShareComposer.CreateInstance(SocialShareComposerType.Facebook);
composer.SetText("Unlocked the Master Player badge!");
composer.AddImage(badgeImage);
composer.Show();
```

This snippet shares a custom achievement badge image to Facebook.

### Social Share with URL

Share game links through social platforms:

```csharp
SocialShareComposer composer = SocialShareComposer.CreateInstance(SocialShareComposerType.Twitter);
composer.SetText("Playing this amazing Unity game!");
composer.AddURL(URLString.URLWithPath("https://game-store.com/mygame"));
composer.Show();
```

This snippet shares promotional text with a game link to Twitter.

### Platform-Specific Content

Tailor content for different social platforms:

```csharp
if (SocialShareComposer.IsComposerAvailable(SocialShareComposerType.Facebook))
{
    SocialShareComposer fbComposer = SocialShareComposer.CreateInstance(SocialShareComposerType.Facebook);
    fbComposer.SetText("Just beat my personal record!");
    fbComposer.AddScreenshot();
    fbComposer.Show();
}
```

This snippet demonstrates platform-specific sharing logic.

### Result Handling

Track social sharing results:

```csharp
composer.SetCompletionCallback(OnSocialShareResult);

private void OnSocialShareResult(SocialShareComposerResult result, Error error)
{
    Debug.Log($"Social share result: {result.ResultCode}");
}
```

Result codes include `Done` for successful posts and `Cancelled` when users cancel sharing.

📌 **Video Note:** Show Unity demo of social share composer opening Facebook and Twitter with different content types.

---

**Next:** [Best Practices - Sharing Services Implementation Guidelines](06-BestPractices.md)