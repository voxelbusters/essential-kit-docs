---
description: "Common questions and troubleshooting for Rate My App"
---

# FAQ & Troubleshooting

### Do I need to configure app store IDs manually in build settings?
No. Essential Kit automatically injects the required configurations during build. You only need to set app store IDs in Essential Kit Settings under the General tab. iOS uses the numeric App Store ID, Android uses the package name.

### Why doesn't the native rating dialog appear on iOS TestFlight builds?
TestFlight builds never show the actual native review dialog by design from Apple. Only development builds (run from Xcode) and production App Store builds show the real dialog. During TestFlight testing, the confirmation dialog will appear but the native prompt won't.

### How many times can I show the rating prompt on iOS?
iOS allows a maximum of 3 native review prompts per year per user in production. Development builds have no limit. This is why confirmation dialogs are recommended - they let you confirm user intent without consuming limited quota.

### Why isn't my rating prompt showing even though constraints are met?
Check these common issues:
- **Feature disabled**: Verify Rate My App is enabled in Essential Kit Settings
- **Auto Show off**: If Auto Show is disabled, you must call `AskForReviewNow()` manually
- **Quota exhausted**: iOS users may have hit the 3x/year limit
- **Wrong timing**: Ensure you're checking `IsAllowedToRate()` at the right moment
- **TestFlight build**: TestFlight builds don't show native dialogs

### Can I test the actual native dialog during development?
Yes, but only on development builds run from Xcode (iOS) or Android Studio. TestFlight and app store builds follow platform quotas. Use the Unity Editor simulator for initial testing, then validate on development device builds.

### How do I reset the rating state for testing?
In Unity Editor:
1. Stop play mode
2. Open Essential Kit Settings
3. Find Rate My App section
4. Click **Reset Simulator** button

On device:
1. Uninstall the app completely
2. Reinstall to get fresh state

### What happens when users click "Remind Later"?
The confirmation dialog closes and repeat constraints begin tracking. Based on your repeat constraint settings (min hours, min launches), the prompt will appear again when conditions are met.

### Can I show the rating prompt multiple times for the same version?
Yes, if the user declines and repeat constraints are met. However, once a user successfully rates or explicitly declines (not "Remind Later"), the prompt won't show again for that version unless you enable **Allow Re-rating in New Version**.

### The confirmation dialog shows but native dialog doesn't appear afterward. Why?
This is normal behavior:
- **iOS**: Platform quota may be exhausted (3x/year limit)
- **Android**: Limited quota reached
- **TestFlight**: Native dialogs never show on TestFlight
- **User previously rated**: Platform remembers and won't prompt again

### How do I track which users have rated my app?
Subscribe to `RateMyApp.OnConfirmationPromptAction` event and track when users select the "Rate App" option. Note that clicking "Rate App" doesn't guarantee they completed the review - some users may close the native dialog without rating.

### Where can I confirm the feature works as expected?
Run the demo scene at `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/RateMyAppDemo.unity`. If the demo works but your integration doesn't, compare your settings and code against the demo implementation.
