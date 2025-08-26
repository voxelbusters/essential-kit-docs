---
description: Access user's address book for social features in Unity mobile games
---

# 📒 Address Book Tutorial

*This tutorial is part of the Essential Kit tutorial series from Voxel Busters.*

Welcome to the Address Book feature tutorial! This comprehensive guide will teach you how to integrate contact access functionality into your Unity mobile games using Essential Kit's cross-platform Address Book API.

{% embed url="https://www.youtube.com/watch?v=Tv85rRIYY_4" %}
Address Book Video Tutorial
{% endembed %}

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

## Tutorial Structure

This tutorial covers five core concepts in logical progression:

1. **Contacts Permissions** - Managing user authorization for contact access
2. **Reading Contacts** - Basic contact retrieval functionality  
3. **Contact Constraints** - Filtering contacts based on available data
4. **Contact Properties** - Working with names, emails, phone numbers, and images
5. **Advanced Usage** - Pagination, custom initialization, and error handling

## Getting Started

{% content-ref url="concepts/" %}
[concepts](concepts/)
{% endcontent-ref %}

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
