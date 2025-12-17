# Achievement Unlock (Report Progress)

## Goal
Report achievement progress and optionally show the native Achievements UI.

## Prerequisite
Make sure the player is authenticated first. Use `use-case-1-auth-bootstrap.md` for a safe startup flow (don’t rely on `GameServicesAuthenticate.successEvent` as “authenticated”).

## Actions used
- `GameServicesReportAchievementProgress`
- `GameServicesGetReportAchievementProgressError` (on failure)
- `GameServicesShowAchievementsUI` (optional)

## Variables
- `achievementId` (String) e.g. `"first_victory"`
- `percentComplete` (Float) 0–100

## Flow
1. When the achievement condition is met, go to `ReportAchievementProgress`.
2. State: `ReportAchievementProgress`
   - Action: `GameServicesReportAchievementProgress`
   - Inputs: `achievementId`, `percentComplete` (use `100` to unlock)
   - Events:
     - `successEvent` → (optional) `ShowAchievementsUI` or back to gameplay
     - `failureEvent` → `GetReportAchievementProgressError` (log/ignore)
3. State: `ShowAchievementsUI` (optional)
   - Action: `GameServicesShowAchievementsUI`

## Notes
- Incremental achievements: report `25`, `50`, … until `100`.
- If the player is not authenticated, `GameServicesReportAchievementProgress` fails immediately; decide whether to silently skip or prompt login via your auth bootstrap.
