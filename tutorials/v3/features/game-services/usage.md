---
description: "Game Services provides cross-platform access to Game Center and Google Play Games for authentication, leaderboards, achievements, and social features"
---

# Usage

Essential Kit wraps iOS Game Center and Android Google Play Games into a unified API. Game Services handles authentication automatically - just call the APIs and Essential Kit manages platform differences.

## Table of Contents
- [Import Namespaces](#import-namespaces)
- [Understanding Authentication](#understanding-authentication)
- [Event Registration](#event-registration)
- [Player Authentication](#player-authentication)
- [Leaderboards](#leaderboards)
- [Achievements](#achievements)
- [Social Features](#social-features)
- [Server Integration](#server-integration)
- [Core APIs Reference](#core-apis-reference)
- [Data Properties](#data-properties)
- [Error Handling](#error-handling)
- [Advanced: Runtime Settings Initialization](#advanced-runtime-settings-initialization)
- [Related Guides](#related-guides)

## Import Namespaces
```csharp
using System;
using System.Collections.Generic;
using VoxelBusters.CoreLibrary;
using VoxelBusters.EssentialKit;
```

## Understanding Authentication

Game Services requires player authentication before accessing leaderboards, achievements, or social features. Essential Kit auto-initializes Game Services on app start using your configured settings.

**Authentication Flow:**
1. Call `GameServices.Authenticate()` when you want the player to sign in
2. On first call, platform shows native login UI (Game Center or Play Games)
3. `OnAuthStatusChange` event fires with authentication result
4. Once authenticated, `GameServices.LocalPlayer` contains player info
5. Subsequent app launches may auto-authenticate silently if enabled by platform

**Key Concepts:**
- **Interactive Authentication**: Shows login UI if player not signed in
- **Silent Authentication**: Attempts sign-in without showing UI (useful for automatic login)
- **LocalPlayer**: Represents the authenticated player with display name, ID, and avatar
- **IsAuthenticated**: Check if player is currently signed in

## Event Registration

Register for authentication events in `OnEnable` and unregister in `OnDisable`:

```csharp
void OnEnable()
{
    GameServices.OnAuthStatusChange += OnAuthStatusChange;
}

void OnDisable()
{
    GameServices.OnAuthStatusChange -= OnAuthStatusChange;
}
```

| Event | Trigger | Data |
| --- | --- | --- |
| `OnAuthStatusChange` | Player signs in, signs out, or authentication state changes | `GameServicesAuthStatusChangeResult` with `LocalPlayer` and `AuthStatus` |

## Player Authentication

### Authenticate Player

Call `Authenticate()` to sign in the player. On first call, shows platform login UI.

```csharp
void SignInPlayer()
{
    Debug.Log("Starting authentication...");
    GameServices.Authenticate(interactive: true);
}

void OnAuthStatusChange(GameServicesAuthStatusChangeResult result, Error error)
{
    if (error != null)
    {
        Debug.Log($"Authentication failed: {error.Description}");
        return;
    }

    Debug.Log($"Auth status: {result.AuthStatus}");

    if (result.AuthStatus == LocalPlayerAuthStatus.Authenticated)
    {
        ILocalPlayer player = result.LocalPlayer;
        Debug.Log($"Signed in as {player.DisplayName}");

        // Access player info
        Debug.Log($"Player Identifier: {player.Identifier}");

        // Load player avatar
        player.LoadImage((imageData, loadError) =>
        {
            if (loadError == null && imageData != null)
            {
                Texture2D avatar = imageData.GetTexture();
                // Display avatar in UI
            }
        });
    }
}
```

{% hint style="info" %}
`GameServices.Authenticate()` immediately succeeds when the player is already signed in, so you can call it directly without first checking `GameServices.IsAuthenticated`. Use `IsAuthenticated` when you need to query status (for example, to toggle UI) rather than to guard the authentication call.
{% endhint %}

### Silent Authentication

Use silent authentication to auto-sign in without showing UI:

```csharp
void Start()
{
    // Try silent authentication on app start
    GameServices.Authenticate(interactive: false);
}
```

If player previously signed in and platform supports auto-authentication, this succeeds silently. Otherwise, `OnAuthStatusChange` returns not authenticated without showing UI.

{% hint style="success" %}
**UX Best Practice**: Call silent authentication on app start. If it fails, show a "Sign In" button that calls `Authenticate(interactive: true)` to show login UI only when player explicitly wants to sign in.
{% endhint %}

### Check Authentication Status

Use `IsAuthenticated` or `LocalPlayer` to check current state:

```csharp
if (GameServices.IsAuthenticated)
{
    ILocalPlayer player = GameServices.LocalPlayer;
    Debug.Log($"Player signed in: {player.DisplayName}");
}
else
{
    Debug.Log("Player not signed in");
}
```

### Sign Out

```csharp
void SignOut()
{
    GameServices.Signout();
    Debug.Log("Player signed out");
}
```

After sign out, `IsAuthenticated` returns `false` and game services operations will fail until player re-authenticates.

## Leaderboards

Leaderboards display competitive rankings. Essential Kit supports submitting scores, loading scores, and showing native leaderboard UI.

### Submit Score

**Using leaderboard ID** (simplest approach):

```csharp
void SubmitScore(long score)
{
    if (!GameServices.IsAuthenticated)
    {
        Debug.Log("Player must be authenticated to submit scores");
        return;
    }

    GameServices.ReportScore("high_score", score, (success, error) =>
    {
        if (success)
        {
            Debug.Log($"Score {score} submitted successfully");
        }
        else if (error != null)
        {
            Debug.Log($"Score submission failed: {error.Description}");
        }
    });
}
```

**Using leaderboard object** (for advanced operations):

```csharp
void SubmitScoreAdvanced(long score)
{
    ILeaderboard leaderboard = GameServices.CreateLeaderboard("high_score");
    if (leaderboard == null)
    {
        Debug.Log("Leaderboard 'high_score' not found in settings");
        return;
    }

    leaderboard.ReportScore(score, (success, error) =>
    {
        if (success)
        {
            Debug.Log($"Score {score} submitted");
        }
        else if (error != null)
        {
            Debug.Log($"Score submission failed: {error.Description}");
        }
    });
}
```

**With optional score tag** (8 ASCII characters max):

```csharp
void SubmitTaggedScore(long score, string levelId)
{
    string tag = levelId.Substring(0, Math.Min(8, levelId.Length));

    GameServices.ReportScore("level_scores", score, (success, error) =>
    {
        if (success)
        {
            Debug.Log($"Score {score} submitted with tag {tag}");
        }
        else if (error != null)
        {
            Debug.Log($"Score submission failed: {error.Description}");
        }
    }, tag);
}
```

### Load Leaderboard Scores

**Load top scores** from a leaderboard:

```csharp
void LoadTopScores()
{
    ILeaderboard leaderboard = GameServices.CreateLeaderboard("high_score");
    if (leaderboard == null) return;

    // Configure score query
    leaderboard.TimeScope = LeaderboardTimeScope.AllTime;
    leaderboard.PlayerScope = LeaderboardPlayerScope.Global;
    leaderboard.LoadTopScores((result, error) =>
    {
        if (error != null)
        {
            Debug.Log($"Failed to load scores: {error.Description}");
            return;
        }

        Debug.Log($"Loaded {result.Scores.Length} scores");
        foreach (ILeaderboardScore score in result.Scores)
        {
            Debug.Log($"{score.Rank}. {score.Player.DisplayName}: {score.Value}");
        }
    });
}
```

**Load player-centered scores** (scores around authenticated player):

```csharp
void LoadPlayerCenteredScores()
{
    ILeaderboard leaderboard = GameServices.CreateLeaderboard("high_score");
    if (leaderboard == null) return;

    leaderboard.TimeScope = LeaderboardTimeScope.Week;
    leaderboard.LoadPlayerCenteredScores((result, error) =>
    {
        if (error == null)
        {
            Debug.Log($"Loaded {result.Scores.Length} scores around player");
        }
    });
}
```

### Leaderboard Time Scopes

Control which scores are displayed:

```csharp
// All-time scores (default)
leaderboard.TimeScope = LeaderboardTimeScope.AllTime;

// This week's scores
leaderboard.TimeScope = LeaderboardTimeScope.Week;

// Today's scores
leaderboard.TimeScope = LeaderboardTimeScope.Today;
```

### Show Leaderboard UI

**Show all leaderboards**:

```csharp
void ShowAllLeaderboards()
{
    GameServices.ShowLeaderboards(LeaderboardTimeScope.AllTime, (result, error) =>
    {
        Debug.Log("Leaderboard UI closed");
    });
}
```

**Show specific leaderboard**:

```csharp
void ShowHighScoreLeaderboard()
{
    GameServices.ShowLeaderboard("high_score", LeaderboardTimeScope.Week, (result, error) =>
    {
        Debug.Log("Leaderboard UI closed");
    });
}
```

The native platform UI shows:
- iOS: Game Center leaderboard overlay
- Android: Play Games leaderboard screen

{% hint style="info" %}
Native leaderboard UI pauses your game automatically. Resume game logic in the callback if needed.
{% endhint %}

### Load Leaderboard Metadata

Load all configured leaderboards with metadata:

```csharp
void LoadLeaderboardsData()
{
    GameServices.LoadLeaderboards((result, error) =>
    {
        if (error == null)
        {
            Debug.Log($"Loaded {result.Leaderboards.Length} leaderboards");
            foreach (ILeaderboard lb in result.Leaderboards)
            {
                Debug.Log($"Leaderboard: {lb.Id}, Title: {lb.Title}");
            }
        }
    });
}
```

## Achievements

Achievements reward player milestones. Essential Kit supports reporting progress and showing achievement UI.

### Understanding Achievement Types

**Standard Achievements** (single unlock):
- Unlock once when player completes a task
- Example: "Complete first level"
- Set `PercentageCompleted = 100.0` to unlock

**Incremental Achievements** (progressive unlock):
- Track progress over time
- Example: "Win 100 games" (0-100% progress)
- Update `PercentageCompleted` as player progresses

### Report Achievement Progress

**Using achievement ID** (simplest approach):

```csharp
void UnlockAchievement(string achievementId)
{
    if (!GameServices.IsAuthenticated)
    {
        Debug.Log("Player must be authenticated");
        return;
    }

    GameServices.ReportAchievementProgress(achievementId, 100.0, (success, error) =>
    {
        if (success)
        {
            Debug.Log($"Achievement {achievementId} unlocked!");
        }
        else if (error != null)
        {
            Debug.Log($"Achievement failed: {error.Description}");
        }
    });
}
```

**For incremental achievements**:

```csharp
void UpdateAchievementProgress(string achievementId, int currentProgress, int maxProgress)
{
    double percentage = ((double)currentProgress / maxProgress) * 100.0;

    GameServices.ReportAchievementProgress(achievementId, percentage, (success, error) =>
    {
        if (success)
        {
            Debug.Log($"Achievement progress: {percentage:F1}%");
        }
        else if (error != null)
        {
            Debug.Log($"Progress update failed: {error.Description}");
        }
    });
}

void TrackWinsExample()
{
    // Example: Track wins
    int wins = 45;
    int targetWins = 100;
    UpdateAchievementProgress("win_100_games", wins, targetWins); // Reports 45% progress
}
```

**Using achievement object** (for advanced control):

```csharp
void ReportProgressAdvanced()
{
    IAchievement achievement = GameServices.CreateAchievement("first_win");
    if (achievement == null)
    {
        Debug.Log("Achievement 'first_win' not found in settings");
        return;
    }

    achievement.PercentageCompleted = 100.0;
    achievement.ReportProgress((success, error) =>
    {
        if (success)
        {
            Debug.Log("Achievement reported successfully");
        }
        else if (error != null)
        {
            Debug.Log($"Achievement report failed: {error.Description}");
        }
    });
}
```

### Load Achievement Descriptions

Load metadata for all configured achievements:

```csharp
void LoadAchievementDescriptions()
{
    GameServices.LoadAchievementDescriptions((result, error) =>
    {
        if (error != null)
        {
            Debug.Log($"Failed to load: {error.Description}");
            return;
        }

        Debug.Log($"Loaded {result.AchievementDescriptions.Length} achievements");
        foreach (IAchievementDescription desc in result.AchievementDescriptions)
        {
            Debug.Log($"{desc.Id}: {desc.Title}");
            Debug.Log($"  Points: {desc.MaximumPoints}");
            Debug.Log($"  Hidden: {desc.IsHidden}");
        }
    });
}
```

### Load Player Achievement Progress

Load player's current achievement progress:

```csharp
void LoadPlayerAchievements()
{
    GameServices.LoadAchievements((result, error) =>
    {
        if (error == null)
        {
            Debug.Log($"Loaded {result.Achievements.Length} achievements");
            foreach (IAchievement achievement in result.Achievements)
            {
                Debug.Log($"{achievement.Id}: {achievement.PercentageCompleted:F1}%");
                if (achievement.IsCompleted)
                {
                    Debug.Log($"  Unlocked on {achievement.LastReportedDate}");
                }
            }
        }
    });
}
```

### Show Achievements UI

Display native achievement progress screen:

```csharp
void ShowAchievementsUI()
{
    GameServices.ShowAchievements((result, error) =>
    {
        Debug.Log("Achievements UI closed");
    });
}
```

The native UI shows:
- iOS: Game Center achievements overlay
- Android: Play Games achievements screen

{% hint style="success" %}
**Achievement Completion Banners**: On iOS, Essential Kit can show a native banner when achievements unlock. Enable "Show Achievement Completion Banner" in Game Services settings to display automatic unlock notifications.
{% endhint %}

## Social Features

Access friends list and add friends for social competition.

### Load Friends

```csharp
void LoadPlayerFriends()
{
    if (!GameServices.IsAuthenticated)
    {
        Debug.Log("Player must be authenticated to load friends");
        return;
    }

    GameServices.LoadFriends((result, error) =>
    {
        if (error != null)
        {
            Debug.Log($"Failed to load friends: {error.Description}");
            return;
        }

        Debug.Log($"Found {result.Players.Length} friends");
        foreach (IPlayer friend in result.Players)
        {
            Debug.Log($"Friend: {friend.DisplayName}");

            // Load friend avatar
            friend.LoadImage((imageData, imgError) =>
            {
                if (imgError == null && imageData != null)
                {
                    Texture2D avatar = imageData.GetTexture();
                    // Display in friends UI
                }
            });
        }
    });
}
```

{% hint style="warning" %}
**Privacy Permissions**: Friends access requires additional privacy permissions. Enable "Allow Friends Access" in Game Services settings and provide clear usage descriptions on iOS.
{% endhint %}

### Add Friend

Send friend request to a player:

```csharp
void SendFriendRequest(string playerId)
{
    GameServices.AddFriend(playerId, (success, error) =>
    {
        if (error == null && success)
        {
            Debug.Log("Friend request sent successfully");
        }
        else
        {
            Debug.Log($"Friend request failed: {error?.Description}");
        }
    });
}
```

## Server Integration

### Load Server Credentials

For backend integration, load server credentials to validate player identity on your game server:

```csharp
void GetServerCredentials()
{
    if (!GameServices.IsAuthenticated)
    {
        Debug.Log("Player must be authenticated");
        return;
    }

    var additionalScopes = new List<ServerCredentialAdditionalScope>
    {
        ServerCredentialAdditionalScope.Email
    };

    GameServices.LoadServerCredentials(additionalScopes, (result, error) =>
    {
        if (error != null)
        {
            Debug.Log($"Failed to load credentials: {error.Description}");
            return;
        }

        ServerCredentials credentials = result.ServerCredentials;
        Debug.Log("Server credentials loaded");

        foreach (ServerCredentialAdditionalScope scope in result.AdditionalGrantedScopes)
        {
            Debug.Log($"Granted additional scope: {scope}");
        }

        // Send to your backend for validation
        SendToBackend(credentials);
    });
}

void SendToBackend(ServerCredentials credentials)
{
    // Example: Send credentials to your game server
    // Server can validate with Game Center or Play Games backend
    Debug.Log("Sending credentials to backend...");
}
```

{% hint style="info" %}
Server credentials expire and need periodic refresh. Credentials contain platform-specific authentication data your backend can use to verify player identity with Game Center or Google Play Games servers.
{% endhint %}

{% hint style="warning" %}
On Android, additional scopes (such as email) require user consent. Inspect `result.AdditionalGrantedScopes` to confirm which scopes were approved before relying on them server-side.
{% endhint %}

## Core APIs Reference

### Authentication APIs
| API | Purpose | Returns |
| --- | --- | --- |
| `GameServices.Authenticate(interactive)` | Authenticate player (shows UI if interactive=true) | Result via `OnAuthStatusChange` event |
| `GameServices.Signout()` | Sign out current player | Immediate, no callback |
| `GameServices.IsAuthenticated` | Check if player signed in | `bool` |
| `GameServices.LocalPlayer` | Get authenticated player info | `ILocalPlayer` (null if not authenticated) |
| `GameServices.Initialize(settings)` | (Advanced) Override settings at runtime | `void` |

### Leaderboard APIs
| API | Purpose | Returns |
| --- | --- | --- |
| `GameServices.CreateLeaderboard(id)` | Create leaderboard object for operations | `ILeaderboard` |
| `GameServices.ReportScore(id, score, callback, tag)` | Submit score to leaderboard | Result via callback |
| `ILeaderboard.LoadTopScores(callback)` | Load highest scores | Result via callback with scores array |
| `ILeaderboard.LoadPlayerCenteredScores(callback)` | Load scores around player | Result via callback with scores array |
| `ILeaderboard.LoadNext(callback)` | Load next page of scores | Result via callback with scores array |
| `ILeaderboard.LoadPrevious(callback)` | Load previous page of scores | Result via callback with scores array |
| `GameServices.ShowLeaderboard(id, timescope, callback)` | Show native leaderboard UI | Result via callback when UI closes |
| `GameServices.ShowLeaderboards(timescope, callback)` | Show all leaderboards UI | Result via callback when UI closes |
| `GameServices.LoadLeaderboards(callback)` | Load leaderboard metadata | Result via callback with leaderboard array |
| `ILeaderboard.LoadImage(callback)` | Load leaderboard icon image | Result via callback with `TextureData` |
| `ILeaderboard.LoadScoresQuerySize` | Configure max entries before loading | `int` (get/set) |

### Achievement APIs
| API | Purpose | Returns |
| --- | --- | --- |
| `GameServices.CreateAchievement(id)` | Create achievement object for operations | `IAchievement` |
| `GameServices.ReportAchievementProgress(id, percentage, callback)` | Report achievement progress | Result via callback |
| `IAchievement.ReportProgress(callback)` | Report progress (set `PercentageCompleted` first) | Result via callback |
| `GameServices.ShowAchievements(callback)` | Show native achievements UI | Result via callback when UI closes |
| `GameServices.LoadAchievementDescriptions(callback)` | Load achievement metadata | Result via callback with descriptions array |
| `GameServices.LoadAchievements(callback)` | Load player's achievement progress | Result via callback with achievements array |
| `IAchievementDescription.LoadImage(callback)` | Load achievement icon image | Result via callback with `TextureData` |

### Social APIs
| API | Purpose | Returns |
| --- | --- | --- |
| `GameServices.LoadFriends(callback)` | Load player's friends list | Result via callback with players array |
| `GameServices.AddFriend(playerId, callback)` | Send friend request | Result via callback with success bool |
| `ILocalPlayer.LoadFriends(callback)` | Load friends directly from the player object | Result via callback with players array |
| `ILocalPlayer.AddFriend(playerId, callback)` | Send friend request via player object | Result via callback with success bool |

### Server APIs
| API | Purpose | Returns |
| --- | --- | --- |
| `GameServices.LoadServerCredentials(callback)` | Load server credentials for backend validation | Result via callback with credentials |
| `GameServices.LoadServerCredentials(additionalScopes, callback)` | Request credentials with additional scopes (Android) | Result via callback with credentials and granted scopes |

## Data Properties

### ILocalPlayer Properties
| Property | Type | Notes |
| --- | --- | --- |
| `Identifier` | string | Platform-specific player identifier |
| `DeveloperScopeIdentifier` | string | Cross-game identifier (iOS only when available) |
| `LegacyIdentifier` | string | Backwards-compatible identifier |
| `DisplayName` | string | Player display name |
| `Alias` | string | Player alias (may match `DisplayName`) |
| `IsAuthenticated` | bool | Whether player is signed in |
| `LoadImage(callback)` | Method | Async load player avatar |
| `LoadFriends(callback)` | Method | Load player's friends |
| `AddFriend(playerId, callback)` | Method | Send friend request |

### ILeaderboardScore Properties
| Property | Type | Notes |
| --- | --- | --- |
| `Value` | long | Score value |
| `Rank` | int | Player rank in leaderboard |
| `Player` | IPlayer | Player who achieved this score |
| `LastReportedDate` | DateTime | When score was submitted |
| `Tag` | string | Optional score tag (max 8 ASCII chars) |

### IAchievement Properties
| Property | Type | Notes |
| --- | --- | --- |
| `Id` | string | Achievement identifier |
| `PercentageCompleted` | double | Progress (0.0 to 100.0) |
| `IsCompleted` | bool | Whether achievement is unlocked |
| `LastReportedDate` | DateTime | Last progress report time |

### IAchievementDescription Properties
| Property | Type | Notes |
| --- | --- | --- |
| `Id` | string | Achievement identifier |
| `Title` | string | Achievement title |
| `UnachievedDescription` | string | Description when locked |
| `AchievedDescription` | string | Description when unlocked |
| `MaximumPoints` | int | Points awarded for unlocking |
| `IsHidden` | bool | Whether achievement is hidden |
| `IsReplayable` | bool | Whether achievement can be re-earned |

## Error Handling

| Error Code | Trigger | Recommended Action |
| --- | --- | --- |
| `Unknown` | Platform error, network issue | Retry or display error message to user |
| `SystemError` | Store/Game Center server reported an internal failure | Retry later and show a user-friendly error |
| `NetworkError` | No internet connection | Show offline message or cache work |
| `NotAllowed` | Operation blocked (e.g., parental controls, insufficient privileges) | Disable the action and explain the restriction |
| `DataNotAvailable` | Requested leaderboard/achievement data missing | Refresh data or hide the UI section temporarily |
| `NotSupported` | Feature disabled on this platform/configuration | Hide feature entry points for the current platform |
| `ConfigurationError` | Essential Kit/Game Services settings mismatch | Verify leaderboard/achievement identifiers and platform setup |
| `InvalidInput` | Invalid leaderboard/achievement ID | Validate IDs against Essential Kit settings |
| `NotAuthenticated` | Operation requires authentication | Prompt player to sign in |

**Error Handling Example**:

```csharp
void HandleGameServicesError(Error error)
{
    if (error == null) return;

    Debug.Log($"Error: {error.Description}");

    // Handle specific error codes
    switch (error.Code)
    {
        case (int)GameServicesErrorCode.NotAuthenticated:
            Debug.Log("Player needs to sign in");
            Debug.Log("Show sign-in UI to the player.");
            break;

        case (int)GameServicesErrorCode.NotAllowed:
            Debug.LogWarning("Operation not allowed for this player or region.");
            break;

        case (int)GameServicesErrorCode.DataNotAvailable:
            Debug.LogWarning("Requested data is not available yet.");
            break;

        case (int)GameServicesErrorCode.NotSupported:
            Debug.LogWarning("Feature not supported on this platform or configuration.");
            break;

        case (int)GameServicesErrorCode.ConfigurationError:
            Debug.LogError("Game Services configuration mismatch.");
            break;

        case (int)GameServicesErrorCode.InvalidInput:
            Debug.Log("Invalid leaderboard or achievement ID");
            break;

        case (int)GameServicesErrorCode.NetworkError:
            Debug.Log("No internet connection");
            Debug.Log("Display offline message to the player.");
            break;

        case (int)GameServicesErrorCode.SystemError:
            Debug.LogError("Platform reported a server-side error.");
            break;

        default:
            Debug.Log("Unknown error occurred");
            break;
    }
}
```

## Advanced: Runtime Settings Initialization

{% hint style="danger" %}
**Warning**: Most games should use Essential Kit Settings configuration. Only use runtime initialization for dynamic leaderboard/achievement systems, server-driven configurations, or tournament modes.
{% endhint %}

### Understanding Runtime Initialization

**Default Behavior:**
Essential Kit auto-initializes Game Services using settings configured in the inspector. This works for 99% of games.

**Advanced Usage:**
Runtime initialization allows creating settings programmatically. Use this for:
- Dynamic tournament leaderboards loaded from your server
- Server-driven achievement systems
- A/B testing different leaderboard configurations
- Event-based competitions with temporary leaderboards

### Implementation

Override default settings at runtime:

```csharp
void Start()
{
    // Create settings programmatically
    var settings = new GameServicesUnitySettings(
        isEnabled: true,
        leaderboards: CreateDynamicLeaderboards(),
        achievements: CreateDynamicAchievements(),
        showAchievementCompletionBanner: true,
        allowFriendsAccess: true
    );

    GameServices.Initialize(settings);
}

LeaderboardDefinition[] CreateDynamicLeaderboards()
{
    // Example: Load from server or create dynamically
    return new[]
    {
        new LeaderboardDefinition(
            id: "tournament_weekly",
            platformId: "com.yourgame.tournament.weekly",
            platformIdOverrides: new RuntimePlatformConstantSet(
                ios: "com.yourgame.tournament.weekly",
                tvos: "com.yourgame.tournament.weekly.tv",
                android: "CgkI_TOURNAMENT_WEEKLY"
            ),
            title: "Weekly Tournament Leaderboard")
    };
}

AchievementDefinition[] CreateDynamicAchievements()
{
    // Example: Create achievements dynamically
    return new[]
    {
        new AchievementDefinition(
            id: "event_achievement",
            platformId: "com.yourgame.event.achievement",
            platformIdOverrides: new RuntimePlatformConstantSet(
                ios: "com.yourgame.event.achievement",
                tvos: "com.yourgame.event.achievement.tv",
                android: "CgkI_EVENT_ACHIEVEMENT"
            ),
            title: "Special Event Winner",
            numOfStepsToUnlock: 1)
    };
}
```

{% hint style="warning" %}
**Important**: Calling `Initialize()` again clears registered callbacks and events. Register for `OnAuthStatusChange` AFTER initialization.
{% endhint %}

## Related Guides
- Demo scene: `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/GameServicesDemo.unity`
- [Platform Setup](setup/) for Game Center and Play Games configuration
- [Testing Guide](testing.md) to validate your implementation
- [FAQ](faq.md) for common issues and troubleshooting

{% hint style="info" %}
Ready to test? Head to the [Testing Guide](testing.md) to validate your implementation on device and in the editor simulator.
{% endhint %}
