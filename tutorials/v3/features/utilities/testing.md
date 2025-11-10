---
description: "Testing and validating Utilities integration"
---

# Testing & Validation

Use these checks to confirm your Utilities integration before release.

## Editor Simulation
- Unity Editor provides basic simulation for Utilities functions
- `OpenAppStorePage()` logs the URL that would be opened
- `OpenApplicationSettings()` logs the settings navigation attempt
- No actual browser or settings app launches in Editor

## Device Testing Checklist

### iOS Testing
- Install on iOS device and test `OpenAppStorePage()`
- Verify App Store app launches and shows correct app page
- Test `OpenApplicationSettings()` and confirm Settings app opens to app's page
- Verify app IDs are correct (numeric format for iOS)

### Android Testing
- Install on Android device and test `OpenAppStorePage()`
- Verify Google Play Store app launches and shows correct app page
- Test `OpenApplicationSettings()` and confirm Settings app opens to app info
- Verify package name is correct (bundle identifier format)

### Cross-Platform Tests
- Test platform-specific IDs using `RuntimePlatformConstant` for cross-promotion
- Verify store navigation works from different app states (foreground, background)
- Test settings navigation after permission denial scenarios
- Confirm correct store app launches (App Store on iOS, Play Store on Android)

{% hint style="warning" %}
App store pages only work for published apps. During development, the store will show "app not found" until your app is live.
{% endhint %}

## Pre-Submission Review
- Test complete flow: permission denial → explanation dialog → settings navigation → permission grant
- Verify app store links open the correct app listing
- Ensure explanation messages are clear before redirecting to settings
- Test that users can return to app after visiting store or settings
- Verify companion app links work correctly for cross-promotion

## Common Test Scenarios

| Scenario | Expected Behavior |
| --- | --- |
| Call `OpenAppStorePage()` | App Store/Play Store launches showing app page |
| Invalid app ID | Store shows "not found" or error |
| Call `OpenApplicationSettings()` | Settings app opens to app's settings/info page |
| User returns from store | App resumes correctly |
| User returns from settings | App detects new permission state |

{% hint style="info" %}
If navigation doesn't work, verify app store IDs are correctly configured in Essential Kit Settings under General > Application Settings.
{% endhint %}
