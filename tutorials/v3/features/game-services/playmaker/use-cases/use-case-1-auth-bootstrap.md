# Auth Bootstrap (Safe Startup Login)

## Goal
Authenticate once per session (silent first, then optional interactive) and keep listening for auth status changes.

## Why this use case exists
`GameServicesAuthenticate.successEvent` means the request was dispatched, not that the player is authenticated. Always wait for `GameServicesOnAuthStatusChange.authenticatedEvent` before calling authenticated-only actions.

## Actions used
- `GameServicesOnAuthStatusChange` (persistent listener)
- `GameServicesIsAuthenticated` (quick check)
- `GameServicesAuthenticate` (dispatch)
- `GameServicesGetAuthenticateError` (optional diagnostics)
- `GameServicesGetLocalPlayerInfo` (optional player info after authenticated)

## Flow
1. State (persistent): `AuthListener`
   - Action: `GameServicesOnAuthStatusChange`
   - Events:
     - `authenticatedEvent` → `Authenticated`
     - `authenticatingEvent` → (optional) `Authenticating`
     - `notAvailableEvent` → `AuthUnavailable`
2. State: `StartupCheck`
   - Action: `GameServicesIsAuthenticated` → `isAuthenticated`
   - If `true` → `Authenticated`
   - If `false` → `SilentAuthenticate`
3. State: `SilentAuthenticate`
   - Action: `GameServicesAuthenticate` (`interactive = false`)
   - `failureEvent` → `AuthUnavailable`
   - `successEvent` → stay in flow and wait for `AuthListener` events
4. State: `AuthUnavailable`
   - (Optional) Action: `GameServicesGetAuthenticateError` (log `errorDescription`)
   - Decide UX:
     - Continue without Game Services
     - Or show a “Connect” button → `InteractiveAuthenticate`
5. State: `InteractiveAuthenticate` (optional)
   - Action: `GameServicesAuthenticate` (`interactive = true`)
   - Wait for `AuthListener.authenticatedEvent`
6. State: `Authenticated`
   - (Optional) Action: `GameServicesGetLocalPlayerInfo` (display name, player id)

## Notes
- Keep `AuthListener` active for the whole session. Auth status can change at any time.
- If you gate achievements/leaderboards behind login, route those flows to `InteractiveAuthenticate` when needed.
