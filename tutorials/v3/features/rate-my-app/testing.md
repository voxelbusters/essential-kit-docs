---
description: "Testing and validating Rate My App integration"
---

# Testing & Validation

Use these checks to confirm your Rate My App integration before release.

## Editor Simulation
- When you run in the Unity Editor, the Rate My App simulator is active automatically
- Simulator shows confirmation dialogs and simulates native review dialogs
- To clear test data and reset constraints, click **Reset Simulator** in Essential Kit Settings
- Remember: simulator responses mimic native behavior but are not a substitute for on-device testing

{% hint style="info" %}
The simulator lets you test constraint logic and confirmation dialogs without consuming platform quota during development.
{% endhint %}

## Device Testing Checklist

### iOS Testing
- Install on iOS device from Xcode or TestFlight
- **Important**: TestFlight builds never show actual native review dialogs - only development builds do
- Development builds have unlimited prompts (no 3x/year quota during development)
- Test confirmation dialog appears with configured text and buttons
- Verify constraints (launches, hours, events) trigger prompts correctly

### Android Testing
- Install development build on Android device
- Verify native In-App Review dialog displays correctly
- Test confirmation dialog functionality and button actions
- Confirm constraints work as configured in settings

### Cross-Platform Tests
- Reset app data and reinstall to test first-run experience
- Trigger significant events and verify counter increments
- Test "Remind Later" functionality if enabled
- Verify version-based re-rating works after updating app version
- Check that quota isn't consumed when confirmation dialog is cancelled

{% hint style="warning" %}
On iOS production builds, you only get 3 native prompts per year per user. Test thoroughly in development before releasing to avoid wasting quota.
{% endhint %}

## Pre-Submission Review
- Test complete flow: install → meet constraints → confirmation dialog → native dialog
- Verify confirmation dialog text is clear and non-manipulative (App Store requirement)
- Ensure rating prompts appear at positive moments (level win, achievement, not during gameplay)
- Capture screenshots of confirmation and native dialogs for compliance documentation
- Test edge cases: app backgrounding during dialog, rapid constraint changes, version updates

## Common Test Scenarios

| Scenario | Expected Behavior |
| --- | --- |
| First launch | No prompt (constraints not met) |
| After meeting constraints | Confirmation dialog shows (if enabled) |
| User clicks "Rate Now" | Native dialog appears |
| User clicks "Remind Later" | Prompt reappears based on repeat constraints |
| User declines rating | No prompt until repeat constraints met |
| App version changes | Re-rating prompt shows (if enabled in settings) |

{% hint style="success" %}
If testers report unexpected behavior, reproduce the issue using the demo scene at `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/RateMyAppDemo.unity` to determine whether the issue originates from your implementation or the plugin.
{% endhint %}
