# Address Book Tutorial - Introduction

This tutorial is part of the Essential Kit tutorial series from Voxel Busters.

Welcome to the Address Book feature tutorial! This comprehensive guide will teach you how to integrate contact access functionality into your Unity mobile games using Essential Kit's cross-platform Address Book API.

## What You'll Learn

- How to check and request contacts access permissions on iOS and Android
- Reading contacts from the device address book with filtering options
- Working with contact properties like names, phone numbers, emails, and profile images
- Implementing pagination for large contact lists
- Advanced scenarios including custom initialization and error handling

## Why Address Books Matter for Unity Mobile Game Developers

The Address Book feature enables Unity mobile games to access device contacts, opening possibilities for social gameplay features, friend invitations, and enhanced user engagement. Common use cases include finding friends already playing your game, creating social leaderboards based on contacts, and implementing referral systems.

## Prerequisites

- Unity 2021.3 or newer
- Essential Kit installed and configured in your project
- Target platforms: iOS and/or Android

## Platform Setup

Essential Kit handles most native setup automatically, including:
- **iOS**: Automatically configures required frameworks and privacy permissions
- **Android**: Manages required permissions in AndroidManifest.xml
- **Cross-platform**: Provides unified API across both platforms

You only need to:
- Provide appropriate usage descriptions in Essential Kit Settings for privacy compliance
- Ensure your app store listings mention contact access features for approval

📌 **Video Note**: Show Essential Kit Settings in Unity Editor, highlighting Address Book configuration options.