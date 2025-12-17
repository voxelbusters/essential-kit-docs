# Prompt Update (Manual Trigger)

## Goal
Prompt the user to update from a settings/help screen.

## Actions Required
| Action | Purpose |
|--------|---------|
| AppUpdaterPromptUpdate | Show native update prompt/flow |
| AppUpdaterGetPromptUpdateError | Read cached error after failure (optional) |
| AppUpdaterGetPromptUpdateProgress | Read cached progress (Android only, optional) |

## Variables Needed
- progress (Float) (Android only, optional)

## Implementation Steps

### 1. UserPressedUpdateButton (Entry State)
From your Settings screen, when user presses “Check for Updates” / “Update App”:
- Go to PromptUpdate

### 2. PromptUpdate
**Action:** AppUpdaterPromptUpdate
- **Inputs:**
  - isForceUpdate: false
  - promptTitle / promptMessage: optional
- **Events:**
  - successEvent → Done
  - failureEvent → (Optional) ReadPromptError
  - progressUpdateEvent → (Optional) UpdateProgressUI (Android only)

### 3. (Optional) UpdateProgressUI
**Action:** AppUpdaterGetPromptUpdateProgress
- **Outputs:**
  - progress → progress

### 4. (Optional) ReadPromptError
**Action:** AppUpdaterGetPromptUpdateError
- **Outputs:** errorCode, errorDescription

## Common Issues
- **App backgrounding**: App may go to background during the update flow
- **Platform support**: PromptUpdate behavior differs between iOS/Android

## Platform Differences
- **iOS**: Typically opens App Store / update prompt UI
- **Android**: Uses Play Core update flow (progressUpdateEvent supported)

## Use When
- User-initiated “Update App” action
- Support/help flows directing users to update
