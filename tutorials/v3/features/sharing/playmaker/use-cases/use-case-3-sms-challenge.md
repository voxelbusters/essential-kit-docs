# SMS Challenge Invite

## Goal
Check if messaging is available, then open the message composer with a pre-filled invite.

## Actions used
- `MessageComposerCanSend`
- `MessageComposerShow`
- `MessageComposerGetError` (optional)

## Variables
- `canSendText` (Bool)

## Flow
1. State: `CanSendMessage`
   - Action: `MessageComposerCanSend`
   - Events:
     - `canSendEvent` → `ShowMessageComposer`
     - `cannotSendEvent` → show “Messaging not available”
2. State: `ShowMessageComposer`
   - Action: `MessageComposerShow`
   - Inputs:
     - `recipients` (optional)
     - `body` (invite text)
   - Events:
     - `closedWithSentEvent` → Sent
     - `closedWithCancelledEvent` → Cancelled
     - `closedWithUnknownEvent` → Unknown (optional handling)
     - `closedWithFailedEvent` → `MessageComposerGetError` (optional) then show error

## Notes
- `MessageComposerResultCode.Unknown` can occur on platforms that don’t provide a definitive result.
