---
description: "Common issues and solutions for Game Services integration"
---

# FAQ & Troubleshooting

## General Questions

### Do I need to manually configure AndroidManifest.xml or Info.plist?

No. Essential Kit automatically injects required permissions and platform entries during build. You only need to configure settings in Essential Kit Settings inspector.

### Can I test Game Services without publishing my app?

Yes. Both platforms support testing before release:
- **iOS**: Use Sandbox environment with test Apple IDs
- **Android**: Add test accounts in Play Console under Play Games Services → Testers

### What are the minimum settings required for Game Services to work?

**iOS:**
- Game Center enabled in App Store Connect
- Leaderboards and achievements configured in App Store Connect
- Leaderboard/achievement definitions added in Essential Kit Settings

**Android:**
- Play Services Application ID set in Essential Kit Settings
- [SHA fingerprint added in Google Play Console](setup/android.md#configuring-credentials-sha-fingerprint-authentication)
- Leaderboards and achievements configured in Play Console
- Leaderboard/achievement definitions added in Essential Kit Settings

### How do platform-specific IDs work?

Each leaderboard/achievement has:
- **Common ID**: Used in your code (e.g., "high_score")
- **iOS Platform ID**: Game Center ID from App Store Connect
- **Android Platform ID**: Play Games ID from Play Console

Essential Kit automatically uses the correct platform ID based on the build target.

## Authentication Issues

### Authentication doesn't work in my game, what should I check?

1. Verify Game Services is enabled in Essential Kit Settings
2. Register for `OnAuthStatusChange` event before calling `Authenticate()`
3. Call `GameServices.Authenticate()` (silent first, then interactive if needed)
4. Check error callback for specific error details
5. Verify platform configuration (see platform-specific sections below)

### Player cancelled authentication, how do I let them sign in again?

Call `GameServices.Authenticate(interactive: true)` when player clicks a "Sign In" button. The `interactive: true` parameter shows the platform login UI.

### Can I check if player is authenticated without showing login UI?

Yes, use `GameServices.IsAuthenticated` property or check `GameServices.LocalPlayer.IsAuthenticated`. For silent authentication attempt, call `GameServices.Authenticate(interactive: false)`.

### How do I handle authentication in production?

Use this pattern:
1. On app start, call `GameServices.Authenticate(interactive: false)` for silent sign-in
2. If silent auth fails, show a "Sign In" button
3. When user clicks button, call `GameServices.Authenticate(interactive: true)` to show login UI

## Leaderboard Issues

### My score submission returns InvalidParameter error, what's wrong?

Check these common causes:
1. Leaderboard ID in code doesn't match ID in Essential Kit Settings
2. Leaderboard definition missing iOS or Android platform ID
3. Platform ID in settings doesn't match dashboard configuration (App Store Connect / Play Console)

### Scores don't appear in the leaderboard, but submission succeeds

Scores may be cached offline and upload later. Check:
1. Device has internet connection
2. Score appears in native Game Center / Play Games app
3. Wait a few minutes for server processing
4. Platform may keep highest score, not latest (check leaderboard configuration)

### How do I display weekly or daily leaderboards?

Use `LeaderboardTimeScope` when showing or loading leaderboards:

```csharp
// Show weekly scores
GameServices.ShowLeaderboard("high_score", LeaderboardTimeScope.Week);

// Load today's scores
leaderboard.TimeScope = LeaderboardTimeScope.Today;
leaderboard.LoadTopScores(callback);
```

### Can I create custom leaderboard UI instead of native UI?

Yes. Use `ILeaderboard.LoadTopScores()` or `LoadPlayerCenteredScores()` to get score data, then display in your own UI. Native UI is optional.

## Achievement Issues

### Achievement progress doesn't update, what should I check?

1. Verify player is authenticated before reporting progress
2. Check achievement ID in code matches Essential Kit Settings
3. Verify platform ID in settings matches dashboard (App Store Connect / Play Console)
4. Confirm percentage is between 0.0 and 100.0
5. Check error callback for specific failure reason

### How do incremental achievements work?

Set the percentage based on progress:

```csharp
// Example: Player won 45 out of 100 games
double percentage = (45.0 / 100.0) * 100.0; // = 45%
GameServices.ReportAchievementProgress("win_100_games", percentage, callback);
```

Platform tracks progress and unlocks when you report 100%.

### Achievement unlocked but banner doesn't show on iOS

Check "Show Achievement Completion Banner" is enabled in Game Services settings. This is iOS-only and must be enabled for automatic banners.

### Can I query player's current achievement progress?

Yes, use `GameServices.LoadAchievements()` to get all achievements with current progress:

```csharp
GameServices.LoadAchievements((result, error) =>
{
    foreach (IAchievement achievement in result.Achievements)
    {
        Debug.Log($"{achievement.Id}: {achievement.PercentageCompleted}%");
    }
});
```

## iOS (Game Center) Specific

### Why doesn't the sign-in dialog appear a second time after user cancelled it?

This is a Game Center limitation. After cancelling, the player must manually sign in through iOS Settings → Game Center. Your app cannot show the dialog again until they sign in via Settings.

**Solution**: Show an in-app message directing users to Settings when authentication fails after cancellation.

### Game Center sandbox doesn't work, what should I check?

1. Sign out of production Game Center in iOS Settings
2. Sign in with a Sandbox test Apple ID
3. Ensure device is connected to internet
4. Test Apple ID must be created in App Store Connect → Users and Access → Sandbox Testers

### Leaderboards and achievements don't appear in Game Center app

1. Verify leaderboards/achievements are approved in App Store Connect
2. Check they're in "Ready to Submit" or "Live" state
3. For sandbox testing, they should at least be in "Waiting for Review" state

### How do I create leaderboard groups on iOS?

1. In App Store Connect, go to Game Center → Leaderboard Groups
2. Create a group with ID starting with "grp." (e.g., "grp.com.yourcompany.game.scores")
3. Add individual leaderboards to the group
4. Use group ID in Essential Kit Settings

{% hint style="danger" %}
If you plan to deploy to multiple Apple platforms (macOS, tvOS), use leaderboard/achievement groups from the start. Changing from individual to group IDs later requires all players to reset progress.
{% endhint %}

## Android (Play Games) Specific

### What are SHA fingerprints and why do I need them?

SHA fingerprints authenticate your app with Play Games. Each keystore (debug, release, Play Store signing) has a unique SHA-1 fingerprint that must be added to Play Console credentials.

### What are different SHA fingerprints for different build types?

{% tabs %}
{% tab title="Debug (Development)" %}
When Development Build is enabled in Unity Build Settings, Android uses the default debug keystore.

**Get SHA-1 fingerprint:**
```bash
keytool -list -v -keystore "PATH_TO_DEBUG_KEYSTORE" -alias androiddebugkey -storepass android -keypass android
```

**Debug keystore locations:**

| Platform | Path |
| --- | --- |
| Windows | `C:\Users\USERNAME\.android\debug.keystore` |
| macOS | `~/.android/debug.keystore` |

![SHA fingerprint output](../../.gitbook/assets/GetSHAFingerPrint.png)

Add this SHA-1 to [Play Console credentials](setup/android.md#configuring-credentials-sha-fingerprint-authentication).
{% endtab %}

{% tab title="Release (Production)" %}
When Development Build is OFF, Unity uses your custom keystore from Player Settings.

**Get SHA-1 fingerprint:**
```bash
keytool -list -v -keystore "PATH_TO_KEYSTORE" -alias ALIAS_NAME -storepass STORE_PASSWORD -keypass KEY_PASSWORD
```

Replace:
- **PATH_TO_KEYSTORE**: Path to your release keystore
- **ALIAS_NAME**: Keystore alias name
- **STORE_PASSWORD**: Keystore password
- **KEY_PASSWORD**: Key password

![Release keystore SHA fingerprint](../../.gitbook/assets/GetSHAFingerPrint.png)

Add this SHA-1 to [Play Console credentials](setup/android.md#configuring-credentials-sha-fingerprint-authentication).
{% endtab %}

{% tab title="Google Play Store (Play App Signing)" %}
Once you upload your APK to Play Console and enable Google Play App Signing, Google re-signs your app with a new certificate.

**Get Play App Signing SHA-1:**
1. Open [Google Play Console](https://play.google.com/apps/publish)
2. Select your app
3. Go to **Setup** → **App Signing**
4. Under "App signing key certificate", copy the SHA-1 certificate fingerprint
5. Add this fingerprint to [Play Console credentials](setup/android.md#configuring-credentials-sha-fingerprint-authentication)

![Google Play App Signing SHA fingerprint](../../.gitbook/assets/GooglePlayAppSigningSHAFingerprint.png)
{% endtab %}
{% endtabs %}

### Why is sign-in failing? "APP NOT CORRECTLY CONFIGURED TO USE GOOGLE PLAY GAME SERVICES"

This error has three main causes:

1. **Wrong SHA fingerprint**: Package name and certificate fingerprint don't match OAuth client credentials
   - Copy SHA-1 from logcat and [add to Play Console credentials](setup/android.md#adding-a-sha-fingerprint)
   - Verify you added the SHA-1 for the keystore you're using (debug/release/Play signing)

2. **Wrong Play Services Application ID**: ID in Essential Kit Settings doesn't match Play Console
   - Check Play Console → Play Games Services → Setup and Management → Configuration
   - Copy the Project ID exactly into Essential Kit Settings

3. **Test account not added**: For unpublished apps, test account must be added as tester
   - Play Console → Your App → Play Games Services → Setup and Management → Testers
   - Add your Google account email to the testers list

{% hint style="danger" %}
99% of Android sign-in failures are caused by incorrect SHA fingerprint in Play Console credentials. Always verify you added the correct fingerprint for your current keystore.
{% endhint %}

{% hint style="warning" %}
Even with correct SHA fingerprints, test accounts must be added to the testers list in Play Console for unpublished apps.
{% endhint %}

### How do I get SHA fingerprint from an APK file?

```bash
keytool -printcert -jarfile PATH_TO_APK_FILE
```

### I get "keytool command not found" error

`keytool` is part of the Java SDK. You need Java installed and:
- **Windows**: Set `JAVA_HOME` environment variable
- **macOS/Linux**: Add Java to PATH

`keytool` is located in the `bin` folder of your Java installation.

### Server Client ID causes sign-in to fail

Make sure you created the OAuth client for **Web Application**, NOT Android. Android Play Games integration requires Web OAuth client ID for server access.

**To create:**
1. Google Cloud Console → Credentials
2. Create OAuth Client → **Web Application** (not Android)
3. Copy Web client ID to Essential Kit Settings → Android Properties → Server Client Id

{% hint style="success" %}
Server Client ID is only needed if you access Play Games profile data from your backend. For basic Game Services (leaderboards/achievements only), leave it empty.
{% endhint %}

## Error Handling

### My operations fail with "NotAuthenticated" error

Player must be authenticated before using leaderboards or achievements. Check:
1. Call `GameServices.Authenticate()` before game services operations
2. Wait for `OnAuthStatusChange` event with authenticated status
3. Use `GameServices.IsAuthenticated` to check state before operations

### How do I handle offline scenarios?

Both Game Center and Play Games cache data when offline:
- Scores and achievement progress are queued and uploaded when online
- Loading operations may fail with network errors
- Native UI requires internet connection

**Best practice**: Check errors and show appropriate offline message to users.

### Where can I see full error details?

Check the `Error` object in callbacks:

```csharp
struct CompletionResult
{
    public bool Success;
    public Error Error;
}

void OnComplete(CompletionResult result)
{
    if (!result.Success)
    {
        Error error = result.Error;
        Debug.Log($"Error code: {error.Code}");
        Debug.Log($"Error message: {error.Description}");
    }
}
```

## Demo Scene & Comparison

### How can I verify Essential Kit behavior versus my implementation?

Run the demo scene at `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/GameServicesDemo.unity`:

1. If demo works but your scene doesn't, compare:
   - Essential Kit Settings configuration
   - Event registration in `OnEnable`/`OnDisable`
   - Error handling in callbacks
   - Authentication flow

2. Check `GameServicesDemo.cs` for reference implementation

### What if the demo scene also fails?

1. Verify platform configuration (App Store Connect / Play Console)
2. Check leaderboard/achievement platform IDs match dashboards exactly
3. Review [Setup Guide](setup/) for missing steps
4. For Android, verify SHA fingerprints are correct

## Platform Permissions

### Do I need to request permissions for Game Services?

No explicit permissions needed. Game Services handles authentication through platform SDKs:
- **iOS**: Game Center uses system-level authentication
- **Android**: Play Games uses Google account authentication

### Friends access requires permissions, how do I enable it?

Enable "Allow Friends Access" in Game Services settings. Essential Kit adds required permissions automatically:
- **iOS**: Adds NSGKFriendListUsageDescription to Info.plist
- **Android**: Adds necessary Play Games permissions

Provide clear privacy descriptions for App Store / Play Store review.

## Related Resources

- [Setup Guide](setup/) - Complete platform configuration
- [Usage Guide](usage.md) - API reference and examples
- [Testing Guide](testing.md) - Device testing checklist
- Demo scene: `GameServicesDemo.unity` - Working reference implementation
