# Server Health Monitoring (Host Reachability)

## Goal
Monitor the configured host reachability and switch to a fallback when it becomes unreachable.

## Prerequisite
Set the host address in Essential Kit settings (Network Services section).

## Actions used
- `NetworkServicesStartNotifier`
- `NetworkServicesOnHostReachabilityChanged` (persistent listener)
- `NetworkServicesGetStatus` (optional)

## Variables
- `isHostReachable` (Bool)

## Flow
1. On app launch: call `NetworkServicesStartNotifier`.
2. Keep `NetworkServicesOnHostReachabilityChanged` in an active state:
   - `eventReachable` → use primary host
   - `eventUnreachable` → show maintenance / switch to backup
3. Optional: call `NetworkServicesGetStatus` whenever you need the latest booleans (`isHostReachable`, `isInternetActive`).
