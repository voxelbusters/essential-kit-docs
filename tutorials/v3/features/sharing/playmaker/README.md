# Sharing Services - PlayMaker

Share content via native share sheet, email, messages, or a platform-specific social composer.

## Actions (11)
- Mail: `MailComposerCanSend`, `MailComposerShow`, `MailComposerGetError`
- Message: `MessageComposerCanSend`, `MessageComposerShow`, `MessageComposerGetError`
- Share sheet: `ShareSheetShow`, `ShareSheetGetError`
- Social: `SocialComposerIsComposerAvailable`, `SocialShareComposerShow`, `SocialShareComposerGetError`

## Key patterns
- `MailComposerCanSend` and `SocialComposerIsComposerAvailable` are synchronous checks (outputs only). Branch using the bool output.
- Composer/show actions fire “closed” events that match the result code (`Done/Sent/Cancelled/Failed/Unknown`).
- Use the matching `*GetError` action on the `closedWithFailedEvent` branch to extract error details.

## Use cases
Start here: `use-cases/README.md`
