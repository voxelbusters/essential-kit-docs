# Network Services - Best Practices

## Connectivity Monitoring
- Start the notifier only when network monitoring is needed to conserve device resources
- Stop the notifier during app pause states or when network awareness isn't required
- Check `IsNotifierActive` before starting to avoid duplicate notifier instances
- Always unsubscribe from events in `OnDisable()` to prevent memory leaks

## Event Handling
- Register for connectivity events in `OnEnable()` and unregister in `OnDisable()`
- Handle both internet connectivity and host reachability events for comprehensive monitoring
- Implement graceful fallbacks when network services become unavailable
- Cache connectivity status locally to avoid repeated API calls

## Resource Management
- Use network status properties (`IsInternetActive`, `IsHostReachable`) for quick status checks
- Avoid polling network status continuously - rely on event notifications instead
- Stop the notifier when your game doesn't need real-time network updates
- Consider app lifecycle events when managing notifier state

## Unity Cross-Platform Considerations
- Network Services works consistently across Unity iOS and Unity Android builds
- No platform-specific code needed - Essential Kit handles cross-platform differences
- Test network scenarios on both platforms during development
- Account for different network behaviors between iOS and Android devices

## User Experience
- Provide clear offline indicators when network features are unavailable
- Queue network-dependent actions for retry when connectivity returns
- Implement progressive degradation for network-dependent features
- Respect user data usage preferences and connection types

## Performance Optimization
- Use event-driven architecture instead of polling for network status
- Cache server reachability results appropriately for your game's needs
- Minimize network monitoring overhead by controlling notifier lifecycle
- Optimize for Unity mobile games performance across different device capabilities

📌 **Video Note**: Present as a comprehensive checklist covering all essential network services practices for Unity developers.