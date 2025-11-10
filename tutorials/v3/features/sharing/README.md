---
description: "Cross-platform social sharing and native composer integration for Unity mobile games"
---

# Sharing Services for Unity

Essential Kit's Sharing Services feature provides native sharing capabilities for Unity games across iOS and Android. This tutorial walks you through choosing the right sharing method (ShareSheet, MailComposer, MessageComposer, SocialShareComposer), sharing content types (text, images, screenshots), and implementing viral growth strategies that feel natural to players.

{% embed url="https://www.youtube.com/watch?v=KGlEt183pwk" %}
Sharing Services Video Tutorial
{% endembed %}

{% hint style="info" %}
Looking for a working reference? Open the demo scene at `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/SharingDemo.unity` and the companion script at `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scripts/SharingDemo.cs` to see the full API in action.
{% endhint %}

## What You'll Learn
- Choose the right sharing method for your use case (Mail, Message, Social, or ShareSheet)
- Create ShareItem objects for different content types (text, images, screenshots, files)
- Implement platform-specific social media composers (Facebook, Twitter, WhatsApp)
- Compose emails and SMS messages with attachments
- Handle sharing results and track viral growth
- Share achievements, scores, and screenshots effectively

## Why Sharing Services Matters
- **Viral Growth**: Players sharing achievements drive organic user acquisition
- **Social Proof**: Screenshots and scores create social validation for your game
- **Personal Invitations**: Direct messaging converts better than generic social posts
- **Player Engagement**: Sharing moments creates emotional investment in your game
- **Community Building**: Social features strengthen player relationships and retention

## Choosing the Right Sharing Method

Essential Kit provides four sharing approaches optimized for different scenarios:

| Method | Best For | Platform Support |
| --- | --- | --- |
| **MailComposer** | Support emails, bug reports, formal communication with attachments | iOS, Android (requires configured email account) |
| **MessageComposer** | Quick invites, SMS/MMS sharing with images | iOS, Android (requires messaging app) |
| **SocialShareComposer** | Targeted posts to specific platforms (Facebook, Twitter, WhatsApp) | iOS, Android (requires app installed) |
| **ShareSheet** | Generic fallback when destination unknown, lets user choose any installed app | iOS, Android |

{% hint style="success" %}
**Selection Rule**: Prefer **specific composers** (Mail, Message, Social) when you know the intended destination. Use **ShareSheet** as a fallback for general sharing when the specific method doesn't fit your use case.
{% endhint %}

## Tutorial Roadmap
1. [Setup](setup.md) - Enable the feature and understand platform configuration
2. [Usage](usage.md) - Implement all sharing methods with ShareItem creation patterns
3. [Testing](testing.md) - Device testing checklist and result validation
4. [FAQ](faq.md) - Troubleshoot common issues and platform limitations

## Key Use Cases

### Achievement Sharing
Celebrate player accomplishments with screenshots and compelling descriptions:
```csharp
// Player unlocks rare achievement
if (SocialShareComposer.IsComposerAvailable(SocialShareComposerType.Facebook))
{
    string text = $"I just unlocked the Legendary Hero achievement in {gameName}!";
    var textItem = ShareItem.Text(text);
    var screenshot = ShareItem.Screenshot();

    SharingServices.ShowSocialShareComposer(
        SocialShareComposerType.Facebook,
        callback: (result) => {
            if (result.ResultCode == SocialShareComposerResultCode.Done) {
                Debug.Log("Grant sharing reward to the player.");
            }
        },
        textItem,
        screenshot
    );
}
```

### Support Emails
Send bug reports with screenshots and log data:
```csharp
if (MailComposer.CanSendMail())
{
    string subject = $"Bug Report - Level {currentLevel}";
    string body = $"Encountered issue at {DateTime.Now}. Screenshot attached.";
    var screenshot = ShareItem.Screenshot();

    SharingServices.ShowMailComposer(
        toRecipients: new[] { "support@yourgame.com" },
        subject: subject,
        body: body,
        callback: (result) => {
            Debug.Log($"Support email result: {result.ResultCode}");
        },
        screenshot
    );
}
```

### Friend Invitations
Personalized invites via SMS with app download links:
```csharp
if (MessageComposer.CanSendText())
{
    string invite = $"Join me in {gameName}! Download: {appStoreUrl}";

    SharingServices.ShowMessageComposer(
        body: invite,
        callback: (result) => {
            if (result.ResultCode == MessageComposerResultCode.Sent) {
                Debug.Log("Track viral invitation event.");
            }
        }
    );
}
```

### Generic Sharing (Fallback)
Let users choose any sharing destination:
```csharp
string shareText = $"Check out my high score in {gameName}: {playerScore}!";
var textItem = ShareItem.Text(shareText);
var screenshotItem = ShareItem.Screenshot();

SharingServices.ShowShareSheet(
    callback: (result) => {
        Debug.Log($"Share sheet result: {result.ResultCode}");
    },
    textItem,
    screenshotItem
);
```

## Share Item Types

Essential Kit supports multiple content types for sharing:

| ShareItem Type | Creation Method | Use Cases |
| --- | --- | --- |
| **Text** | `ShareItem.Text(string)` | Messages, descriptions, URLs as text |
| **URL** | `ShareItem.URL(URLString)` | Deep links, website links, download links |
| **Screenshot** | `ShareItem.Screenshot()` | Capture current game state automatically |
| **Image** | `ShareItem.Image(Texture2D, format, filename)` | Custom images, logos, avatars |
| **File** | `ShareItem.File(byte[], mimeType, filename)` | Save files, documents, replays |

## Prerequisites
- Unity project with Essential Kit v3 installed and Sharing Services feature included
- iOS or Android target platform configured
- Understanding of when to use specific composers vs generic ShareSheet

{% hint style="warning" %}
**Platform Requirements**: Email requires configured email accounts on device. SMS requires messaging capabilities. Social composers require respective apps installed and user logged in.
{% endhint %}

{% content-ref url="setup.md" %}
[Setup](setup.md)
{% endcontent-ref %}

{% content-ref url="usage.md" %}
[Usage](usage.md)
{% endcontent-ref %}

{% content-ref url="testing.md" %}
[Testing](testing.md)
{% endcontent-ref %}

{% content-ref url="faq.md" %}
[FAQ](faq.md)
{% endcontent-ref %}
