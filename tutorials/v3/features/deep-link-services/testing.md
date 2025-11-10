# Testing

Deep links behave differently depending on the platform, so run through each scenario below before shipping.

## Quick Checklist
- ✅ Deep Link Services enabled in Essential Kit Settings
- ✅ `OnCustomSchemeUrlOpen` and/or `OnUniversalLinkOpen` handlers registered before gameplay starts
- ✅ Device has a build that matches the deep link configuration
- ✅ Link you are testing uses the same scheme/host/path defined in settings

## Mobile Device Testing

### iOS (Devices and Simulator)
1. Build and install your app on the target device or simulator.
2. Open Safari and visit a simple HTML page that contains your link:

   ```html
   <a href="mygame://invite/friend123">Join my match</a>
   ```

3. Tap the link. If the app is installed, iOS should foreground your game and fire the relevant deep link event.
4. On simulator you can also trigger links from the command line:

   ```bash
   xcrun simctl openurl booted "mygame://invite/friend123"
   ```

5. For universal links, make sure your `apple-app-site-association` file is reachable over HTTPS before testing.

### Android (Devices and Emulator)
1. Build and install your app on the device or emulator.
2. Use Chrome or any browser to open a test page with your link or type the URL directly into the address bar.
3. Android should display a chooser the first time; pick your app and select **Always** to skip future prompts.
4. You can also launch from `adb`:

   ```bash
   adb shell am start -W -a android.intent.action.VIEW -d "mygame://invite/friend123"
   ```

5. For Android App Links (https), verify that your `assetlinks.json` file is accessible. Use `adb shell am` with the https URL to confirm the association.

{% hint style="info" %}
Need a ready-made scene? Run `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/DeepLinkServicesDemo.unity` and watch the console logs as you tap links.
{% endhint %}

## Debugging Tips
- If no event fires, confirm `DeepLinkServices.IsAvailable()` returns `true` and the feature is enabled in build settings.
- Mismatched schemes, hosts, or paths are the most common cause of silent failures—double-check spelling and casing.
- Universal links cache the first valid association per install. Uninstall the app before testing changes to the hosted files.
