---
description: "Validating Media Services integration before release"
---

# Testing & Validation

Use these checks to confirm your Media Services integration before release.

## Editor Simulation
- When you run in the Unity Editor, the Media Services simulator is active automatically
- The simulator provides test images and videos for gallery selection and camera capture
- To reset simulator data (clear test selections), restart the Unity Editor or play mode
- Remember: simulator responses mimic native behavior but are not a substitute for on-device testing

{% hint style="info" %}
The simulator uses sample images included with Essential Kit. Test your UI layout with various image sizes and aspect ratios to ensure proper display handling.
{% endhint %}

## Device Testing Checklist
### Permission Prompts
- [ ] Install on both iOS and Android devices to verify permission dialogs display correct usage descriptions
- [ ] Test first-run experience: permission prompt appears on first camera/gallery operation
- [ ] Verify permission denial handling: app guides users to settings with `Utilities.OpenApplicationSettings()`
- [ ] Test permission revocation: remove permissions in device settings, then relaunch app

### Gallery Selection
- [ ] Select single image works correctly and displays in your UI
- [ ] Multiple selection returns correct number of images
- [ ] User cancellation (close picker without selecting) is handled gracefully
- [ ] Large images (8MB+) load without crashing or excessive memory usage
- [ ] Video selection saves file correctly for playback

### Camera Capture
- [ ] Photo capture opens native camera and returns captured image
- [ ] Video capture records and saves video file correctly
- [ ] User cancellation (close camera without capturing) is handled
- [ ] Captured media displays immediately in your UI

### Saving to Gallery
- [ ] Screenshots save successfully to device gallery
- [ ] Custom album creation works on iOS (if enabled in settings)
- [ ] Verify saved images appear in native Photos app
- [ ] Test save failures: check error handling for permission denial

## Performance Validation
- [ ] Loading large images (4000x3000px) from gallery doesn't freeze the UI
- [ ] Multiple sequential operations (select, save, select) work smoothly
- [ ] Memory usage returns to normal after disposing textures
- [ ] Background threads handle conversion (`AsTexture2D`, `AsFilePath`) without blocking gameplay

## Platform-Specific Checks

### iOS Testing
- [ ] Photo Picker (iOS 14+) appears instead of traditional gallery on supported devices
- [ ] Usage descriptions appear in permission dialogs (check Info.plist in Xcode)
- [ ] Custom albums create successfully (if "Saves Files to Custom Directories" is enabled)
- [ ] Limited photo library access works (iOS 14+ partial permission)

### Android Testing
- [ ] Photo Picker appears on Android 13+ devices automatically
- [ ] Traditional gallery picker works on Android 12 and below
- [ ] Camera permission dialog shows on first camera operation
- [ ] Saved images appear in device gallery immediately

## Pre-Submission Review
- [ ] Reset app permissions in device settings and reinstall to confirm first-run experience
- [ ] Capture screenshots or screen recordings of permission flows for compliance documentation
- [ ] Test with devices at minimum supported OS version (iOS 12, Android 5.0)
- [ ] Verify media operations work correctly after app backgrounding and returning
- [ ] Test with poor network conditions (for server uploads of selected media)

## Common Test Scenarios

### Avatar Selection Flow
```
1. User taps "Change Avatar"
2. Gallery picker appears (permission prompt if first time)
3. User selects photo
4. Image loads and displays as avatar
5. Avatar persists after app restart
```

### Screenshot Sharing Flow
```
1. User captures game moment
2. App saves screenshot to gallery
3. Success message appears
4. User opens Photos app and sees screenshot in "MyGame Screenshots" album
```

### Photo Mode Capture Flow
```
1. User enters photo mode
2. Taps capture button
3. Native camera opens (permission prompt if first time)
4. User takes photo
5. Photo appears in game immediately
6. Photo can be shared or saved
```

## Troubleshooting Test Failures
If testers report issues, reproduce using the demo scene first:
1. Open `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/MediaServicesDemo.unity`
2. Test the exact operation that's failing in your game
3. If demo works but your implementation doesn't, compare:
   - Options configuration (MIME types, constraints)
   - Error handling paths
   - Permission status checking
   - Callback execution timing

{% hint style="success" %}
Ready to release? Make sure you've tested on physical devices running both old and new OS versions. Simulators cannot fully test camera and gallery access.
{% endhint %}

## Related Guides
- [Setup Guide](setup.md) - Verify configuration before testing
- [Usage Guide](usage.md) - Review implementation patterns
- [FAQ](faq.md) - Solutions for common test failures
