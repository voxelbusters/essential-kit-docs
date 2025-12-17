# Network Services - PlayMaker

Monitor internet connectivity and a configured host reachability.

## Actions (5)
- `NetworkServicesStartNotifier`, `NetworkServicesStopNotifier`
- `NetworkServicesGetStatus` (poll current booleans)
- `NetworkServicesOnInternetConnectivityChanged` (persistent listener)
- `NetworkServicesOnHostReachabilityChanged` (persistent listener; host configured in Essential Kit settings)

## Key patterns
- Call `NetworkServicesStartNotifier` once (app startup).
- Keep listener actions active to receive change events.
- Use `NetworkServicesGetStatus` whenever you need the latest booleans for UI.

## Use cases
Start here: `use-cases/README.md`
