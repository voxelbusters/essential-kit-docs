# Leaderboard Score Submit

## Goal
Report a score and optionally open the native Leaderboard UI.

## Prerequisite
Make sure the player is authenticated first. Use `use-case-1-auth-bootstrap.md` for a safe startup flow.

## Actions used
- `GameServicesReportScore`
- `GameServicesGetReportScoreSuccessResult` (on success)
- `GameServicesGetReportScoreError` (on failure)
- `GameServicesShowLeaderboardUI` (optional)

## Variables
- `leaderboardId` (String) e.g. `"top_scores"`
- `scoreValue` (Int)

## Flow
1. When the match ends (or on a milestone), store the score in `scoreValue`.
2. State: `ReportScore`
   - Action: `GameServicesReportScore`
   - Inputs: `leaderboardId`, `scoreValue` (and optional `tag`)
   - Events:
     - `successEvent` → `GetReportScoreSuccessResult` → (optional) `ShowLeaderboardUI`
     - `failureEvent` → `GetReportScoreError` (log/ignore)
3. State: `ShowLeaderboardUI` (optional)
   - Action: `GameServicesShowLeaderboardUI`
   - Input: `leaderboardId` (to open a specific board)

## Notes
- `GameServicesReportScore` waits for completion. Use the extractor actions immediately after its `successEvent`/`failureEvent`.
- Some platforms keep only the best score; submitting a lower score may not change ranking.
