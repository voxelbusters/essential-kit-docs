---
description: "Common Media Services issues and solutions"
---

# FAQ & Troubleshooting

### Do I need to add camera and gallery permissions manually in AndroidManifest.xml and Info.plist?
No. Essential Kit automatically injects required permissions during the build process. Just enable the appropriate features in Essential Kit Settings (Services tab) and the plugin adds:
- **Android**: `CAMERA`, `READ_EXTERNAL_STORAGE`, `WRITE_EXTERNAL_STORAGE` based on enabled features
- **iOS**: `NSCameraUsageDescription`, `NSPhotoLibraryUsageDescription`, `NSPhotoLibraryAddUsageDescription` with your configured descriptions

### Images are not saving to Android gallery. What should I check?
For Android 10+ (API level 29+), ensure you have gallery write permissions. The most common issues:
1. **Missing Configuration**: Enable "Saves Files to Photo Gallery" in Essential Kit Settings
2. **Permission Denied**: First call to `SaveMediaContent()` requests permission automatically; check error callback for denial
3. **Development Build Issue**: Unity development builds may have restricted permissions. Test release builds or call `MediaServices.GetGalleryAccessStatus(GalleryAccessMode.ReadWrite)` to verify permission state

### User denied camera/gallery access. How do I let them re-enable it?
Use `Utilities.OpenApplicationSettings()` to deep link into the platform settings screen. Pair it with in-app messaging explaining why the permission enables your feature:

```csharp
void OnPermissionDenied()
{
    Debug.LogWarning("Camera access is required for profile photos. Opening Settings.");
    Utilities.OpenApplicationSettings();
}
```

### Can I test camera and gallery features in the Unity Editor?
Yes, Essential Kit provides editor simulation automatically. The simulator uses sample images and videos to test your integration. However, **you must test on physical devices** before release to verify:
- Actual permission dialogs and user flows
- Platform-specific pickers (Photo Picker on Android 13+, PHPicker on iOS 14+)
- Real camera capture and video recording
- Performance with large media files

### My captured photos appear rotated incorrectly. How do I fix this?
This happens when image metadata (EXIF orientation) isn't applied. Essential Kit handles orientation automatically when converting to `Texture2D`:

```csharp
content.AsTexture2D((texture, error) =>
{
    // Texture is already rotated correctly based on EXIF data
    if (error == null)
    {
        Debug.Log($"Texture ready with size {texture.width}x{texture.height}.");
    }
});
```

If you're reading raw data yourself, check the EXIF orientation tag and rotate accordingly.

### How can I limit file sizes for selected images?
Media selection APIs don't provide built-in file size filtering. Check file size after selection:

```csharp
content.GetRawMediaData((rawData, error) =>
{
    if (error == null)
    {
        int fileSizeKB = rawData.Data.Length / 1024;
        if (fileSizeKB > 5000) // 5MB limit
        {
            Debug.LogWarning("Please select an image smaller than 5MB.");
            return;
        }
        Debug.Log($"Processing image of size {fileSizeKB} KB.");
    }
});
```

For automatic compression, convert to Texture2D and re-encode:

```csharp
content.AsTexture2D((texture, error) =>
{
    if (error == null)
    {
        byte[] compressedData = texture.EncodeToJPG(quality: 75);
        Debug.Log($"Compressed image to {compressedData.Length / 1024} KB.");
    }
});
```

### Where can I confirm plugin behavior versus my implementation?
Run `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/MediaServicesDemo.unity`. If the sample works but your scene does not, compare:
- `MediaContentSelectOptions` / `MediaContentCaptureOptions` configuration
- Error handling in callbacks (check for `null` errors and user cancellation)
- Permission settings in Essential Kit Settings (Services tab)
- Callback execution timing (ensure operations complete before cleanup)

### Can I select multiple media types at once (images and videos)?
No, each selection operation supports a single media type filter. To support both, present a choice to the user:

```csharp
void SelectMedia(bool selectVideos)
{
    var options = selectVideos
        ? MediaContentSelectOptions.CreateForVideo()
        : MediaContentSelectOptions.CreateForImage();

    MediaServices.SelectMediaContent(options, (contents, error) =>
    {
        if (error != null)
        {
            Debug.LogError($"Selection failed: {error}");
            return;
        }

        Debug.Log($"Selected {contents.Length} item(s).");
    });
}
```

### Do saved images appear immediately in the device gallery?
Yes, images saved with `SaveMediaContent()` appear immediately in the native Photos app. If they don't appear:
1. Verify the callback returned `success = true` without errors
2. Check that "Saves Files to Photo Gallery" is enabled in Essential Kit Settings
3. Force refresh the gallery app (close and reopen on Android)
4. On iOS with custom albums, ensure "Saves Files to Custom Directories" is enabled if using non-null `directoryName`

### How do I handle "out of memory" errors with large images?
Large images (4000x3000px+) can cause memory issues. Strategies:
1. **Load at reduced resolution**: Some platforms provide thumbnail APIs (not exposed by Essential Kit currently)
2. **Compress immediately**: Convert to Texture2D and re-encode at lower quality
3. **Dispose quickly**: Call `Destroy(texture)` immediately after use
4. **Streaming**: Use `AsFilePath()` instead of `AsTexture2D()` for upload scenarios

```csharp
content.AsFilePath(Application.temporaryCachePath, "upload_image",
    (filePath, error) =>
{
    if (error == null)
    {
        Debug.Log($"Saved file to {filePath} for upload.");
        System.IO.File.Delete(filePath); // Clean up after upload
    }
});
```

### What MIME types are supported for saving?
Common supported MIME types:
- `MimeType.kPNGImage` - PNG images
- `MimeType.kJPEGImage` - JPEG images
- `MimeType.kMP4Video` - MP4 videos
- `MimeType.kMOVVideo` - MOV videos (iOS)

Use the appropriate MIME type matching your data format. Mismatched MIME types may cause save failures or incorrect gallery categorization.

### Can I customize the native camera interface?
No, Essential Kit uses the platform's native camera interface which cannot be customized. For custom camera experiences, consider:
- Building a custom camera using `WebCamTexture` (requires separate implementation)
- Using third-party camera plugins for advanced features
- Accepting the standard native interface (recommended for simplicity)

### How do I test custom album creation on iOS?
Enable "Saves Files to Custom Directories" in Essential Kit Settings, then:

```csharp
var saveOptions = new MediaContentSaveOptions(
    directoryName: "MyGame Photos", // Creates custom album
    fileName: "screenshot"
);

MediaServices.SaveMediaContent(imageData, MimeType.kPNGImage, saveOptions,
    (success, error) =>
{
    if (success)
    {
        Debug.Log("Saved to 'MyGame Photos' album");
    }
    else
    {
        Debug.LogError($"Save failed: {error}");
    }
});
```

On iOS, this creates a new album. On Android, behavior depends on OS version (may organize into folders or save to default location).
