# Media Services Tutorial - Saving Media Content

## What is Media Content Saving?

Media content saving allows your Unity mobile game to store images, videos, and other media files directly to the device's gallery or photo library. This feature is crucial for games with screenshot sharing, content creation tools, or any functionality that generates media for players to keep.

## Why Use Media Saving in Unity Mobile Games?

Media saving enables:
- Screenshot sharing and social features
- Game achievement image generation
- Custom artwork and content export
- Player creation tools with save functionality  
- Photo booth and editing features

## Basic Media Saving

Use `SaveMediaContent()` to save media to the device gallery:

```csharp
using VoxelBusters.EssentialKit;

// Capture a screenshot and save it
var screenshot = ScreenCapture.CaptureScreenshotAsTexture();
var pngData = screenshot.EncodeToPNG();
var saveOptions = new MediaContentSaveOptions(null, "game_screenshot");

MediaServices.SaveMediaContent(pngData, MimeType.kPNGImage, saveOptions, OnImageSaved);

void OnImageSaved(bool success, Error error)
{
    if (error == null && success)
    {
        Debug.Log("Screenshot saved to gallery successfully");
    }
    else
    {
        Debug.Log($"Save failed: {error}");
    }
}
```

This snippet captures the current screen and saves it as a PNG image to the device gallery.

## MediaContentSaveOptions Configuration

Configure save options to customize where and how media is saved:

```csharp
using VoxelBusters.EssentialKit;

// Save to default location (recommended)
var defaultOptions = new MediaContentSaveOptions(null, "my_game_image");

// Save to specific album (may require additional permissions)
var albumOptions = new MediaContentSaveOptions("MyGameAlbum", "special_screenshot");
```

Note: Passing `null` as the directory name is recommended as custom albums may require additional permissions on some platforms like iOS.

## Saving Different Media Types

Essential Kit supports saving various media formats:

```csharp
using VoxelBusters.EssentialKit;

public void SaveCustomImage(Texture2D texture)
{
    var imageData = texture.EncodeToPNG();
    var options = new MediaContentSaveOptions(null, "custom_image");
    
    MediaServices.SaveMediaContent(imageData, MimeType.kPNGImage, options, OnSaved);
}

public void SaveJPEGImage(Texture2D texture)
{
    var imageData = texture.EncodeToJPG(90); // 90% quality
    var options = new MediaContentSaveOptions(null, "jpeg_image");
    
    MediaServices.SaveMediaContent(imageData, MimeType.kJPGImage, options, OnSaved);
}

void OnSaved(bool success, Error error)
{
    Debug.Log(success ? "Image saved successfully" : $"Save failed: {error}");
}
```

## Complete Save Example

Here's a complete example for saving game-generated content:

```csharp
using VoxelBusters.EssentialKit;
using UnityEngine;

public class GameContentSaver : MonoBehaviour
{
    public void SaveGameAchievement(Texture2D achievementImage)
    {
        if (achievementImage == null)
        {
            Debug.Log("No image to save");
            return;
        }
        
        var pngData = achievementImage.EncodeToPNG();
        var saveOptions = new MediaContentSaveOptions(null, $"achievement_{System.DateTime.Now:yyyyMMdd_HHmmss}");
        
        MediaServices.SaveMediaContent(pngData, MimeType.kPNGImage, saveOptions, OnAchievementSaved);
    }
    
    void OnAchievementSaved(bool success, Error error)
    {
        if (error == null && success)
        {
            Debug.Log("Achievement image saved to gallery");
            ShowSaveSuccessMessage();
        }
        else
        {
            HandleSaveError(error);
        }
    }
    
    void HandleSaveError(Error error)
    {
        var errorCode = (MediaServicesErrorCode)error.Code;
        switch (errorCode)
        {
            case MediaServicesErrorCode.PermissionNotAvailable:
                Debug.Log("Gallery save permission not granted");
                break;
            default:
                Debug.Log($"Save error: {error}");
                break;
        }
    }
    
    void ShowSaveSuccessMessage()
    {
        // Show UI confirmation to player
        Debug.Log("Achievement saved! Check your gallery.");
    }
}
```

This example demonstrates saving achievement images with proper error handling and user feedback.

## Error Handling for Save Operations

Always handle save operation errors:

```csharp
void OnMediaSaved(bool success, Error error)
{
    if (error != null)
    {
        var errorCode = (MediaServicesErrorCode)error.Code;
        switch (errorCode)
        {
            case MediaServicesErrorCode.PermissionNotAvailable:
                Debug.Log("Gallery write permission required");
                break;
            case MediaServicesErrorCode.DataNotAvailable:
                Debug.Log("Invalid media data provided");
                break;
            default:
                Debug.Log($"Save operation failed: {error}");
                break;
        }
        return;
    }
    
    if (success)
    {
        Debug.Log("Media saved successfully to gallery");
    }
    else
    {
        Debug.Log("Save operation completed but may have failed");
    }
}
```

This error handling ensures robust save functionality across Unity cross-platform deployments.

📌 **Video Note**: Show Unity demo of saving screenshots and custom images to device gallery, demonstrating the saved content appearing in the native gallery app on both iOS and Android.