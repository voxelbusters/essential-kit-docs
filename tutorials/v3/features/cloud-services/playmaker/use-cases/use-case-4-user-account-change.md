# Cloud User Account Change Handling

## Goal
React when the cloud user account status changes (signed in/out, restricted, etc.).

## Actions Required
| Action | Purpose |
|--------|---------|
| CloudServicesOnUserChange | Listen for cloud user status changes (persistent) |
| CloudServicesSynchronize | Sync after user becomes available (optional) |

## Variables Needed
- (optional) lastKnownState (String/Enum in your FSM)

## Implementation Steps

### 1. State: RegisterUserListener (Persistent)
**Action:** CloudServicesOnUserChange
- **Events:**
  - availableEvent → CloudAvailable
  - noAccountEvent → CloudUnavailable
  - restrictedEvent → CloudUnavailable
  - couldNotDetermineEvent → CloudUnavailable

### 2. State: CloudAvailable
Enable cloud save UI and optionally call `CloudServicesSynchronize` to refresh snapshot/values.

### 3. State: CloudUnavailable
Disable cloud save UI and fall back to local-only storage.

## Notes
- On iOS this commonly maps to iCloud account availability.
- Keep this listener active if your app needs to respond during runtime.

