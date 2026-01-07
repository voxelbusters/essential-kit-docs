# Leaderboard Load Scores (Top / Player Centered)

## Goal
Load leaderboard scores and iterate cached entries to build a custom leaderboard UI.

## Prerequisite
Make sure the player is authenticated first. Use `use-case-1-auth-bootstrap.md`.

## Actions used
- `GameServicesCreateLeaderboard` (cache a leaderboard handle)
- `GameServicesConfigureLeaderboard` (scope/time/query size)
- `GameServicesLeaderboardLoadTopScores` or `GameServicesLeaderboardLoadPlayerCenteredScores`
- `GameServicesGetLeaderboardLoadScoresSuccessResult` (on success; gives `scoreCount`)
- `GameServicesGetLeaderboardLoadScoresError` (on failure)
- `GameServicesGetLeaderboardScoreInfo` (iterate entries)
- (Optional paging) `GameServicesLeaderboardLoadNextPage`, `GameServicesLeaderboardLoadPreviousPage`

## Variables
- `leaderboardId` (String) e.g. `"top_scores"`
- `scoreCount` (Int), `scoreIndex` (Int)
- Per entry: `playerDisplayName` (String), `rank` (Int), `scoreValue` (Int), `formattedScore` (String)

## Flow
1. State: `CreateLeaderboard`
   - Action: `GameServicesCreateLeaderboard` (input: `leaderboardId`)
2. State: `ConfigureLeaderboard` (optional)
   - Action: `GameServicesConfigureLeaderboard`
   - Inputs: `playerScope`, `timeScope`, `querySize`
3. State: `LoadScores`
   - Action: `GameServicesLeaderboardLoadTopScores` (or `...LoadPlayerCenteredScores`)
   - Events:
     - `successEvent` → `GetScoresMetadata`
     - `failureEvent` → `GetLeaderboardLoadScoresError`
4. State: `GetScoresMetadata`
   - Action: `GameServicesGetLeaderboardLoadScoresSuccessResult` → `scoreCount`
   - Set `scoreIndex = 0`
5. Loop:
   - While `scoreIndex < scoreCount`:
     - Action: `GameServicesGetLeaderboardScoreInfo` (input: `scoreIndex`)
     - Add entry to UI
     - `scoreIndex++`

## Notes
- Use paging actions when `scoreCount` is at your `querySize` and you want more results.
- To show native UI instead of building your own, use `GameServicesShowLeaderboardsUI` / `GameServicesShowLeaderboardUI`.
