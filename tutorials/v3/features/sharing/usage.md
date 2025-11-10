---
description: "Sharing Services provides native composers for mail, messages, social media, and generic sharing"
---

# Usage

Essential Kit's Sharing Services wraps platform-specific sharing APIs into a unified interface. Choose the right sharing method based on your use case: MailComposer for emails, MessageComposer for SMS/MMS, SocialShareComposer for specific platforms, or ShareSheet as a generic fallback.

## Table of Contents

- [Understanding Core Concepts](#understanding-core-concepts)
- [Import Namespaces](#import-namespaces)
- [Method 1: ShareSheet (Generic Fallback)](#method-1-sharesheet-generic-fallback)
- [Method 2: MailComposer (Email Sharing)](#method-2-mailcomposer-email-sharing)
- [Method 3: MessageComposer (SMS/MMS Sharing)](#method-3-messagecomposer-smsmms-sharing)
- [Method 4: SocialShareComposer (Platform-Specific Sharing)](#method-4-socialsharecomposer-platform-specific-sharing)
- [Advanced: Smart Sharing Strategy](#advanced-smart-sharing-strategy)
- [ShareItem Advanced Usage](#shareitem-advanced-usage)
- [Data Properties](#data-properties)
- [Core APIs Reference](#core-apis-reference)
- [Result Codes](#result-codes)
- [Error Handling](#error-handling)

## Understanding Core Concepts

- **ShareItem** objects describe the payload (text, URL, screenshot, binary file) independent of the composer you ultimately launch.
- **Composer availability checks** (`MailComposer.CanSendMail()`, `SocialShareComposer.IsComposerAvailable(...)`) prevent dead-end flows on devices without the required apps or accounts.
- **Callback result codes** confirm whether the user completed the share action, allowing you to reward players responsibly.
- **Fallback hierarchies** use specific composers first (better UX) and drop back to `ShareSheet` when the preferred destination is unavailable.

## Import Namespaces
```csharp
using VoxelBusters.EssentialKit;
using VoxelBusters.CoreLibrary;
```

## Understanding ShareItem Objects

All sharing methods accept `ShareItem` objects that encapsulate different content types. Create ShareItems for text, URLs, images, screenshots, and files.

### ShareItem Creation Methods

```csharp
// Text content
var textItem = ShareItem.Text("Your share message here");

// URL links
var urlItem = ShareItem.URL(URLString.URLWithPath("https://www.yourgame.com"));

// Screenshot (captures current screen)
var screenshotItem = ShareItem.Screenshot();

// Image from Texture2D
Texture2D texture = GetYourTexture();
var imageItem = ShareItem.Image(texture, TextureEncodingFormat.PNG, "image.png");

// File data
byte[] fileData = GetYourFileData();
var fileItem = ShareItem.File(fileData, "application/pdf", "document.pdf");
```

{% hint style="info" %}
**ShareItem Combination**: Most sharing methods accept multiple ShareItems in a single call. Combine text with images, URLs with screenshots, etc. Platform capabilities determine which combinations are supported.
{% endhint %}

## Method 1: ShareSheet (Generic Fallback)

ShareSheet presents a native interface showing all installed apps that can handle the shared content. Use as a **fallback** when specific composers don't fit your use case.

### Understanding ShareSheet

ShareSheet is the most flexible sharing method—it adapts to apps installed on the user's device. However, **prefer specific composers** (Mail, Message, Social) when you know the intended destination for better user experience.

**When to Use ShareSheet**:
- Generic sharing when destination is unknown
- Fallback when specific composers are unavailable
- Letting users choose from all possible sharing options

### ShareSheet Static Method

Quick sharing with minimal code:

```csharp
using VoxelBusters.EssentialKit;

public class ShareManager : MonoBehaviour
{
    public void ShareAchievement(int score)
    {
        string shareText = $"I just scored {score} points! Can you beat this?";
        var textItem = ShareItem.Text(shareText);
        var screenshot = ShareItem.Screenshot();

        SharingServices.ShowShareSheet(
            callback: (result) =>
            {
                Debug.Log($"Share sheet closed. Result: {result.ResultCode}");

                if (result.ResultCode == ShareSheetResultCode.Done)
                {
                    Debug.Log("Content shared successfully");
                    RewardPlayer();
                }
                else if (result.ResultCode == ShareSheetResultCode.Cancelled)
                {
                    Debug.Log("User cancelled sharing");
                }
            },
            textItem,
            screenshot
        );
    }

    void RewardPlayer()
    {
        Debug.Log("Rewarding player for sharing");
    }
}
```

### ShareSheet Instance Method

For more control, create a ShareSheet instance:

```csharp
public class ShareSheetExample : MonoBehaviour
{
    public void ShareWithURL()
    {
        ShareSheet shareSheet = ShareSheet.CreateInstance();

        shareSheet.AddText("Check out this amazing game!");
        shareSheet.AddURL(URLString.URLWithPath("https://yourgame.com/download"));
        shareSheet.AddScreenshot();

        shareSheet.SetCompletionCallback((result, error) =>
        {
            if (error == null)
            {
                Debug.Log($"Share sheet result: {result.ResultCode}");
            }
            else
            {
                Debug.LogError($"Share sheet error: {error.Description}");
            }
        });

        shareSheet.Show();
    }
}
```

## Method 2: MailComposer (Email Sharing)

MailComposer provides native email composition with support for recipients, subject, body (HTML or plain text), and attachments. **Best for**: support emails, bug reports, formal communication.

### Checking Mail Availability

Always check before showing the mail composer:

```csharp
if (MailComposer.CanSendMail())
{
    // Device has configured email accounts
    SharingServices.ShowMailComposer(
        toRecipients: new[] { "support@yourgame.com" },
        subject: "Support Request",
        body: "Describe your issue.",
        callback: null
    );
}
else
{
    Debug.LogWarning("No email accounts configured on this device");
    // Show alternative sharing method
    SharingServices.ShowShareSheet(
        callback: null,
        ShareItem.Text("Support request")
    );
}
```

### MailComposer Static Method

Send emails with the convenience method:

```csharp
public class SupportEmailManager : MonoBehaviour
{
    public void SendBugReport(string bugDescription)
    {
        if (!MailComposer.CanSendMail())
        {
            Debug.LogError("Mail not available");
            return;
        }

        string subject = $"Bug Report - {Application.productName}";
        string body = $"Bug Description:\n{bugDescription}\n\nDevice: {SystemInfo.deviceModel}\nOS: {SystemInfo.operatingSystem}";
        var screenshot = ShareItem.Screenshot();

        SharingServices.ShowMailComposer(
            toRecipients: new[] { "support@yourgame.com" },
            ccRecipients: null,
            bccRecipients: null,
            subject: subject,
            body: body,
            isHtmlBody: false,
            callback: (result) =>
            {
                if (result.ResultCode == MailComposerResultCode.Sent)
                {
                    Debug.Log("Bug report sent successfully");
                    ShowThankYouMessage();
                }
                else if (result.ResultCode == MailComposerResultCode.Saved)
                {
                    Debug.Log("Email saved as draft");
                }
                else if (result.ResultCode == MailComposerResultCode.Cancelled)
                {
                    Debug.Log("User cancelled email");
                }
                else if (result.ResultCode == MailComposerResultCode.Failed)
                {
                    Debug.LogError("Email failed to send");
                }
            },
            screenshot
        );
    }

    void ShowThankYouMessage()
    {
        Debug.Log("Thank you for reporting the bug!");
    }
}
```

### MailComposer Instance Method

Build emails step-by-step with more control:

```csharp
public class DetailedEmailComposer : MonoBehaviour
{
    public void SendFeedback(string feedbackText, Texture2D screenshot)
    {
        if (!MailComposer.CanSendMail()) return;

        MailComposer composer = MailComposer.CreateInstance();

        composer.SetToRecipients(new[] { "feedback@yourgame.com" });
        composer.SetCcRecipients(new[] { "team@yourgame.com" });
        composer.SetSubject("Player Feedback");

        // HTML body with formatting
        string htmlBody = $@"
            <html>
            <body>
                <h2>Player Feedback</h2>
                <p><strong>Feedback:</strong> {feedbackText}</p>
                <p><strong>Player ID:</strong> {GetPlayerId()}</p>
                <p><strong>Date:</strong> {DateTime.Now}</p>
            </body>
            </html>
        ";
        composer.SetBody(htmlBody, isHtmlBody: true);

        // Add screenshot attachment
        if (screenshot != null)
        {
            var imageItem = ShareItem.Image(screenshot, TextureEncodingFormat.PNG, "feedback.png");
            string mimeType, fileName;
            byte[] imageData = imageItem.GetFileData(out mimeType, out fileName);
            composer.AddAttachment(imageData, mimeType, fileName);
        }

        composer.SetCompletionCallback((result, error) =>
        {
            Debug.Log($"Mail composer closed: {result.ResultCode}");
        });

        composer.Show();
    }

    string GetPlayerId()
    {
        return "PLAYER_12345"; // Your player ID logic
    }
}
```

## Method 3: MessageComposer (SMS/MMS Sharing)

MessageComposer handles SMS and MMS with text, images, and other attachments. **Best for**: quick invites, sharing screenshots, personal messages.

### Checking Message Capabilities

Message composer has multiple capability checks:

```csharp
if (MessageComposer.CanSendText())
{
    Debug.Log("SMS is available");

    if (MessageComposer.CanSendAttachments())
    {
        Debug.Log("MMS with attachments is supported");
    }

    if (MessageComposer.CanSendSubject())
    {
        Debug.Log("Message subject is supported (platform-specific)");
    }
}
```

### MessageComposer Static Method

Send messages with the convenience method:

```csharp
public class InviteManager : MonoBehaviour
{
    public void SendGameInvite()
    {
        if (!MessageComposer.CanSendText())
        {
            Debug.LogError("Messaging not available");
            return;
        }

        string inviteMessage = $"Join me in {Application.productName}! Download here: https://yourgame.com/download";

        SharingServices.ShowMessageComposer(
            recipients: null, // Let user choose recipients
            subject: MessageComposer.CanSendSubject() ? "Game Invitation" : null,
            body: inviteMessage,
            callback: (result) =>
            {
                if (result.ResultCode == MessageComposerResultCode.Sent)
                {
                    Debug.Log("Invite sent successfully");
                    TrackViralInvitation();
                }
                else if (result.ResultCode == MessageComposerResultCode.Cancelled)
                {
                    Debug.Log("User cancelled message");
                }
                else if (result.ResultCode == MessageComposerResultCode.Failed)
                {
                    Debug.LogError("Message failed to send");
                }
            }
        );
    }

    void TrackViralInvitation()
    {
        Debug.Log("Tracking viral invitation for analytics");
    }
}
```

### MessageComposer Instance Method with Attachments

Send MMS with images:

```csharp
public class MMSShareManager : MonoBehaviour
{
    public void ShareLevelCompletion(int levelNumber, Texture2D levelImage)
    {
        if (!MessageComposer.CanSendText()) return;

        MessageComposer composer = MessageComposer.CreateInstance();

        composer.SetBody($"I just completed Level {levelNumber}!");

        if (MessageComposer.CanSendAttachments() && levelImage != null)
        {
            var imageItem = ShareItem.Image(levelImage, TextureEncodingFormat.JPG, "level.jpg");
            string mimeType, fileName;
            byte[] imageData = imageItem.GetFileData(out mimeType, out fileName);
            composer.AddAttachment(imageData, mimeType, fileName);
        }

        composer.SetCompletionCallback((result, error) =>
        {
            Debug.Log($"Message composer result: {result.ResultCode}");
        });

        composer.Show();
    }
}
```

## Method 4: SocialShareComposer (Platform-Specific Sharing)

SocialShareComposer targets specific social platforms (Facebook, Twitter, WhatsApp). **Best for**: targeted social media posts when you know the destination platform.

### Checking Social Platform Availability

Each platform must be checked individually:

```csharp
bool facebookAvailable = SocialShareComposer.IsComposerAvailable(SocialShareComposerType.Facebook);
bool twitterAvailable = SocialShareComposer.IsComposerAvailable(SocialShareComposerType.Twitter);
bool whatsappAvailable = SocialShareComposer.IsComposerAvailable(SocialShareComposerType.WhatsApp);

Debug.Log($"Facebook: {facebookAvailable}, Twitter: {twitterAvailable}, WhatsApp: {whatsappAvailable}");
```

### Facebook Sharing

{% hint style="danger" %}
**Facebook Policy**: Facebook does not allow pre-filling text in the share dialog. Text ShareItems will be ignored. Only images and URLs can be shared to Facebook.
{% endhint %}

```csharp
public class FacebookShareManager : MonoBehaviour
{
    public void ShareToFacebook(Texture2D achievementImage)
    {
        if (!SocialShareComposer.IsComposerAvailable(SocialShareComposerType.Facebook))
        {
            Debug.LogWarning("Facebook not available, using fallback");
            ShareViaShareSheet();
            return;
        }

        var imageItem = ShareItem.Image(achievementImage, TextureEncodingFormat.PNG, "achievement.png");
        var urlItem = ShareItem.URL(URLString.URLWithPath("https://yourgame.com"));

        SharingServices.ShowSocialShareComposer(
            SocialShareComposerType.Facebook,
            callback: (result) =>
            {
                if (result.ResultCode == SocialShareComposerResultCode.Done)
                {
                    Debug.Log("Shared to Facebook successfully");
                    RewardSocialSharing();
                }
                else if (result.ResultCode == SocialShareComposerResultCode.Cancelled)
                {
                    Debug.Log("Facebook sharing cancelled");
                }
            },
            imageItem,
            urlItem
        );
    }

    void ShareViaShareSheet()
    {
        Debug.Log("Falling back to ShareSheet");
    }

    void RewardSocialSharing()
    {
        Debug.Log("Rewarding player for social share");
    }
}
```

### Twitter Sharing

Twitter supports text, images, and URLs:

```csharp
public class TwitterShareManager : MonoBehaviour
{
    public void ShareToTwitter(int highScore)
    {
        if (!SocialShareComposer.IsComposerAvailable(SocialShareComposerType.Twitter))
        {
            Debug.LogWarning("Twitter not available");
            return;
        }

        string tweetText = $"I just scored {highScore} points in {Application.productName}! #gaming #highscore";
        var textItem = ShareItem.Text(tweetText);
        var screenshotItem = ShareItem.Screenshot();
        var urlItem = ShareItem.URL(URLString.URLWithPath("https://yourgame.com/download"));

        SharingServices.ShowSocialShareComposer(
            SocialShareComposerType.Twitter,
            callback: (result) =>
            {
                Debug.Log($"Twitter share result: {result.ResultCode}");
            },
            textItem,
            screenshotItem,
            urlItem
        );
    }
}
```

### WhatsApp Sharing

WhatsApp supports text and images:

```csharp
public class WhatsAppShareManager : MonoBehaviour
{
    public void ShareToWhatsApp(string gameInvite)
    {
        if (!SocialShareComposer.IsComposerAvailable(SocialShareComposerType.WhatsApp))
        {
            Debug.LogWarning("WhatsApp not installed");
            return;
        }

        var textItem = ShareItem.Text(gameInvite);
        var screenshot = ShareItem.Screenshot();

        SharingServices.ShowSocialShareComposer(
            SocialShareComposerType.WhatsApp,
            callback: (result) =>
            {
                if (result.ResultCode == SocialShareComposerResultCode.Done)
                {
                    Debug.Log("Shared to WhatsApp");
                    TrackWhatsAppShare();
                }
            },
            textItem,
            screenshot
        );
    }

    void TrackWhatsAppShare()
    {
        Debug.Log("Tracking WhatsApp share for analytics");
    }
}
```

{% hint style="warning" %}
**Platform Limitation**: On iOS WhatsApp, you can share either text OR an image, but not both simultaneously. Android WhatsApp supports both. Handle this limitation by prioritizing image over text on iOS.
{% endhint %}

### SocialShareComposer Instance Method

For more control, create composer instances:

```csharp
public class SocialComposerExample : MonoBehaviour
{
    public void ShareWithComposer(SocialShareComposerType platform)
    {
        if (!SocialShareComposer.IsComposerAvailable(platform))
        {
            Debug.LogWarning($"{platform} not available");
            return;
        }

        SocialShareComposer composer = SocialShareComposer.CreateInstance(platform);

        composer.SetText("Amazing game moment!");
        composer.AddURL(URLString.URLWithPath("https://yourgame.com"));
        composer.AddScreenshot();

        composer.SetCompletionCallback((result, error) =>
        {
            if (error == null)
            {
                Debug.Log($"{platform} sharing result: {result.ResultCode}");
            }
            else
            {
                Debug.LogError($"{platform} error: {error.Description}");
            }
        });

        composer.Show();
    }
}
```

## Advanced: Smart Sharing Strategy

Implement fallback logic for best user experience:

```csharp
public class SmartSharingManager : MonoBehaviour
{
    public void ShareAchievement(string achievementName, Texture2D screenshot)
    {
        string shareText = $"I just unlocked the {achievementName} achievement!";
        var textItem = ShareItem.Text(shareText);
        var imageItem = ShareItem.Image(screenshot, TextureEncodingFormat.PNG, "achievement.png");
        var urlItem = ShareItem.URL(URLString.URLWithPath("https://yourgame.com"));

        // Try preferred platforms first
        if (SocialShareComposer.IsComposerAvailable(SocialShareComposerType.Twitter))
        {
            Debug.Log("Sharing via Twitter");
            SharingServices.ShowSocialShareComposer(
                SocialShareComposerType.Twitter,
                callback: (result) => HandleSharingResult("Twitter", result.ResultCode),
                textItem,
                imageItem,
                urlItem
            );
        }
        else if (SocialShareComposer.IsComposerAvailable(SocialShareComposerType.Facebook))
        {
            Debug.Log("Twitter unavailable, trying Facebook");
            SharingServices.ShowSocialShareComposer(
                SocialShareComposerType.Facebook,
                callback: (result) => HandleSharingResult("Facebook", result.ResultCode),
                imageItem,
                urlItem
            );
        }
        else
        {
            Debug.Log("No specific platforms available, using ShareSheet");
            SharingServices.ShowShareSheet(
                callback: (result) => HandleSharingResult("ShareSheet", result.ResultCode),
                textItem,
                imageItem,
                urlItem
            );
        }
    }

    void HandleSharingResult(string platform, object resultCode)
    {
        Debug.Log($"{platform} sharing completed: {resultCode}");
    }
}
```

## ShareItem Advanced Usage

### Converting GIFs to ShareItems

For animated GIF sharing:

```csharp
public void ShareAnimatedGif(string gifFilePath)
{
    SharingServices.ConvertGifToShareItem(
        gifFilePath,
        onSuccess: (shareItem) =>
        {
            Debug.Log("GIF converted successfully");

            SharingServices.ShowShareSheet(
                callback: (result) => Debug.Log($"Shared GIF: {result.ResultCode}"),
                shareItem
            );
        },
        onError: (error) =>
        {
            Debug.LogError($"GIF conversion failed: {error.Description}");
        }
    );
}
```

### Combining Multiple ShareItems

Mix different content types:

```csharp
public void ShareRichContent()
{
    var text = ShareItem.Text("Check out my game progress!");
    var screenshot = ShareItem.Screenshot();
    var url = ShareItem.URL(URLString.URLWithPath("https://yourgame.com"));
    var customImage = ShareItem.Image(GetLogoTexture(), TextureEncodingFormat.PNG, "logo.png");

SharingServices.ShowShareSheet(
    callback: (result) => Debug.Log($"Rich content shared: {result.ResultCode}"),
    text,
    screenshot,
    url,
    customImage
);
}

Texture2D GetLogoTexture()
{
    return Resources.Load<Texture2D>("GameLogo");
}
```

## Data Properties

| Item | Type | Notes |
| --- | --- | --- |
| `ShareItem.Text/URL/Image/File/Screenshot` | Factory Methods | Describe the payload you pass into any composer. You can mix and match multiple `ShareItem` instances per request. |
| `MailComposerResult.ResultCode` | `MailComposerResultCode` | Indicates whether the player sent, saved, cancelled, or failed to send an email. |
| `MessageComposerResult.ResultCode` | `MessageComposerResultCode` | Reports the outcome of SMS/MMS share attempts so you can decide whether to reward the user. |
| `SocialShareComposerResult.ResultCode` | `SocialShareComposerResultCode` | Captures the success/cancel/failure state for each platform-specific composer. |
| `ShareSheetResult.ResultCode` | `ShareSheetResultCode` | Confirms whether the user selected a destination or dismissed the sheet. |
| `MessageComposer.CanSendAttachments()` | `bool` | Tells you whether the device supports MMS attachments—check before adding images or files. |

## Core APIs Reference

| API | Purpose | Returns |
| --- | --- | --- |
| `SharingServices.ShowShareSheet(callback, shareItems)` | Show generic share sheet | void (result via callback) |
| `SharingServices.ShowMailComposer(to, cc, bcc, subject, body, isHtml, callback, shareItems)` | Show mail composer | void (result via callback) |
| `SharingServices.ShowMessageComposer(recipients, subject, body, callback, shareItems)` | Show message composer | void (result via callback) |
| `SharingServices.ShowSocialShareComposer(platform, callback, shareItems)` | Show social composer | void (result via callback) |
| `MailComposer.CanSendMail()` | Check email availability | `bool` |
| `MessageComposer.CanSendText()` | Check SMS availability | `bool` |
| `MessageComposer.CanSendAttachments()` | Check MMS availability | `bool` |
| `MessageComposer.CanSendSubject()` | Check subject support | `bool` |
| `SocialShareComposer.IsComposerAvailable(platform)` | Check social platform | `bool` |
| `ShareItem.Text(string)` | Create text item | `ShareItem` |
| `ShareItem.URL(URLString)` | Create URL item | `ShareItem` |
| `ShareItem.Screenshot()` | Create screenshot item | `ShareItem` |
| `ShareItem.Image(Texture2D, format, filename)` | Create image item | `ShareItem` |
| `ShareItem.File(byte[], mimeType, filename)` | Create file item | `ShareItem` |

## Result Codes

Different composers return different result codes:

**ShareSheetResultCode**:
- `Done` - User completed sharing
- `Cancelled` - User cancelled
- `Unknown` - Platform did not provide a result (treat as failure or retry)

**MailComposerResultCode**:
- `Sent` - Email sent successfully
- `Saved` - Email saved as draft
- `Cancelled` - User cancelled
- `Failed` - Email failed to send

**MessageComposerResultCode**:
- `Sent` - Message sent
- `Cancelled` - User cancelled
- `Failed` - Message failed

**SocialShareComposerResultCode**:
- `Done` - Shared successfully
- `Cancelled` - User cancelled
- `Failed` - Sharing failed

## Error Handling

| Scenario | Trigger | Recommended Action |
| --- | --- | --- |
| Mail composer unavailable | `MailComposer.CanSendMail()` returns `false` (no account configured) | Present a friendly message and fall back to `ShareSheet` or in-game referral codes. |
| MMS attachments unsupported | `MessageComposer.CanSendAttachments()` returns `false` | Share text-only invites or direct players to email/social options that support media. |
| Social composer missing | `SocialShareComposer.IsComposerAvailable` returns `false` | Offer a fallback (ShareSheet) or hide the specific platform button for that player. |
| Share sheet reports `Unknown` | Destination app did not expose the result | Log `result.ResultCode` for analytics and let the player retry with a different destination. |
| Push-style reward logic misfires | Result callback returns `Cancelled` | Only reward players when result codes indicate success (`Done`, `Sent`), and communicate the requirement in your UI. |

## Advanced: Manual Initialization

{% hint style="warning" %}
Manual initialization is only needed for specific runtime scenarios. For most games, Essential Kit's automatic initialization handles everything. **Skip this section unless** you need runtime configuration or custom sharing settings.
{% endhint %}

### Implementation

```csharp
void Awake()
{
    var settings = new SharingServicesUnitySettings(isEnabled: true);
    SharingServices.Initialize(settings);
}
```

{% hint style="info" %}
Call `Initialize()` once before using Sharing Services features. Most games should use the [standard setup](setup.md) configured in Essential Kit Settings instead.
{% endhint %}

## Related Guides
- Demo scene: `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/SharingDemo.unity`
- Use with **Media Services** to share captured screenshots and videos
- Pair with **Network Services** to verify connectivity before sharing
- See [Testing Guide](testing.md) for device testing checklist
