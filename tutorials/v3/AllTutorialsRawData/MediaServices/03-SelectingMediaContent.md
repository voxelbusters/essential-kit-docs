# Media Services Tutorial - Selecting Media Content

## What is Media Content Selection?

Media content selection allows players to choose images, videos, audio files, or documents from their device's gallery or file system. This is a fundamental feature for Unity mobile games that need user-generated content, profile customization, or file import functionality.

## Why Use Media Selection in Unity Mobile Games?

Media selection enables:
- Profile picture customization in social games
- Custom content import (textures, avatars, etc.)
- User-generated content features  
- File sharing and importing capabilities
- Photo contest and gallery features

## Basic Media Selection

Use `SelectMediaContent()` to let users choose media from their device:

```csharp
using VoxelBusters.EssentialKit;

var options = new MediaContentSelectOptions("Select Image", MimeType.kAllImages, 1);
MediaServices.SelectMediaContent(options, OnMediaSelected);

void OnMediaSelected(IMediaContent[] contents, Error error)
{
    if (error == null)
    {
        Debug.Log($"Selected {contents.Length} items");
    }
    else
    {
        Debug.Log($"Selection failed: {error}");
    }
}
```

This snippet opens the device's media picker, allowing users to select one image file.

## MediaContentSelectOptions Configuration

The `MediaContentSelectOptions` class provides flexible configuration:

```csharp
// Custom selection options
var options = new MediaContentSelectOptions(
    title: "Choose Images",           // Dialog title
    allowedMimeType: MimeType.kAllImages,  // File type filter
    maxAllowed: 5                     // Maximum selections
);
```

## Predefined Selection Options

Essential Kit provides convenient helper methods for common scenarios:

```csharp
// Select single image
var imageOptions = MediaContentSelectOptions.CreateForImage(maxAllowed: 1);

// Select multiple videos  
var videoOptions = MediaContentSelectOptions.CreateForVideo(maxAllowed: 3);

// Select audio files
var audioOptions = MediaContentSelectOptions.CreateForAudio(maxAllowed: 2);

// Select any file type
var anyOptions = MediaContentSelectOptions.CreateForAny(maxAllowed: 10);
```

## Multi-Selection Example

Here's how to handle multiple file selection in your Unity cross-platform game:

```csharp
using VoxelBusters.EssentialKit;

public void SelectMultipleImages()
{
    var options = MediaContentSelectOptions.CreateForImage(maxAllowed: 5);
    MediaServices.SelectMediaContent(options, OnImagesSelected);
}

void OnImagesSelected(IMediaContent[] contents, Error error)
{
    if (error == null)
    {
        Debug.Log($"User selected {contents.Length} images");
        foreach (var content in contents)
        {
            Debug.Log("Processing selected image...");
            // Process each selected image
        }
    }
    else
    {
        Debug.Log($"Image selection cancelled or failed: {error}");
    }
}
```

This example allows users to select up to 5 images and processes each selection.

## Error Handling

Always handle potential errors when selecting media content:

```csharp
void OnMediaSelected(IMediaContent[] contents, Error error)
{
    if (error != null)
    {
        var errorCode = (MediaServicesErrorCode)error.Code;
        switch (errorCode)
        {
            case MediaServicesErrorCode.UserCancelled:
                Debug.Log("User cancelled selection");
                break;
            case MediaServicesErrorCode.PermissionNotAvailable:
                Debug.Log("Gallery permission not granted");
                break;
            default:
                Debug.Log($"Selection error: {error}");
                break;
        }
        return;
    }
    
    // Process successful selections
    foreach (var content in contents)
    {
        Debug.Log("Processing selected content...");
    }
}
```

This snippet demonstrates proper error handling using the `MediaServicesErrorCode` enum.

📌 **Video Note**: Show Unity demo of the media selection interface on both iOS and Android, demonstrating single and multi-selection scenarios with different file types.