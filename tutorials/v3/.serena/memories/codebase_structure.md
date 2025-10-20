# Essential Kit v3 Documentation Codebase Structure

## Root Directory Structure
```
/Volumes/Work/Projects/Products/AssetStore/Cross Platform Essential Kit/Docs/tutorials/v3/
├── .claude/                    # Claude Code configuration
├── .serena/                    # Serena project configuration  
├── .gitbook/                   # GitBook specific files
├── AllTutorialsRawData/        # Source tutorial content (appears to be drafts/templates)
├── features/                   # Feature-specific documentation (main content)
├── plugin-overview/            # Core plugin documentation
├── whats-new-in-v3/           # Version 3 specific information
├── notes/                      # Technical troubleshooting guides
├── README.md                   # Main introduction page
├── SUMMARY.md                  # GitBook table of contents
├── CLAUDE.md                   # Project instructions for Claude
├── features-overview.md        # High-level feature summary
├── installation.md             # Plugin installation guide
└── upgrade-guide.md           # Version upgrade instructions
```

## Features Directory Structure
Each feature follows consistent organization pattern:
```
features/[feature-name]/
├── README.md                   # Feature overview and introduction
├── setup.md or setup/          # Platform-specific configuration
│   ├── ios.md                 # iOS-specific setup
│   └── android.md             # Android-specific setup
├── usage.md                   # Code examples and API usage
├── testing.md                 # Testing procedures
├── faq.md                     # Common issues and solutions
├── examples/                  # Extended code examples
│   └── [specific-examples].md
└── notes/                     # Technical implementation details
    └── [technical-notes].md
```

## Key Features Documented
- **address-book**: Contact access functionality
- **app-shortcuts**: Dynamic home screen shortcuts
- **app-updater**: Version update management
- **billing-services**: In-app purchases and subscriptions
- **cloud-services**: Cross-device data synchronization
- **deep-link-services**: URL scheme and universal link handling
- **game-services**: Leaderboards and achievements
- **media-services**: Photo/video capture and selection
- **native-ui**: Alert dialogs and date pickers
- **network-services**: Connectivity monitoring
- **notification-services**: Local and push notifications
- **rate-my-app**: App rating prompts
- **sharing**: Social sharing and mail/message composition
- **task-services**: Background task execution
- **utilities**: Settings and store link utilities
- **web-view**: In-app browser functionality

## Supporting Documentation
- **plugin-overview/**: Settings, folder structure, localization
- **whats-new-in-v3/**: Version comparison, release notes, upgrade guide
- **notes/**: Platform-specific troubleshooting (Gradle errors, API levels, etc.)

## Content Types
- **Markdown Files**: Primary documentation format (.md)
- **Configuration**: YAML/JSON for project settings
- **Media**: Images and GIFs for visual documentation
- **No Source Code**: This is documentation only, references Unity C# plugin code