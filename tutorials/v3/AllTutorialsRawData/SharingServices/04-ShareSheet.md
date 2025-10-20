# Share Sheet

## What is Share Sheet?

Share Sheet provides universal sharing functionality for Unity mobile games by presenting the device's native sharing interface. It displays all installed apps that can handle the shared content, allowing players to choose their preferred sharing destination from email, social media, messaging, cloud storage, and more.

## Why Use Share Sheet in Unity Mobile Games?

Share Sheet is crucial for Unity mobile games because it maximizes sharing reach by supporting all installed sharing apps, provides flexible content sharing without knowing the destination app, and delivers native platform-specific sharing experiences that players expect.

## Core Share Sheet APIs

### Basic Text Sharing

```csharp
ShareSheet shareSheet = ShareSheet.CreateInstance();
shareSheet.AddText("Just scored 50,000 points in this Unity game!");
shareSheet.Show();
```

This snippet creates a share sheet with text content and displays the native sharing interface.

### Screenshot Sharing

Share game screenshots instantly:

```csharp
ShareSheet shareSheet = ShareSheet.CreateInstance();
shareSheet.AddScreenshot();
shareSheet.Show();
```

The screenshot is automatically captured and made available to all compatible sharing apps.

### Text with Screenshot

Combine text and visual content:

```csharp
ShareSheet shareSheet = ShareSheet.CreateInstance();
shareSheet.AddText("Level completed!");
shareSheet.AddScreenshot();
shareSheet.Show();
```

This snippet shares both descriptive text and a screenshot of the current game state.

### URL Sharing

Share game links or promotional content:

```csharp
ShareSheet shareSheet = ShareSheet.CreateInstance();
shareSheet.AddText("Play this amazing Unity game!");
shareSheet.AddURL(URLString.URLWithPath("https://game-store.com/mygame"));
shareSheet.Show();
```

This snippet shares promotional text with a direct link to the game.

### Image Sharing

Share custom game images:

```csharp
Texture2D achievementImage = GetAchievementBadge();
ShareSheet shareSheet = ShareSheet.CreateInstance();
shareSheet.AddImage(achievementImage);
shareSheet.Show();
```

This snippet shares a custom texture image through the share sheet.

### Multiple Content Types

Share comprehensive content in one action:

```csharp
ShareSheet shareSheet = ShareSheet.CreateInstance();
shareSheet.AddText("New high score!");
shareSheet.AddURL(URLString.URLWithPath("https://leaderboard.com"));
shareSheet.AddScreenshot();
shareSheet.Show();
```

The platform determines which apps can handle each content type and presents appropriate options.

### Result Handling

Track sharing results for analytics:

```csharp
shareSheet.SetCompletionCallback(OnShareResult);

private void OnShareResult(ShareSheetResult result, Error error)
{
    Debug.Log($"Share result: {result.ResultCode}");
}
```

Result codes include `Done` for successful sharing and `Cancelled` when the user cancels.

📌 **Video Note:** Show Unity demo of share sheet displaying different app options based on shared content types.

---

**Next:** [Social Share Composer - Direct Social Media Integration](05-SocialShareComposer.md)