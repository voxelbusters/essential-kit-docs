# Direct Users to App Settings

## Goal
Guide users to the native app settings page where they can enable permissions (camera, contacts, notifications, etc.).

## Actions Required
| Action | Purpose |
|--------|---------|
| UtilitiesOpenApplicationSettings | Opens native settings for this app |

## Variables Needed
None required

## Implementation Steps

### 1. State: DetectPermissionDenied
Check permission status (e.g., AddressBookGetContactsAccessStatus, camera, etc.)
- If DENIED → ShowSettingsPrompt
- If AUTHORIZED → Continue

### 2. State: ShowSettingsPrompt
Display UI message: "This feature requires [Permission Name]. Please enable it in Settings."
- Button: "Open Settings" → OpenSettings state

### 3. State: OpenSettings
**Action:** UtilitiesOpenApplicationSettings

**Note:** The app will suspend and Settings app will open. Users can return via multitasking.

## Common Issues

- **Settings don't open**: Only works on device (iOS/Android), not in Editor
- **User doesn't grant permission**: App needs to re-check permission when returning from settings
- **Wrong settings page**: On older Android versions, may open general settings instead of app-specific

## Flow Diagram
```
DetectPermissionDenied
    └─ Denied → ShowSettingsPrompt

ShowSettingsPrompt
    └─ User taps "Open Settings" → OpenSettings

OpenSettings
    └─ Settings app opens, app suspends
```

## Best Practices
- Explain WHY permission is needed before opening settings
- Use clear, friendly language: "We need photo access to save your avatar"
- Don't automatically open settings - let users tap a button
- Handle app resume gracefully (re-check permission status)

## Example UI Message
```
"Camera Access Required"

"To take photos for your profile, please enable camera
access in Settings."

[Cancel]  [Open Settings]
```
