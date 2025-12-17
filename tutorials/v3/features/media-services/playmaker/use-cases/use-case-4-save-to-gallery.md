# Save Image to Device Gallery

## Goal
Save a Texture2D (screenshot, generated image, edited photo) to the device's photo gallery.

## Actions Required
| Action | Purpose |
|--------|---------|
| MediaServicesGetGalleryAccessStatus | Read current gallery permission status (Write mode) |
| MediaServicesSaveContent | Save texture to gallery |
| MediaServicesGetSaveContentError | Read cached error after failure (optional) |

## Variables Needed
- galleryStatus (Enum: GalleryAccessStatus)
- imageToSave (Texture2D)
- albumName (String) = "MyGameScreenshots" (optional)
- mimeType (String) = "image/png" or "image/jpeg"

## Implementation Steps

### 1. State: CheckGalleryPermission
**Action:** MediaServicesGetGalleryAccessStatus
- **Inputs:**
  - accessMode: Write
- **Outputs:**
  - status → galleryStatus
- **Next:** Use an Enum Switch/Compare on `galleryStatus`:
  - `Authorized` / `NotDetermined` / `Limited` → SaveImage
  - `Denied` / `Restricted` → ShowPermissionError

### 2. State: SaveImage
**Action:** MediaServicesSaveContent
- **Inputs:**
  - textureSource: imageToSave (Texture2D)
  - mimeType: `"image/png"` or `"image/jpeg"` (SaveContent encodes PNG/JPG only)
  - albumName: albumName (optional)
- **Events:**
  - successEvent → ShowSaveSuccess
  - failureEvent → ShowSaveError

**Optional:** On `failureEvent`, call `MediaServicesGetSaveContentError` to read `errorCode` + `errorDescription`.

### 3. State: ShowSaveSuccess
Display message: "Saved to Photos"
- Optional: Show toast notification
- Return to main state

## Save Flow
```
CheckGalleryPermission (Write mode)
    └─ SaveImage
        ├─ Success → Show "Saved!"
        └─ Failure → Show Error
```

## Screenshot Workflow

Complete screenshot + save workflow:

### 1. State: CaptureScreenshot
```csharp
// Use Unity's ScreenCapture or Texture2D.ReadPixels
Texture2D screenshot = ScreenCapture.CaptureScreenshotAsTexture();
Store in imageToSave variable
```
Go to CheckGalleryPermission

### 2-3. Permission Check and Save
Same as above (CheckGalleryPermission → SaveImage)

## Common Issues

- **Permission Denied**: Guide user to Settings to enable Photos access
- **Album Not Created**: Some platforms may not support custom album names
- **Texture Format**: Ensure texture is readable (Read/Write enabled in import settings)
- **Large Textures**: High-resolution saves can be slow; show progress indicator

## Platform Differences

**iOS:**
- Creates album in Photos app if it doesn't exist
- "Privacy - Photo Library Additions Usage Description" required
- Supports both PNG and JPG

**Android:**
- Saves to Pictures or DCIM directory
- WRITE_EXTERNAL_STORAGE permission required (older versions)
- Album name may be folder name in Pictures

## Format Considerations

**PNG:**
- Lossless compression
- Larger file size
- Best for: Screenshots with text, UI elements

**JPG:**
- Lossy compression
- Smaller file size (50-80% reduction)
- Best for: Photos, gameplay screenshots without text

## Performance Tips

**Async Saving:**
- Saving can take 100ms-1s for large images
- Show "Saving..." indicator during save
- Don't block user interaction

**Resolution Optimization:**
- Save at native resolution for screenshots
- Consider downscaling for generated images

## Use Cases

**Screenshot Sharing:**
- User captures gameplay moment
- Save to gallery
- User can share via native share sheet

**Level Editor:**
- User creates custom level
- Generate preview image
- Save to gallery for sharing

**Photo Filter App:**
- User applies filters to photo
- Save edited version
- Original remains in gallery
