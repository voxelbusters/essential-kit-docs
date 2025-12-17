# Custom Shortcut Icons (Settings + AddShortcut)

## Goal
Use custom shortcut icons reliably (primarily Android) when calling `AppShortcutsAddShortcut`.

## Actions Used
- `AppShortcutsAddShortcut`
- `AppShortcutsGetAddShortcutError` (optional)

## Setup (Essential Kit Settings)
1. Open: **Window → Essential Kit → Settings → App Shortcuts**
2. Add your shortcut icon textures to the **Icons** list.

## FSM Steps
1. Call `AppShortcutsAddShortcut`.
2. Set `iconFileName` to the icon file name you want to use (must include extension, e.g., `play.png`).

## Failure Handling
- If `AppShortcutsAddShortcut` fails, call `AppShortcutsGetAddShortcutError` to read `errorCode` + `errorDescription`.

## Notes
- `iconFileName` must refer to a texture present in the AppShortcuts settings **Icons** list; otherwise the icon won’t show up.
