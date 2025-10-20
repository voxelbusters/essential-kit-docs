# Media Services Tutorial - Access Status Checking

## What is Access Status Checking?

Access status checking allows you to determine whether your Unity mobile game has permission to access the device's gallery or camera before attempting media operations. This is crucial for providing smooth user experiences in Unity iOS and Unity Android applications, as it allows you to handle permission states gracefully.

## Why Use Access Status Checking in Unity Mobile Games?

Checking access status helps you:
- Provide appropriate user messaging before requesting permissions
- Avoid failed operations due to missing permissions  
- Create better user flows around media functionality
- Comply with platform permission guidelines

## Gallery Access Status

Use `GetGalleryAccessStatus()` to check gallery permissions:

```csharp
using VoxelBusters.EssentialKit;

// Check gallery access status for read/write operations
var galleryStatus = MediaServices.GetGalleryAccessStatus(GalleryAccessMode.ReadWrite);
Debug.Log($"Gallery access status: {galleryStatus}");
```

This method returns a `GalleryAccessStatus` enum with the following values:
- `NotDetermined` - User hasn't been asked for permission yet
- `Restricted` - App is not authorized (parental controls, etc.)
- `Denied` - User explicitly denied access
- `Authorized` - App has permission to access gallery

## Camera Access Status  

Use `GetCameraAccessStatus()` to check camera permissions:

```csharp
using VoxelBusters.EssentialKit;

// Check camera access status
var cameraStatus = MediaServices.GetCameraAccessStatus();
Debug.Log($"Camera access status: {cameraStatus}");
```

This method returns a `CameraAccessStatus` enum with the following values:
- `NotDetermined` - User hasn't been asked for permission yet
- `Restricted` - App is not authorized (parental controls, etc.)
- `Denied` - User explicitly denied access  
- `Authorized` - App has permission to access camera

## Practical Usage Example

Here's how you might use access status checking in a Unity cross-platform game:

```csharp
using VoxelBusters.EssentialKit;

public void CheckMediaPermissions()
{
    var galleryStatus = MediaServices.GetGalleryAccessStatus(GalleryAccessMode.ReadWrite);
    var cameraStatus = MediaServices.GetCameraAccessStatus();
    
    Debug.Log($"Gallery: {galleryStatus}, Camera: {cameraStatus}");
    
    // Enable/disable UI buttons based on permissions
    EnableGalleryButton(galleryStatus == GalleryAccessStatus.Authorized);
    EnableCameraButton(cameraStatus == CameraAccessStatus.Authorized);
}
```

This snippet checks both gallery and camera permissions, then updates UI elements accordingly.

📌 **Video Note**: Show Unity demo clip demonstrating permission status checking with different permission states, including UI updates based on the returned status values.