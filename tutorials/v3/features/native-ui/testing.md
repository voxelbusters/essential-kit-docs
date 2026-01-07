---
description: "Testing and validating Native UI integration"
---

# Testing & Validation

Use these checks to confirm your Native UI integration before release.

## Editor Simulation
- When you run in the Unity Editor, Native UI uses Unity's built-in UI for simulation
- Dialogs and pickers appear as Unity canvases that mimic native behavior
- Editor simulation doesn't perfectly match platform appearance but validates logic
- Remember: simulator responses are not a substitute for on-device testing

{% hint style="info" %}
Editor simulation lets you test dialog flow, button callbacks, and date selection without building to devices. Use it for rapid iteration before device testing.
{% endhint %}

## Device Testing Checklist

### AlertDialog Testing
- Install on both iOS and Android devices to verify platform-specific styling
- Test basic dialogs appear with native animations and appearance
- Verify multi-button dialogs display correctly (iOS: vertical stacking, Android: horizontal when possible)
- Test text input fields show appropriate keyboards (email, password, default)
- Confirm callbacks fire correctly when buttons are pressed
- Test dialog dismissal on background tap (platform-dependent behavior)
- Verify action sheets appear correctly on iOS (bottom sheet style)

### DatePicker Testing
- Test date picker shows native platform picker (iOS: drum roller, Android: calendar view)
- Verify time picker displays correct format (12-hour vs 24-hour based on device locale)
- Test date and time picker combination mode works correctly
- Confirm minimum and maximum date constraints are enforced
- Verify initial date displays correctly when set
- Test date picker callbacks return correct DateTime values
- Confirm cancelled picker returns appropriate result code

### Cross-Platform Tests
- Compare dialog appearance on iOS vs Android to ensure both follow platform guidelines
- Test dialogs respect system theme (light/dark mode)
- Verify text input respects platform keyboard behavior
- Test date formats match user's locale settings
- Confirm dialogs block interaction with game until dismissed

{% hint style="warning" %}
Platform appearances differ significantly. iOS uses UIAlertController (centered alerts) while Android uses Material Design (edge-aligned dialogs). This is expected and correct.
{% endhint %}

## Pre-Submission Review
- Test complete flows: dialog → user input → callback → action
- Verify all dialog text is clear, concise, and properly localized
- Test edge cases: empty text input, date picker cancellation, rapid button tapping
- Confirm dialogs appear during different game states (menu, gameplay, pause)
- Test that dialogs properly pause/resume when app backgrounds
- Capture screenshots of key dialogs for app store compliance

## Common Test Scenarios

| Scenario | Expected Behavior |
| --- | --- |
| Show basic alert | Native dialog appears with title, message, buttons |
| Multi-button dialog | All buttons visible and functional |
| Text input with empty field | Empty string returned, validation in your code |
| Text input cancellation | Cancel callback fires, no input processed |
| Date picker cancellation | `SelectedDate` is null |
| Date picker selection | `SelectedDate` has the selected `DateTime` |
| Min/max date constraints | Picker prevents selection outside range |
| Action sheet (iOS) | Bottom sheet style on iOS, regular dialog on Android |

{% hint style="success" %}
If testers report dialog issues, reproduce using the demo scene at `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/NativeUIDemo.unity` to determine if the issue is in your implementation or the plugin.
{% endhint %}

## Platform-Specific Testing

### iOS Specific
- Test that action sheets appear from bottom on iOS
- Verify alert dialogs center on screen
- Test iOS keyboard types (email, number pad, URL) for text inputs
- Confirm date picker uses iOS drum roller style
- Test that dialogs respect safe area on notched devices

### Android Specific
- Test that dialogs follow Material Design guidelines
- Verify keyboard appears correctly for text inputs
- Test date picker shows calendar view
- Confirm time picker uses Android clock face or input
- Test behavior across different Android versions and manufacturers

## Accessibility Testing
- Test with VoiceOver (iOS) and TalkBack (Android) enabled
- Verify all buttons are announced correctly
- Test that input fields have proper labels
- Confirm date picker values are spoken when selected
- Verify keyboard navigation works in text input dialogs
