# Usage

Once you set up the details in [Essential Kit Settings](setup.md#properties), you need to import the namespace for starting the network status detection.

```csharp
using VoxelBusters.CoreLibrary;
using VoxelBusters.EssentialKit;
```

For detecting the network status you need to start the notifier. Once there is a change in network status, events are fired to capture the status. You need to register for the events first to get the network status.

```csharp
private void OnEnable()
{
    // register for events
    NetworkServices.OnHostReachabilityChange        += OnHostReachabilityChange;
    NetworkServices.OnInternetConnectivityChange    += OnInternetConnectivityChange;
}

private void OnDisable()
{
    // unregister from events
    NetworkServices.OnHostReachabilityChange        -= OnHostReachabilityChange;
    NetworkServices.OnInternetConnectivityChange    -= OnInternetConnectivityChange;
}
```

```csharp
private void OnInternetConnectivityChange(NetworkServicesInternetConnectivityStatusChangeResult result)
{
    Debug.Log("Received internet connectivity changed event.");
    Debug.Log("Internet connectivity status: " + result.IsConnected);
}

private void OnHostReachabilityChange(NetworkServicesHostReachabilityStatusChangeResult result)
{
    Debug.Log("Received host reachability changed event.");
    Debug.Log("Host reachability status: " + result.IsReachable);
}
```

{% hint style="success" %}
As you can see, you can either listen to general internet connectivity or to a specific host. You need to set the host in the **Host address** section of [settings properties](setup.md#properties).
{% endhint %}

### Start detecting the status

Start the network notifier to enable detection of network connectivity and receive the events.

```csharp
NetworkServices.StartNotifier();
```

### Stop detecting the status

Once you are done with your requirement on detecting network connectivity, you can stop the notifier by calling StopNotifier.

```csharp
NetworkServices.StopNotifier();
```

### Checking status any time

Once after you called StartNotifier, there are options to check the status of the network by some utility methods.

```
bool isInternetActive = NetworkServices.IsInternetActive;
```

```
bool isHostReachable = NetworkServices.IsHostReachable;
```

```
bool isNotifierActive    = NetworkServices.IsNotifierActive;
```

{% hint style="success" %}
It's always good to stop the network notifier if you aren't using the status. This helps to save some network data and device battery for users as the plugin don't need to pool the servers.
{% endhint %}
