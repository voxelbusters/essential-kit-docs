---
description: >-
  Cross-platform camera capture, photo selection, and gallery access for Unity
  mobile games
---

# 📸 Media Services

Essential Kit's Media Services feature lets Unity teams integrate native camera and gallery functionality without maintaining platform-specific code. This tutorial walks you through setup, key APIs, testing, and troubleshooting so you can add photo capture, media selection, and image saving capabilities with confidence.

{% embed url="https://www.youtube.com/watch?v=SI_ZOMxSty4" %}
Media Services Video Tutorial
{% endembed %}

{% hint style="info" %}
Looking for a working reference? Open the demo scene at `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/MediaServicesDemo.unity` and the companion script at `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scripts/MediaServicesDemo.cs` to see the full API in action.
{% endhint %}

## What You'll Learn

* Capture photos and videos using the native camera interface
* Let players select images from their device gallery with permissions handling
* Save game screenshots and generated images to the device gallery
* Handle media content conversion (texture, file, raw data) efficiently

## Why Media Services Matters

* **Player Engagement**: Enable avatar selection, photo sharing, and user-generated content features
* **Social Features**: Power screenshot sharing, in-game photo modes, and community content
* **Technical Simplicity**: Handle complex platform differences automatically (Photo Picker on Android, PHPicker on iOS)

## Tutorial Roadmap

1. [Setup](setup.md) - Enable the feature and configure platform permissions
2. [Usage](usage.md) - Camera capture, gallery selection, and saving media
3. [Testing](testing.md) - Simulate in editor and verify on devices
4. [FAQ](faq.md) - Troubleshoot common issues

## Key Use Cases

* **Avatar Selection**: Let players choose profile pictures from their gallery
* **Screenshot Sharing**: Capture and save game moments to device albums
* **Photo Mode**: Build in-game camera features with real device camera integration
* **User Content**: Enable photo uploads for clans, profiles, or creative modes

## Prerequisites

* Unity project with Essential Kit v3 installed and Media Services feature included
* iOS or Android target with camera/gallery usage descriptions configured
* Test device or Essential Kit simulator to validate permission prompts

{% content-ref url="setup.md" %}
[setup.md](setup.md)
{% endcontent-ref %}

{% content-ref url="usage.md" %}
[usage.md](usage.md)
{% endcontent-ref %}

{% content-ref url="testing.md" %}
[testing.md](testing.md)
{% endcontent-ref %}

{% content-ref url="faq.md" %}
[faq.md](faq.md)
{% endcontent-ref %}
