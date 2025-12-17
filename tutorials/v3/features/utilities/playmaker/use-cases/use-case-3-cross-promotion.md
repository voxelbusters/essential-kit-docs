# Cross-Promote Another App

## Goal
Open the app store page for a different app (e.g., to promote another game in your portfolio).

## Actions Required
| Action | Purpose |
|--------|---------|
| UtilitiesOpenAppStorePageById | Opens app store with platform-specific app IDs |

## Variables Needed
- iosAppStoreId (String): iOS numeric App Store ID (e.g., "1234567890")
- androidPackageId (String): Android bundle ID (e.g., "com.publisher.anotherapp")

## Implementation Steps

### 1. State: SetTargetIds
Set the platform-specific IDs for the app you want to promote:
- **iOS**: `iosAppStoreId` = numeric App Store ID (e.g., "1234567890")
- **Android**: `androidPackageId` = package name (e.g., "com.publisher.anotherapp")

### 2. State: OpenTargetApp
**Action:** UtilitiesOpenAppStorePageById
- **Inputs:**
  - iosAppStoreId → iosAppStoreId (optional, iOS only)
  - androidPackageName → androidPackageName (optional, Android only)

**Note:** The app will suspend and the App Store will open for the target app.

## Common Issues

- **Wrong app opens**: Verify app ID is correct for the platform
- **App not found**: Ensure the target app is published on the current platform
- **Action fails in Editor**: App Store links only work on device

## Flow Diagram
```
SetTargetIds
    ├─ iosAppStoreId = "1234567890"
    └─ androidPackageId = "com.publisher.anotherapp"

OpenTargetApp
    └─ App Store opens for target app
```

## Best Practices
- Show a preview/description of the promoted app before opening
- Use compelling call-to-action: "Try our NEW game!"
- Track conversions using analytics before opening store
- Consider showing promotions after natural breaks (level end, menu screen)

## Example Configuration

### For iOS:
```
targetAppId = "123456789"  // Numeric App Store ID
```

### For Android:
```
targetAppId = "com.yourpublisher.anothergame"  // Package name
```

### Platform-Aware Setup:
Use PlayMaker's platform detection or FsmString with different values per build.

## Notes
- You can set only the ID for the platform you ship on, or set both to support cross-platform builds.
