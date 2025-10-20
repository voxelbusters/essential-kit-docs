# Media Services Tutorial - Overview

## High-Level Architecture

Essential Kit's Media Services provides a unified, cross-platform API for accessing device cameras and media galleries. The architecture follows a clean separation of concerns:

```
Unity Game Layer
       ↓
MediaServices Static API
       ↓  
Cross-Platform Abstraction
       ↓
Platform-Specific Implementations
    ↙        ↘
iOS Native    Android Native
```

The `MediaServices` static class serves as your single entry point, automatically routing calls to the appropriate platform implementation while maintaining consistent behavior across Unity iOS and Unity Android builds.

## Concepts Covered in This Tutorial

This tutorial series covers the following core concepts:

1. **Access Status Checking** - Determining gallery and camera permission states
2. **Selecting Media Content** - Choosing images, videos, and files from device gallery  
3. **Capturing Media Content** - Taking photos and recording videos with device camera
4. **Saving Media Content** - Storing media files to device gallery
5. **Media Content Processing** - Converting media between different formats (Texture2D, raw data, file paths)

## Cross-Platform Considerations

Essential Kit's Media Services seamlessly handles platform differences:

- **Permission Systems**: iOS privacy permissions and Android runtime permissions are managed automatically
- **File System Access**: Different storage architectures are abstracted behind a unified API
- **Media Format Support**: Platform-specific codec and format variations are handled transparently  
- **UI Components**: Native gallery and camera interfaces are presented consistently

## Unity Cross-Platform Development Benefits

By using Essential Kit's Media Services, you gain:

- **Single Codebase**: Write once, deploy to both Unity iOS and Unity Android platforms
- **Native Performance**: Direct access to platform-optimized media handling systems
- **Automatic Updates**: Essential Kit handles OS version compatibility and API changes
- **Unity SDK Integration**: Seamless integration with Unity's rendering and asset pipeline

This Unity mobile games SDK integration approach eliminates the need for separate native development while maintaining full access to device capabilities.

📌 **Video Note**: Use visual overview diagram showing the flow from Unity game code through Essential Kit to native platform APIs, highlighting the cross-platform abstraction layer.