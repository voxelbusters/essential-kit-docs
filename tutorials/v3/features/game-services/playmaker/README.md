# Game Services - PlayMaker

Authenticate and use platform game services (Game Center / Google Play Games): achievements, leaderboards, friends, and server credentials.

## Key patterns
- `GameServicesAuthenticate.successEvent` only means the request was dispatched. Wait for `GameServicesOnAuthStatusChange.authenticatedEvent` before calling authenticated-only actions.
- Keep `GameServicesOnAuthStatusChange` in a state that stays active for the session; auth status can change at any time.
- Most “load/report” actions already wait for completion and cache results; use the matching `GameServicesGet*` extractor actions immediately after SUCCESS/FAILURE.

## Action groups (quick reference)
- Auth: `GameServicesAuthenticate`, `GameServicesOnAuthStatusChange`, `GameServicesIsAuthenticated`, `GameServicesSignout`, `GameServicesGetAuthenticateError`, `GameServicesGetLocalPlayerInfo`
- Achievements: `GameServicesReportAchievementProgress`, `GameServicesGetReportAchievementProgressError`, `GameServicesShowAchievementsUI`
- Leaderboards: `GameServicesReportScore`, `GameServicesGetReportScoreSuccessResult`, `GameServicesGetReportScoreError`, `GameServicesCreateLeaderboard`, `GameServicesConfigureLeaderboard`, score loading + iterators, `GameServicesShowLeaderboardsUI` / `GameServicesShowLeaderboardUI`
- Friends: `GameServicesLoadFriends`, `GameServicesGetLoadFriendsSuccessResult`, `GameServicesGetLoadFriendsError`, `GameServicesGetFriendInfo`, `GameServicesAddFriend`
- Server credentials: `GameServicesLoadServerCredentials`, `GameServicesGetLoadServerCredentialsSuccessResult`, `GameServicesGetLoadServerCredentialsError`

## Use cases
Start here: `use-cases/README.md`
