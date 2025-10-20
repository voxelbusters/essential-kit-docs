# Deep Link Services Tutorial - Introduction

This tutorial is part of the Essential Kit tutorial series from Voxel Busters.

Welcome to the **Deep Link Services** tutorial for Unity mobile game developers.

## What You'll Learn

- Handle custom URL schemes in Unity iOS and Unity Android games
- Implement Universal Links (iOS) and App Links (Android) 
- Parse deep link parameters for game navigation
- Set up Essential Kit Settings for cross-platform deep linking
- Handle deep link events in your Unity mobile games

## Why Deep Link Services Matters for Unity Mobile Game Developers

Deep linking enables players to jump directly into specific game content from external sources like social media, websites, or other apps. This improves player engagement and supports marketing campaigns for Unity cross-platform games.

Common use cases include sharing achievement links, inviting friends to multiplayer sessions, and directing players to specific game levels or events.

## Prerequisites

- Unity 2021.3.45f1 or later
- Essential Kit properly installed and configured
- Basic understanding of Unity mobile development

## Platform Setup

**Essential Kit handles most native setup automatically** including framework integration, permission declarations, and manifest entries. This eliminates the complex manual configuration typically required for Unity iOS and Unity Android deep linking!

You only need to:
- Configure URL schemes in Essential Kit Settings
- Set up domain verification for Universal Links/App Links
- Ensure app store compliance and privacy policies

## Essential Kit Settings Configuration

📌 **Video Note**: Show Essential Kit Settings inspector configuration

1. Open **Window > Essential Kit > Settings** in Unity
2. Navigate to the **Services** tab
3. Find **Deep Link Services** section
4. Enable the feature
5. Configure **URL Schemes**:
   - Add custom schemes like `mygame://` 
   - Example: `mygame://level/5` or `mygame://invite/abc123`
6. Set **Universal Link Domains**:
   - Add your website domain (e.g., `mygame.com`)
   - Example: `https://mygame.com/level/5`
7. Configure platform-specific options as needed

**Quick Setup Examples:**

For a puzzle game called "BlockMaster":
- URL Scheme: `blockmaster://`
- Universal Link Domain: `blockmaster.com`
- Example links: `blockmaster://level/10` or `https://blockmaster.com/level/10`

For a multiplayer game:
- URL Scheme: `mygame://`  
- Links: `mygame://join/room123` or `mygame://challenge/player456`

## Tutorial Structure

This tutorial covers these concepts:
1. **URL Scheme Handling** - Custom schemes and event handling
2. **Universal Links** - Cross-platform link implementation  
3. **Parameter Parsing** - Extracting data from links
4. **Advanced Usage** - Initialize methods and custom handling
5. **Best Practices** - Guidelines for Unity mobile games

Ready to start? Let's begin with [Overview](01-Overview.md).