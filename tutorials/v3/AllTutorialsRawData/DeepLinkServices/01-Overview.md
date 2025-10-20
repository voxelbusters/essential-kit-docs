# Deep Link Services Overview

## High-Level Architecture

Deep Link Services in Essential Kit provides a unified interface for handling incoming links across Unity iOS and Unity Android platforms. The system automatically detects and routes different link types to appropriate handlers.

📌 **Video Note**: Show architecture diagram with link flow

```
External Link → Platform Detection → Essential Kit → Unity Game
    ↓                    ↓                ↓            ↓
URL Scheme         iOS/Android      DeepLinkServices  Game Logic
Universal Link      Native Layer         Events      Navigation
```

## Concepts Covered in This Tutorial

This tutorial covers these core concepts:

1. **URL Scheme Handling** - Custom protocol schemes like `mygame://`
2. **Universal Links** - HTTP/HTTPS links that open your Unity app
3. **Parameter Parsing** - Extracting data from incoming links for game navigation

## Cross-Platform Considerations

Essential Kit abstracts platform differences for Unity cross-platform development:

- **iOS**: Handles URL schemes and Associated Domains automatically
- **Android**: Manages Intent filters and App Links verification
- **Unity Editor**: Provides simulator support for testing during development

## Unity Mobile Games SDK Integration

Deep Link Services integrates seamlessly with Unity's build pipeline for iOS and Android. The Essential Kit Unity plugin handles native configuration, making it ideal for Unity mobile games requiring social sharing or marketing campaign support.

This eliminates manual Info.plist editing on iOS and AndroidManifest.xml modifications on Android.

Next: [URL Scheme Handling](02-URLSchemeHandling.md)