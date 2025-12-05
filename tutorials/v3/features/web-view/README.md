---
description: Cross-platform web content display for Unity mobile games
---

# 🌏 Web View

Essential Kit's WebView feature lets Unity teams display web content, run JavaScript, and enable web-to-game communication without maintaining platform-specific code. This tutorial walks you through setup, web view APIs, JavaScript interaction, and troubleshooting so you can integrate web content seamlessly.

{% embed url="https://www.youtube.com/watch?v=0GSBP3tknT4" %}
Web View Video Tutorial
{% endembed %}

{% hint style="danger" %}
**Editor Limitation**: WebView feature does not work in Unity Editor. Testing requires building to iOS or Android devices.
{% endhint %}

{% hint style="info" %}
Looking for a working reference? Open the demo scene at `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/WebViewDemo.unity` and the companion script at `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scripts/WebViewDemo.cs` to see the full API in action.
{% endhint %}

## What You'll Learn

* Create and display web views with custom frame sizes and styles
* Load URLs, HTML strings, and local files into web views
* Execute JavaScript and receive results from web content
* Implement web-to-Unity communication using custom URL schemes
* Control web view lifecycle (show, hide, reload, clear cache)

## Why WebView Matters

* **Dynamic Content**: Display terms of service, privacy policies, and FAQs without app updates
* **Web Authentication**: Show OAuth login flows (Facebook, Google) with native web interface
* **HTML5 Games**: Run HTML5 mini-games or interactive content within your Unity app
* **Hybrid Features**: Integrate web-based UI for complex forms, dashboards, or admin tools

## Tutorial Roadmap

1. [Setup](setup.md) - Enable the feature and configure platform permissions
2. [Usage](usage.md) - Create web views, load content, JavaScript interaction, URL schemes
3. [Testing](testing.md) - Device testing checklist and validation
4. [FAQ](faq.md) - Troubleshoot common issues

## Key Use Cases

* **Terms & Conditions**: Display hosted legal documents with automatic updates
* **Social Login**: Show OAuth flows for Facebook, Google, Apple authentication
* **News Feed**: Display dynamic game news, announcements, and patch notes
* **HTML5 Mini-Games**: Run lightweight web games within your main game
* **Custom Ads**: Display full-screen promotional web content

## Prerequisites

* Unity project with Essential Kit v3 installed and WebView feature included
* iOS or Android target (WebView requires physical device testing)
* Web content to display (URL, HTML string, or local HTML file)

{% hint style="info" %}
**Single WebView Limitation**: Essential Kit displays one web view at a time. Multiple simultaneous web views are not supported.
{% endhint %}

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
