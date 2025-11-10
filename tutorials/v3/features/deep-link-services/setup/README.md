---
description: "Configuring Deep Link Services"
---

# Setup

## Understanding Deep Link Types

Before configuring, understand the two types of deep links available:

### Custom Scheme URLs (Simple)
Custom scheme URLs use app-specific schemes like `mygame://invite/123`. These are quick to set up but not unique across apps.

**Pros:**
- Simple setup through Essential Kit Settings only
- No backend infrastructure required
- Works immediately after configuration

**Cons:**
- Not unique - other apps can register the same scheme
- If multiple apps use the same scheme, users see a selection dialog
- Less professional for marketing campaigns

**Example:** `mygame://level/5`, `mygame://shop?item=sword`

### Universal Links (Professional)
Universal links use standard web URLs like `https://yourgame.com/invite/123`. These require backend setup but provide a professional experience.

**Pros:**
- Unique to your domain - no conflicts
- Seamless user experience with no selection dialog
- Better for attribution and marketing campaigns
- Falls back to web browser if app is not installed

**Cons:**
- Requires backend server configuration
- More complex setup with domain verification
- Needs separate iOS and Android configuration files

**Example:** `https://yourgame.com/level/5`, `https://yourgame.com/shop/sword`

{% hint style="info" %}
Start with custom scheme URLs for development and testing. Add universal links later for production when you need professional user acquisition.
{% endhint %}

## Prerequisites
- Essential Kit imported into the project from My Assets section of Package Manager
- iOS or Android build target configured in Unity
- For universal links: A web server with HTTPS and the ability to host verification files

## Setup Checklist

### 1. Enable Deep Link Services
Open **Essential Kit Settings** (`Window > Voxel Busters > Essential Kit > Open Settings`), switch to the **Services** tab, and enable **Deep Link Services**.

<figure><img src="../../../.gitbook/assets/deep-link-services-settings.gif" alt=""><figcaption><p>Deep Link Services Settings</p></figcaption></figure>

### 2. Configure Custom Scheme URLs
Under **iOS Properties** and **Android Properties**, add your custom URL schemes:

| Field | Description | Example |
| --- | --- | --- |
| **Identifier** | Display name shown in app chooser dialog if multiple apps register this scheme | "MyGame Deep Link" |
| **Scheme** | Unique scheme name for your app | "mygame" |
| **Host** | Optional host to filter links further | "invite" or leave empty |
| **Path** | Optional path to filter specific actions | "/referral" or leave empty |

**Common Patterns:**
- **Open-ended**: Set only Scheme (`mygame://`) to handle all links
- **Specific actions**: Set Scheme + Host (`mygame://invite/`) for targeted handling
- **Fine-grained**: Set Scheme + Host + Path (`mygame://shop/items`) for precise routing

{% hint style="success" %}
Use a scheme name that's unique to your game. Consider including your studio name or game name: `studiogame://` instead of just `game://`
{% endhint %}

### 3. Configure Universal Links (Optional)
For universal links, you need:

**Essential Kit Configuration:**
- Add universal link definitions in the same way as custom schemes
- Use `https` as the Scheme
- Set your domain as the Host (e.g., `yourgame.com`)
- Set paths to match specific content (e.g., `/invite`, `/level`)

**Backend Configuration:**
See platform-specific guides for backend setup:
- [iOS Universal Links Setup](ios.md)
- [Android App Links Setup](android.md)

### 4. Save and Build
Changes to the settings asset are saved automatically. If you use source control, commit the updated `Resources/EssentialKitSettings.asset` file.

During build, Essential Kit automatically:
- **iOS**: Adds URL schemes to `Info.plist`
- **Android**: Adds intent filters to `AndroidManifest.xml`

## Configuration Reference

| Setting | Platform | Required? | Notes |
| --- | --- | --- | --- |
| Enable Deep Link Services | All | Yes | Toggles the feature in builds; disabling strips related native code |
| iOS Properties | iOS | Yes | Contains custom schemes and universal links for iOS |
| Android Properties | Android | Yes | Contains custom schemes and app links for Android |
| Identifier | All | Yes | Display name for this deep link configuration |
| Service Type | iOS | No | Leave blank unless you need specific iOS service types |
| Scheme | All | Yes | The URL scheme (e.g., "mygame" for mygame://) |
| Host | All | Optional | Filter links by host (e.g., "invite" for mygame://invite/) |
| Path | All | Optional | Filter links by path (e.g., "/referral") |

{% hint style="info" %}
Need a working baseline? Run the sample at `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/DeepLinkServicesDemo.unity` to confirm your settings before integrating into production.
{% endhint %}

{% hint style="warning" %}
Test deep links on actual devices, not just the editor simulator. Platform-specific behavior (like the app chooser dialog) only appears on real devices.
{% endhint %}
