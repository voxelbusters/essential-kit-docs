# Friends List Display

## Goal
Load the player’s friends list and iterate it to populate your UI.

## Prerequisite
Make sure the player is authenticated first. Use `use-case-1-auth-bootstrap.md` for a safe startup flow.

## Actions used
- `GameServicesLoadFriends`
- `GameServicesGetLoadFriendsSuccessResult` (on success; gives `friendsCount`)
- `GameServicesGetLoadFriendsError` (on failure)
- `GameServicesGetFriendInfo` (iterate friends)

## Variables
- `friendsCount` (Int)
- `friendIndex` (Int)
- `playerId` (String), `displayName` (String), `alias` (String)

## Flow
1. State: `LoadFriends`
   - Action: `GameServicesLoadFriends`
   - Events:
     - `successEvent` → `GetFriendsCount`
     - `failureEvent` → `GetLoadFriendsError` (or show “no friends”)
2. State: `GetFriendsCount`
   - Action: `GameServicesGetLoadFriendsSuccessResult` → `friendsCount`
   - Set `friendIndex = 0`
3. Loop:
   - While `friendIndex < friendsCount`:
     - Action: `GameServicesGetFriendInfo` (input: `friendIndex`)
     - Read outputs: `playerId`, `displayName`, `alias`
     - Add to UI
     - `friendIndex++`

## Notes
- Friend lists can be empty due to privacy settings or no friends on the service.
- Refresh only when needed; `GameServicesLoadFriends` clears and repopulates the cached list.
