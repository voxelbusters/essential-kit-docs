# Utilities (System utilities) - PlayMaker

Access system utilities like app store navigation and settings using Essential Kit's Utilities feature via PlayMaker custom actions.

## Actions (6)
- `UtilitiesOpenAppStorePageDefault` (sync): Opens the app store page using the configured app ID from Essential Kit settings.
- `UtilitiesOpenAppStorePageById` (sync): Opens the app store page using platform-specific IDs passed as parameters.
- `UtilitiesOpenApplicationSettings` (sync): Opens the native application settings page (iOS: Settings app, Android: system settings).
- `UtilitiesRequestInfoForAgeCompliance` (async): Requests age compliance info using optional age gate ranges.
- `UtilitiesGetInfoForAgeComplianceSuccessResult` (sync): Reads the last age compliance info result cached by the request action.
- `UtilitiesGetInfoForAgeComplianceError` (sync): Reads the last age compliance error cached by the request action.

## Quick flow
1. `UtilitiesOpenAppStorePageDefault` → Opens app store for ratings/reviews
   - OR `UtilitiesOpenAppStorePageById` with explicit platform-specific app IDs
2. `UtilitiesOpenApplicationSettings` → Directs users to grant permissions

## Notes
- App store and settings actions are fire-and-forget (no success/failure callbacks).
- Age compliance is async; use `UtilitiesRequestInfoForAgeCompliance` with success/failure events, then read cached outputs if needed.

## Common uses
- **App Store Reviews**: Use `UtilitiesOpenAppStorePageDefault` to prompt users for ratings
- **Permission Flow**: Use `UtilitiesOpenApplicationSettings` when permissions are denied
- **Cross-App Promotion**: Use `UtilitiesOpenAppStorePageById` to promote other apps
- **Age Compliance**: Use `UtilitiesRequestInfoForAgeCompliance` to collect age range info and handle gating

## Use cases
Start here: `use-cases/README.md`

## Platform notes
- **iOS**: App ID is the numeric App Store ID (e.g., "1234567890")
- **Android**: App ID is the bundle identifier (e.g., "com.example.myapp")
- Configure default app IDs in Essential Kit Settings for platform-specific values
