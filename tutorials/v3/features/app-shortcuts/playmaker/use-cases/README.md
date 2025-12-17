# AppShortcuts Use Cases

Quick-start guides for home screen shortcuts and quick actions using PlayMaker custom actions.

## Available Use Cases

### 1. [Register And Route](use-case-1-register-and-route.md)

- **What it does:** Register shortcuts and route when user clicks one
- **Actions:** 2 (`AppShortcutsAddShortcut`, `AppShortcutsOnShortcutClicked`)

### 2. [Add/Update/Remove Policy](use-case-2-add-update-remove-policy.md)

- **What it does:** Add/update/remove shortcuts based on app state
- **Actions:** 2 (`AppShortcutsAddShortcut`, `AppShortcutsRemoveShortcut`)

### 3. [Custom Icons](use-case-3-custom-icons.md)

- **What it does:** Use `iconFileName` correctly (via AppShortcuts settings Icons list)
- **Actions:** 1 (`AppShortcutsAddShortcut`)

## Quick Action Reference
| Action | Purpose |
|--------|---------|
| AppShortcutsAddShortcut | Create or update home screen shortcut |
| AppShortcutsGetAddShortcutError | Read cached error after add failure |
| AppShortcutsRemoveShortcut | Remove specific shortcut by ID |
| AppShortcutsGetRemoveShortcutError | Read cached error after remove failure |
| AppShortcutsOnShortcutClicked | Listen for shortcut click events |

## Platform Support
- **iOS**: 3D Touch/Haptic Touch shortcuts (iOS 9+)
- **Android**: Long-press app icon shortcuts (API 25+)
- **Limit**: Platform limits apply (commonly 4 shortcuts)

## Related Documentation
- **[README.md](../README.md)**
