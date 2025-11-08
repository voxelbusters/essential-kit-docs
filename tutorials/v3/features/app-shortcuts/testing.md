# Testing & Validation

Use these checks to confirm your App Shortcuts integration before release.

## Testing Environment
- App Shortcuts do not have an editor simulator. Build to a physical iOS or Android device to validate add, remove, and click flows.
- Use the AppShortcutsDemo scene UI during device builds to trigger shortcut actions quickly while testing.

## Device Testing Checklist
- Install on both iOS and Android devices to verify shortcuts appear when long-pressing the app icon.
- Test adding multiple shortcuts (2-4) and verify they display with correct titles, subtitles, and icons.
- Tap each shortcut after registering your listener and confirm `OnShortcutClicked` fires with the correct identifier.
- Force-quit the app, tap a shortcut from the home screen, and verify the app launches and handles the click event.
- Test removing shortcuts dynamically and confirm they disappear from the app icon menu.
- Validate icon display: ensure filenames in `SetIconFileName()` match textures in App Shortcuts settings.

## Platform-Specific Testing

### iOS Testing
- Long-press the app icon to reveal Quick Actions (requires iOS 9+ and 3D Touch or long-press support).
- Test on devices without 3D Touch to verify long-press gesture works.
- Confirm a maximum of 4 shortcuts display; additional shortcuts won't appear.

### Android Testing
- Long-press the app icon to reveal shortcuts (requires Android 7.1+ / API level 25).
- Test on different launchers (stock Android, Samsung One UI, etc.) to verify display consistency.
- Confirm shortcuts persist after device restart.

## Pre-Submission Review
- Uninstall and reinstall the app to verify shortcuts are properly cleared on fresh install.
- Test the shortcut flow from cold launch (app not running) to ensure event caching works correctly.
- Capture screenshots of the shortcut menu for app store submission materials.
- If testers report missing icons or incorrect shortcuts, verify the **Icons** list in Essential Kit Settings includes all referenced textures.
