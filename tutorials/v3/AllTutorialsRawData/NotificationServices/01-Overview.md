# Notification Services - Overview

## High-Level Architecture

The Essential Kit Notification Services provides a unified cross-platform API that abstracts the complexities of iOS APNS and Android FCM:

```
Your Unity Game
       ↓
NotificationServices (Essential Kit)
       ↓
┌─────────────────┬─────────────────┐
│   iOS (APNS)    │  Android (FCM)  │
│   Automatic     │   Automatic     │
└─────────────────┴─────────────────┘
```

## Concepts Covered in This Tutorial

This tutorial series covers these essential concepts:

### 02-NotificationPermissions.md
Learn how to request and check notification permissions, handle different permission states, and manage user authorization across platforms.

### 03-LocalNotifications.md  
Master creating, scheduling, and managing local notifications that trigger on the device without server involvement.

### 04-RemoteNotifications.md
Understand push notifications from your server, device token registration, and handling remote notification payloads.

### 05-NotificationManagement.md
Explore retrieving scheduled notifications, managing delivered notifications, and working with notification settings.

### 06-NotificationTriggers.md
Deep dive into time-based, calendar-based, and location-based notification triggers for precise delivery.

### 07-AdvancedUsage.md
Advanced scenarios including custom notification properties, channels, initialization with custom settings, and comprehensive error handling.

### 08-BestPractices.md
Essential guidelines for optimizing notification delivery, user experience, and platform compliance.

### 09-Summary.md
Complete recap of all notification concepts and next steps for Unity developers.

## Cross-Platform Considerations

Essential Kit provides seamless Unity cross-platform development for iOS and Android:

- **Unified API**: Single codebase works across both platforms
- **Platform Optimization**: Automatically uses native iOS and Android notification features
- **Smart Abstraction**: Handles platform differences transparently
- **Unity Mobile Games SDK Integration**: Designed specifically for Unity mobile game development workflows

📌 **Video Note**: Use visual overview diagram showing the unified API architecture and cross-platform abstraction.