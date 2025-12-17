# Offline Mode Handling

## Goal
Detect internet connectivity changes and switch between online/offline flows.

## Actions used
- `NetworkServicesStartNotifier`
- `NetworkServicesGetStatus` (optional initial poll)
- `NetworkServicesOnInternetConnectivityChanged` (persistent listener)

## Variables
- `isInternetActive` (Bool)

## Flow
1. On app launch: call `NetworkServicesStartNotifier`.
2. Optional: call `NetworkServicesGetStatus` and branch using `isInternetActive` to initialize UI.
3. Keep `NetworkServicesOnInternetConnectivityChanged` in an active state:
   - `eventConnected` → resume online features / sync queued actions
   - `eventDisconnected` → pause online features / show offline UI

## Notes
- Listener actions should stay active; they fire events when connectivity changes.
