# SharingServices Use Cases

Quick-start guides for sharing content via native share mechanisms using PlayMaker custom actions.

## Available Use Cases

### 1. [Screenshot Share](use-case-1-screenshot-share.md)

- **What it does:** Share screenshots with text and URL via native share sheet
- **Actions:** 2 (ShareSheetShow, ShareSheetGetError)

### 2. [Bug Report Email](use-case-2-bug-report-email.md)

- **What it does:** Send pre-filled email with attachments
- **Actions:** 2 (MailComposerCanSend, MailComposerShow)

### 3. [SMS Challenge Invite](use-case-3-sms-challenge.md)

- **What it does:** Send challenge codes via text message
- **Actions:** 3 (MessageComposerCanSend, MessageComposerShow, MessageComposerGetError)

### 4. [Social Media Post](use-case-4-social-post.md)

- **What it does:** Share directly to Facebook, Twitter, or WhatsApp
- **Actions:** 3 (SocialComposerIsComposerAvailable, SocialShareComposerShow, SocialShareComposerGetError)

## Quick Action Reference
| Action | Purpose |
|--------|---------|
| ShareSheetShow | Generic share sheet (all platforms) |
| ShareSheetGetError | Read cached error after ShareSheetShow failed |
| MailComposerCanSend | Check if email is available |
| MailComposerShow | Show email composer |
| MailComposerGetError | Read cached error after MailComposerShow failed |
| MessageComposerCanSend | Check if SMS/iMessage is available |
| MessageComposerShow | Show SMS/iMessage composer |
| MessageComposerGetError | Read cached error after MessageComposerShow failed |
| SocialComposerIsComposerAvailable | Check social platform availability |
| SocialShareComposerShow | Show platform-specific composer |
| SocialShareComposerGetError | Read cached error after SocialShareComposerShow failed |

## Related Documentation
- Feature overview: `../README.md`
