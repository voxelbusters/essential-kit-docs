# Add/Update/Remove Shortcut Policy

## Goal
Update shortcuts based on your app state (progression, entitlement, season, user preferences).

## Actions Used
- `AppShortcutsAddShortcut`
- `AppShortcutsRemoveShortcut`
- `AppShortcutsGetAddShortcutError` (optional)
- `AppShortcutsGetRemoveShortcutError` (optional)

## Variables
- `shortcutIdsToKeep` (String list/array you maintain)
- `shortcutIdToRemove` (String)

## FSM Steps
1. **Decide your set**: build `shortcutIdsToKeep` in your own logic (there is no “get current shortcuts list” action/API exposed here).
2. **Add or update**: call `AppShortcutsAddShortcut` for each ID you want available right now.
3. **Remove outdated**: when you know an ID should be removed (e.g., expired event), call `AppShortcutsRemoveShortcut(shortcutIdToRemove)`.

## Failure Handling
- Add failure → `AppShortcutsGetAddShortcutError`
- Remove failure → `AppShortcutsGetRemoveShortcutError`

## Notes
- Adding with the same `shortcutId` updates/replaces the existing shortcut.
- Apply policy changes during safe moments (main menu, after a level, etc.).
