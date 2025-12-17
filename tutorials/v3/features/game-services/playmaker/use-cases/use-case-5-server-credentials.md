# Server Credentials (Backend Sign-In)

## Goal
Fetch platform-issued server credentials and send them to your backend for validation/sign-in.

## Prerequisite
Make sure the player is authenticated first. Use `use-case-1-auth-bootstrap.md`.

## Actions used
- `GameServicesLoadServerCredentials`
- `GameServicesGetLoadServerCredentialsSuccessResult` (on success)
- `GameServicesGetLoadServerCredentialsError` (on failure)

## Flow
1. State: `LoadServerCredentials`
   - Action: `GameServicesLoadServerCredentials`
   - (Optional) Input: `additionalScopes` (comma-separated enum names)
   - Events:
     - `successEvent` → `GetServerCredentials`
     - `failureEvent` → `GetLoadServerCredentialsError`
2. State: `GetServerCredentials`
   - Action: `GameServicesGetLoadServerCredentialsSuccessResult`
   - Read platform fields:
     - Android: `androidServerAuthCode`
     - iOS: `iosPublicKeyUrl`, `iosSignature`, `iosSalt`, `iosTimestamp`
3. Send the extracted fields to your backend and complete your server-side sign-in flow.

## Notes
- Values are platform-specific; expect the unused platform fields to be empty.
- Keep this flow separate from gameplay-critical paths; it’s typically a “connect account” feature.
