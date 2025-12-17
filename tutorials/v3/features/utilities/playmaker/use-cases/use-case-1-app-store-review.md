# Prompt for App Store Review

## Goal
Open the app store page for your app to encourage users to leave ratings and reviews.

## Actions Required
| Action | Purpose |
|--------|---------|
| UtilitiesOpenAppStorePageDefault | Opens app store using configured app ID |

## Variables Needed
None required (uses Essential Kit Settings)

## Implementation Steps

### 1. State: OpenAppStore
**Action:** UtilitiesOpenAppStorePageDefault

**Note:** The app will suspend and the App Store will open. Users can return via multitasking.

## Configuration Required
In Essential Kit Settings, configure:
- **iOS**: Set App Store ID (numeric, e.g., "1234567890")
- **Android**: Set Package Name (e.g., "com.yourcompany.yourapp")

## Common Issues

- **App Store doesn't open**: Verify app IDs are correctly configured in Essential Kit Settings
- **Wrong app opens**: Check that platform-specific app IDs match your published app
- **Action fails in Editor**: App Store links only work on device (iOS/Android)

## Flow Diagram
```
OpenAppStore
    └─ App Store opens, app suspends
```

## Best Practices
- Prompt after positive experiences (level completion, achievement unlocked)
- Don't show too frequently (once per version, or after significant milestones)
- Use a friendly message before opening: "Enjoying the game? Rate us!"
