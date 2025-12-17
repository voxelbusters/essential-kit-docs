# AppUpdater Use Cases

Quick-start guides for checking app updates and prompting updates using PlayMaker custom actions.

## Available Use Cases

### 1. [Request Update Info And Prompt](use-case-1-request-update-info-and-prompt.md)
**What it does:** End-to-end flow: check update status and (optionally) prompt the user to update
**Actions:** 3 (`AppUpdaterRequestUpdateInfo`, `AppUpdaterGetRequestUpdateInfoSuccessResult`, `AppUpdaterPromptUpdate`)

### 2. [Silent Policy Check](use-case-2-silent-policy-check.md)
**What it does:** Check for updates periodically without blocking UI
**Actions:** 2 (`AppUpdaterRequestUpdateInfo`, `AppUpdaterGetRequestUpdateInfoSuccessResult`)

### 3. [Prompt Update (Manual Trigger)](use-case-3-prompt-update.md)
**What it does:** Trigger a store update prompt from a settings/help screen
**Actions:** 1 (`AppUpdaterPromptUpdate`)

## Quick Action Reference
| Action | Purpose |
|--------|---------|
| AppUpdaterRequestUpdateInfo | Request update status (cached) |
| AppUpdaterGetRequestUpdateInfoSuccessResult | Read cached update status after success |
| AppUpdaterGetRequestUpdateInfoError | Read cached error after request failure |
| AppUpdaterPromptUpdate | Show native update prompt / flow |
| AppUpdaterGetPromptUpdateProgress | Read cached progress (Android only) |
| AppUpdaterGetPromptUpdateError | Read cached error after prompt failure |

## Output Variables
| Variable | Type | Description |
|----------|------|-------------|
| updateStatus | Enum (AppUpdaterUpdateStatus) | `Available` / `NotAvailable` / `InProgress` / `Downloaded` |
| progress | Float (0..1) | PromptUpdate progress (Android only) |

## Best Practices
- Check once per day maximum
- Show forced updates immediately
- Allow users to dismiss optional updates
- Track last check time in PlayerPrefs
- Don't interrupt critical user flows
- Test update flows with TestFlight/internal testing

## Platform Support
- **iOS**: App Store version checking
- **Android**: Google Play Store version checking
- Both platforms require network connection

## Related Documentation
- **[README.md](../README.md)**
