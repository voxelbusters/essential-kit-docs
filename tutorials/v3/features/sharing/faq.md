---
description: "Common Sharing Services issues and solutions"
---

# FAQ & Troubleshooting

### Why doesn't text appear in my Facebook share?
Facebook policy prohibits pre-filling share dialogs with text. As per [Facebook's documentation](https://developers.facebook.com/docs/apps/review/prefill/), only images and URLs can be shared—text must be entered manually by the user.

**Solution**: For Facebook sharing, use images and URLs. Add text descriptions to your game's post-share screen instead of trying to pre-fill Facebook text.

```csharp
// Facebook: Images and URLs only
if (SocialShareComposer.IsComposerAvailable(SocialShareComposerType.Facebook))
{
    var imageItem = ShareItem.Screenshot();
    var urlItem = ShareItem.URL(URLString.URLWithPath("https://yourgame.com"));

    // Text will be ignored by Facebook
    SharingServices.ShowSocialShareComposer(
        SocialShareComposerType.Facebook,
        callback: null,
        imageItem,
        urlItem
    );
}
```

### When should I use ShareSheet vs specific composers?
Use the decision tree:

**Use Specific Composers (MailComposer, MessageComposer, SocialShareComposer) when**:
- You know the intended destination (email for support, SMS for invites, Facebook for achievements)
- You want to pre-fill specific fields (email subject, message body)
- You need platform-specific features (email attachments, HTML formatting)
- Better user experience with targeted sharing flow

**Use ShareSheet when**:
- Destination is unknown or varies by user preference
- Specific composer is unavailable (fallback scenario)
- Maximum flexibility for user choice
- Quick general sharing without specific requirements

```csharp
// Good: Specific use case with fallback
if (MailComposer.CanSendMail())
{
    SharingServices.ShowMailComposer(
        toRecipients: new[] { "support@yourgame.com" },
        subject: "Support Request",
        body: "Describe your issue.",
        callback: null
    );
}
else
{
    SharingServices.ShowShareSheet(
        callback: null,
        ShareItem.Text("Support request")
    );
}
```

### How can I detect if the user actually shared the content?
Detection varies by platform:

**iOS**: Result callbacks reliably report share status:
```csharp
SharingServices.ShowShareSheet(
    callback: (result) =>
    {
        if (result.ResultCode == ShareSheetResultCode.Done)
        {
            Debug.Log("User completed sharing on iOS");
            Debug.Log("Reward the user for sharing.");
        }
    },
    ShareItem.Text("Share content")
);
```

**Android**: Result detection is limited. Android's sharing system doesn't always report whether content was actually shared or just viewed. The callback may fire when the share sheet closes, regardless of whether sharing completed.

**Best Practice**: On Android, assume sharing succeeded when the result callback fires, or don't gate rewards strictly on confirmed sharing. iOS provides reliable confirmation.

### Why doesn't MailComposer show on my device?
MailComposer requires configured email accounts on the device. If none are configured, `MailComposer.CanSendMail()` returns `false`.

**Solution**: Always check before showing:
```csharp
if (MailComposer.CanSendMail())
{
    SharingServices.ShowMailComposer(
        toRecipients: new[] { "support@yourgame.com" },
        subject: "Support Request",
        body: "Describe your issue.",
        callback: null
    );
}
else
{
    ShowMessage("Please configure an email account in Settings");
    // Offer alternative sharing method
    SharingServices.ShowShareSheet(
        callback: null,
        ShareItem.Text("Support request")
    ); // Fallback
}
```

**Device Setup**:
- **iOS**: Settings → Mail → Accounts → Add Account
- **Android**: Settings → Accounts → Add Account → Email

### Can I share both text and image to WhatsApp on iOS?
No. WhatsApp on iOS only accepts either text OR an image in a single share, not both. Android WhatsApp supports both simultaneously.

**Solution**: Prioritize image over text on iOS, or let user choose:
```csharp
void ShareToWhatsApp(string text, Texture2D image)
{
    if (!SocialShareComposer.IsComposerAvailable(SocialShareComposerType.WhatsApp))
    {
        return;
    }

#if UNITY_IOS
    // iOS: Choose image or text (image typically more valuable)
    var imageItem = ShareItem.Image(image, TextureEncodingFormat.PNG, "share.png");
    SharingServices.ShowSocialShareComposer(
        SocialShareComposerType.WhatsApp,
        callback: null,
        imageItem
    );
#elif UNITY_ANDROID
    // Android: Both work
    var textItem = ShareItem.Text(text);
    var imageItem = ShareItem.Image(image, TextureEncodingFormat.PNG, "share.png");
    SharingServices.ShowSocialShareComposer(
        SocialShareComposerType.WhatsApp,
        callback: null,
        textItem,
        imageItem
    );
#endif
}
```

### Why doesn't MessageComposer support subject on Android?
SMS (Short Message Service) doesn't have a subject field—only MMS (Multimedia Messaging Service) supports subjects on some platforms. Android SMS typically doesn't support subjects.

**Solution**: Check capability before setting subject:
```csharp
if (MessageComposer.CanSendText())
{
    string subject = null;

    if (MessageComposer.CanSendSubject())
    {
        subject = "Game Invitation";
        Debug.Log("Subject supported on this platform");
    }
    else
    {
        Debug.Log("Subject not supported - using body only");
    }

    SharingServices.ShowMessageComposer(
        recipients: null,
        subject: subject,
        body: "Join me in the game!",
        callback: null
    );
}
```

### How do I share high-resolution screenshots without quality loss?
Use PNG format for lossless compression:

```csharp
public void ShareHighQualityScreenshot()
{
    // Screenshot() captures current screen automatically
    var screenshot = ShareItem.Screenshot();

    SharingServices.ShowShareSheet(
        callback: (result) => Debug.Log($"Screenshot shared: {result.ResultCode}"),
        screenshot
    );
}
```

For custom images, use PNG encoding:
```csharp
Texture2D highResTexture = GetHighResTexture();
var imageItem = ShareItem.Image(
    highResTexture,
    TextureEncodingFormat.PNG, // Lossless
    "highres.png"
);
```

**Note**: Some platforms (like Twitter, Facebook) may automatically compress images on their end. Essential Kit preserves quality up to the sharing point.

### Can I customize the appearance of ShareSheet?
No. ShareSheet uses the native platform UI (`UIActivityViewController` on iOS, `Intent.createChooser()` on Android) which cannot be customized. The appearance is controlled by the OS.

**What you can control**:
- Content shared (text, images, URLs)
- Which apps are available (based on content type)
- Excluded activity types (iOS only, advanced)

**What you cannot control**:
- UI appearance, colors, layout
- Button positions or labels
- Available app order

### How do I share files like PDFs or documents?
Use `ShareItem.File()` with appropriate MIME type:

```csharp
public void SharePDF()
{
    // Load your PDF data
    byte[] pdfData = GetPDFData();

    var fileItem = ShareItem.File(
        pdfData,
        "application/pdf",
        "document.pdf"
    );

    SharingServices.ShowShareSheet(
        callback: (result) => Debug.Log($"PDF shared: {result.ResultCode}"),
        fileItem
    );
}

byte[] GetPDFData()
{
    // Your PDF loading logic
    return System.IO.File.ReadAllBytes(Application.persistentDataPath + "/doc.pdf");
}
```

**Common MIME types**:
- PDF: `application/pdf`
- Text: `text/plain`
- JSON: `application/json`
- ZIP: `application/zip`
- CSV: `text/csv`

### Why does my social composer say platform is unavailable?
`SocialShareComposer.IsComposerAvailable()` returns `false` when:
1. The app is not installed on the device
2. The user is not logged into the app
3. The platform doesn't support sharing via the iOS/Android sharing API

**Solution**: Always check availability and provide fallback:
```csharp
if (SocialShareComposer.IsComposerAvailable(SocialShareComposerType.Twitter))
{
    SharingServices.ShowSocialShareComposer(
        SocialShareComposerType.Twitter,
        callback: result => Debug.Log($"Twitter share: {result.ResultCode}"),
        ShareItem.Text("Join me in the game!")
    );
}
else
{
    Debug.Log("Twitter unavailable, using ShareSheet fallback");
    SharingServices.ShowShareSheet(
        callback: result => Debug.Log($"ShareSheet fallback: {result.ResultCode}"),
        ShareItem.Text("Join me in the game!")
    ); // Let user choose other apps
}
```

### Can I share without showing any UI?
No. Native sharing APIs require user interaction and UI presentation for privacy and security reasons. Silent background sharing is not permitted by iOS or Android.

All sharing methods (`ShowShareSheet`, `ShowMailComposer`, `ShowMessageComposer`, `ShowSocialShareComposer`) display native UI that the user must interact with.

### How do I track which platform users shared to?
Platform tracking is limited:

**iOS ShareSheet**: Result code indicates success/failure but not which app was selected.

**Android ShareSheet**: Similar limitations—result indicates closure but not destination app.

**Specific Composers**: You know the platform (Mail, SMS, Facebook, etc.) because you explicitly called that composer.

**Best Practice**: Track by composer type rather than destination app:
```csharp
void TrackSharing(string composerType, object resultCode)
{
    Debug.Log($"Sharing via {composerType}: {resultCode}");
    // Send to analytics: composer type, result code, content type
}

// Track specific composer
SharingServices.ShowSocialShareComposer(
    SocialShareComposerType.Twitter,
    callback: (result) => TrackSharing("Twitter", result.ResultCode),
    ShareItem.Text("Share text")
);
```

### Why are my email attachments too large to send?
Email services have attachment size limits (typically 10-25MB depending on email provider).

**Solution**: Compress images before sharing:
```csharp
public void ShareCompressedScreenshot()
{
    Texture2D screenshot = CaptureScreenshot();

    // Use JPEG with quality setting for smaller file size
    var compressedImage = ShareItem.Image(
        screenshot,
        TextureEncodingFormat.JPG, // JPEG compresses better than PNG
        "screenshot.jpg"
    );

    SharingServices.ShowMailComposer(
        toRecipients: new[] { "support@yourgame.com" },
        subject: "Screenshot",
        body: "Compressed screenshot attached",
        callback: (result) => Debug.Log($"Email result: {result.ResultCode}"),
        compressedImage
    );
}

Texture2D CaptureScreenshot()
{
    // Your screenshot capture logic
    return ScreenCapture.CaptureScreenshotAsTexture();
}
```

**File size tips**:
- Use JPEG for photos/screenshots (smaller than PNG)
- Use PNG only when transparency is needed
- Resize large textures before converting to ShareItem
- Compress binary files before creating ShareItem

### Can I pre-fill recipients in MessageComposer?
Yes, but user can always modify:

```csharp
SharingServices.ShowMessageComposer(
    recipients: new[] { "+1234567890", "+0987654321" },
    subject: null,
    body: "Join my game!",
    callback: (result) => Debug.Log($"Message result: {result.ResultCode}")
);
```

**Note**: Recipient field is pre-filled but not locked—user can add/remove recipients before sending. This is intentional for privacy reasons.

### Does ShareSheet work in Unity Editor?
No. ShareSheet and all sharing composers require native platform APIs that are only available when built to iOS or Android devices.

**Testing Workflow**:
1. Build to physical device (iOS or Android)
2. Install and launch
3. Test sharing functionality on device
4. Monitor result callbacks

**Editor Behavior**: Calling sharing methods in Editor may show warnings or do nothing. Always test on devices.

### How do I handle sharing errors gracefully?
Implement comprehensive error handling:

```csharp
public void ShareWithErrorHandling()
{
    // Check capabilities first
    if (!MailComposer.CanSendMail())
    {
        ShowMessage("Email not available. Please configure an email account.");
        return;
    }

    SharingServices.ShowMailComposer(
        toRecipients: new[] { "support@game.com" },
        subject: "Support Request",
        body: "Describe your issue here",
        callback: (result) =>
        {
            switch (result.ResultCode)
            {
                case MailComposerResultCode.Sent:
                    ShowMessage("Thank you! Your email was sent.");
                    break;

                case MailComposerResultCode.Saved:
                    ShowMessage("Email saved as draft");
                    break;

                case MailComposerResultCode.Cancelled:
                    Debug.Log("User cancelled email");
                    break;

                case MailComposerResultCode.Failed:
                    ShowMessage("Email failed to send. Please try again.");
                    // Offer alternative (ShareSheet)
                    OfferAlternativeSharing();
                    break;
            }
        }
    );
}

void ShowMessage(string message)
{
    Debug.Log($"[User Message] {message}");
    // Show in-game message UI
}

void OfferAlternativeSharing()
{
    // Fallback to ShareSheet
    SharingServices.ShowShareSheet(
        callback: (result) => Debug.Log($"ShareSheet fallback: {result.ResultCode}"),
        ShareItem.Text("Support request")
    );
}
```

### Can I share animated GIFs?
Yes, using the GIF conversion method:

```csharp
public void ShareAnimatedGif()
{
    string gifPath = Application.persistentDataPath + "/animation.gif";

    SharingServices.ConvertGifToShareItem(
        gifPath,
        onSuccess: (shareItem) =>
        {
            Debug.Log("GIF converted successfully");

            SharingServices.ShowShareSheet(
                callback: (result) => Debug.Log($"GIF shared: {result.ResultCode}"),
                shareItem
            );
        },
        onError: (error) =>
        {
            Debug.LogError($"GIF conversion failed: {error.Description}");
            ShowMessage("Could not share GIF. Please try a different format.");
        }
    );
}
```

**Note**: Not all platforms/apps support animated GIFs. Some may convert to static images.

### Where can I confirm plugin behavior versus my implementation?
Run `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/SharingDemo.unity` on a physical device. If the sample works but your implementation doesn't:

- Compare capability checking (`CanSendMail()`, `IsComposerAvailable()`)
- Verify ShareItem creation (correct MIME types, valid data)
- Check callback implementation (correct result code handling)
- Confirm you're testing on device, not in Editor
- Validate image sizes (not exceeding platform limits)
- Ensure proper result code comparisons in callbacks
