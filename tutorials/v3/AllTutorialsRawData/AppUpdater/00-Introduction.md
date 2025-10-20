# App Updater - Introduction

Welcome to the App Updater tutorial! This tutorial is part of the Essential Kit tutorial series from Voxel Busters.

## What You'll Learn

In this comprehensive tutorial, you will master:

- **Requesting update information** to check if updates are available for your Unity mobile game
- **Prompting users for updates** with customizable native dialogs and options
- **Understanding update statuses** and handling different update scenarios
- **Implementing force updates** for critical app versions
- **Advanced update configurations** using Unity settings and builder patterns

## Why App Updates Matter for Unity Mobile Game Developers

Keeping your Unity mobile games updated is crucial for maintaining player engagement and ensuring optimal performance. The App Updater feature provides a seamless, cross-platform solution that automatically handles the complexity of native update mechanisms on both iOS and Android platforms.

Common use cases include:
- **Critical bug fixes** that need immediate deployment
- **New game content** and feature releases
- **Security updates** and performance improvements
- **Compliance updates** for app store requirements

## Prerequisites

- Unity 2021.3.45f1 or compatible version
- Essential Kit properly installed and configured in your project
- Basic understanding of Unity mobile game development
- Test devices (iOS/Android) for platform-specific testing

## Platform Setup

**Essential Kit handles most native setup automatically!** This includes:
- Native framework integration for both iOS and Android platforms
- App Store Connect and Google Play Console API configurations
- Required permissions and manifest entries
- Platform-specific update mechanisms

What you still need to handle:
- **App Store compliance**: Ensure your app meets platform-specific update policies
- **Privacy policies**: Update privacy statements if your update process collects usage data
- **Testing environments**: Set up proper testing workflows for update scenarios

📌 **Video Note**: Show Essential Kit Settings in Unity Editor, highlighting the App Updater configuration panel and automatic setup features.

The App Updater works differently across platforms:
- **iOS**: Presents native alerts directing users to the App Store for updates
- **Android**: Uses Google Play's In-App Update API for seamless updates, with fallback to Play Store redirection if needed

Let's begin by exploring the App Updater architecture and core concepts!