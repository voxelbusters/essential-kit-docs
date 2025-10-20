# Network Notifier

## What is the Network Notifier?

The Network Notifier is the background monitoring system that tracks network changes and triggers connectivity events. It continuously monitors both internet connectivity and host reachability, notifying your Unity mobile game when network conditions change.

Use the Network Notifier in Unity mobile games when:
- You need real-time network status updates
- Implementing responsive online/offline UI changes
- Building network-aware game features
- Managing server connection retries

## Starting the Network Notifier

Use `StartNotifier()` to begin monitoring network changes:

```csharp
void Start()
{
    NetworkServices.StartNotifier();
    Debug.Log("Network monitoring started - will receive connectivity events");
}
```

This code starts the network monitoring system. Once started, you'll begin receiving connectivity change events through the registered callbacks.

## Stopping the Network Notifier

Use `StopNotifier()` to stop network monitoring when no longer needed:

```csharp
void OnDestroy()
{
    NetworkServices.StopNotifier();
    Debug.Log("Network monitoring stopped - no more connectivity events");
}
```

This snippet stops the network monitoring system, which conserves device resources when network monitoring isn't needed.

## Checking Notifier Status

The `IsNotifierActive` property tells you if the notifier is currently running:

```csharp
if (NetworkServices.IsNotifierActive)
{
    Debug.Log("Network notifier is active - monitoring network changes");
}
else
{
    Debug.Log("Network notifier is stopped - not monitoring changes");
}
```

This code checks the current notifier state. Use this to avoid starting multiple notifier instances or to display monitoring status in debug UI.

## Complete Notifier Management Example

Here's how to properly manage the network notifier lifecycle in your Unity game:

```csharp
public class NetworkNotifierManager : MonoBehaviour
{
    void Start()
    {
        if (!NetworkServices.IsNotifierActive)
        {
            NetworkServices.StartNotifier();
            Debug.Log("Started network notifier for connectivity monitoring");
        }
    }

    void OnApplicationPause(bool pauseStatus)
    {
        if (pauseStatus)
        {
            NetworkServices.StopNotifier();
            Debug.Log("Paused - stopped network monitoring");
        }
        else
        {
            NetworkServices.StartNotifier();
            Debug.Log("Resumed - restarted network monitoring");
        }
    }
}
```

This example shows proper notifier lifecycle management, including handling app pause/resume states common in Unity mobile games development.

📌 **Video Note**: Show Unity demo demonstrating notifier start/stop actions and how they affect event callbacks in real-time.