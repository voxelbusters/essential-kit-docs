---
description: "Configuring Sharing Services for social and native sharing"
---

# Setup

## Prerequisites
- Essential Kit imported into the project from My Assets section of Package Manager
- iOS and Android build targets configured
- No external accounts required for basic sharing functionality

## Setup Checklist
1. Open **Essential Kit Settings** (`Window > Voxel Busters > Essential Kit > Open Settings`), switch to the **Services** tab, and enable **Sharing Services**
2. Essential Kit automatically configures platform-specific sharing frameworks during build
3. Changes to the settings asset are saved automatically. If you use source control, commit the updated `Resources/EssentialKitSettings.asset` file

### Configuration Reference
| Setting | Platform | Required? | Notes |
| --- | --- | --- | --- |
| Enable Sharing Services | All | Yes | Toggles the feature in builds; disabling strips related native code |

{% hint style="success" %}
**Zero Configuration Required**: Sharing Services has no additional configuration options. Simply enable the feature and all sharing methods become available immediately.
{% endhint %}

### Platform-Specific Notes

#### iOS
- Automatically configures `Social.framework` and `MessageUI.framework` during build
- Social media composers use native iOS sharing frameworks
- Mail composer uses `MFMailComposeViewController`
- Message composer uses `MFMessageComposeViewController`
- ShareSheet uses `UIActivityViewController` with all available sharing services
- **No app-specific configuration needed** - iOS sharing works out of the box

#### Android
- Automatically configures Android Intent sharing system during build
- Uses `Intent.ACTION_SEND` and `Intent.ACTION_SENDTO` for sharing
- ShareSheet presents `Intent.createChooser()` with installed apps
- Mail composer uses email client intents
- Message composer uses SMS/MMS intents
- Social composers launch respective apps via package-specific intents
- **No additional permissions required** for basic sharing functionality

{% hint style="info" %}
**App Availability**: Social media sharing requires users to have the respective apps installed (Facebook, Twitter, WhatsApp). Email requires configured email accounts. SMS requires messaging capabilities. ShareSheet adapts to available apps on each device.
{% endhint %}

## What Happens During Build

Essential Kit's build pipeline automatically:
- **iOS**: Links `Social.framework` and `MessageUI.framework`, configures sharing capabilities
- **Android**: Sets up Intent filters for sharing, configures package queries for social apps

You don't need to manually configure Xcode projects or Android manifests—Essential Kit handles all platform setup transparently.

## Capability Checking

Before showing composers, check device capabilities to provide fallback options:

**Mail Composer**:
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
    Debug.Log("No email accounts configured");
    // Show alternative sharing method
}
```

**Message Composer**:
```csharp
if (MessageComposer.CanSendText())
{
    Debug.Log("SMS available");

    if (MessageComposer.CanSendAttachments())
    {
        Debug.Log("MMS with attachments supported");
    }

    if (MessageComposer.CanSendSubject())
    {
        Debug.Log("Message subject supported");
    }
}
```

**Social Share Composer**:
```csharp
if (SocialShareComposer.IsComposerAvailable(SocialShareComposerType.Facebook))
{
    Debug.Log("Facebook sharing available");
}

if (SocialShareComposer.IsComposerAvailable(SocialShareComposerType.Twitter))
{
    Debug.Log("Twitter sharing available");
}

if (SocialShareComposer.IsComposerAvailable(SocialShareComposerType.WhatsApp))
{
    Debug.Log("WhatsApp sharing available");
}
```

{% hint style="warning" %}
**Always Check Availability**: Different devices have different apps installed and services configured. Always check capability before showing composers and provide fallback options like ShareSheet for better user experience.
{% endhint %}

## Testing Setup

Test sharing on physical devices with various configurations:
- **Device with no email accounts**: Test mail composer unavailability fallback
- **Device with social apps installed**: Verify social composers appear
- **Device with minimal apps**: Test ShareSheet shows only available options
- **iOS and Android devices**: Verify platform-specific behaviors

{% hint style="info" %}
Need a working baseline? Run the sample at `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/SharingDemo.unity` to confirm your settings before implementing sharing features in your game.
{% endhint %}

## Next Steps
After enabling Sharing Services in settings:
1. Review [Usage Guide](usage.md) to understand all sharing methods
2. Implement capability checking before showing composers
3. Test on physical devices with different app configurations
4. Implement fallback sharing options for unavailable composers
