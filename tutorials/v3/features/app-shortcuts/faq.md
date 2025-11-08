# FAQ & Troubleshooting

### Do I need to configure platform-specific settings manually?
No. Essential Kit automatically handles platform integration during the build process. You only need to enable App Shortcuts in Essential Kit Settings and add your icon textures to the Icons list.

### My shortcut icons don't appear on the device—what should I check?
Confirm the filename you pass to `SetIconFileName()` exactly matches a texture in the **Icons** list in App Shortcuts settings (including file extension like `.png`). If the name doesn't match, the shortcut appears without an icon.

### How many shortcuts can I add?
iOS supports a maximum of 4 shortcuts. Android varies by device launcher but typically supports 4-5 shortcuts. Additional shortcuts beyond the platform limit won't display.

### The shortcut click event doesn't fire when launching the app—what's wrong?
Ensure you register the `OnShortcutClicked` event in `OnEnable()` before the app finishes initializing. Essential Kit caches shortcut clicks during launch and fires the event once you register the listener. If you register too late or forget to register, the event won't fire.

### Can I update a shortcut's title or icon without removing it first?
No. To update a shortcut, call `AppShortcuts.Remove(shortcutId)` first, then call `AppShortcuts.Add()` with the new configuration. This ensures the platform displays the updated information.

### My shortcuts disappear after app update—is this expected?
Shortcuts should persist across app updates on both platforms. If they disappear, verify you haven't changed the shortcut identifiers in your code. Changing the ID creates a new shortcut instead of updating the existing one.

### Where can I confirm plugin behavior versus my implementation?
Run `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/AppShortcutsDemo.unity`. If the sample works but your scene does not, compare the configuration, event registration, and icon setup to narrow down the difference.

### Can I localize shortcut titles and subtitles?
Yes. Pass localized strings when creating shortcuts with `AppShortcutItem.Builder`. Essential Kit doesn't handle localization automatically, so use Unity's localization system or your own string management to provide translated text based on the device language.

### What happens if I call Remove() on a shortcut that doesn't exist?
Nothing. The operation is safe and produces no error or warning. This allows you to defensively remove shortcuts without checking if they exist first.
