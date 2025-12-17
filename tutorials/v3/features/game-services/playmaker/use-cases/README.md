# GameServices Use Cases

Quick-start guides showing minimal implementations of Game Center/Google Play Games features using PlayMaker custom actions.

## Important (auth listener action)
`GameServicesOnAuthStatusChange` should be registered in a state that stays active. Don’t treat `GameServicesAuthenticate.successEvent` as “logged in”; it only confirms the request was dispatched.

## Available Use Cases
1. [Auth Bootstrap (Safe Startup Login)](use-case-1-auth-bootstrap.md)
2. [Achievement Unlock (Report Progress)](use-case-2-achievement-unlock.md)
3. [Leaderboard Score Submit](use-case-3-leaderboard-submit.md)
4. [Leaderboard Load Scores (Top / Player Centered)](use-case-4-leaderboard-load-scores.md)
5. [Server Credentials (Backend Sign-In)](use-case-5-server-credentials.md)
6. [Friends List Display](use-case-6-friends-display.md)

## Related Documentation
- Feature overview: `../README.md`
