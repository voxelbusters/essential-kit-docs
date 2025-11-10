---
description: "Configuring WebView for web content display"
---

# Setup

## Prerequisites
- Essential Kit imported into the project from My Assets section of Package Manager
- iOS builds use WKWebView (iOS 11+)
- Android builds use Android WebView with hardware acceleration

## Setup Checklist
1. Open **Essential Kit Settings** (`Window > Voxel Busters > Essential Kit > Open Settings`), switch to the **Services** tab, and enable **WebView**
2. Configure Android-specific options if needed (camera, microphone, back button navigation)
3. Essential Kit automatically adds required permissions and frameworks during build
4. Changes to the settings asset are saved automatically. If you use source control, commit the updated `Resources/EssentialKitSettings.asset` file

### Configuration Reference
| Setting | Platform | Required? | Notes |
| --- | --- | --- | --- |
| Enable WebView | All | Yes | Toggles the feature in builds; disabling strips related native code |
| Uses Camera | Android | Optional | Enable if web content needs camera access; adds CAMERA permission |
| Uses Microphone | Android | Optional | Enable if web content needs microphone access; adds RECORD_AUDIO permission |
| Allow Back Navigation Key | Android | Optional | If enabled, hardware back button navigates to previous web page instead of hiding web view |

{% hint style="success" %}
**Android Permissions**: Only enable camera and microphone if your web content actually uses them (video chat, camera uploads). Essential Kit automatically adds the required Android permissions when enabled.
{% endhint %}

{% hint style="warning" %}
**Back Button Behavior**: By default, Android's back button closes the web view. Enable "Allow Back Navigation Key" if you want it to navigate backward through web page history (like a browser).
{% endhint %}

### Platform-Specific Notes

#### iOS
- Uses `WKWebView` (modern WebKit-based web view)
- Automatically links `WebKit.framework` during build
- Supports JavaScript, CSS3, HTML5 with full iOS Safari capabilities
- App Transport Security requires HTTPS URLs (or Info.plist exceptions for HTTP)

#### Android
- Uses Android `WebView` with hardware acceleration
- Automatically adds `INTERNET` permission to AndroidManifest.xml during build
- JavaScript must be explicitly enabled via `webView.JavaScriptEnabled = true`
- Supports all modern web standards with Chrome WebView engine

{% hint style="info" %}
**HTTPS Requirement (iOS)**: iOS App Transport Security (ATS) blocks HTTP URLs by default. Use HTTPS for all web content or add ATS exceptions to Info.plist for specific domains.
{% endhint %}

{% hint style="info" %}
Need a working baseline? Run the sample at `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/WebViewDemo.unity` to confirm your settings before wiring the feature into production screens. **Note**: This requires building to a device as WebView doesn't work in Unity Editor.
{% endhint %}
