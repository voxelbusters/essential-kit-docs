---
description: "Validating Network Services integration before release"
---

# Testing & Validation

Use these checks to confirm your Network Services integration before release.

## Editor Simulation
- Network Services works in Unity Editor with actual network connectivity
- Test by toggling WiFi or ethernet on your development machine
- Monitor console logs to verify events fire correctly
- Remember: editor uses your development machine's network, not simulated mobile scenarios

## Device Testing Checklist
### Basic Connectivity Monitoring
- [ ] Enable airplane mode and verify `OnInternetConnectivityChange` fires with `IsConnected = false`
- [ ] Disable airplane mode and verify event fires with `IsConnected = true`
- [ ] Switch between WiFi and cellular data - verify smooth transition without false disconnects
- [ ] Test weak signal scenarios (basement, elevator) - verify appropriate status detection

### Host Reachability Monitoring
- [ ] Configure host address in Essential Kit Settings before testing
- [ ] Verify `OnHostReachabilityChange` fires when server is reachable
- [ ] Test with invalid host address - verify unreachable status
- [ ] Disconnect internet while monitoring - verify both internet and host events fire
- [ ] Block specific server port (firewall test) - verify host unreachable while internet active

### Start/Stop Monitoring
- [ ] Call `StartNotifier()` - verify monitoring begins and status properties update
- [ ] Call `StopNotifier()` - verify events stop firing
- [ ] Toggle monitoring multiple times - verify no memory leaks or duplicate events
- [ ] Test auto-start (if enabled) - verify monitoring begins automatically on app launch

### Battery Impact
- [ ] Monitor battery drain with continuous monitoring over 30 minutes
- [ ] Compare battery usage when monitoring is stopped vs active
- [ ] Verify polling interval from settings is respected (check logs for timing)
- [ ] Test background monitoring - verify system manages monitoring appropriately

## Platform-Specific Checks

### iOS Testing
- [ ] Verify Reachability framework linked automatically (check Xcode project)
- [ ] Test on iOS 12+ devices (minimum supported version)
- [ ] Verify smooth handling of WiFi/cellular handoff
- [ ] Test with VPN active - verify connectivity detection works correctly

### Android Testing
- [ ] Verify `ACCESS_NETWORK_STATE` permission added automatically (check AndroidManifest.xml)
- [ ] Test on Android 5.0+ devices (minimum supported version)
- [ ] Test on Android 10+ with scoped storage
- [ ] Verify ConnectivityManager API level adaptation (older vs newer Android versions)

## Performance Validation
- [ ] Events fire within 1-5 seconds of actual network change
- [ ] No UI freezing or frame drops when connectivity changes
- [ ] Status properties return immediately (no blocking calls)
- [ ] Rapid network toggling (on/off/on) handled gracefully without crashes

## Common Test Scenarios

### Offline Mode Detection
```
1. User opens app with internet active
2. StartNotifier() called
3. User enters airplane mode
4. OnInternetConnectivityChange fires with IsConnected = false
5. UI updates to show offline indicator
6. Online features are disabled
```

### Server Maintenance Handling
```
1. User playing online game
2. Backend server goes offline (simulate by changing host address to invalid URL)
3. OnHostReachabilityChange fires with IsReachable = false
4. IsInternetActive remains true (internet available)
5. App shows "Server maintenance" message instead of "No internet"
```

### Battery Optimization
```
1. User enters main menu
2. StopNotifier() called (menu doesn't need monitoring)
3. User enters multiplayer mode
4. StartNotifier() called
5. Monitoring resumes, events fire on network changes
```

## Troubleshooting Test Failures
If events aren't firing or status is incorrect:

1. **Verify StartNotifier() Called**: Check `NetworkServices.IsNotifierActive` returns `true`
2. **Check Event Registration**: Ensure `OnEnable`/`OnDisable` properly subscribe/unsubscribe
3. **Validate Host Address**: For host monitoring, confirm valid IPv4/IPv6 in settings
4. **Test with Demo Scene**: Run `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/NetworkServicesDemo.unity` to verify plugin behavior

{% hint style="success" %}
**Testing Tip**: Use flight mode toggle for quick offline testing. For realistic scenarios, test in areas with poor signal (parking garages, elevators) to verify handling of intermittent connectivity.
{% endhint %}

## Pre-Submission Review
- [ ] Test on physical devices (iOS and Android) running minimum supported OS versions
- [ ] Verify monitoring starts/stops correctly throughout app lifecycle
- [ ] Test complete user flows: app launch → online gameplay → offline → reconnect
- [ ] Verify battery usage is acceptable (stop monitoring when not needed)
- [ ] Test with various network conditions: WiFi, cellular, weak signal, no signal
- [ ] Confirm UI properly reflects all network states (online, offline, server down)

## Related Guides
- [Setup Guide](setup.md) - Verify configuration before testing
- [Usage Guide](usage.md) - Review implementation patterns
- [FAQ](faq.md) - Solutions for common test failures
