# Mail Composer

## What is Mail Composer?

Mail Composer provides native email composition functionality for Unity mobile games. It enables players to send emails directly from your game using their device's configured email accounts, with full attachment support for screenshots, files, and custom content.

## Why Use Mail Composer in Unity Mobile Games?

Mail Composer is essential for Unity mobile games because it enables direct player communication, bug reporting with visual context, personalized game invitations, and seamless feedback collection through the familiar email interface players already use.

## Core Mail Composer APIs

### Availability Check

Always verify email capability before showing the composer:

```csharp
if (MailComposer.CanSendMail())
{
    Debug.Log("Device can send email");
}
```

### Basic Email Composition  

```csharp
MailComposer composer = MailComposer.CreateInstance();
composer.SetToRecipients("support@game.com");
composer.SetSubject("Game Feedback");
composer.SetBody("Great Unity game!", false);
composer.Show();
```

This snippet creates a mail composer, sets the recipient and content, then displays the native email interface.

### Email with Screenshot

Unity mobile games often need to attach screenshots for bug reports:

```csharp
MailComposer composer = MailComposer.CreateInstance();
composer.SetSubject("Bug Report");
composer.AddScreenshot("bug.png");
composer.Show();
```

The `AddScreenshot()` method automatically captures and attaches the current screen.

### Multiple Recipients

Set different recipient types for comprehensive communication:

```csharp
MailComposer composer = MailComposer.CreateInstance();
composer.SetToRecipients("player@example.com");
composer.SetCcRecipients("team@example.com"); 
composer.SetBccRecipients("analytics@example.com");
composer.Show();
```

This snippet demonstrates setting To, CC, and BCC recipients in one email.

### File Attachments

Attach game data or custom files:

```csharp
byte[] saveData = GetGameSaveData();
MailComposer composer = MailComposer.CreateInstance();
composer.AddAttachment(saveData, "application/json", "save.json");
composer.Show();
```

This snippet attaches binary game data as a JSON file to the email.

### Result Handling

Handle composer results to track user actions:

```csharp
composer.SetCompletionCallback(OnMailResult);

private void OnMailResult(MailComposerResult result, Error error)
{
    Debug.Log($"Mail result: {result.ResultCode}");
}
```

Result codes include `Sent`, `Cancelled`, `Saved`, and `Failed` for comprehensive tracking.

📌 **Video Note:** Show Unity demo clip of mail composer with screenshot attachment and result handling.

---

**Next:** [Message Composer - SMS Integration for Unity Games](03-MessageComposer.md)