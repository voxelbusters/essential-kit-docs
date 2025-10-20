# Media Services Tutorial - Capturing Media Content

## What is Media Content Capture?

Media content capture allows your Unity mobile game to access the device camera to take photos or record videos directly within your application. This feature is essential for games that need real-time content creation, augmented reality features, or player-generated media.

## Why Use Media Capture in Unity Mobile Games?

Media capture enables:
- Profile photo capture for player accounts
- Augmented reality photo/video features
- In-game photo contests and challenges  
- Social sharing with custom camera integration
- User-generated content creation tools

## Basic Image Capture

Use `CaptureMediaContent()` to capture photos with the device camera:

```csharp
using VoxelBusters.EssentialKit;

var options = MediaContentCaptureOptions.CreateForImage();
MediaServices.CaptureMediaContent(options, OnImageCaptured);

void OnImageCaptured(IMediaContent content, Error error)
{
    if (error == null)
    {
        Debug.Log("Image captured successfully");
        // Process the captured image
    }
    else
    {
        Debug.Log($"Image capture failed: {error}");
    }
}
```

This snippet opens the device camera in photo mode and handles the captured image.

## Basic Video Capture

Use `CreateForVideo()` to capture videos:

```csharp
using VoxelBusters.EssentialKit;

var options = MediaContentCaptureOptions.CreateForVideo();
MediaServices.CaptureMediaContent(options, OnVideoCaptured);

void OnVideoCaptured(IMediaContent content, Error error)
{
    if (error == null)
    {
        Debug.Log("Video captured successfully");
        // Process the captured video
    }
    else
    {
        Debug.Log($"Video capture failed: {error}");
    }
}
```

This example captures video content using the device camera.

## Custom Capture Options

Create custom capture options for more control:

```csharp
using VoxelBusters.EssentialKit;

// Custom image capture with specific filename
var imageOptions = new MediaContentCaptureOptions(
    captureType: MediaContentCaptureType.Image,
    title: "Take Profile Photo",
    fileName: "player_avatar",
    source: MediaContentCaptureSource.Camera
);

// Custom video capture
var videoOptions = new MediaContentCaptureOptions(
    captureType: MediaContentCaptureType.Video,
    title: "Record Video",
    fileName: "gameplay_video",
    source: MediaContentCaptureSource.Camera
);
```

## Complete Capture Example

Here's a complete example for Unity cross-platform capture functionality:

```csharp
using VoxelBusters.EssentialKit;

public void CapturePlayerPhoto()
{
    var options = new MediaContentCaptureOptions(
        MediaContentCaptureType.Image,
        "Capture Avatar",
        "avatar_photo"
    );
    
    MediaServices.CaptureMediaContent(options, OnPhotoCaptured);
}

void OnPhotoCaptured(IMediaContent content, Error error)
{
    if (error != null)
    {
        HandleCaptureError(error);
        return;
    }
    
    Debug.Log("Photo captured, processing...");
    
    // Convert to texture for Unity rendering
    content.AsTexture2D((texture, conversionError) => {
        if (conversionError == null && texture != null)
        {
            Debug.Log($"Photo converted to texture: {texture.width}x{texture.height}");
            // Use texture in your game UI
        }
        else
        {
            Debug.Log($"Texture conversion failed: {conversionError}");
        }
    });
}
```

This example captures a photo and converts it to a Unity Texture2D for immediate use.

## Error Handling for Capture

Always handle capture errors appropriately:

```csharp
void HandleCaptureError(Error error)
{
    var errorCode = (MediaServicesErrorCode)error.Code;
    switch (errorCode)
    {
        case MediaServicesErrorCode.UserCancelled:
            Debug.Log("User cancelled camera capture");
            break;
        case MediaServicesErrorCode.PermissionNotAvailable:
            Debug.Log("Camera permission not granted");
            break;
        case MediaServicesErrorCode.DataNotAvailable:
            Debug.Log("Camera not available on device");
            break;
        default:
            Debug.Log($"Capture error: {error}");
            break;
    }
}
```

This error handling covers common camera capture scenarios in Unity iOS and Unity Android applications.

📌 **Video Note**: Show Unity demo of camera capture in action on both iOS and Android devices, demonstrating both photo and video capture modes with the resulting content displayed in the game UI.