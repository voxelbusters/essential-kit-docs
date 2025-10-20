# Sharing Services Overview

The Sharing Services module provides four essential components that enable native content sharing in Unity cross-platform mobile applications. These services integrate seamlessly with iOS and Android sharing ecosystems while maintaining consistent APIs for Unity developers.

## Architecture Overview

Essential Kit's sharing architecture follows a unified pattern optimized for Unity mobile game development:

```
Unity Game
    ↓
Essential Kit Sharing API
    ↓
Platform Abstraction Layer
    ↙         ↘
iOS Native    Android Native
```

This design ensures Unity cross-platform compatibility while delivering native user experiences on each platform.

## Core Components

This tutorial covers four sharing concepts that work across iOS and Android:

### **Mail Composer**
Native email composition with full attachment support. Ideal for Unity mobile games to enable players to send personalized invites, report issues with screenshots, or share achievements via email.

### **Message Composer** 
SMS and messaging functionality for direct communication. Perfect for Unity mobile games to enable quick sharing of game content, friend invitations, or achievement notifications through text messages.

### **Share Sheet**
Universal sharing interface that presents all available sharing apps on the device. Essential for Unity mobile games to maximize sharing reach by letting players choose their preferred sharing platform.

### **Social Share Composer**
Direct integration with social media platforms like Facebook and Twitter. Crucial for Unity mobile games to enable viral sharing and community building through dedicated social platforms.

## Cross-Platform Implementation

### iOS Features
- Native `UIActivityViewController` for Share Sheet
- `MFMailComposeViewController` for email composition
- `MFMessageComposeViewController` for messaging
- Social framework integration for platform-specific sharing

### Android Features  
- Android Intent system for universal sharing
- Email client integration via `ACTION_SEND`
- SMS support through messaging intents
- Native social app integration

## Content Type Support

| Content | Mail | Message | Share Sheet | Social |
|---------|------|---------|-------------|--------|
| Text    | ✅    | ✅       | ✅           | ✅      |
| Images  | ✅    | ✅*      | ✅           | ✅      |
| URLs    | ✅    | ❌       | ✅           | ✅      |
| Files   | ✅    | ✅*      | ✅           | ❌      |

*Platform capability dependent

Essential Kit abstracts these complexity differences, providing consistent Unity SDK integration across iOS and Android platforms.

📌 **Video Note:** Use visual overview diagram showing Unity game connecting to native sharing services.

---

**Next:** [Mail Composer - Email Sharing for Unity Games](02-MailComposer.md)