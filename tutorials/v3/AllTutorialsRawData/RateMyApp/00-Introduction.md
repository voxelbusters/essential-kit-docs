# Rate My App Tutorial - Introduction

Welcome to the Rate My App feature tutorial! This tutorial is part of the Essential Kit tutorial series from Voxel Busters.

## What You'll Learn

In this tutorial, you'll discover how to:

- Enable and configure the Rate My App feature in Unity
- Check if rating conditions are met using `IsAllowedToRate()`
- Display rating prompts with `AskForReviewNow()`
- Handle confirmation dialog events and user responses
- Implement advanced timing and version control strategies

## Why Rate My App Matters for Unity Mobile Game Developers

App store ratings directly impact your Unity mobile game's visibility and download rates. The Rate My App feature helps you strategically prompt users for feedback at optimal moments, leading to better ratings and increased discoverability on both iOS App Store and Google Play Store.

## Prerequisites

- Unity 2021.3 or later
- Essential Kit properly installed and configured
- Basic understanding of Unity C# scripting

## Platform Setup

**Great news!** Essential Kit handles all native setup automatically, including:

- iOS: SKStoreReviewController framework integration
- Android: Google Play In-App Review API setup
- Platform-specific manifest entries and permissions

You only need to ensure:
- Your app is published on the respective app stores
- Privacy policies comply with store guidelines
- App Store Connect and Google Play Console are properly configured

📌 **Video Note**: Show Essential Kit Settings panel in Unity Editor with Rate My App configuration options.

## Platform Considerations

**iOS**: Uses native SKStoreReviewController with a maximum quota of 3 prompts per year per user.

**Android**: Uses Google Play In-App Review API with undisclosed but limited quota per user.

Let's get started with the overview of how Rate My App works across Unity iOS and Unity Android platforms!