---
description: "Common Network Services issues and solutions"
---

# FAQ & Troubleshooting

### Why are network status events not triggered?
Ensure you've called `NetworkServices.StartNotifier()` to begin monitoring. Check these common issues:
1. **Monitoring Not Started**: Call `StartNotifier()` in `Start()` or enable "Auto Start Notifier" in settings
2. **Events Not Registered**: Subscribe to events in `OnEnable()` before calling `StartNotifier()`
3. **Already Stopped**: Verify `IsNotifierActive` returns `true` - monitoring may have been stopped elsewhere

```csharp
void Start()
{
    if (!NetworkServices.IsNotifierActive)
    {
        NetworkServices.StartNotifier();
        Debug.Log("Network monitoring started");
    }
}
```

### Why does network status change before I call StartNotifier?
This happens if "Auto Start Notifier" is enabled in Essential Kit Settings. The plugin automatically begins monitoring on app launch. To use manual control:
1. Open Essential Kit Settings (Services tab)
2. Find Network Services configuration
3. Disable "Auto Start Notifier"
4. Call `StartNotifier()` manually when needed

### How do I monitor a specific server or backend?
Configure the host address in Essential Kit Settings:
1. Open Essential Kit Settings → Services → Network Services
2. Set **Host Address** (IPv4 or IPv6) to your server URL or IP
3. Subscribe to `OnHostReachabilityChange` event
4. Call `StartNotifier()`

```csharp
void OnHostReachabilityChange(NetworkServicesHostReachabilityStatusChangeResult result)
{
    if (result.IsReachable)
    {
        Debug.Log("Backend server is online");
    }
    else
    {
        Debug.Log("Backend server is offline or unreachable");
    }
}
```

### Can I change the host address at runtime?
Yes, use manual initialization to set a dynamic host address:

```csharp
void ConfigureForRegion(string serverURL)
{
    var settings = new NetworkServicesUnitySettings(
        isEnabled: true,
        hostAddress: new Address { IPv4 = serverURL },
        autoStartNotifier: false);

    NetworkServices.Initialize(settings);
    NetworkServices.StartNotifier();
}
```

This is useful for region-specific servers or environment switching (dev/staging/production).

### Events fire too frequently during network transitions. How do I handle this?
Implement debouncing to ignore rapid status changes during network handoffs (WiFi to cellular):

```csharp
private float lastStatusChangeTime;
private const float debounceDelay = 2f;

void OnInternetConnectivityChange(NetworkServicesInternetConnectivityStatusChangeResult result)
{
    if (Time.time - lastStatusChangeTime < debounceDelay)
    {
        return; // Ignore rapid changes
    }

    lastStatusChangeTime = Time.time;
    Debug.Log(result.IsConnected ? "Connection restored." : "Connection lost.");
}
```

### How do I stop events from firing when the app is backgrounded?
Stop monitoring when the app goes to background to save battery:

```csharp
void OnApplicationPause(bool isPaused)
{
    if (isPaused)
    {
        NetworkServices.StopNotifier();
    }
    else
    {
        NetworkServices.StartNotifier();
    }
}
```

### Does Network Services work in Unity Editor?
Yes, it uses your development machine's actual network connection. Test by:
- Toggling WiFi/ethernet on your computer
- Changing firewall settings
- Using network simulation tools (Charles Proxy, Fiddler)

However, **always test on physical devices** before release to verify mobile-specific scenarios (cellular handoff, weak signal, etc.).

### What's the difference between IsInternetActive and IsHostReachable?
- **IsInternetActive**: General internet connectivity (WiFi, cellular, any network)
- **IsHostReachable**: Specific server/host configured in settings is reachable

Use cases:
- **IsInternetActive**: "No internet" error messages, disable all online features
- **IsHostReachable**: "Server maintenance" messages, disable server-dependent features only

Example:
```csharp
if (!NetworkServices.IsInternetActive)
{
    Debug.Log("Show dialog: No internet connection");
}
else if (!NetworkServices.IsHostReachable)
{
    Debug.Log("Show dialog: Server temporarily unavailable");
}
```

### How much battery does continuous monitoring consume?
Continuous monitoring has minimal battery impact (< 1% over several hours) due to efficient platform APIs. However:
- **Best Practice**: Stop monitoring when not needed (menu screens, single-player modes)
- **Polling Interval**: Adjust "Time Gap Between Polling" in settings (default 5 seconds)
- **Auto-Start**: Disable if you don't need monitoring from app launch

### Can I test offline functionality in Unity Editor?
Yes, disconnect your development machine's network to simulate offline scenarios. For more realistic testing:
- Use **Device Simulator** package to test different network conditions
- Test on physical devices with airplane mode, WiFi toggle, weak signal areas
- Use network conditioning tools (Xcode Network Link Conditioner, Android emulator throttling)

### How do I handle queued actions when connectivity returns?
Implement an action queue system:

```csharp
private Queue<Action> pendingNetworkActions = new Queue<Action>();

public void QueueNetworkAction(Action action)
{
    if (NetworkServices.IsInternetActive)
    {
        action.Invoke();
    }
    else
    {
        pendingNetworkActions.Enqueue(action);
        Debug.Log($"Queued action - {pendingNetworkActions.Count} pending");
    }
}

void OnInternetConnectivityChange(NetworkServicesInternetConnectivityStatusChangeResult result)
{
    if (result.IsConnected)
    {
        while (pendingNetworkActions.Count > 0)
        {
            pendingNetworkActions.Dequeue().Invoke();
        }
    }
}
```

### Where can I confirm plugin behavior versus my implementation?
Run `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/NetworkServicesDemo.unity`. If the sample works but your implementation doesn't:
- Compare event registration timing (before vs after StartNotifier)
- Verify settings configuration (auto-start, host address)
- Check if monitoring is being stopped unexpectedly elsewhere
- Confirm event handlers aren't being unsubscribed prematurely

### Can I monitor multiple hosts simultaneously?
No, Essential Kit supports monitoring one configured host at a time. For multiple servers:
1. **Primary Host in Settings**: Configure your main backend server
2. **Manual Polling**: Implement custom ping logic for secondary servers
3. **Rotate Monitoring**: Change host address dynamically using `Initialize()` with new settings

Alternatively, monitor general internet connectivity and handle specific server checks in your backend communication layer.

### Is host reachability the same as a ping test?
Host reachability uses platform-specific APIs (iOS Reachability, Android ConnectivityManager) which are more efficient than traditional ping. However:
- Not as detailed as ICMP ping
- Checks TCP connectivity to specified port (default 80)
- Faster and more battery-efficient than continuous pinging
- May report reachable if host resolves but service is down

For true service health, combine with application-level health checks (HTTP endpoint status).
