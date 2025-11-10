---
description: "Configuring Media Services for camera and gallery access"
---

# Setup

## Prerequisites
- Essential Kit imported into the project from My Assets section of Package Manager
- iOS builds require camera and photo library usage descriptions
- Android automatically uses Photo Picker on Android 13+ (no permissions needed for selection)

## Setup Checklist
1. Open **Essential Kit Settings** (`Window > Voxel Busters > Essential Kit > Open Settings`), switch to the **Services** tab, and enable **Media Services**
2. Configure which media operations your app will use (camera capture, gallery access, saving to albums)
3. Essential Kit automatically adds required platform permissions during build based on your configuration
4. Changes to the settings asset are saved automatically. If you use source control, commit the updated `Resources/EssentialKitSettings.asset` file

### Configuration Reference
| Setting | Platform | Required? | Notes |
| --- | --- | --- | --- |
| Enable Media Services | All | Yes | Toggles the feature in builds; disabling strips related native code |
| Uses Camera for Image Capture | All | Optional | Enable if capturing photos with camera; adds camera permission |
| Uses Camera for Video Capture | All | Optional | Enable if capturing videos; adds camera and microphone permissions |
| Saves Files to Photo Gallery | All | Optional | Enable if saving images/videos to gallery; adds write permission |
| Saves Files to Custom Directories | iOS | Optional | Enable if creating custom albums; requires additional iOS permissions |

{% hint style="success" %}
Only enable the features you actually use. Essential Kit automatically injects the appropriate permissions (`CAMERA`, `READ_EXTERNAL_STORAGE`, `WRITE_EXTERNAL_STORAGE` on Android; `NSCameraUsageDescription`, `NSPhotoLibraryUsageDescription` on iOS) based on enabled settings.
{% endhint %}

{% hint style="info" %}
**Modern Platform Behavior**: Essential Kit uses platform-recommended APIs automatically:
- **Android 13+**: Photo Picker (no permissions required for selection)
- **iOS 14+**: PHPicker for image selection (limited photo library access)
- **Older versions**: Falls back to traditional permission-based gallery access
{% endhint %}

### Platform-Specific Notes

#### iOS Usage Descriptions
iOS requires usage descriptions that explain why your app needs access. Add these in your app's localization files or Essential Kit will use default messages:
- **Camera**: "We need camera access to let you capture photos for your profile"
- **Photo Library**: "We need photo library access to let you select images"

#### Android Permissions
- **Photo Picker** (Android 13+): No permissions needed for image selection
- **Traditional Gallery**: `READ_EXTERNAL_STORAGE` automatically added for older Android versions
- **Camera**: `CAMERA` permission automatically added when camera features are enabled
- **Saving**: `WRITE_EXTERNAL_STORAGE` automatically added when saving is enabled

{% hint style="warning" %}
**Custom Albums/Directories on iOS**: Enabling "Saves Files to Custom Directories" requires additional permissions. If you don't need custom albums, pass `null` for `directoryName` in `MediaContentSaveOptions` and disable this setting to avoid unnecessary permission prompts.
{% endhint %}

{% hint style="info" %}
Need a working baseline? Run the sample at `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/MediaServicesDemo.unity` to confirm your settings before wiring the feature into production screens.
{% endhint %}
