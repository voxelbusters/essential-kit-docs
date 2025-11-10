---
description: "Common Utilities questions and troubleshooting tips"
---

# FAQ & Troubleshooting

### OpenAppStorePage does nothing in my development build. What should I check?
Verify that the Utilities feature is enabled in **Essential Kit Settings** and that you configured the correct App Store ID (iOS) or package name (Android). In sandbox builds the store client can open but show an error if the app is not yet published; test with the live identifier once it is available.

### The store shows “Item not available in your region.” How do I fix this?
This message appears if the player’s store region differs from the region where your app is published. Confirm that the `RuntimePlatformConstant` values (or default IDs in settings) point to the correct listing and remind testers to switch their store region to match the availability of the app.

### OpenApplicationSettings doesn’t restore permissions after the user returns. What should I do?
Always re-check permissions in `OnApplicationFocus(true)` or `OnApplicationPause(false)` after calling `Utilities.OpenApplicationSettings()`. If the status is still denied, show guidance that explains how to toggle the switch and offer an in-app support link for stubborn cases.

### Can I open the store listing for a companion app?
Yes. Pass platform-specific identifiers to `Utilities.OpenAppStorePage(RuntimePlatformConstant.iOS("1234567890"), RuntimePlatformConstant.Android("com.company.companion"))`. Utilities routes the request to the appropriate store client without extra platform code.

### Will OpenApplicationSettings work if Screen Time restrictions are enabled?
iOS and Android may block access to settings when parental controls or enterprise restrictions are active. Detect the failure by checking the permission state after returning to the app; if it is still denied, inform the player that a device-level restriction is preventing changes and suggest contacting a guardian or administrator.
