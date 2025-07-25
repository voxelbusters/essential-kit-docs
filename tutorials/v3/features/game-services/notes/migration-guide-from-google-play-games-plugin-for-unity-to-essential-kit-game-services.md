# Migration Guide: From Google Play Games Plugin for Unity to Essential Kit Game Services

This guide provides step-by-step instructions for migrating from Google Play Games Plugin to Essential Kit's Game Services. The migration process involves updating your authentication, achievements, leaderboards, and friends management code to use Essential Kit's unified cross-platform API.

### Prerequisites

* Essential Kit package installed and configured
* Existing Google Play Games Plugin project to migrate
* Platform IDs for your existing leaderboards and achievements

### Migration Overview

| Aspect                   | Google Play Games Plugin               | Essential Kit Game Services            |
| ------------------------ | -------------------------------------- | -------------------------------------- |
| **Namespace**            | `using GooglePlayGames;`               | `using VoxelBusters.EssentialKit;`     |
| **Platform Support**     | Android only                           | iOS + Android unified                  |
| **Initialization**       | `PlayGamesPlatform.Activate()`         | `GameServices.Initialize()` (optional) |
| **Authentication**       | `Social.localUser.Authenticate()`      | `GameServices.Authenticate()`          |
| **Platform Abstraction** | Unity's Social API + Google extensions | Essential Kit unified API              |

### Step 1: Configuration Setup

#### 1.1 Remove Google Play Games Plugin Configuration

```csharp
// REMOVE: Old Google Play Games initialization
PlayGamesPlatform.Activate();
PlayGamesPlatform.Instance.AddIdMapping("high_scores", "CgkIabcdefghijklmnop");
PlayGamesPlatform.Instance.AddIdMapping("first_win", "CgkIxyzuvwabcdefgh");
```

#### 1.2 Configure Essential Kit Settings

1. Open **Window → Voxel Busters → Essential Kit → Settings**
2. Navigate to **Game Services** section
3. Configure your leaderboards and achievements:

**Leaderboards Configuration:**

```
Leaderboards:
├── [0] High Scores
│   ├── Id: "high_scores"
│   ├── iOS Platform Id: "com.yourgame.highscores" 
│   ├── Android Platform Id: "CgkIabcdefghijklmnop"
│   ├── Title: "High Scores"
│   └── Score Format Type: Integer
└── [+] Add New Leaderboard
```

**Achievements Configuration:**

```
Achievements:
├── [0] First Victory  
│   ├── Id: "first_win"
│   ├── iOS Platform Id: "com.yourgame.firstwin"
│   ├── Android Platform Id: "CgkIxyzuvwabcdefgh" 
│   ├── Title: "First Victory"
│   ├── Description: "Win your first game"
│   └── Point Value: 100
└── [+] Add New Achievement
```

### Step 2: Namespace and Initialization Migration

#### 2.1 Update Using Statements

```csharp
// REMOVE: Old namespaces
// using GooglePlayGames;
// using GooglePlayGames.BasicApi;
// using UnityEngine.SocialPlatforms;

// ADD: Essential Kit namespaces
using VoxelBusters.CoreLibrary;
using VoxelBusters.EssentialKit;
```

#### 2.2 Update Initialization Code

```csharp
// OLD: Google Play Games initialization
void Start()
{
    PlayGamesPlatform.Activate();
    Social.localUser.Authenticate(OnAuthenticate);
}

// NEW: Essential Kit initialization (optional - auto-initializes from settings)
void Start()
{
    // Optional: Check if service is available
    if (GameServices.IsAvailable())
    {
        // Subscribe to auth status changes
        GameServices.OnAuthStatusChange += OnAuthStatusChange;
        
        // Authenticate
        GameServices.Authenticate();
    }
}
```

### Step 3: Authentication Migration

#### 3.1 Authentication Status Handling

```csharp
// OLD: Google Play Games authentication
private void OnAuthenticate(bool success)
{
    if (success)
    {
        Debug.Log("Authenticated successfully");
        string playerId = Social.localUser.id;
        string playerName = Social.localUser.userName;
    }
    else
    {
        Debug.Log("Authentication failed");
    }
}

// NEW: Essential Kit authentication
private void OnAuthStatusChange(GameServicesAuthStatusChangeResult result, Error error)
{
    if (error == null)
    {
        switch (result.AuthStatus)
        {
            case LocalPlayerAuthStatus.Authenticated:
                Debug.Log("Player authenticated successfully");
                var localPlayer = GameServices.LocalPlayer;
                string playerId = localPlayer.Id;
                string playerName = localPlayer.DisplayName;
                break;
                
            case LocalPlayerAuthStatus.NotAuthenticated:
                Debug.Log("Player not authenticated");
                break;
                
            case LocalPlayerAuthStatus.Authenticating:
                Debug.Log("Authentication in progress...");
                break;
        }
    }
    else
    {
        Debug.LogError($"Authentication error: {error.Description}");
    }
}
```

#### 3.2 Check Authentication Status

```csharp
// OLD: Check authentication status
bool isAuthenticated = Social.localUser.authenticated;

// NEW: Check authentication status
bool isAuthenticated = GameServices.IsAuthenticated;
```

### Step 4: Achievement Migration

#### 4.1 Reporting Achievement Progress

```csharp
// OLD: Google Play Games achievement reporting
Social.ReportProgress("first_win", 100.0, (bool success) =>
{
    if (success)
        Debug.Log("Achievement unlocked!");
});

// Alternative Google method
PlayGamesPlatform.Instance.UnlockAchievement("first_win", (bool success) => 
{
    Debug.Log($"Achievement unlock: {success}");
});

// NEW: Essential Kit achievement reporting
GameServices.ReportAchievementProgress("first_win", 100.0, (error) =>
{
    if (error == null)
    {
        Debug.Log("Achievement unlocked!");
    }
    else
    {
        Debug.LogError($"Achievement error: {error.Description}");
    }
});
```

#### 4.2 Loading Achievements

```csharp
// OLD: Google Play Games load achievements
Social.LoadAchievements((IAchievement[] achievements) =>
{
    foreach (var achievement in achievements)
    {
        Debug.Log($"Achievement: {achievement.id}, Progress: {achievement.percentCompleted}");
    }
});

// NEW: Essential Kit load achievements
GameServices.LoadAchievements((result, error) =>
{
    if (error == null)
    {
        foreach (var achievement in result.Achievements)
        {
            Debug.Log($"Achievement: {achievement.Id}, Progress: {achievement.PercentageCompleted}");
        }
    }
    else
    {
        Debug.LogError($"Load achievements error: {error.Description}");
    }
});
```

#### 4.3 Show Achievements UI

```csharp
// OLD: Google Play Games show achievements
Social.ShowAchievementsUI();

// NEW: Essential Kit show achievements
GameServices.ShowAchievements((result, error) =>
{
    if (error == null)
    {
        Debug.Log("Achievements UI closed");
    }
});
```

### Step 5: Leaderboard Migration

#### 5.1 Reporting Scores

```csharp
// OLD: Google Play Games score reporting
Social.ReportScore(1000, "high_scores", (bool success) =>
{
    Debug.Log($"Score reported: {success}");
});

// NEW: Essential Kit score reporting
GameServices.ReportScore("high_scores", 1000, (error) =>
{
    if (error == null)
    {
        Debug.Log("Score reported successfully");
    }
    else
    {
        Debug.LogError($"Score report error: {error.Description}");
    }
});

// NEW: Score reporting with context tag
GameServices.ReportScore("high_scores", 1000, (error) =>
{
    // Handle callback
}, tag: "level_1");
```

#### 5.2 Loading Leaderboards

```csharp
// OLD: Google Play Games load leaderboard
var leaderboard = Social.CreateLeaderboard();
leaderboard.id = "high_scores";
leaderboard.LoadScores((bool success) =>
{
    if (success)
    {
        foreach (var score in leaderboard.scores)
        {
            Debug.Log($"Score: {score.value}, Player: {score.userID}");
        }
    }
});

// NEW: Essential Kit load leaderboard
GameServices.LoadLeaderboards((result, error) =>
{
    if (error == null)
    {
        foreach (var leaderboard in result.Leaderboards)
        {
            Debug.Log($"Leaderboard: {leaderboard.Id}, Title: {leaderboard.Title}");
        }
    }
});
```

#### 5.3 Show Leaderboard UI

```csharp
// OLD: Google Play Games show leaderboard
Social.ShowLeaderboardUI();

// Or specific leaderboard
PlayGamesPlatform.Instance.ShowLeaderboardUI("high_scores");

// NEW: Essential Kit show leaderboards
GameServices.ShowLeaderboards(LeaderboardTimeScope.AllTime, (result, error) =>
{
    if (error == null)
    {
        Debug.Log("Leaderboards UI closed");
    }
});

// Or specific leaderboard
GameServices.ShowLeaderboard("high_scores", LeaderboardTimeScope.AllTime, (result, error) =>
{
    Debug.Log("Leaderboard UI closed");
});
```

### Step 6: Friends Management Migration

#### 6.1 Loading Friends

```csharp
// OLD: Google Play Games load friends
Social.localUser.LoadFriends((bool success) =>
{
    if (success)
    {
        foreach (var friend in Social.localUser.friends)
        {
            Debug.Log($"Friend: {friend.userName}");
        }
    }
});

// NEW: Essential Kit load friends
GameServices.LoadFriends((result, error) =>
{
    if (error == null)
    {
        foreach (var friend in result.Friends)
        {
            Debug.Log($"Friend: {friend.DisplayName}");
        }
    }
});
```

#### 6.2 Adding Friends (Essential Kit Feature)

```csharp
// NEW: Essential Kit specific feature - Add friend
GameServices.AddFriend("player_id_to_add", (success, error) =>
{
    if (error == null && success)
    {
        Debug.Log("Friend request sent successfully");
    }
});
```

### Step 7: Advanced Features Migration

#### 7.1 Server Credentials (Enhanced in Essential Kit)

```csharp
// OLD: Google Play Games server access
PlayGamesPlatform.Instance.RequestServerSideAccess(true, (string authCode) =>
{
    if (!string.IsNullOrEmpty(authCode))
    {
        // Send auth code to your server
    }
});

// NEW: Essential Kit server credentials
GameServices.LoadServerCredentials((result, error) =>
{
    if (error == null)
    {
        var credentials = result.ServerCredentials;
        Debug.Log($"Player ID: {credentials.PlayerId}");
        Debug.Log($"Auth Token: {credentials.AuthToken}");
        // More comprehensive server integration data
    }
});
```

#### 7.2 Error Handling Improvements

```csharp
// OLD: Google Play Games basic error handling
Social.ReportScore(1000, "leaderboard", (bool success) =>
{
    if (!success)
    {
        Debug.Log("Score report failed"); // Limited error info
    }
});

// NEW: Essential Kit comprehensive error handling
GameServices.ReportScore("leaderboard", 1000, (error) =>
{
    if (error != null)
    {
        Debug.LogError($"Score report failed: {error.Description}");
        Debug.LogError($"Error Code: {error.Code}");
        Debug.LogError($"Domain: {error.Domain}");
        // Detailed error information for debugging
    }
});
```

### Step 8: Event Management Migration

#### 8.1 Subscribe to Game Services Events

```csharp
// NEW: Essential Kit event subscriptions (in Start or Awake)
private void Start()
{
    // Subscribe to authentication status changes
    GameServices.OnAuthStatusChange += OnAuthStatusChange;
}

private void OnDestroy()
{
    // Unsubscribe to prevent memory leaks
    GameServices.OnAuthStatusChange -= OnAuthStatusChange;
}
```

### Step 9: Platform-Specific Considerations

#### 9.1 Handling iOS Game Center (New Capability)

```csharp
// Essential Kit automatically handles iOS Game Center integration
// No additional code required - same API works on both platforms

#if UNITY_IOS
    // iOS-specific behavior (if needed)
    Debug.Log("Running on iOS with Game Center integration");
#elif UNITY_ANDROID
    // Android-specific behavior (if needed)
    Debug.Log("Running on Android with Play Games Services");
#endif
```

### Step 10: Testing and Validation

#### 10.1 Testing Checklist

* [ ] Authentication works on both platforms
* [ ] Achievement unlock/progress reporting functions correctly
* [ ] Leaderboard score submission and retrieval works
* [ ] UI dialogs display properly
* [ ] Friends management functions (if used)
* [ ] Error handling provides meaningful feedback
* [ ] Cross-platform ID mapping works correctly

#### 10.2 Common Migration Issues and Solutions

**Issue: Missing platform IDs**

```csharp
// SOLUTION: Ensure all platform IDs are configured in Essential Kit settings
// Check Window → Voxel Busters → Essential Kit → Configure
```

**Issue: Authentication not working**

```csharp
// SOLUTION: Check service availability and event subscription
if (GameServices.IsAvailable())
{
    GameServices.OnAuthStatusChange += OnAuthStatusChange;
    GameServices.Authenticate();
}
```

{% content-ref url="../../../notes/google-play-services-authentication.md" %}
[google-play-services-authentication.md](../../../notes/google-play-services-authentication.md)
{% endcontent-ref %}

**Issue: Cross-platform testing**

```csharp
// SOLUTION: Test on both platforms with proper platform IDs
#if UNITY_EDITOR
    Debug.Log("Testing in simulator mode");
#endif
```

### Migration Timeline Estimate

* **Small Project** (< 5 leaderboards/achievements): 2-4 hours
* **Medium Project** (5-15 leaderboards/achievements): 4-8 hours
* **Large Project** (15+ leaderboards/achievements): 8-16 hours

### Benefits After Migration

1. **Cross-Platform Unity**: Single codebase works on both iOS and Android
2. **Improved Error Handling**: Detailed error information for better debugging
3. **Modern API Design**: Cleaner, more intuitive method signatures
4. **Visual Configuration**: Inspector-based setup reduces code complexity
5. **Enhanced Features**: Additional functionality like AddFriend, server credentials
6. **Future-Proof**: Unified API insulates from platform-specific changes



This migration guide should help you transition from Google Play Games Plugin to Essential Kit Game Services while taking advantage of the enhanced cross-platform capabilities and improved developer experience.
