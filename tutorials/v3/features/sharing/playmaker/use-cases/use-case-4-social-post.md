# Social Media Post (Platform Composer)

## Goal
Share directly to a specific social app when available, otherwise fall back to the share sheet.

## Actions used
- `SocialComposerIsComposerAvailable`
- `SocialShareComposerShow`
- `SocialShareComposerGetError` (optional)
- `ShareSheetShow` (fallback)

## Variables
- `isAvailable` (Bool)

## Flow
1. State: `CheckAvailability`
   - Action: `SocialComposerIsComposerAvailable` → `isAvailable`
   - Branch:
     - If `isAvailable` → `ShowSocialComposer`
     - Else → `ShowShareSheet` (fallback)
2. State: `ShowSocialComposer`
   - Action: `SocialShareComposerShow`
   - Events:
     - `closedWithDoneEvent` → Done
     - `closedWithCancelledEvent` → Cancelled
     - `closedWithUnknownEvent` → Unknown (optional handling)
     - `closedWithFailedEvent` → `SocialShareComposerGetError` (optional) then fallback or show error

## Notes
- Availability depends on platform + whether the target app is installed/configured.
