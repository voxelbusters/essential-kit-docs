# App Updater - PlayMaker

Check for new versions and show the native “update app” flow.

## Actions (6)
- `AppUpdaterRequestUpdateInfo` (async): requests update status. Fires `successEvent` / `failureEvent` and caches the result.
- `AppUpdaterGetRequestUpdateInfoSuccessResult` (sync): read cached `updateStatus` after `AppUpdaterRequestUpdateInfo` SUCCESS.
- `AppUpdaterGetRequestUpdateInfoError` (sync): read cached `errorCode` / `errorDescription` after `AppUpdaterRequestUpdateInfo` FAILURE.
- `AppUpdaterPromptUpdate` (async): shows the native update prompt/flow. Fires `successEvent` / `failureEvent` and optional `progressUpdateEvent`.
- `AppUpdaterGetPromptUpdateProgress` (sync): read cached `progress` (0..1) after `progressUpdateEvent` (Android only).
- `AppUpdaterGetPromptUpdateError` (sync): read cached `errorCode` / `errorDescription` after `AppUpdaterPromptUpdate` FAILURE.

## Quick flows

### Check, then prompt (recommended)
1. `AppUpdaterRequestUpdateInfo`
2. `AppUpdaterGetRequestUpdateInfoSuccessResult` → branch by `updateStatus`
3. If update is available, call `AppUpdaterPromptUpdate`

### Forced update with progress (Android)
1. `AppUpdaterPromptUpdate` with `isForceUpdate = true` and `stayActive = true`
2. On `progressUpdateEvent`, call `AppUpdaterGetPromptUpdateProgress` and update your UI.

### Manual “Update App” button
Call `AppUpdaterPromptUpdate` directly from your settings/help screen (and handle FAILURE with `AppUpdaterGetPromptUpdateError`).

## Notes
- `AppUpdaterRequestUpdateInfo` will fail if AppUpdater isn’t available on the current platform.
- Progress updates are typically meaningful only on Android.

## Use cases
Start here: `use-cases/README.md`

