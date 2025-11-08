---
description: "Configuring Game Services for iOS Game Center and Android Play Games"
---

# Setup

Game Services requires platform-specific configuration in App Store Connect (iOS) and Google Play Console (Android), plus Essential Kit settings configuration.

## Prerequisites
- Essential Kit imported into the project from My Assets section of Package Manager
- iOS builds require Game Center configuration in App Store Connect
- Android builds require Play Games Services setup in Google Play Console
- Leaderboards and achievements must be created on both platforms with unique IDs

## Setup Checklist
1. **Platform Configuration**: Configure leaderboards and achievements in App Store Connect and Google Play Console (see platform-specific guides below)
2. **Enable Feature**: Open **Essential Kit Settings** (`Window > Voxel Busters > Essential Kit > Open Settings`), switch to the **Services** tab, and enable **Game Services**
3. **Add Definitions**: In Game Services settings, add leaderboard and achievement definitions matching your platform configurations
4. **Configure Properties**: Set achievement completion banner preference and friends access permissions
5. **Verify Settings**: Changes save automatically. If using source control, commit the updated `Resources/EssentialKitSettings.asset` file

## Platform-Specific Setup

Game Services requires creating leaderboards and achievements on each platform's developer console before configuring Essential Kit.

{% content-ref url="ios.md" %}
[iOS Game Center Setup](ios.md)
{% endcontent-ref %}

{% content-ref url="android.md" %}
[Android Play Games Setup](android.md)
{% endcontent-ref %}

## Essential Kit Configuration

After creating leaderboards and achievements in platform dashboards, configure them in Essential Kit Settings.

<figure><img src="../../../.gitbook/assets/game-services-settings.gif" alt="" width="563"><figcaption><p>Game Services Settings</p></figcaption></figure>

### Leaderboard Configuration

Each leaderboard needs a common ID for your code and platform-specific IDs matching your dashboard configuration.

**Example Configuration:**
```
Leaderboard ID: "high_score"
├─ iOS Platform ID: "com.yourcompany.yourgame.highscore"
├─ Android Platform ID: "CgkI7_abc123HIGHSCORE"
└─ Title: "High Scores"
```

**To add leaderboards:**
1. In Game Services settings, click **Add Leaderboard**
2. Set **Id** - common identifier used in code (e.g., "high_score")
3. Enter **iOS Platform ID** from App Store Connect Game Center configuration
4. Enter **Android Platform ID** from Google Play Console leaderboards
5. Set **Title** for debugging reference (optional)

![Add a leaderboard](../../../.gitbook/assets/GameServicesAddLeaderboard.gif)

### Achievement Configuration

Each achievement needs a common ID for your code and platform-specific IDs from platform dashboards.

**Example Configuration:**
```
Achievement ID: "first_win"
├─ iOS Platform ID: "com.yourcompany.yourgame.firstwin"
├─ Android Platform ID: "CgkI7_ghi789FIRSTWIN"
├─ Title: "First Victory"
└─ Steps to Unlock: 1 (use >1 for incremental achievements)
```

**To add achievements:**
1. In Game Services settings, click **Add Achievement**
2. Set **Id** - common identifier used in code (e.g., "first_win")
3. Enter **iOS Platform ID** from App Store Connect Game Center configuration
4. Enter **Android Platform ID** from Google Play Console achievements
5. Set **Title** for debugging reference (optional)
6. Set **Number of Steps to Unlock** (1 for single unlock, >1 for incremental)

![Add an Achievement](../../../.gitbook/assets/GameServicesAddAchievement.gif)

{% hint style="danger" %}
On iOS, if you plan to deploy to multiple Apple platforms (macOS, tvOS), use leaderboard/achievement groups from the start. Group IDs must start with "grp." prefix and be unique.

**Recommended format:** `grp.com.companyname.gamename.itemname`
**Example:** `grp.com.voxelbusters.flappybird.highscoreleaderboard`

This avoids changing IDs later once you have live versions on different platforms.
{% endhint %}

## Configuration Reference

### General Settings
| Setting | Platform | Default | Notes |
| --- | --- | --- | --- |
| Enable Game Services | All | Off | Must be enabled to include Game Services in builds |
| Leaderboards | All | Empty | Array of leaderboard definitions |
| Achievements | All | Empty | Array of achievement definitions |
| Show Achievement Completion Banner | iOS | On | Displays native iOS banner when achievements unlock |
| Allow Friends Access | All | Off | Adds permissions for friends list access |
| Android Properties | Android | Auto | OAuth client and display configuration |

### Leaderboard Properties
| Property | Type | Required | Notes |
| --- | --- | --- | --- |
| Id | string | Yes | Common identifier used in code across all platforms |
| iOS Platform ID | string | Yes (iOS) | Leaderboard ID from App Store Connect Game Center |
| Android Platform ID | string | Yes (Android) | Leaderboard ID from Google Play Console |
| Platform Id Overrides | object | Optional | Per-platform ID overrides if IDs differ |
| Title | string | Optional | Debugging label (not shown to players in game) |

### Achievement Properties
| Property | Type | Required | Notes |
| --- | --- | --- | --- |
| Id | string | Yes | Common identifier used in code across all platforms |
| iOS Platform ID | string | Yes (iOS) | Achievement ID from App Store Connect Game Center |
| Android Platform ID | string | Yes (Android) | Achievement ID from Google Play Console |
| Platform Id Overrides | object | Optional | Per-platform ID overrides if IDs differ |
| Title | string | Optional | Debugging label (not shown to players in game) |
| Number of Steps to Unlock | int | Yes | Set to 1 for single unlock, >1 for incremental achievements |

### Android Properties
| Property | Type | Required | Notes |
| --- | --- | --- | --- |
| Play Services Application Id | string | Yes | Project ID from Google Play Console → Play Games Services → Configuration |
| Server Client Id | string | Optional | **Web** OAuth Client ID for backend access to player data (not Android OAuth) |
| Show Alert Dialogs | bool | Optional | Display native error dialogs for sign-in failures |

{% hint style="success" %}
**Android Server Client ID:** Only required if you access Play Games profile data from your backend server. Use **Web Platform OAuth Client** ID, NOT Android OAuth Client ID. Using the wrong OAuth client will cause sign-in failures.

To create: Google Cloud Console → Credentials → Create OAuth Client → Web Application
{% endhint %}

{% hint style="warning" %}
Leaderboard and achievement IDs must exactly match the platform IDs configured in App Store Connect and Google Play Console. Mismatched IDs will cause runtime errors when calling Game Services APIs.
{% endhint %}

{% hint style="info" %}
Need a working baseline? Run the sample at `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/GameServicesDemo.unity` to confirm your settings before wiring the feature into production screens.
{% endhint %}

## Automatic Platform Integration

Essential Kit automatically handles platform-specific configuration during build:
- **iOS**: Adds GameKit.framework, configures capabilities, injects Info.plist entries
- **Android**: Adds Play Games Services dependencies, configures AndroidManifest permissions

You don't need to manually configure Xcode projects or AndroidManifest.xml files.

## Next Steps

After completing setup, proceed to the [Usage Guide](../usage.md) to learn how to authenticate players and implement leaderboards and achievements in your game.
