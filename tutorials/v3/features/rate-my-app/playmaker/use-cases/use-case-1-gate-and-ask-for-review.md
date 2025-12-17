# Gate And Ask For Review

## Goal
Check if you’re allowed to show the review prompt, then request it at a good moment.

## Actions Used
- `RateMyAppIsAllowed`
- `RateMyAppAskForReview`

## Variables
- `isAllowed` (Bool) - output from `RateMyAppIsAllowed`

## FSM Steps
1. **GoodMoment** (level complete / success screen): call `RateMyAppIsAllowed`.
2. **If allowed**: call `RateMyAppAskForReview` (set `skipConfirmation` based on your UX).
3. **If not allowed**: do nothing and continue.

## Notes
- “Prompt shown” means the request was made; iOS/Android may throttle review prompts.
- Configure Rate My App constraints in Essential Kit Settings (cooldowns, limits, etc.).
