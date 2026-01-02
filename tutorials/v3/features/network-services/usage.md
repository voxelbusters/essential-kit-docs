---
description: "Network Services monitors internet connectivity and server reachability on mobile devices"
---

# Usage

Essential Kit wraps native iOS and Android network monitoring APIs into a single Unity interface. Network Services provides real-time connectivity detection with automatic change notifications.

## Table of Contents

- [Import Namespaces](#import-namespaces)
- [Understanding Network Monitoring](#understanding-network-monitoring)
- [Event Registration](#event-registration)
- [Starting Network Monitoring](#starting-network-monitoring)
- [Checking Current Status](#checking-current-status)
- [Stopping Network Monitoring](#stopping-network-monitoring)
- [Practical Implementation Patterns](#practical-implementation-patterns)
- [Data Properties](#data-properties)
- [Core APIs Reference](#core-apis-reference)
- [Error Handling](#error-handling)
- [Advanced: Manual Initialization](#advanced-manual-initialization)

## Import Namespaces
```csharp
using VoxelBusters.EssentialKit;
using VoxelBusters.CoreLibrary;
```

## Understanding Network Monitoring

### Two Monitoring Types
Network Services provides two independent monitoring capabilities:

**Internet Connectivity**: Monitors general internet access via WiFi, cellular, or other connections. Use this to detect when the device is completely offline.

**Host Reachability**: Monitors connectivity to a specific server or service. Use this to detect when your backend is unreachable even if general internet is available.

### Monitoring Lifecycle
Network monitoring must be explicitly started and can be stopped to conserve battery:
- **StartNotifier()**: Begin monitoring and receiving change events
- **StopNotifier()**: Stop monitoring to save battery
- **Auto Start**: Optionally enable in settings to start monitoring automatically on app launch

## Event Registration

Register for connectivity events in `OnEnable` and unregister in `OnDisable`:

```csharp
void OnEnable()
{
    NetworkServices.OnInternetConnectivityChange += OnInternetConnectivityChange;
    NetworkServices.OnHostReachabilityChange += OnHostReachabilityChange;
}

void OnDisable()
{
    NetworkServices.OnInternetConnectivityChange -= OnInternetConnectivityChange;
    NetworkServices.OnHostReachabilityChange -= OnHostReachabilityChange;
}
```

| Event | Trigger |
| --- | --- |
| `OnInternetConnectivityChange` | Fired when general internet connectivity status changes (online/offline) |
| `OnHostReachabilityChange` | Fired when configured host server reachability changes (reachable/unreachable) |

## Starting Network Monitoring

### Why Monitoring is Needed
Detect connectivity changes in real-time to provide immediate feedback to players about network status. This allows you to:
- Block online features when offline
- Queue actions for when connectivity returns
- Show appropriate UI (offline indicators, retry buttons)
- Prevent frustrating network error dialogs

### Basic Monitoring
```csharp
void Start()
{
    // Start monitoring network status
    NetworkServices.StartNotifier();
    Debug.Log("Network monitoring started");
}

void OnInternetConnectivityChange(NetworkServicesInternetConnectivityStatusChangeResult result)
{
    if (result.IsConnected)
    {
        Debug.Log("Internet connected");
        Debug.Log("Enable online-only features.");
        Debug.Log("Show connected indicator.");
    }
    else
    {
        Debug.Log("Internet disconnected");
        Debug.Log("Disable online-only features.");
        Debug.Log("Show offline indicator.");
    }
}

void OnHostReachabilityChange(NetworkServicesHostReachabilityStatusChangeResult result)
{
    if (result.IsReachable)
    {
        Debug.Log("Backend server reachable");
        Debug.Log("Unlock server-powered features.");
    }
    else
    {
        Debug.Log("Backend server unreachable");
        Debug.Log("Inform players about server maintenance.");
    }
}
```

## Checking Current Status

Once monitoring is started, check the current network status anytime without waiting for events:

```csharp
void CheckNetworkStatus()
{
    bool hasInternet = NetworkServices.IsInternetActive;
    bool serverReachable = NetworkServices.IsHostReachable;
    bool monitoringActive = NetworkServices.IsNotifierActive;

    Debug.Log($"Internet: {hasInternet}, Server: {serverReachable}, Monitoring: {monitoringActive}");

    if (!hasInternet)
    {
        Debug.Log("Show offline dialog to the player.");
    }
    else if (!serverReachable)
    {
        Debug.Log("Show server-down dialog to the player.");
    }
}
```

## Data Properties
| Item | Type | Notes |
| --- | --- | --- |
| `NetworkServicesInternetConnectivityStatusChangeResult.IsConnected` | `bool` | `true` when the device currently has a route to the internet (Wi-Fi, cellular, etc.). |
| `NetworkServicesHostReachabilityStatusChangeResult.IsReachable` | `bool` | Indicates whether the configured host responded to Essential Kit’s reachability probe. |
| `NetworkServices.IsInternetActive` | `bool` | Last known internet status; stays cached until you start the notifier or a new change event fires. |
| `NetworkServices.IsHostReachable` | `bool` | Live view of backend reachability. Returns `true` until a reachability check fails or host monitoring is disabled. |
| `NetworkServices.IsNotifierActive` | `bool` | Confirms whether monitoring is currently running, which is useful before registering UI states or retry queues. |

{% hint style="info" %}
Status properties are only refreshed while the notifier is active. Start monitoring before reading them to avoid stale defaults.
{% endhint %}

## Stopping Network Monitoring

Stop monitoring when network status isn't needed to conserve battery:

```csharp
void OnApplicationPause(bool isPaused)
{
    if (isPaused)
    {
        // App going to background - stop monitoring
        NetworkServices.StopNotifier();
        Debug.Log("Network monitoring stopped");
    }
    else
    {
        // App returning to foreground - resume monitoring
        NetworkServices.StartNotifier();
        Debug.Log("Network monitoring resumed");
    }
}
```

{% hint style="success" %}
**Battery Optimization**: Stop monitoring when not needed (menu screens, pause screens, background state). Restart when entering online-dependent gameplay or features.
{% endhint %}

## Practical Implementation Patterns

### Blocking Online Features When Offline
```csharp
void OnInternetConnectivityChange(NetworkServicesInternetConnectivityStatusChangeResult result)
{
    if (result.IsConnected)
    {
        // Enable online features
        multiplayerButton.interactable = true;
        leaderboardButton.interactable = true;
        eventButton.interactable = true;
        Debug.Log("Hide offline banner.");
    }
    else
    {
        // Disable online features
        multiplayerButton.interactable = false;
        leaderboardButton.interactable = false;
        eventButton.interactable = false;
        Debug.Log("Show offline banner: No internet connection.");
    }
}
```

### Queueing Actions for When Connectivity Returns
```csharp
private Queue<System.Action> pendingActions = new Queue<System.Action>();

void SavePlayerProgress()
{
    if (NetworkServices.IsInternetActive)
    {
        // Upload immediately
        Debug.Log("Upload progress to the server.");
    }
    else
    {
        // Queue for later
        pendingActions.Enqueue(() => Debug.Log("Deferred upload to server."));
        Debug.Log("Action queued - will execute when online");
    }
}

void OnInternetConnectivityChange(NetworkServicesInternetConnectivityStatusChangeResult result)
{
    if (result.IsConnected && pendingActions.Count > 0)
    {
        Debug.Log($"Connection restored - executing {pendingActions.Count} queued actions");
        while (pendingActions.Count > 0)
        {
            pendingActions.Dequeue().Invoke();
        }
    }
}
```

### Handling Server-Specific Failures
```csharp
void OnHostReachabilityChange(NetworkServicesHostReachabilityStatusChangeResult result)
{
    if (!result.IsReachable)
    {
        // Backend down but internet available
        if (NetworkServices.IsInternetActive)
        {
            Debug.Log("Show maintenance dialog: Our servers are temporarily unavailable. Please try again later.");
        }
        else
        {
            Debug.Log("Show offline dialog: No internet connection. Please check your network settings.");
        }
    }
    else
    {
        Debug.Log("Hide maintenance dialog and resume server operations.");
    }
}
```

### Smart Monitoring Control
```csharp
enum GameState
{
    MainMenu,
    Multiplayer,
    Leaderboards,
    LiveEvents,
    SinglePlayer,
}

void OnGameStateChanged(GameState newState)
{
    switch (newState)
    {
        case GameState.MainMenu:
            // Menu doesn't need constant monitoring
            NetworkServices.StopNotifier();
            break;

        case GameState.Multiplayer:
        case GameState.Leaderboards:
        case GameState.LiveEvents:
            // Online features need active monitoring
            NetworkServices.StartNotifier();
            break;

        case GameState.SinglePlayer:
            // Single player can stop monitoring
            NetworkServices.StopNotifier();
            break;
    }
}
```

## Core APIs Reference

| API | Purpose | Returns |
| --- | --- | --- |
| `NetworkServices.StartNotifier()` | Begin network connectivity monitoring | void - events fire on status changes |
| `NetworkServices.StopNotifier()` | Stop network monitoring to save battery | void |
| `NetworkServices.IsInternetActive` | Check current internet connectivity | `bool` |
| `NetworkServices.IsHostReachable` | Check current host server reachability | `bool` |
| `NetworkServices.IsNotifierActive` | Check if monitoring is currently running | `bool` |

## Error Handling

| Scenario | Trigger | Recommended Action |
| --- | --- | --- |
| No host reachability events | `OnHostReachabilityChange` never fires | Confirm a host address (and optional port) is set in Essential Kit Settings before starting the notifier. |
| Immediate disconnects after Start | Monitoring started but properties stay `true` | Ensure `StartNotifier()` is called before reading status properties and that you’re subscribed to events in `OnEnable`. |
| Rapid event flapping | Device switches quickly between Wi-Fi and cellular | Debounce repeated status changes before toggling UI or retry queues (see snippet below). |
| Long-running monitoring drains battery | Notifier left active on offline screens | Stop the notifier on menus or pause screens and restart only when online functionality is required. |

### Debounce Example
```csharp
private float lastStatusChangeTime;
private const float statusChangeDebounce = 2f;

void OnInternetConnectivityChange(NetworkServicesInternetConnectivityStatusChangeResult result)
{
    if (Time.time - lastStatusChangeTime < statusChangeDebounce)
    {
        Debug.Log("Ignoring rapid status change");
        return;
    }

    lastStatusChangeTime = Time.time;
    Debug.Log(result.IsConnected ? "Connection restored (debounced)." : "Connection lost (debounced).");
}
```

### Missing Host Configuration
```csharp
void OnHostReachabilityChange(NetworkServicesHostReachabilityStatusChangeResult result)
{
    if (result == null)
    {
        return;
    }

    Debug.Log($"Host reachable: {result.IsReachable}");
}
```

## Advanced: Manual Initialization

{% hint style="warning" %}
Manual initialization is only needed for specific runtime scenarios. For most games, Essential Kit's automatic initialization handles everything. **Skip this section unless** you need dynamic host configuration or runtime settings.
{% endhint %}

### Understanding Manual Initialization

**Default Behavior:**
Essential Kit automatically initializes Network Services using the settings asset configured in the Unity Editor.

**Advanced Usage:**
Override default settings at runtime when you need:
- Dynamic host address based on user region or environment
- Server-driven monitoring configuration
- A/B testing different polling intervals
- Feature flags for network monitoring

### Implementation

Override settings at runtime before starting monitoring:
```csharp
void Awake()
{
    var customSettings = new NetworkServicesUnitySettings(
        isEnabled: true,
        hostAddress: new Address(ipv4: "api.mygame.com", ipv6: string.Empty),
        autoStartNotifier: false,
        pingSettings: new NetworkServicesUnitySettings.PingTestSettings(
            maxRetryCount: 3,
            timeGapBetweenPolling: 5f,
            timeOutPeriod: 10f,
            port: 443));

    NetworkServices.Initialize(customSettings);
}
```

{% hint style="info" %}
Call `Initialize()` before calling `StartNotifier()`. Most games should use the [standard setup](setup.md) configured in Essential Kit Settings instead.
{% endhint %}

## Related Guides
- Demo scene: `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/NetworkServicesDemo.unity`
- Use with **Task Services** to ensure critical uploads complete before backgrounding
- Pair with offline-first data architecture for seamless connectivity transitions
- See [Testing Guide](testing.md) for network simulation and device validation
