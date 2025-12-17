# Request Update Info And Prompt (End-to-end)

## Goal
Check App Store/Play Store for newer app version and prompt user to update if available.

This use-case intentionally combines:
- the “check” part (UseCase2)
- the “prompt” part (UseCase3)

If you only need one side of the flow, use those focused use-cases instead.

## Actions Required
| Action | Purpose |
|--------|---------|
| AppUpdaterRequestUpdateInfo | Query store for update status (cached) |
| AppUpdaterGetRequestUpdateInfoSuccessResult | Read updateStatus after SUCCESS |
| AppUpdaterPromptUpdate | Show native update prompt/flow |
| AppUpdaterGetRequestUpdateInfoError | Read error after FAILURE (optional) |
| AppUpdaterGetPromptUpdateError | Read error after prompt FAILURE (optional) |

## Variables Needed
- updateStatus (Enum: AppUpdaterUpdateStatus)
- isForceUpdate (Bool) (your policy)

## Implementation Steps

### 1. RequestUpdateInfo (Entry State)
**Action:** AppUpdaterRequestUpdateInfo
- **Events:**
  - successEvent → GetStatus
  - failureEvent → (Optional) ReadRequestError

### 2. GetStatus
**Action:** AppUpdaterGetRequestUpdateInfoSuccessResult
- **Outputs:**
  - updateStatus → updateStatus

### 3. EvaluateStatus
- If updateStatus == Available or Downloaded → PromptUpdate
- Else → ContinueNormal

### 4. PromptUpdate
**Action:** AppUpdaterPromptUpdate
- **Inputs:**
  - isForceUpdate: isForceUpdate
  - promptTitle / promptMessage: optional
- **Events:**
  - successEvent → ContinueNormal
  - failureEvent → (Optional) ReadPromptError
  - progressUpdateEvent → (Optional) UpdateUIProgress (Android only)

### 5. (Optional) ReadRequestError / ReadPromptError
- Use **AppUpdaterGetRequestUpdateInfoError** / **AppUpdaterGetPromptUpdateError** to read `errorCode` + `errorDescription`.

### 6. ContinueNormal
Proceed to main app experience

## Common Issues
- **Network dependency**: Requires internet connection
- **Store caching**: Version info may lag actual deployment
- **Frequency**: Check on app launch, not mid-session
- **User experience**: Don't spam update prompts

## Platform Behavior
- **iOS**: Opens App Store app page
- **Android**: Opens Google Play Store app page

## Use When
- App launch (cold start only)
- After resuming from background (optional)
- Critical security patches
- Breaking backend API changes
