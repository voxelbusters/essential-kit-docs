# Internet Connectivity

## What is Internet Connectivity?

Internet connectivity monitoring allows your Unity mobile game to detect whether the device has general internet access. This is essential for determining if your game can perform online operations like multiplayer matchmaking, cloud saves, or downloading content.

Use internet connectivity monitoring in Unity mobile games to:
- Show/hide online features based on connectivity status
- Display connection status indicators in your UI
- Decide whether to attempt network operations
- Provide offline gameplay alternatives

## Checking Current Internet Status

The `NetworkServices.IsInternetActive` property provides instant access to the current connectivity state:

```csharp
if (NetworkServices.IsInternetActive)
{
    Debug.Log("Internet is available - can perform online operations");
}
else
{
    Debug.Log("No internet connection - switching to offline mode");
}
```

This snippet checks the current connectivity status and logs the result. Use this property to make real-time decisions about network-dependent features.

## Responding to Connectivity Changes

Subscribe to connectivity change events to respond when the network status changes:

```csharp
void OnEnable()
{
    NetworkServices.OnInternetConnectivityChange += OnInternetChanged;
}

void OnInternetChanged(NetworkServicesInternetConnectivityStatusChangeResult result)
{
    if (result.IsConnected)
    {
        Debug.Log("Internet connection restored - enabling online features");
    }
    else
    {
        Debug.Log("Internet connection lost - switching to offline mode");
    }
}
```

This code demonstrates event subscription and handling. The callback receives a result object containing the new connectivity status, allowing you to respond immediately to network changes.

## Practical Usage Example

Here's how to implement a simple connection manager for your Unity game:

```csharp
public class ConnectionManager : MonoBehaviour
{
    void Start()
    {
        NetworkServices.OnInternetConnectivityChange += HandleConnectivityChange;
        UpdateUIBasedOnConnection();
    }

    void HandleConnectivityChange(NetworkServicesInternetConnectivityStatusChangeResult result)
    {
        UpdateUIBasedOnConnection();
        Debug.Log($"Connection status changed: {result.IsConnected}");
    }

    void UpdateUIBasedOnConnection()
    {
        bool isOnline = NetworkServices.IsInternetActive;
        // Update your game UI based on connection status
        Debug.Log($"Updating UI - Online: {isOnline}");
    }
}
```

This example shows a complete connectivity management system that updates the UI whenever the network status changes.

📌 **Video Note**: Show Unity demo clip of connectivity status changing in real-time, with UI elements updating to reflect online/offline status.