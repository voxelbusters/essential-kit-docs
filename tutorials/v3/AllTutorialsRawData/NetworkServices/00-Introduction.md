# Network Services Tutorial - Introduction

Welcome to the Network Services tutorial! This tutorial is part of the Essential Kit tutorial series from Voxel Busters.

## What You'll Learn

In this tutorial, you'll master Essential Kit's Network Services feature and learn how to:

- Check internet connectivity status in your Unity mobile games
- Monitor host reachability for specific servers
- Use network change notifications to respond to connectivity changes
- Implement network-aware game features for Unity iOS and Android
- Handle offline scenarios gracefully in cross-platform Unity games

## Why Network Services Matter for Unity Mobile Game Developers

Network connectivity is crucial for modern Unity mobile games. Whether you're implementing multiplayer features, cloud saves, leaderboards, or in-app purchases, knowing your network status helps create better user experiences. Essential Kit's Network Services provide a unified way to monitor connectivity across Unity iOS and Unity Android platforms.

Common use cases include:
- Pausing multiplayer gameplay when connection is lost
- Showing offline indicators in the UI
- Queuing actions to retry when connectivity returns
- Optimizing data usage based on connection type

## Prerequisites

- Unity 2019.4 or later
- Essential Kit properly installed and configured in your Unity project
- Basic knowledge of Unity C# scripting and event handling

## Platform Setup

**Great news!** Essential Kit handles all the complex native setup automatically for network monitoring across both iOS and Android platforms. The plugin automatically:

- Configures network reachability permissions
- Sets up platform-specific connectivity monitoring
- Handles cross-platform API differences
- Manages network state callbacks and threading

You don't need to configure any special permissions, frameworks, or manifest entries. Essential Kit abstracts away all the platform complexities, letting you focus on your game logic!

The only consideration is ensuring your privacy policy mentions network connectivity monitoring if required by your target app stores.

📌 **Video Note**: Show Essential Kit Settings in Unity Editor with Network Services configuration panel.