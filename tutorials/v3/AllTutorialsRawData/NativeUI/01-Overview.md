# Native UI - Overview

The Native UI module provides cross-platform access to essential native interface components that maintain platform-specific appearance and behavior. This Unity cross-platform development solution ensures your Unity mobile games feel natural on both iOS and Android.

## Architecture

The Native UI system follows a clean architecture pattern:

```
Unity Game Layer
        ↓
Essential Kit API Layer (AlertDialog, DatePicker)
        ↓
Platform Abstraction Layer
        ↓
Native Implementation (iOS UIAlertController, Android AlertDialog)
```

## Concepts Covered in This Tutorial

This tutorial series covers the following key concepts:

1. **Alert Dialogs** - Native alert dialogs with custom titles, messages, buttons, and text input fields
2. **Date Pickers** - Native date and time selection components with various modes and configurations

Each concept provides a complete Unity SDK integration that handles the complexity of native platform differences automatically.

## Cross-Platform Considerations

Essential Kit's Native UI module abstracts platform differences while preserving native behavior:

- **iOS**: Uses UIAlertController and UIDatePicker with native iOS styling
- **Android**: Uses AlertDialog and DatePickerDialog with Material Design
- **Unity Editor**: Provides simulator implementations for testing without device deployment

The API remains consistent across platforms, making it ideal for Unity cross-platform development for iOS and Android.

## Unity Mobile Games SDK Integration

Native UI components integrate seamlessly with your Unity mobile games workflow:
- No additional native code required
- Automatic memory management and lifecycle handling
- Unity-friendly callback system with main thread dispatching
- Support for both runtime and editor testing

📌 Video Note: Use visual overview diagram showing the flow from Unity script to native UI component display on both iOS and Android devices.