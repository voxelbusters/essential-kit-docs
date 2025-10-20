# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is the documentation repository for Essential Kit v3, a Unity cross-platform mobile development tool that provides unified APIs for native mobile features across iOS, Android, and tvOS platforms. The plugin includes 15+ feature modules like billing services, cloud saves, game services, notifications, and more.

## Documentation Structure

The documentation is organized as a GitBook-style structure:

- **Features Documentation**: Located in `/features/` with each feature having its own subdirectory containing:
  - `README.md` - Feature overview and introduction
  - `setup.md` or `setup/` - Platform-specific configuration instructions  
  - `usage.md` - Code examples and API usage
  - `testing.md` - Testing procedures
  - `faq.md` - Frequently asked questions
  - `examples/` - Extended code examples and use cases
  - `notes/` - Technical notes and implementation details

- **Core Documentation Files**:
  - `SUMMARY.md` - GitBook table of contents structure
  - `features-overview.md` - High-level feature summary
  - `installation.md` - Plugin installation guide
  - `upgrade-guide.md` - Version upgrade instructions

- **Supporting Documentation**:
  - `plugin-overview/` - Settings, folder structure, localization
  - `whats-new-in-v3/` - Version 3 changes and migration
  - `notes/` - Technical troubleshooting and platform-specific issues

## Feature Organization Pattern

Each feature follows a consistent documentation pattern:
1. **Overview** - What the feature does and use cases
2. **Setup** - Installation and platform configuration (often split into iOS/Android)
3. **Usage** - Code examples and API reference
4. **Testing** - How to test the feature during development
5. **FAQ** - Common issues and solutions

## Platform-Specific Considerations

- **iOS**: Requires capabilities setup, entitlements, and sometimes StoreKit configuration
- **Android**: Needs manifest permissions, Gradle dependencies, and Google Play Console setup
- **tvOS**: Limited feature support (no Address Book, App Shortcuts, Media Library, Web View, Date Picker, Sharing)

## Documentation Maintenance Guidelines

- Maintain consistency in documentation structure across all features
- Keep platform-specific setup instructions in separate files when complex
- Include practical code examples in usage documentation
- Update FAQ sections based on common user questions
- Ensure all feature documentation includes testing procedures
- Reference Unity-specific concepts and workflows throughout

## API Documentation

- Generated API docs are available in `/api/docs/v3/` (Doxygen HTML)
- Plugin uses assembly definition files (.asmdef) for modular compilation
- Relies on External Dependency Manager for Android library resolution
- Settings are stored in `Assets/Resources/EssentialKitSettings.asset`

## Key Dependencies

- Unity Editor (mobile development focus)
- External Dependency Manager (Google's Unity JAR Resolver)
- Newtonsoft JSON package (`com.unity.nuget.newtonsoft-json": "2.0.0"`)
- Platform-specific SDKs (StoreKit 2, Google Play Billing, etc.)
- always use serena mcp tools first