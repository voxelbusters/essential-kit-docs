---
description: "Media Services allows camera capture, gallery selection, and image saving on mobile devices"
---

# Usage

Essential Kit wraps native iOS and Android media APIs into a single Unity interface. All media operations automatically handle permissions - the first call triggers the system permission dialog if needed.

## Table of Contents
- [Understanding Core Concepts](#understanding-core-concepts)
- [Import Namespaces](#import-namespaces)
- [How Permissions Work](#how-permissions-work)
- [Selecting Media from Gallery](#selecting-media-from-gallery)
- [Capturing Media with Camera](#capturing-media-with-camera)
- [Saving Media to Gallery](#saving-media-to-gallery)
- [Working with IMediaContent](#working-with-imedia-content)
- [Data Properties](#data-properties)
- [Core APIs Reference](#core-apis-reference)
- [Error Handling](#error-handling)
- [Advanced: Manual Initialization](#advanced-manual-initialization)

## Understanding Core Concepts

### Media Content Types
Media Services supports three content types through unified APIs:
- **Images**: PNG, JPEG photos from gallery or camera
- **Videos**: MP4, MOV videos from gallery or camera
- **Documents**: PDFs and other file types (gallery selection only)

### Permission Modes
Gallery access has different permission levels:
- **Read**: Select existing media from gallery
- **Write**: Save new media to gallery
- **Add**: Add media without full gallery access (iOS 14+ limited library)

### IMediaContent Interface
All media operations return `IMediaContent` instances that can be converted to:
- **Texture2D**: For displaying images in UI
- **File Path**: For saving to disk with custom location
- **Raw Data**: For uploading to servers or custom processing

## Import Namespaces
```csharp
using System;
using VoxelBusters.EssentialKit;
using VoxelBusters.CoreLibrary;
```

## How Permissions Work

Just call the media operation directly - no permission checks needed. Essential Kit automatically shows the system permission dialog on first use. If permission is granted, the operation executes. If denied, the error callback explains why.

{% hint style="success" %}
**UX Best Practice**: Show a custom explanation screen before calling media operations to improve opt-in rates. For example, display "Choose a profile picture to personalize your experience" before calling `SelectMediaContent()`.
{% endhint %}

Handle permission issues in the error callback:
```csharp
void OnMediaOperationComplete(IMediaContent[] contents, Error error)
{
    if (error != null)
    {
        if (error.Code == (int)MediaServicesErrorCode.PermissionNotAvailable)
        {
            Debug.Log("Gallery access denied - guide user to settings");
            Utilities.OpenApplicationSettings();
        }
        return;
    }

    Debug.Log($"Selected {contents.Length} media items");
}
```

### Optional: Check Permission Status
Use `GetGalleryAccessStatus()` or `GetCameraAccessStatus()` only when you need to inspect the exact state **before** calling the main operation or to customize UI messaging.

```csharp
var galleryStatus = MediaServices.GetGalleryAccessStatus(GalleryAccessMode.Read);
// NotDetermined | Restricted | Denied | Authorized | Limited

var cameraStatus = MediaServices.GetCameraAccessStatus();
// NotDetermined | Restricted | Denied | Authorized
```

## Selecting Media from Gallery

### Why Gallery Selection is Needed
Let players choose existing media from their device for avatars, backgrounds, or user-generated content features without requiring them to take new photos.

This ensures:
- Faster user onboarding (use existing photos)
- Privacy-friendly selection (Photo Picker on modern platforms)
- Multiple file type support (images, videos, documents)

### Basic Image Selection

```csharp
void SelectAvatarImage()
{
    var options = MediaContentSelectOptions.CreateForImage();

    MediaServices.SelectMediaContent(options, OnImageSelected);
}

void OnImageSelected(IMediaContent[] contents, Error error)
{
    if (error != null)
    {
        Debug.LogError($"Image selection failed: {error.Description}");
        return;
    }

    if (contents == null || contents.Length == 0)
    {
        Debug.Log("User cancelled selection");
        return;
    }

    // Convert to Texture2D for display
    contents[0].AsTexture2D((texture, conversionError) =>
    {
        if (conversionError != null)
        {
            Debug.LogError($"Failed to load image: {conversionError.Description}");
            return;
        }

        Debug.Log($"Loaded avatar image: {texture.width}x{texture.height}");
        Debug.Log("Assign the texture to your avatar UI.");
    });
}
```

### Multiple Selection
```csharp
void SelectMultiplePhotos()
{
    var options = MediaContentSelectOptions.CreateForImage(maxAllowed: 10);

    MediaServices.SelectMediaContent(options, (contents, error) =>
    {
        if (error == null && contents != null)
        {
            Debug.Log($"Selected {contents.Length} photos");
            foreach (var content in contents)
            {
                // Process each photo
            }
        }
    });
}
```

### Selecting Videos
```csharp
void SelectVideo()
{
    var options = MediaContentSelectOptions.CreateForVideo();

    MediaServices.SelectMediaContent(options, (contents, error) =>
    {
        if (error == null && contents != null && contents.Length > 0)
        {
            // Videos must be saved to file for playback
            contents[0].AsFilePath(Application.persistentDataPath, "selected_video",
                (filePath, fileError) =>
            {
                if (fileError == null)
                {
                    Debug.Log($"Video saved to: {filePath}");
                    Debug.Log("Play the saved video using your preferred player.");
                }
            });
        }
    });
}
```

### Custom MIME Type Selection
```csharp
void SelectDocument()
{
    var options = new MediaContentSelectOptions(
        title: "Select Document",
        allowedMimeType: MimeType.kPDFDocument,
        maxAllowed: 1
    );

    MediaServices.SelectMediaContent(options, OnDocumentSelected);
}
```

## Capturing Media with Camera

### Why Camera Capture is Needed
Let players create new content directly from your app - profile photos, in-game screenshots with real backgrounds, or user-generated content.

This ensures:
- Fresh, context-appropriate content creation
- Immediate photo/video capture without leaving the app
- Native camera interface with platform-optimized controls

### Capturing a Photo
```csharp
void CaptureProfilePhoto()
{
    var options = new MediaContentCaptureOptions(
        MediaContentCaptureType.Image,
        title: "Capture Profile Photo",
        fileName: "profile_photo",
        source: MediaContentCaptureSource.Camera);

    MediaServices.CaptureMediaContent(options, OnPhotoCaptured);
}

void OnPhotoCaptured(IMediaContent content, Error error)
{
    if (error != null)
    {
        Debug.LogError($"Camera capture failed: {error.Description}");
        return;
    }

    if (content == null)
    {
        Debug.Log("User cancelled camera capture");
        return;
    }

    content.AsTexture2D((texture, conversionError) =>
    {
        if (conversionError == null)
        {
            Debug.Log($"Captured photo: {texture.width}x{texture.height}");
            Debug.Log("Apply the captured texture to the profile UI.");
        }
    });
}
```

### Capturing a Video
```csharp
void CaptureVideo()
{
    var options = new MediaContentCaptureOptions(
        MediaContentCaptureType.Video,
        title: "Capture video",
        fileName: "captured_video",
        source: MediaContentCaptureSource.Camera);

    MediaServices.CaptureMediaContent(options, (content, error) =>
    {
        if (error == null && content != null)
        {
            // Save video to file
            content.AsFilePath(Application.persistentDataPath, "videos",
                (filePath, fileError) =>
            {
                if (fileError == null)
                {
                    Debug.Log($"Video captured at: {filePath}");
                }
            });
        }
    });
}
```

### Advanced Capture Options
```csharp
void CustomCapture()
{
    var options = new MediaContentCaptureOptions(
        title: "Capture Image",
        fileName: "game_photo",
        captureType: MediaContentCaptureType.Image
    );

    MediaServices.CaptureMediaContent(options, OnPhotoCaptured);
}
```

## Saving Media to Gallery

### Why Saving Media is Needed
Let players save game screenshots, generated images, or downloaded content to their device for sharing and keeping.

This ensures:
- Players can share achievements on social media
- Generated content persists outside the app
- Screenshots can be accessed from native photo apps

### Saving a Screenshot
```csharp
void SaveGameScreenshot()
{
    // Capture screenshot
    Texture2D screenshot = ScreenCapture.CaptureScreenshotAsTexture();
    byte[] imageData = screenshot.EncodeToPNG();

    var saveOptions = new MediaContentSaveOptions(
        directoryName: "MyGame Screenshots",
        fileName: $"mygame_screenshot_{DateTime.UtcNow:yyyyMMdd_HHmmss}");

    MediaServices.SaveMediaContent(
        data: imageData,
        mimeType: MimeType.kPNGImage,
        options: saveOptions,
        callback: OnScreenshotSaved
    );

    // Clean up temporary texture
    UnityEngine.Object.Destroy(screenshot);
}

void OnScreenshotSaved(bool success, Error error)
{
    if (success)
    {
        Debug.Log("Screenshot saved to gallery");
        Debug.Log("Show share success feedback to the player.");
    }
    else if (error != null)
    {
        Debug.LogError($"Failed to save screenshot: {error.Description}");
    }
}
```

### Saving Without Custom Album
```csharp
void SaveToDefaultGallery()
{
    Texture2D image = GetGeneratedImage();
    byte[] imageData = image.EncodeToJPG(quality: 90);

    // Pass null for directoryName to save to default location
    var options = new MediaContentSaveOptions(
        directoryName: null,  // No custom album
        fileName: "generated_image"
    );

    MediaServices.SaveMediaContent(imageData, MimeType.kJPEGImage, options,
        (success, error) =>
    {
        Debug.Log(success ? "Saved successfully" : $"Save failed: {error}");
    });
}
```

{% hint style="warning" %}
**Custom Albums on iOS**: Creating custom albums requires additional permissions. If "Saves Files to Custom Directories" is disabled in settings, you must pass `null` for `directoryName` to avoid permission errors.
{% endhint %}

## Working with IMediaContent

`IMediaContent` is the universal interface for all media returned by Essential Kit. It supports three conversion methods:

### Convert to Texture2D
```csharp
void LoadImageTexture(IMediaContent content)
{
    content.AsTexture2D((texture, error) =>
    {
        if (error == null)
        {
            Debug.Log($"Display texture ({texture.width}x{texture.height}) in your UI.");
        }
    });
}
```

### Convert to File Path
```csharp
void SaveToFile(IMediaContent content)
{
    string saveDirectory = Application.persistentDataPath;
    string fileName = "media_file";

    content.AsFilePath(saveDirectory, fileName, (filePath, error) =>
    {
        if (error == null)
        {
            Debug.Log($"Media saved to: {filePath}");
        }
    });
}
```

### Get Raw Media Data
```csharp
void GetRawBytes(IMediaContent content)
{
    content.AsRawMediaData((rawData, error) =>
    {
        if (error == null)
        {
            byte[] mediaBytes = rawData.Bytes;
            string mimeType = rawData.Mime;
            Debug.Log($"Got {mediaBytes.Length} bytes of {mimeType}");

            // Upload to server, process, etc.
        }
    });
}
```

## Data Properties

| Item | Type | Notes |
| --- | --- | --- |
| `IMediaContent` | Interface | Provides asynchronous helpers (`AsTexture2D`, `AsFilePath`, `AsRawMediaData`) so you can retrieve the captured or selected asset in the format your UI or backend expects. |
| `RawMediaData.Bytes` | `byte[]` | Raw payload returned by `AsRawMediaData`; combine with `RawMediaData.Mime` to upload files or persist binary data accurately. |
| `RawMediaData.Mime` | `string` | MIME type that Essential Kit detected for the media item (`image/png`, `video/mp4`, etc.); use it when saving or posting to remote services. |
| `MediaServicesErrorCode` | Enum | Values surfaced through `Error.Code` inside callbacks. Use it to branch on permission issues, cancellations, or platform errors before retrying. |

## Core APIs Reference

| API | Purpose | Returns |
| --- | --- | --- |
| `MediaServices.SelectMediaContent(options, callback)` | Open gallery to select media | `IMediaContent[]` via callback |
| `MediaServices.CaptureMediaContent(options, callback)` | Open camera to capture photo/video | `IMediaContent` via callback |
| `MediaServices.SaveMediaContent(data, mimeType, options, callback)` | Save media to device gallery | `bool` success via callback |
| `MediaContentSelectOptions.CreateForImage()` | Create selection options for images | `MediaContentSelectOptions` |
| `MediaContentSelectOptions.CreateForVideo()` | Create selection options for videos | `MediaContentSelectOptions` |
| `MediaContentCaptureOptions.CreateForImage()` | Create capture options for photos | `MediaContentCaptureOptions` |
| `MediaContentCaptureOptions.CreateForVideo()` | Create capture options for videos | `MediaContentCaptureOptions` |
| `MediaServices.GetGalleryAccessStatus(mode)` | **Optional:** Check gallery permission | `GalleryAccessStatus` enum |
| `MediaServices.GetCameraAccessStatus()` | **Optional:** Check camera permission | `CameraAccessStatus` enum |

## Error Handling

| Error Code | Trigger | Recommended Action |
| --- | --- | --- |
| `PermissionNotAvailable` | User declined camera/gallery access | Show rationale + link to `Utilities.OpenApplicationSettings()` |
| `UserCancelled` | User closed picker/camera without selecting | Log for analytics, no error message needed |
| `Unknown` | Platform error during operation | Retry or log for support investigation |
| `DataNotAvailable` | Missing required data in the underlying service | Validate options before calling API |

```csharp
void HandleMediaError(Error error)
{
    if (error == null) return;

        switch (error.Code)
        {
            case (int)MediaServicesErrorCode.PermissionNotAvailable:
                Debug.LogWarning("Explain why permission is needed and direct players to Settings.");
                break;

        case (int)MediaServicesErrorCode.UserCancelled:
            Debug.Log("User cancelled operation");
            break;

        default:
            Debug.LogError($"Media operation failed: {error.Description}");
            break;
    }
}
```

## Advanced: Manual Initialization

{% hint style="warning" %}
Manual initialization is only needed for specific runtime scenarios. For most games, Essential Kit's automatic initialization handles everything. **Skip this section unless** you need runtime settings or server-driven configuration.
{% endhint %}

### Understanding Manual Initialization

**Default Behavior:**
Essential Kit automatically initializes Media Services using settings from the ScriptableObject configured in the Unity Editor.

**Advanced Usage:**
Override default settings at runtime when you need:
- Feature flags based on user subscription level
- A/B testing different camera quality settings
- Server-driven feature configuration
- Dynamic album names based on game state

### Implementation

Override settings at runtime before using Media Services:
```csharp
void Awake()
{
    var customSettings = new MediaServicesUnitySettings(
        isEnabled: true,
        usesCameraForImageCapture: true,
        usesCameraForVideoCapture: true,
        savesFilesToGallery: true,
        savesFilesToCustomAlbums: false); // Disable custom albums
    
    MediaServices.Initialize(customSettings);
}
```

{% hint style="info" %}
Call `Initialize()` before any media operations. Most games should use the [standard setup](setup.md) configured in Essential Kit Settings instead.
{% endhint %}

## Related Guides
- Demo scene: `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/MediaServicesDemo.unity`
- Pair with **Sharing Services** to share selected images via native share sheet
- Use with **Utilities.OpenApplicationSettings()** for permission recovery flows
- See [Testing Guide](testing.md) for editor simulation and device validation
