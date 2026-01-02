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
- If using age compliance, confirm **Uses Age Compliance Api** is enabled and `RequestInfoForAgeCompliance` returns data or `NotDeclared` gracefully

### Android Testing
- Install on Android device and test `OpenAppStorePage()`
- Verify Google Play Store app launches and shows correct app page
- Test `OpenApplicationSettings()` and confirm Settings app opens to app info
- Verify package name is correct (bundle identifier format)
- If using age compliance, confirm **Uses Age Compliance Api** is enabled and `RequestInfoForAgeCompliance` returns data or `NotDeclared` gracefully

### Cross-Platform Tests
- Test platform-specific IDs using `RuntimePlatformConstant` for cross-promotion
- Verify store navigation works from different app states (foreground, background)
- Test settings navigation after permission denial scenarios
- Confirm correct store app launches (App Store on iOS, Play Store on Android)
- Call `RequestInfoForAgeCompliance` and verify callback handling for success, `NotDeclared`, and error cases

{% hint style="warning" %}
App store pages only work for published apps. During development, the store will show "app not found" until your app is live.
{% endhint %}

## Age Compliance Testing

- Enable **Uses Age Compliance Api** and rebuild before testing on devices
- Call `RequestInfoForAgeCompliance` with different `RequestInfoForAgeComplianceOptions` to ensure your content gates cover all segments
- Verify `UserAgeRangeDeclarationMethod == NotDeclared` triggers your fallback age gate and that `UserAgeRange` is ignored
- When testing with a low content gate (for example, `13-17`), confirm `LowerBound` can be `-1` for underage users
- Confirm adult responses may report `UpperBound` as `-1` to indicate no upper limit
- Handle errors by logging and providing a safe default experience

## Pre-Submission Review
- Test complete flow: permission denial → explanation dialog → settings navigation → permission grant
- Verify app store links open the correct app listing
- Ensure explanation messages are clear before redirecting to settings
- Test that users can return to app after visiting store or settings
- Verify companion app links work correctly for cross-promotion
- Ensure age compliance flows have a manual gate fallback when `NotDeclared` is returned

## Common Test Scenarios

| Scenario | Expected Behavior |
| --- | --- |
| Call `OpenAppStorePage()` | App Store/Play Store launches showing app page |
| Invalid app ID | Store shows "not found" or error |
| Call `OpenApplicationSettings()` | Settings app opens to app's settings/info page |
| User returns from store | App resumes correctly |
| User returns from settings | App detects new permission state |
| Call `RequestInfoForAgeCompliance()` | Callback invoked with `InfoForAgeCompliance` or `NotDeclared` when no declared age is available |
| `LowerBound`/`UpperBound` is `-1` | Indicates out-of-range age (younger than provided gates) or adult with no upper bound |

{% hint style="info" %}
If navigation doesn't work, verify app store IDs are correctly configured in Essential Kit Settings under General > Application Settings.
{% endhint %}
