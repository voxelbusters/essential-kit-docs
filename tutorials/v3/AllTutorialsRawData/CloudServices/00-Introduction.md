# Cloud Services Introduction

Welcome to the Cloud Services tutorial! This tutorial is part of the Essential Kit tutorial series from Voxel Busters.

## What You'll Learn

In this tutorial series, you'll master Essential Kit's Cloud Services feature for Unity cross-platform development:

- How to store and retrieve data in the cloud
- Working with different data types (bool, int, string, byte arrays)
- Handling cloud synchronization across devices
- Managing user account changes and data conflicts
- Best practices for Unity iOS and Unity Android cloud integration

## Why Cloud Services Matter for Unity Mobile Game Developers

Cloud Services enable your Unity mobile games to sync player data across multiple devices seamlessly. Whether your players switch between their phone and tablet, or get a new device, their game progress, settings, and preferences remain consistent.

Essential Kit's Cloud Services provide:
- **Cross-platform data sync** between iOS (iCloud) and Android (Google Cloud)
- **Automatic conflict resolution** when data differs between devices
- **Offline support** with local caching
- **Real-time sync notifications** when data changes

Common use cases include:
- Player progress and save games
- Game settings and preferences  
- Achievement progress
- In-app purchase history
- Custom player configurations

## Prerequisites

- Unity 2021.3.45f1 or compatible version
- Essential Kit properly installed and configured
- Basic understanding of Unity C# scripting

## Platform Setup

**Great news!** Essential Kit handles most native platform setup automatically, including:
- Framework integration (CloudKit for iOS, Google Cloud for Android)
- Required permissions and manifest entries
- Native platform initialization

📌 Video Note: Show Essential Kit Settings in Unity Editor

### What You Still Need to Do

**For iOS:**
- Enable iCloud capability in Xcode project settings
- Configure iCloud Key-Value storage in Apple Developer Portal

**For Android:**
- Ensure Google Play Games Services is configured (if using signed-in users)
- Add appropriate privacy policy disclosures

Essential Kit abstracts away the complex native implementation details, letting you focus on your game logic rather than platform-specific cloud integration code.