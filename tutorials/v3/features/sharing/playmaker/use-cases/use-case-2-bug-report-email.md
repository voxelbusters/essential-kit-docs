# Bug Report Email

## Goal
Check if mail is available, then open the mail composer with pre-filled details.

## Actions used
- `MailComposerCanSend`
- `MailComposerShow`
- `MailComposerGetError` (optional)

## Variables
- `canSend` (Bool)

## Flow
1. State: `CanSendMail`
   - Action: `MailComposerCanSend` → `canSend`
   - Branch:
     - If `canSend` → `ShowMailComposer`
     - Else → show “Mail not configured”
2. State: `ShowMailComposer`
   - Action: `MailComposerShow`
   - Example inputs:
     - `toRecipients`: `["support@mygame.com"]`
     - `subject`: `"Bug Report"`
     - `body`: `"Describe the issue..."`
     - `addScreenshot`: `true` (optional)
   - Events:
     - `closedWithSentEvent` → Sent
     - `closedWithSavedEvent` → Saved draft
     - `closedWithCancelledEvent` → Cancelled
     - `closedWithUnknownEvent` → Unknown (optional handling)
     - `closedWithFailedEvent` → `MailComposerGetError` (optional) then show error

## Notes
- “Sent” means the user queued the email in the outbox; delivery is handled by the mail client/network.
