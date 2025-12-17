# MediaServices Use Cases

Quick-start guides showing minimal implementations of camera and gallery features using PlayMaker custom actions.

## Available Use Cases

### 1. [Capture Photo from Camera](use-case-1-capture-photo.md)
**What it does:** Open camera, take photo, display in game
**Complexity:** Basic
**Actions:** 3 (GetCameraAccessStatus, CaptureContent, GetContentTexture)
**Best for:** Profile pictures, AR features, photo-based gameplay

---

### 2. [Select Photo from Gallery](use-case-2-gallery-select.md)
**What it does:** Pick one or more photos from device gallery
**Complexity:** Basic
**Actions:** 4 (GetGalleryAccessStatus, SelectContent, GetSelectContentSuccessResult, GetContentTexture)
**Best for:** Photo frames, avatars, importing user images

---

### 3. [Batch Import Multiple Images](use-case-3-batch-import.md)
**What it does:** Select multiple photos and get file paths for processing
**Complexity:** Intermediate
**Actions:** 3 (SelectContent, GetSelectContentSuccessResult, GetContentFilePath)
**Best for:** Photo albums, batch upload, collage creation

---

### 4. [Save Image to Device Gallery](use-case-4-save-to-gallery.md)
**What it does:** Save screenshots or generated images to Photos app
**Complexity:** Basic
**Actions:** 2 (GetGalleryAccessStatus, SaveContent)
**Best for:** Screenshot sharing, saving creations, photo export

---

## Choosing the Right Use Case

**Start Here:**
- Need camera input? → **Use Case 1** (Capture Photo)
- User picks existing photo? → **Use Case 2** (Gallery Select)
- Multiple photo selection? → **Use Case 3** (Batch Import)
- Save game content to device? → **Use Case 4** (Save to Gallery)

## Quick Action Reference

| Action | Purpose | Used In |
|--------|---------|---------|
| MediaServicesGetCameraAccessStatus | Read current camera permission status (synchronous) | Use Case 1 |
| MediaServicesGetGalleryAccessStatus | Read current gallery permission status (synchronous) | Use Cases 2, 3, 4 |
| MediaServicesCaptureContent | Open camera to capture | Use Case 1 |
| MediaServicesSelectContent | Open gallery picker | Use Cases 2, 3 |
| MediaServicesGetSelectContentSuccessResult | Get selection count (after SelectContent SUCCESS) | Use Cases 2, 3 |
| MediaServicesGetSelectContentError | Read error after selection failure | Use Cases 2, 3 |
| MediaServicesGetContentTexture | Convert cached image to Texture2D (async; use FINISHED) | Use Cases 1, 2 |
| MediaServicesGetContentFilePath | Get temp file path (async; use FINISHED) | Use Case 3 |
| MediaServicesGetCaptureContentError | Read error after capture failure | Use Case 1 |
| MediaServicesSaveContent | Save to gallery | Use Case 4 |
| MediaServicesGetSaveContentError | Read error after save failure | Use Case 4 |
| MediaServicesGetContentRawMediaData | Get bytes + MIME type (async; use FINISHED) | Optional (upload) |

## Media Types Supported

**Image**: Photos, screenshots (PNG, JPG, HEIC)
**Video**: Video files (MP4, MOV)
**Audio**: Audio files (MP3, WAV)

## Permission Types

**Camera Access:**
- Required for CaptureContent with Image or Video
- One-time prompt on first use

**Gallery Read:**
- Required for SelectContent
- Access to user's photo library

**Gallery Write:**
- Required for SaveContent
- Permission to add photos to library

## Common Workflows

**Profile Picture Upload:**
```
SelectContent (single image)
    └─ GetContentTexture
        └─ Upload to server
```

**Screenshot Sharing:**
```
Capture screenshot (Unity API)
    └─ SaveContent
        └─ User shares from Photos app
```

**Photo Editor:**
```
SelectContent
    └─ GetContentTexture
        └─ Apply filters
            └─ SaveContent
```

## Platform Requirements

**iOS:**
- **Camera**: "Privacy - Camera Usage Description" in Info.plist
- **Gallery Read**: "Privacy - Photo Library Usage Description"
- **Gallery Write**: "Privacy - Photo Library Additions Usage Description"

**Android:**
- **Camera**: CAMERA permission in AndroidManifest.xml
- **Gallery**: READ_EXTERNAL_STORAGE (read), WRITE_EXTERNAL_STORAGE (write)
- Android 10+: Scoped storage changes may apply

## Performance Best Practices

1. **Memory Management**: Dispose of textures when done
2. **Async Operations**: Show loading indicators during conversions
3. **Resolution**: Scale down large images for thumbnails
4. **Batch Processing**: Process one image at a time to avoid memory spikes

## Related Documentation
- Feature overview: `../README.md`
