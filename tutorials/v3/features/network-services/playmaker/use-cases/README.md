# NetworkServices Use Cases

Quick-start guides for connectivity monitoring using PlayMaker custom actions.

## Available Use Cases

### 1. [Offline Mode Handling](use-case-1-offline-mode.md)
**What it does:** Start monitoring and react to internet connect/disconnect events
**Actions:** 2 (StartNotifier, OnInternetConnectivityChanged) + optional (GetStatus)

### 2. [Server Health Monitoring](use-case-2-server-health.md)
**What it does:** Monitor configured host reachability and switch to fallback
**Actions:** 2 (StartNotifier, OnHostReachabilityChanged) + optional (GetStatus)

### 3. [Feature Gating](use-case-3-feature-gating.md)
**What it does:** Enable/disable features based on connectivity
**Actions:** 2 (GetStatus, OnInternetConnectivityChanged)

## Quick Action Reference
| Action | Purpose |
|--------|---------|
| NetworkServicesGetStatus | Check current connectivity |
| NetworkServicesStartNotifier | Begin monitoring |
| NetworkServicesStopNotifier | Stop monitoring |
| NetworkServicesOnInternetConnectivityChanged | Listen for changes |
| NetworkServicesOnHostReachabilityChanged | Monitor specific host |

## Related Documentation
- Feature overview: `../README.md`
