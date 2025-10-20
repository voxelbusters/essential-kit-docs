# Cloud Services Overview

Essential Kit's Cloud Services provide a unified interface for storing and syncing key-value data across devices using native cloud storage solutions.

## Architecture

```
Unity Game
    ↓
Essential Kit Cloud Services API
    ↓
Platform Abstraction Layer
    ↓         ↓
iOS iCloud   Android Google Cloud
```

## Cross-Platform Implementation

- **iOS**: Uses CloudKit Key-Value Storage (iCloud)
- **Android**: Uses Google Cloud Save (Google Play Games Services)
- **Unity Editor**: Simulator mode for development testing

Essential Kit handles platform differences automatically, providing you with a single, consistent API for Unity cross-platform development.

## Concepts Covered in This Tutorial

This tutorial series covers the following core concepts:

1. **Working with Cloud Data** - Storing and retrieving different data types
2. **Synchronization** - Manual sync between local and cloud data
3. **Complex Data Serialization** - Storing game objects using JSON
4. **Change Notifications** - Responding to data changes and conflict resolution
5. **Advanced Usage** - Professional patterns and error handling

## Key Features for Unity Mobile Games

- **Automatic Local Caching**: Data is cached locally for offline access
- **Conflict Resolution**: Built-in handling when local and cloud data differ
- **Real-time Updates**: Notifications when data changes on other devices
- **Cross-device Sync**: Player data follows them across all their devices
- **Unity SDK Integration**: Seamless integration with Unity mobile game development workflow

📌 Video Note: Use visual overview diagram showing data flow between devices through cloud services.

## Storage Limitations

- **iOS iCloud**: 1MB total storage, 1MB per key, maximum 1024 keys
- **Android Google Cloud**: Varies by implementation but generally generous limits
- **Key Length**: Maximum 64 bytes for key names

Essential Kit abstracts these platform differences while keeping you informed of the constraints for optimal Unity iOS and Unity Android performance.