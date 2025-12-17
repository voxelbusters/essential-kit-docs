# Register And Route Shortcut Clicks

## Goal
Register a few app shortcuts and route the user when they click a shortcut.

## Actions Used
- `AppShortcutsAddShortcut`
- `AppShortcutsOnShortcutClicked`
- `AppShortcutsGetAddShortcutError` (optional)

## Variables
- `shortcutId` (String) - output from `AppShortcutsOnShortcutClicked`

## FSM Steps
1. **Bootstrap/RegisterShortcuts**: call `AppShortcutsAddShortcut` once per shortcut you want (repeat the action in the state, or use multiple states).
2. **ShortcutListener (keep active)**: add `AppShortcutsOnShortcutClicked` and transition to your router state on `clickedEvent`.
3. **Route**: compare `shortcutId` and jump to the matching FSM state/scene (fallback to main menu for unknown IDs).

## Failure Handling
- If `AppShortcutsAddShortcut` fires `failureEvent`, call `AppShortcutsGetAddShortcutError` to read `errorCode` + `errorDescription`.

## Notes
- Keep the listener state active in your app’s bootstrap scene so you can catch clicks that launch the app.
- If you set `iconFileName` in `AppShortcutsAddShortcut`, it must match an icon configured in Essential Kit settings (see Use Case 3).
