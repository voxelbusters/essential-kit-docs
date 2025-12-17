# Capture Photo from Camera

## Goal
Use the device camera to capture a photo and display it in your game UI.

## Actions Required
| Action | Purpose |
|--------|---------|
| MediaServicesGetCameraAccessStatus | Read current camera permission status |
| MediaServicesCaptureContent | Capture a photo (fires success/failure events) |
| MediaServicesGetContentTexture | Convert captured content (index 0) to Texture2D |
| MediaServicesGetCaptureContentError | Read cached error after failure (optional) |

## Variables Needed
- cameraStatus (Enum: CameraAccessStatus)
- capturedTexture (Texture2D)
- errorCode (Int) (optional)
- errorDescription (String) (optional)

## Implementation Steps

### 1. State: CheckCameraPermission
**Action:** MediaServicesGetCameraAccessStatus
- **Outputs:**
  - status → cameraStatus
- **Next:** Use an Enum Switch/Compare on `cameraStatus`:
  - `Authorized` / `NotDetermined` → CapturePhoto
  - `Denied` / `Restricted` → ShowPermissionError

### 2. State: CapturePhoto
**Action:** MediaServicesCaptureContent
- **Inputs:**
  - captureType: Image
  - customTitle: "Take Photo" (optional)
- **Events:**
  - successEvent → ConvertToTexture
  - failureEvent → GetCaptureError

**Note:** This opens the native camera UI and waits for the callback.

### 3. State: ConvertToTexture
**Action:** MediaServicesGetContentTexture
- **Inputs:**
  - contentIndex: 0 (first/only captured image)
- **Outputs:**
  - texture → capturedTexture
- **Next:** This action finishes when conversion completes. Use the state’s `FINISHED` transition → DisplayPhoto.

### 4. State: DisplayPhoto
Assign capturedTexture to UI Image component:
```
uiImage.texture = capturedTexture
```

### 5. (Optional) GetCaptureError
On `failureEvent`, call `MediaServicesGetCaptureContentError` to read `errorCode` + `errorDescription`.

## Capture Flow
```
CheckCameraPermission
    ├─ status = Authorized/NotDetermined → CapturePhoto
    └─ status = Denied/Restricted → ShowPermissionError

CapturePhoto
    └─ Success → ConvertToTexture
        └─ DisplayPhoto
```

## Common Issues

- **Permission Denied**: Guide user to Settings to enable camera access
- **Camera Unavailable**: Check if device has a camera (some tablets don't)
- **Texture is Null**: Ensure ConvertToTexture completes before accessing texture
- **Memory Issues**: Large photos can use significant memory; consider resizing

## Platform Differences

**iOS:**
- Requires "Privacy - Camera Usage Description" in Info.plist
- Permission prompt shown automatically on first use

**Android:**
- Requires CAMERA permission in AndroidManifest.xml
- Permission request may show before camera opens

## Performance Tips

- **Texture Size**: Captured photos can be large (4K+); resize if only displaying thumbnails
- **Memory Management**: Dispose of textures when no longer needed
- **Preview vs Final**: Consider showing preview before converting to final texture
