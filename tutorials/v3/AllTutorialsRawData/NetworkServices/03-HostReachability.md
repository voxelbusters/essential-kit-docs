# Host Reachability

## What is Host Reachability?

Host reachability monitoring allows your Unity mobile game to check if specific servers or hosts are accessible, even when general internet connectivity exists. This is more precise than internet connectivity checking and helps determine if your game's specific services are reachable.

Use host reachability in Unity mobile games when:
- Your game depends on specific game servers
- You need to verify API endpoints are accessible
- Implementing server failover systems
- Checking if your authentication servers are responsive

## Checking Current Host Reachability Status

The `NetworkServices.IsHostReachable` property provides the current reachability status for configured hosts:

```csharp
if (NetworkServices.IsHostReachable)
{
    Debug.Log("Game server is reachable - can connect to multiplayer");
}
else
{
    Debug.Log("Game server unreachable - showing offline message");
}
```

This snippet checks if the target host is currently reachable and logs the result. Use this to determine if server-dependent features should be available.

## Responding to Host Reachability Changes

Subscribe to host reachability events to respond when specific server accessibility changes:

```csharp
void OnEnable()
{
    NetworkServices.OnHostReachabilityChange += OnHostReachabilityChanged;
}

void OnHostReachabilityChanged(NetworkServicesHostReachabilityStatusChangeResult result)
{
    if (result.IsReachable)
    {
        Debug.Log("Host is now reachable - enabling server features");
    }
    else
    {
        Debug.Log("Host became unreachable - disabling server features");
    }
}
```

This code shows how to handle host reachability changes. The callback provides detailed information about the host's accessibility status.

## Practical Server Monitoring Example

Here's how to implement server-specific monitoring for your Unity game:

```csharp
public class ServerManager : MonoBehaviour
{
    void Start()
    {
        NetworkServices.OnHostReachabilityChange += HandleHostReachability;
        CheckServerStatus();
    }

    void HandleHostReachability(NetworkServicesHostReachabilityStatusChangeResult result)
    {
        Debug.Log($"Server reachability changed: {result.IsReachable}");
        UpdateServerDependentFeatures(result.IsReachable);
    }

    void UpdateServerDependentFeatures(bool serverReachable)
    {
        if (serverReachable)
        {
            Debug.Log("Enabling multiplayer and leaderboards");
        }
        else
        {
            Debug.Log("Disabling server features - showing offline mode");
        }
    }
}
```

This example demonstrates a complete server monitoring system that enables or disables features based on server reachability status.

📌 **Video Note**: Show Unity demo clip of host reachability status changing, demonstrating how server-dependent features respond to connectivity changes.