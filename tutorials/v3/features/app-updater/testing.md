# Testing

Keep the scenarios below in mind while validating App Updater. The flow depends heavily on the distribution channel because the feature talks to the real app stores.

## Quick Checklist
- ✅ App Updater enabled in Essential Kit Settings and identifiers configured
- ✅ Build version on device is lower than the version you expect the store to report
- ✅ `RequestUpdateInfo` is called before `PromptUpdate`
- ✅ Network connection available (Wi-Fi or cellular)

## iOS

Apple only returns update information for apps that are already live on the App Store.

1. Publish a build (version `X`) to the App Store. Install it on the test device from the store.
2. In Unity, increase the build number and version to `X + 1`, build the project, and install it locally.
3. Run the new build, call `RequestUpdateInfo`, and confirm that the status is `NotAvailable` (because the installed version already matches the store).
4. Downgrade the local build to `X - 1`, install that build on the device, and run `RequestUpdateInfo` again. You should see `Available`, then `PromptUpdate` will redirect to the App Store.

No live build yet? Temporarily point the “App Store ID” setting to another app that *is* published so you can exercise the flow, but remember to revert the ID immediately after testing.

## Android

Google restricts in-app updates to packages distributed through the Play Store. The easiest way to test is **Internal App Sharing** or an **Internal Testing track**.

1. Upload APK/AAB version `X` to Internal App Sharing.
2. Upload version `X + 1` to the same channel.
3. Install version `X` using the generated tester link.
4. Launch the app, call `RequestUpdateInfo`, and expect `Available`.
5. Call `PromptUpdate` to try both flows:
   - **Flexible flow**: decline the final install step to verify the `Downloaded` status.
   - **Immediate flow**: accept the update to check that your app handles the restart.
6. Watch device logs (`adb logcat`) for progress values and ensure your UI reacts correctly.

{% hint style="info" %}
The demo scene at `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/AppUpdaterDemo.unity` already wires up both buttons. Use it to verify the flow before integrating into your game UI.
{% endhint %}

## Troubleshooting
- `Unknown` status usually indicates the store APIs could not identify your package. Double-check bundle identifier, package name, and that the app is uploaded to the same channel you are testing against.
- A `NetworkIssue` error means the device could not reach the store; retry with a reliable connection.
- If the callback reports `progress == 0` after prompting, the user dismissed the update. Decide whether to re-prompt or continue gameplay.
