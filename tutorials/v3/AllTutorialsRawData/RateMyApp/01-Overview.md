# Rate My App Overview

The Rate My App feature provides a simple way to request user ratings using native platform dialogs. It's designed to respect platform quotas while giving you control over when and how rating prompts appear.

## High-Level Architecture

```
Unity Game
     ↓
RateMyApp API
     ↓
Platform-Specific Implementation
     ↓
Native Rating Dialog
(iOS: SKStoreReviewController / Android: Play In-App Review)
```

## Concepts Covered in This Tutorial

This tutorial covers three main concepts:

1. **Checking Rating Conditions** - Using `IsAllowedToRate()` to verify if timing constraints are met
2. **Showing Rating Prompts** - Using `AskForReviewNow()` to display native rating dialogs
3. **Handling User Responses** - Using events to track confirmation dialog interactions

## Unity Cross-Platform Development for iOS and Android

The Rate My App feature provides a unified API that works seamlessly across Unity iOS and Unity Android platforms. Essential Kit abstracts the platform differences, so you write code once and it works everywhere.

**Key Benefits:**
- Single API for both platforms
- Automatic native setup and framework integration  
- Built-in quota management and timing controls
- Unity mobile games SDK integration with minimal setup

📌 **Video Note**: Show the simple flow diagram and demonstrate the feature working on both iOS and Android devices.

## Platform Differences

While the API is unified, each platform has its own native implementation:

- **iOS**: Uses SKStoreReviewController (iOS 10.3+)
- **Android**: Uses Google Play In-App Review API (Android 5.0+)

Essential Kit handles these differences automatically, providing a consistent Unity cross-platform development experience.