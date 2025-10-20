# Message Composer

## What is Message Composer?

Message Composer provides native SMS and messaging functionality for Unity mobile games. It enables players to send text messages and multimedia content directly from your game using their device's messaging apps, with support for both SMS and platform-specific messaging features like iMessage.

## Why Use Message Composer in Unity Mobile Games?

Message Composer is valuable for Unity mobile games because it enables quick friend invitations, instant score sharing, viral content distribution, and direct player-to-player communication through the messaging platforms players use daily.

## Core Message Composer APIs

### Availability Checks

Check messaging capabilities before presenting options:

```csharp
if (MessageComposer.CanSendText())
{
    Debug.Log("Device can send text messages");
}

if (MessageComposer.CanSendAttachments())
{
    Debug.Log("Device supports message attachments");  
}
```

### Basic Text Message

```csharp
MessageComposer composer = MessageComposer.CreateInstance();
composer.SetRecipients("1234567890");
composer.SetBody("Check out this Unity game!");
composer.Show();
```

This snippet creates a message composer, sets the recipient and content, then displays the native messaging interface.

### Message with Subject (iOS)

On iOS, iMessage supports subject lines:

```csharp
MessageComposer composer = MessageComposer.CreateInstance();
composer.SetRecipients("1234567890");
if (MessageComposer.CanSendSubject())
{
    composer.SetSubject("Game Invitation");
}
composer.SetBody("Join me in this Unity game!");
composer.Show();
```

This snippet demonstrates conditional subject setting based on platform capabilities.

### Message with Screenshot

Share game moments through messaging:

```csharp
MessageComposer composer = MessageComposer.CreateInstance();
composer.SetBody("Amazing level completion!");
composer.AddScreenshot("victory.png");
composer.Show();
```

The screenshot is automatically captured and attached to the message.

### Multiple Recipients

Send messages to multiple contacts:

```csharp
MessageComposer composer = MessageComposer.CreateInstance();
composer.SetRecipients("1234567890", "0987654321");
composer.SetBody("New high score: 10,000 points!");
composer.Show();
```

This snippet sends the same message to multiple recipients simultaneously.

### Image Attachments

Attach custom images to messages:

```csharp
Texture2D gameImage = GetAchievementImage();
MessageComposer composer = MessageComposer.CreateInstance();
composer.AddImage(gameImage, "achievement.png");
composer.SetBody("Unlocked new achievement!");
composer.Show();
```

This snippet attaches a custom image texture to the message.

### Result Handling

Track message composer results:

```csharp
composer.SetCompletionCallback(OnMessageResult);

private void OnMessageResult(MessageComposerResult result, Error error)
{
    Debug.Log($"Message result: {result.ResultCode}");
}
```

Result codes include `Sent`, `Cancelled`, and `Failed` for tracking user actions.

📌 **Video Note:** Show Unity demo of message composer on both iOS and Android with different attachment types.

---

**Next:** [Share Sheet - Universal Sharing for Unity Games](04-ShareSheet.md)