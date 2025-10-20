# App Shortcuts Tutorial - Overview

## High-Level Architecture

App Shortcuts in Essential Kit provides a unified cross-platform interface for creating dynamic app shortcuts on both iOS and Android devices. The system abstracts platform differences while maintaining native performance and appearance.

```
Unity Game Layer
       ↓
Essential Kit App Shortcuts API
       ↓
┌─────────────────┬─────────────────┐
│   iOS Platform  │ Android Platform│
│  Quick Actions  │  App Shortcuts  │
└─────────────────┴─────────────────┘
```

## Concepts Covered in This Tutorial

This tutorial covers three core concepts essential for Unity cross-platform development:

### 1. App Shortcut Creation
Learn how to build dynamic shortcuts using the builder pattern with custom titles, subtitles, and icons for your Unity mobile games.

### 2. Shortcut Management  
Understand how to add and remove shortcuts dynamically based on game state, player progress, and seasonal events.

### 3. Shortcut Events
Master handling shortcut click events to route players directly to specific game content and features.

## Cross-Platform Considerations

Essential Kit ensures consistent behavior across platforms while respecting native conventions:

- **iOS**: Utilizes native Quick Actions appearing in 3D Touch/Haptic Touch menus
- **Android**: Creates App Shortcuts accessible via long-press on the app icon
- **Unified API**: Single codebase works seamlessly across Unity iOS and Unity Android builds
- **Native Performance**: Direct platform integration without performance overhead

This Unity cross-platform SDK integration approach eliminates the need for separate iOS and Android implementations while maintaining platform-specific user experience expectations.

📌 **Video Note**: Use visual overview diagram showing the flow from Unity code to platform-specific shortcut creation, including screenshots of shortcuts appearing on both iOS and Android home screens.