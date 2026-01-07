---
description: "Configuring Network Services for connectivity monitoring"
---

# Setup

## Prerequisites
- Essential Kit imported into the project from My Assets section of Package Manager
- No special permissions required (network state monitoring is available to all apps)
- Optional: Backend server address for host reachability monitoring

## Setup Checklist
1. Open **Essential Kit Settings** (`Window > Voxel Busters > Essential Kit > Open Settings`), switch to the **Services** tab, and enable **Network Services**
2. Configure optional settings: host address, auto-start behavior, ping configuration
3. Essential Kit automatically adds `ACCESS_NETWORK_STATE` permission on Android during build
4. Changes to the settings asset are saved automatically. If you use source control, commit the updated `Resources/EssentialKitSettings.asset` file

### Configuration Reference
| Setting | Platform | Required? | Notes |
| --- | --- | --- | --- |
| Enable Network Services | All | Yes | Toggles the feature in builds; disabling strips related native code |
| Host Address (IPv4/IPv6) | All | Optional | Server address to monitor for reachability; leave empty if only monitoring general internet |
| Auto Start Notifier | All | Optional | If enabled, monitoring begins automatically on app launch; disable for manual control |
| Max Retry Count | All | Optional | Number of retry attempts before reporting failure (default: 3) |
| Time Gap Between Polling | All | Optional | Seconds between network checks when monitoring is active (default: 2) |
| Time Out Period | All | Optional | Seconds before considering a network request timed out (default: 60) |
| Port | All | Optional | Port to ping on remote server for reachability checks (default: 53) |

{% hint style="success" %}
**Auto Start Notifier**: Enable this to automatically monitor network status from app launch. Disable if you want manual control (call `StartNotifier()` only when needed to save battery).
{% endhint %}

{% hint style="info" %}
**Host Reachability Monitoring**: If you configure a host address, Network Services monitors both general internet connectivity AND specific server reachability. This is useful for detecting when your backend is down even if the user has internet access.
{% endhint %}

### Platform-Specific Notes

#### iOS
- Uses iOS Reachability API via `SystemConfiguration.framework`
- No permissions required
- Essential Kit automatically configures framework links during build

#### Android
- Uses `ConnectivityManager` and network callback APIs
- `ACCESS_NETWORK_STATE` permission automatically added during build
- Works on all Android versions with automatic API level adaptation

{% hint style="warning" %}
**Battery Considerations**: Continuous network monitoring consumes battery. Use `StartNotifier()` and `StopNotifier()` to control when monitoring is active. Stop monitoring when network status isn't actively needed (e.g., on menu screens without online features).
{% endhint %}

{% hint style="info" %}
Need a working baseline? Run the sample at `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/NetworkServicesDemo.unity` to confirm your settings before wiring the feature into production screens.
{% endhint %}
