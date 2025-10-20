# App Updater - Overview

## High-Level Architecture

The App Updater provides a unified interface for handling application updates across iOS and Android platforms. It abstracts the complexity of platform-specific update mechanisms while providing developers with fine-grained control over the update experience.

```
┌─────────────────┐
│   Your Game     │
│                 │
├─────────────────┤
│   App Updater   │  ← Unified API
│                 │
├─────────────────┤
│ Platform Layer  │
│                 │
│ iOS: App Store  │  Android: In-App
│ Redirect        │  Update API
└─────────────────┘
```

## Concepts Covered in This Tutorial

This tutorial covers the following core concepts:

1. **Update Information** - Checking for available updates and understanding update metadata
2. **Prompt Update** - Presenting native update dialogs to users with customizable options
3. **Update Status** - Understanding different update states and handling them appropriately
4. **Advanced Usage** - Implementing custom initialization, force updates, and error handling

## Cross-Platform Considerations

Essential Kit's App Updater seamlessly handles Unity cross-platform development for iOS and Android:

- **Unified API**: Single codebase works across both platforms
- **Native Integration**: Leverages platform-specific update mechanisms automatically
- **Automatic Fallbacks**: Gracefully handles platform limitations and edge cases
- **Consistent Behavior**: Provides predictable update flows regardless of platform

## Unity Mobile Games SDK Integration

The App Updater integrates deeply with Unity's mobile development workflow:

- **Editor Simulation**: Test update flows without deploying to devices
- **Build Pipeline Integration**: Automatic setup during Unity Android and iOS builds
- **Settings Management**: Configure update behavior through Unity Inspector
- **Event-Driven Architecture**: Callback-based API fits Unity's programming patterns

📌 **Video Note**: Show a visual overview diagram illustrating the App Updater architecture, platform integration points, and typical update workflow from checking for updates to completion.

The App Updater simplifies what would otherwise be complex, platform-specific implementations into a few simple method calls, letting you focus on creating great Unity mobile games instead of wrestling with native update APIs.