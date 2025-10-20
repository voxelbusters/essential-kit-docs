# Network Services - Overview

## High-Level Architecture

Essential Kit's Network Services provides a simple, unified interface for monitoring network connectivity across Unity iOS and Android platforms. The system works by:

```
Unity Game Layer
       ↓
NetworkServices API
       ↓
Cross-Platform Bridge
       ↓
Native iOS/Android Network APIs
```

The service monitors two types of connectivity:
- **Internet Connectivity**: General internet access availability
- **Host Reachability**: Specific server/host accessibility

## Concepts Covered in This Tutorial

This tutorial covers the following Network Services concepts:

1. **Internet Connectivity** (02-InternetConnectivity.md)
   - Checking current internet status
   - Responding to connectivity changes
   - Using the `IsInternetActive` property

2. **Host Reachability** (03-HostReachability.md) 
   - Monitoring specific server accessibility
   - Host reachability change events
   - Using the `IsHostReachable` property

3. **Network Notifier** (04-NetworkNotifier.md)
   - Starting and stopping network monitoring
   - Managing notifier lifecycle
   - Automatic vs manual notifier control

## Cross-Platform Considerations

Essential Kit provides seamless Unity cross-platform development for iOS and Android by handling:
- Different native networking APIs between platforms
- Platform-specific permission requirements  
- Threading differences in network callbacks
- Network state detection variations

The Unity mobile games SDK integration ensures consistent behavior across both platforms, allowing you to write once and deploy everywhere.

📌 **Video Note**: Use visual overview diagram showing the flow from Unity game code to native platform network monitoring and back to Unity callbacks.