# Utilities (System utilities) - PlayMaker

Access system utilities like app store navigation and settings using Essential Kit's Utilities feature via PlayMaker custom actions.

## Actions (3)
- `UtilitiesOpenAppStorePageDefault` (sync): Opens the app store page using the configured app ID from Essential Kit settings.
- `UtilitiesOpenAppStorePageById` (sync): Opens the app store page using platform-specific IDs passed as parameters.
- `UtilitiesOpenApplicationSettings` (sync): Opens the native application settings page (iOS: Settings app, Android: system settings).

## Quick flow
1. `UtilitiesOpenAppStorePageDefault` → Opens app store for ratings/reviews
   - OR `UtilitiesOpenAppStorePageById` with explicit platform-specific app IDs
2. `UtilitiesOpenApplicationSettings` → Directs users to grant permissions

## Notes
- These actions are fire-and-forget (no success/failure callbacks). Use them from a button click or user confirmation state.

## Common uses
- **App Store Reviews**: Use `UtilitiesOpenAppStorePageDefault` to prompt users for ratings
- **Permission Flow**: Use `UtilitiesOpenApplicationSettings` when permissions are denied
- **Cross-App Promotion**: Use `UtilitiesOpenAppStorePageById` to promote other apps

## Use cases
Start here: `use-cases/README.md`

## Platform notes
- **iOS**: App ID is the numeric App Store ID (e.g., "1234567890")
- **Android**: App ID is the bundle identifier (e.g., "com.example.myapp")
- Configure default app IDs in Essential Kit Settings for platform-specific values
