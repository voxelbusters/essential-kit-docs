---
description: "Testing Game Services integration in Unity Editor and on devices"
---

# Testing & Validation

Use these checks to confirm your Game Services integration before release.

## Editor Simulation

Essential Kit includes a Game Services simulator that runs automatically in Unity Editor.

### Using the Simulator

1. **Automatic Activation**: When you run in Unity Editor, the Game Services simulator activates automatically
2. **Simulated Authentication**: Call `GameServices.Authenticate()` in Play mode to simulate sign-in
3. **Test Data**: Simulator uses mock leaderboards and achievements based on your settings
4. **Reset State**: To clear simulator data, restart Play mode or use simulator reset (if available in settings)

**What the Simulator Tests:**
- Authentication flow and events
- Leaderboard score submission
- Achievement progress reporting
- UI callbacks and error handling

**Simulator Limitations:**
- No actual Game Center or Play Games connection
- No real player avatars or friend lists
- Native UI dialogs don't appear
- Server credential validation not possible

{% hint style="info" %}
The simulator validates your code logic and Essential Kit integration. Always test on physical devices before release to verify platform-specific behavior.
{% endhint %}

## Device Testing Checklist

### iOS Testing (Game Center)

#### Pre-Testing Setup
- [ ] Build and install on iOS device (iOS 14+ recommended)
- [ ] Ensure device has Game Center enabled in Settings
- [ ] Sign in to Game Center with a test Apple ID
- [ ] Verify leaderboards and achievements exist in App Store Connect

#### Authentication Tests
- [ ] Launch app and call `GameServices.Authenticate(interactive: true)`
- [ ] Verify Game Center login dialog appears (if not signed in)
- [ ] Confirm `OnAuthStatusChange` event fires with authenticated status
- [ ] Check `GameServices.LocalPlayer.DisplayName` shows correct player name
- [ ] Test silent authentication (`interactive: false`) on subsequent launches

#### Leaderboard Tests
- [ ] Submit score using `GameServices.ReportScore()`
- [ ] Verify score appears in Game Center app
- [ ] Call `GameServices.ShowLeaderboard()` and confirm native UI displays
- [ ] Test time scopes (AllTime, Week, Today)
- [ ] Load top scores and verify data returns correctly
- [ ] Load player-centered scores

#### Achievement Tests
- [ ] Report achievement progress using `GameServices.ReportAchievementProgress()`
- [ ] Verify achievement completion banner appears (if enabled in settings)
- [ ] Call `GameServices.ShowAchievements()` and confirm native UI displays
- [ ] Check achievements in Game Center app match reported progress
- [ ] Test both standard and incremental achievements

#### Error Cases
- [ ] Sign out and verify operations fail gracefully with NotAuthenticated error
- [ ] Test with airplane mode to verify offline behavior
- [ ] Submit invalid leaderboard ID and verify error handling
- [ ] Report invalid achievement ID and verify error handling

### Android Testing (Play Games)

#### Pre-Testing Setup
- [ ] Build and install on Android device (Android 5.0+ recommended)
- [ ] Ensure Google Play Games app is installed
- [ ] Sign in to Google Play Games with test Google account
- [ ] Verify leaderboards and achievements exist in Play Console
- [ ] Confirm OAuth configuration is correct (if using server features)

#### Authentication Tests
- [ ] Launch app and call `GameServices.Authenticate(interactive: true)`
- [ ] Verify Play Games login dialog appears (if not signed in)
- [ ] Confirm `OnAuthStatusChange` event fires with authenticated status
- [ ] Check `GameServices.LocalPlayer.DisplayName` shows correct player name
- [ ] Test silent authentication on subsequent launches

#### Leaderboard Tests
- [ ] Submit score using `GameServices.ReportScore()`
- [ ] Open Play Games app and verify score appears
- [ ] Call `GameServices.ShowLeaderboard()` and confirm native UI displays
- [ ] Test time scopes (AllTime, Week, Today)
- [ ] Load top scores and verify data returns correctly
- [ ] Load player-centered scores

#### Achievement Tests
- [ ] Report achievement progress using `GameServices.ReportAchievementProgress()`
- [ ] Call `GameServices.ShowAchievements()` and confirm native UI displays
- [ ] Open Play Games app and verify achievements match reported progress
- [ ] Test both standard and incremental achievements

#### Error Cases
- [ ] Sign out and verify operations fail gracefully
- [ ] Test with airplane mode to verify offline behavior
- [ ] Submit invalid leaderboard ID and verify error handling
- [ ] Report invalid achievement ID and verify error handling

## Cross-Platform Testing

Test these scenarios on both iOS and Android:

### Authentication Flow
- [ ] First launch authentication (interactive)
- [ ] Silent authentication on subsequent launches
- [ ] Sign out and re-authenticate
- [ ] Handle authentication cancellation gracefully

### Score Submission
- [ ] Submit multiple scores to same leaderboard
- [ ] Verify platform keeps highest score (or latest, depending on leaderboard config)
- [ ] Submit scores with tags
- [ ] Test score submission while offline (platforms cache internally)

### Achievement Progress
- [ ] Unlock standard achievement (100% progress)
- [ ] Incrementally update achievement progress (25%, 50%, 75%, 100%)
- [ ] Report same achievement progress multiple times
- [ ] Test achievement progress while offline

### UI Display
- [ ] Native leaderboard UI displays correctly
- [ ] Native achievement UI displays correctly
- [ ] UI callbacks fire when user closes native views
- [ ] Game resumes properly after native UI closes

## Performance Testing

Check these performance aspects:

- [ ] Authentication completes within 3-5 seconds (with good connection)
- [ ] Score submission completes within 2-3 seconds
- [ ] Achievement reporting completes within 2-3 seconds
- [ ] Loading leaderboard scores completes within 3-5 seconds
- [ ] No frame drops when showing native UI
- [ ] No memory leaks after multiple authentication cycles

## Pre-Submission Review

Before submitting to App Store or Play Store:

### iOS App Store
- [ ] Reset app permissions in iOS Settings → Privacy → Game Center
- [ ] Reinstall app and verify first-run authentication experience
- [ ] Capture screenshots of Game Center integration for App Store review
- [ ] Test on multiple iOS versions (at least last 2 major versions)
- [ ] Verify Game Center entitlement is enabled in Xcode

### Google Play Store
- [ ] Clear Play Games app data and reinstall your app
- [ ] Verify first-run authentication experience
- [ ] Test on multiple Android versions (at least API 21+)
- [ ] Verify leaderboard/achievement IDs match Play Console exactly
- [ ] Confirm OAuth client ID is correct (if using server features)

### General Checks
- [ ] All leaderboards display correctly on both platforms
- [ ] All achievements unlock correctly on both platforms
- [ ] Error messages are user-friendly, not technical
- [ ] No crashes when network connection changes
- [ ] Privacy policy mentions Game Center/Play Games data usage
- [ ] App handles sign-out gracefully without crashes

## Troubleshooting Test Issues

If tests fail, check these common issues:

**Authentication Fails**
- Verify Game Services enabled in Essential Kit Settings
- Check platform dashboard configuration (App Store Connect / Play Console)
- Ensure device is signed in to Game Center / Play Games
- Check internet connection

**Scores Don't Appear**
- Verify leaderboard ID in code matches settings configuration
- Check leaderboard exists in platform dashboard
- Confirm player is authenticated before submitting
- Check for error in callback

**Achievements Don't Unlock**
- Verify achievement ID in code matches settings configuration
- Check achievement exists in platform dashboard
- Confirm `PercentageCompleted = 100.0` for unlock
- Check for error in callback

**Native UI Doesn't Show**
- Verify player is authenticated
- Check leaderboard/achievement ID is valid
- Ensure callback is registered to handle UI close

{% hint style="success" %}
If the demo scene works but your implementation doesn't, compare your code against `GameServicesDemo.cs` to identify differences in setup, event registration, or error handling.
{% endhint %}

## Next Steps

After successful testing, review the [FAQ](faq.md) for common issues and solutions to problems you might encounter in production.

{% content-ref url="faq.md" %}
[FAQ](faq.md)
{% endcontent-ref %}
