# Essential Kit v3 Documentation Project Overview

## Project Purpose
This is the documentation repository for Essential Kit v3, a Unity cross-platform mobile development plugin that provides unified APIs for native mobile features across iOS, Android, and tvOS platforms. The plugin includes 15+ feature modules like billing services, cloud saves, game services, notifications, and more.

## Core Technology Stack
- **Documentation Format**: GitBook-style Markdown documentation
- **Platform**: Unity 2021.3+ mobile development tool
- **Target Platforms**: iOS 15+, Android 21+ (API level), tvOS (Beta)
- **Dependencies**: 
  - External Dependency Manager (Google's Unity JAR Resolver)
  - Newtonsoft JSON package (`com.unity.nuget.newtonsoft-json": "2.0.0"`)
  - Platform-specific SDKs (StoreKit 2, Google Play Billing, etc.)

## Repository Structure
- GitBook table of contents in `SUMMARY.md`
- Feature documentation in `/features/` subdirectories
- Core docs: installation, upgrade guides, settings
- Supporting docs in `/plugin-overview/`, `/whats-new-in-v3/`, `/notes/`
- Raw tutorial content in `/AllTutorialsRawData/` (appears to be source material)

## Documentation Patterns
Each feature follows consistent structure:
1. `README.md` - Overview and introduction
2. `setup.md` or `setup/` - Platform-specific configuration
3. `usage.md` - Code examples and API usage
4. `testing.md` - Testing procedures
5. `faq.md` - Common issues and solutions
6. `examples/` - Extended use cases
7. `notes/` - Technical implementation details

## Key Features Documented
- Address Book, App Shortcuts, App Updater
- Billing Services (IAP), Cloud Services, Deep Link Services
- Game Services, Media Services, Native UI, Network Services
- Notification Services, Rate My App, Sharing, Task Services, Web View
- Utilities (Settings, Store Links)

## Development Context
- Unity mobile game development focus
- Cross-platform iOS/Android/tvOS support
- Privacy-first implementation approach
- Assembly definition files (.asmdef) for modular compilation
- Extensive platform-specific setup automation