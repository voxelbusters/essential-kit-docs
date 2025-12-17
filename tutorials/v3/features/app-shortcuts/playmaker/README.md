# App Shortcuts - PlayMaker

Create and manage home screen shortcuts, and listen for shortcut click events.

## Actions (5)
- `AppShortcutsAddShortcut` (sync): add/update a shortcut (`shortcutId`, `title`, optional `subtitle`, `iconFileName`). Fires `successEvent` / `failureEvent`.
- `AppShortcutsGetAddShortcutError` (sync): read cached `errorCode` / `errorDescription` after `AppShortcutsAddShortcut` failure.
- `AppShortcutsRemoveShortcut` (sync): remove a shortcut by `shortcutId`. Fires `successEvent` / `failureEvent`.
- `AppShortcutsGetRemoveShortcutError` (sync): read cached `errorCode` / `errorDescription` after `AppShortcutsRemoveShortcut` failure.
- `AppShortcutsOnShortcutClicked` (listener): stays active and fires `clickedEvent` with the clicked `shortcutId`.

## Quick flows

### Register shortcuts (startup)
Call `AppShortcutsAddShortcut` once per shortcut you want available.

### Route when clicked
Keep a state active with `AppShortcutsOnShortcutClicked`, then route based on `shortcutId` in your next state (String Compare / Switch).

### Remove a shortcut
Call `AppShortcutsRemoveShortcut(shortcutId)`; on failure, call `AppShortcutsGetRemoveShortcutError`.

## Use cases
Start here: `use-cases/README.md`

## Platform notes
- iOS / Android: shortcuts appear on long-press of the app icon (platform limits apply; commonly ~4 dynamic shortcuts).
- If you use `iconFileName`, it must match an icon configured in Essential Kit Settings → App Shortcuts.

