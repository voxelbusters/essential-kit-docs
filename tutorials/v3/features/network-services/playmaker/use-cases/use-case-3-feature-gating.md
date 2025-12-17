# Network-Based Feature Gating

## Goal
Enable/disable features based on current internet connectivity.

## Actions used
- `NetworkServicesGetStatus`
- `NetworkServicesOnInternetConnectivityChanged` (persistent listener)

## Variables
- `isInternetActive` (Bool)

## Flow
1. On entering a screen: call `NetworkServicesGetStatus` and gate features using `isInternetActive`.
2. Keep `NetworkServicesOnInternetConnectivityChanged` active to update UI dynamically:
   - `eventConnected` → enable online-only buttons
   - `eventDisconnected` → disable them and show an offline indicator
