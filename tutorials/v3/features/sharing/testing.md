---
description: "Validating sharing integration before release"
---

# Testing & Validation

Use these checks to confirm your Sharing Services integration before release.

## Device Testing Checklist

### ShareSheet Functionality
- [ ] ShareSheet displays when called
- [ ] Available apps populate based on content type
- [ ] Text sharing works correctly
- [ ] Image sharing displays screenshots properly
- [ ] URL sharing opens links in target apps
- [ ] Combined content (text + image + URL) shares correctly
- [ ] ShareSheet dismisses properly on cancel
- [ ] Callback reports correct result codes (Done, Cancelled)

### Mail Composer
- [ ] `MailComposer.CanSendMail()` returns correct status
- [ ] Mail composer displays with all configured fields
- [ ] To, CC, BCC recipients populate correctly
- [ ] Subject line appears as configured
- [ ] Plain text body displays correctly
- [ ] HTML body renders with formatting
- [ ] Screenshot attachments appear in email
- [ ] Image attachments attach properly
- [ ] File attachments (PDFs, etc.) attach correctly
- [ ] Multiple attachments work together
- [ ] Sent email callback reports `MailComposerResultCode.Sent`
- [ ] Cancelled email callback reports `MailComposerResultCode.Cancelled`
- [ ] Saved draft callback reports `MailComposerResultCode.Saved`

### Message Composer
- [ ] `MessageComposer.CanSendText()` returns correct status
- [ ] `MessageComposer.CanSendAttachments()` reports MMS capability
- [ ] `MessageComposer.CanSendSubject()` reports subject support
- [ ] Message composer displays correctly
- [ ] Recipients field populates (if provided)
- [ ] Message body text appears correctly
- [ ] Subject appears (on platforms that support it)
- [ ] Image attachments work in MMS
- [ ] Screenshot attachments attach properly
- [ ] Sent message callback reports `MessageComposerResultCode.Sent`
- [ ] Cancelled message callback reports `MessageComposerResultCode.Cancelled`

### Social Share Composer - Facebook
- [ ] `SocialShareComposer.IsComposerAvailable(Facebook)` checks installation
- [ ] Facebook composer opens when app is installed
- [ ] Image sharing works to Facebook
- [ ] URL sharing works to Facebook
- [ ] Text is correctly ignored (Facebook policy)
- [ ] Done callback fires after successful share
- [ ] Cancelled callback fires when user cancels
- [ ] Fallback to ShareSheet when Facebook unavailable

### Social Share Composer - Twitter
- [ ] `SocialShareComposer.IsComposerAvailable(Twitter)` checks installation
- [ ] Twitter composer opens when app is installed
- [ ] Text sharing works with character limits respected
- [ ] Image sharing works to Twitter
- [ ] URL sharing works to Twitter
- [ ] Combined text + image + URL works
- [ ] Done callback fires after successful tweet
- [ ] Cancelled callback fires when user cancels

### Social Share Composer - WhatsApp
- [ ] `SocialShareComposer.IsComposerAvailable(WhatsApp)` checks installation
- [ ] WhatsApp composer opens when app is installed
- [ ] Text sharing works to WhatsApp
- [ ] Image sharing works to WhatsApp
- [ ] Text + image works on Android
- [ ] Text OR image limitation respected on iOS
- [ ] URL sharing works to WhatsApp
- [ ] Done callback fires after successful share
- [ ] Cancelled callback fires when user cancels

## Platform-Specific Checks

### iOS Testing
- [ ] Share sheet uses native `UIActivityViewController`
- [ ] Mail composer uses `MFMailComposeViewController`
- [ ] Message composer uses `MFMessageComposeViewController`
- [ ] Social composers use native iOS sharing
- [ ] All composers dismiss correctly
- [ ] Result callbacks fire on all platforms
- [ ] Screenshot capture quality is acceptable
- [ ] Sharing respects iOS app privacy settings

### Android Testing
- [ ] Share sheet uses `Intent.createChooser()`
- [ ] Intent sharing shows installed apps only
- [ ] Mail intent launches email clients correctly
- [ ] Message intent launches SMS/MMS apps correctly
- [ ] Social sharing launches respective apps
- [ ] Android back button dismisses composers
- [ ] Result codes match expected values (note: Android may not report some statuses)
- [ ] MIME types are recognized correctly

## Content Testing

### Text Sharing
- [ ] Short text (< 280 characters) shares completely
- [ ] Long text shares without truncation
- [ ] Special characters (emoji, symbols) display correctly
- [ ] URLs in text are clickable in recipients
- [ ] Newlines and formatting preserved

### Image Sharing
- [ ] PNG images share with transparency preserved
- [ ] JPEG images share with acceptable quality
- [ ] Large images (> 5MB) share successfully or show error
- [ ] Screenshots capture correctly on different resolutions
- [ ] Portrait and landscape orientations captured correctly
- [ ] Image dimensions suitable for target platforms

### URL Sharing
- [ ] HTTPS URLs share and open correctly
- [ ] HTTP URLs share (if allowed by platform)
- [ ] Deep links share correctly
- [ ] App Store/Play Store links open correctly
- [ ] URL previews generate in supporting apps

### File Sharing
- [ ] PDF files share correctly
- [ ] Custom MIME types recognized by target apps
- [ ] File names preserve correctly
- [ ] Binary data integrity maintained
- [ ] GIF conversion works for animated GIFs

## Error Testing

Test error handling for common failures:
- [ ] Sharing with no email accounts configured handled gracefully
- [ ] Sharing to unavailable social platform shows error/fallback
- [ ] Network offline doesn't crash sharing
- [ ] Invalid image data shows appropriate error
- [ ] Oversized attachments handled with error message
- [ ] Malformed URLs handled correctly

```csharp
// Test error scenarios
if (!MailComposer.CanSendMail())
{
    Debug.Log("Expected: No email configured");
    // Verify fallback behavior works
}

if (!SocialShareComposer.IsComposerAvailable(SocialShareComposerType.Facebook))
{
    Debug.Log("Expected: Facebook not installed");
    // Verify fallback to ShareSheet works
}
```

## Cross-Platform Testing

Test sharing content between platforms:
- [ ] Share from iOS device, receive on Android device
- [ ] Share from Android device, receive on iOS device
- [ ] Images display correctly across platforms
- [ ] Links open correctly on both platforms
- [ ] Text formatting consistent across platforms

## Result Callback Testing

Verify all result codes are handled:

```csharp
void TestShareSheetCallbacks()
{
    SharingServices.ShowShareSheet(
        callback: (result, error) =>
        {
            if (error != null)
            {
                Debug.LogError($"Share sheet error: {error.Description}");
                return;
            }

            switch (result.ResultCode)
            {
                case ShareSheetResultCode.Done:
                    Debug.Log("✓ Share completed");
                    break;
                case ShareSheetResultCode.Cancelled:
                    Debug.Log("✓ Share cancelled by user");
                    break;
                case ShareSheetResultCode.Unknown:
                    Debug.LogError("✓ Share reported unknown result - verify error handling");
                    break;
            }
        },
        shareItems: new[]
        {
            ShareItem.Text("Test"),
        }
    );
}

void TestMailComposerCallbacks()
{
    SharingServices.ShowMailComposer(
        toRecipients: new[] { "test@test.com" },
        subject: "Test",
        body: "Testing mail callbacks",
        callback: (result, error) =>
        {
            if (error != null)
            {
                Debug.LogError($"Mail composer error: {error.Description}");
                return;
            }

            switch (result.ResultCode)
            {
                case MailComposerResultCode.Sent:
                    Debug.Log("✓ Email sent");
                    break;
                case MailComposerResultCode.Saved:
                    Debug.Log("✓ Email saved as draft");
                    break;
                case MailComposerResultCode.Cancelled:
                    Debug.Log("✓ Email cancelled");
                    break;
                case MailComposerResultCode.Failed:
                    Debug.LogError("✓ Email failed - verify error handling");
                    break;
            }
        }
    );
}
```

## Pre-Submission Review
- [ ] Test on physical devices (iOS and Android) at minimum supported OS versions
- [ ] Verify all sharing methods work on devices with different app configurations
- [ ] Test with email accounts configured and unconfigured
- [ ] Test with social apps installed and uninstalled
- [ ] Verify sharing doesn't crash on any tested device
- [ ] Confirm all callbacks execute and report correct result codes
- [ ] Test sharing during different network conditions (WiFi, cellular, offline)
- [ ] Verify shared content appears correctly in recipient apps

## Common Test Scenarios

### Achievement Sharing Flow
```
1. Player unlocks achievement
2. Show sharing prompt
3. User selects Facebook
4. Verify IsComposerAvailable() returns true
5. Show SocialShareComposer with achievement text and screenshot
6. User completes share
7. Callback receives SocialShareComposerResultCode.Done
8. Reward player for sharing
9. Track analytics event
```

### Bug Report Flow
```
1. User encounters bug
2. User taps "Report Bug" button
3. Check MailComposer.CanSendMail()
4. Show mail composer with bug details and screenshot
5. User sends email
6. Callback receives MailComposerResultCode.Sent
7. Show "Thank you" message
8. Track support request
```

### Viral Invitation Flow
```
1. User taps "Invite Friends"
2. Show platform selection (Message, WhatsApp, ShareSheet)
3. User selects SMS
4. Check MessageComposer.CanSendText()
5. Show message composer with invite text
6. User sends to friends
7. Callback receives MessageComposerResultCode.Sent
8. Track invitation for viral analytics
```

### Fallback Strategy Flow
```
1. User tries to share to Twitter
2. Check SocialShareComposer.IsComposerAvailable(Twitter)
3. Twitter not installed (returns false)
4. Automatically fall back to ShareSheet
5. Show ShareSheet with same content
6. User shares via alternative app
7. Callback receives ShareSheetResultCode.Done
8. Track platform used for analytics
```

## Troubleshooting Test Failures

If sharing doesn't work or composers don't appear:

1. **Verify Feature Enabled**: Check Essential Kit Settings has Sharing Services enabled
2. **Check Device Capabilities**: Verify device has required apps/accounts configured
3. **Test with Demo Scene**: Run `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/SharingDemo.unity`
4. **Platform Logs**: Check Xcode console (iOS) or logcat (Android) for errors
5. **Capability Checks**: Always call `CanSendMail()`, `IsComposerAvailable()` before showing composers
6. **Image Quality**: Verify images aren't too large (> 10MB may fail)
7. **MIME Types**: Ensure file MIME types are correct for platform

### Debug Logging

Add extensive logging to track sharing flow:

```csharp
void ShareWithLogging()
{
    Debug.Log("[Sharing] Starting share process");

    if (MailComposer.CanSendMail())
    {
        Debug.Log("[Sharing] Mail composer available");
        SharingServices.ShowMailComposer(
            toRecipients: new[] { "test@test.com" },
            subject: "Test",
            body: "Test body",
            callback: (result, error) =>
            {
                if (error != null)
                {
                    Debug.LogError($"[Sharing] Mail error: {error.Description}");
                    return;
                }
                Debug.Log($"[Sharing] Mail result: {result.ResultCode}");
                if (result.ResultCode == MailComposerResultCode.Failed)
                {
                    Debug.LogError("[Sharing] Mail failed - check device settings");
                }
            }
        );
    }
    else
    {
        Debug.LogWarning("[Sharing] Mail composer NOT available - no email configured");
    }
}
```

{% hint style="success" %}
**Testing Tip**: Start with ShareSheet for basic functionality, then test specific composers. ShareSheet always works if content is valid, making it good for baseline testing before moving to platform-specific composers.
{% endhint %}

## Related Guides
- [Setup Guide](setup.md) - Verify configuration before testing
- [Usage Guide](usage.md) - Review implementation patterns
- [FAQ](faq.md) - Solutions for common test failures
