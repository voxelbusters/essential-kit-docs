# Reset Cloud Data (Remove Keys)

## Goal
Let the user delete cloud keys (for example from a Settings “Reset cloud save” button).

## Actions Required
| Action | Purpose |
|--------|---------|
| CloudServicesRemoveKey | Remove a specific key |
| CloudServicesRemoveAllKeys | Remove all keys (use with caution) |
| CloudServicesSynchronize | Push deletion to cloud (recommended) |

## Implementation Steps

### Option A: Remove specific keys
1. Call `CloudServicesRemoveKey` for each key you want to delete.
2. Call `CloudServicesSynchronize` and wait for `successEvent`.

### Option B: Remove everything
1. Call `CloudServicesRemoveAllKeys`.
2. Call `CloudServicesSynchronize` and wait for `successEvent`.

## Notes
- Provide a confirmation UI before using RemoveAllKeys.
- After reset, your app should fall back to local defaults until new values are saved.

