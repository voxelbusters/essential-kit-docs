# Game Services Tutorial - Advanced Usage

## Custom Runtime Initialization

For advanced use cases where you need to configure Game Services at runtime rather than using the default settings:

```csharp
// Create custom settings at runtime
GameServicesUnitySettings customSettings = ScriptableObject.CreateInstance<GameServicesUnitySettings>();
customSettings.ShowAchievementCompletionBanner = true;

// Configure leaderboards at runtime
customSettings.Leaderboards = new LeaderboardDefinition[]
{
    new LeaderboardDefinition()
    {
        Id = "high_score_leaderboard",
        IosId = "ios.leaderboard.highscore",
        AndroidId = "android_leaderboard_highscore"
    }
};

// Configure achievements at runtime
customSettings.Achievements = new AchievementDefinition[]
{
    new AchievementDefinition()
    {
        Id = "first_win_achievement",
        IosId = "ios.achievement.firstwin", 
        AndroidId = "android_achievement_first_win"
    }
};

// Initialize with custom settings
GameServices.Initialize(customSettings);
Debug.Log("Game Services initialized with runtime configuration");
```

This snippet shows how to configure leaderboards and achievements dynamically at runtime, useful for games that load configurations from servers.

## Custom Leaderboard UI Implementation

Creating your own leaderboard interface instead of using the native UI:

```csharp
void LoadCustomLeaderboardUI(string leaderboardId)
{
    ILeaderboard leaderboard = GameServices.CreateLeaderboard(leaderboardId);
    leaderboard.LoadScoresQuerySize = 20;
    leaderboard.TimeScope = LeaderboardTimeScope.Week;
    
    leaderboard.LoadTopScores((result, error) =>
    {
        if (error == null)
        {
            DisplayCustomLeaderboard(result.Scores, result.LocalPlayerScore);
        }
    });
}

void DisplayCustomLeaderboard(ILeaderboardScore[] scores, ILeaderboardScore localScore)
{
    Debug.Log("=== CUSTOM LEADERBOARD ===");
    for (int i = 0; i < scores.Length; i++)
    {
        string highlight = (scores[i] == localScore) ? ">>> " : "    ";
        Debug.Log($"{highlight}#{scores[i].Rank} {scores[i].Player.DisplayName}: {scores[i].Value}");
    }
}
```

This snippet creates a custom leaderboard display instead of using the platform's native UI.

## Custom Achievement Progress Tracking

Implementing detailed achievement progress with custom UI feedback:

```csharp
void TrackCustomAchievementProgress(string achievementId, float increment)
{
    // Load current achievement to check progress
    GameServices.LoadAchievements((result, error) =>
    {
        if (error == null)
        {
            var achievement = System.Array.Find(result.Achievements, a => a.Id == achievementId);
            if (achievement != null)
            {
                double newProgress = Mathf.Min(100.0, achievement.PercentageCompleted + increment);
                
                // Show custom progress UI
                ShowCustomProgressUI(achievementId, achievement.PercentageCompleted, newProgress);
                
                // Report the updated progress
                GameServices.ReportAchievementProgress(achievementId, newProgress, (success, progressError) =>
                {
                    if (success && newProgress >= 100.0)
                    {
                        ShowCustomAchievementUnlocked(achievementId);
                    }
                });
            }
        }
    });
}

void ShowCustomProgressUI(string achievementId, double oldProgress, double newProgress)
{
    Debug.Log($"Achievement {achievementId}: {oldProgress:F1}% → {newProgress:F1}%");
}
```

This snippet implements custom achievement progress tracking with detailed feedback.

## Error Handling with Specific Error Codes

Using the actual GameServicesErrorCode enum for precise error handling:

```csharp
void HandleGameServicesErrors()
{
    GameServices.LoadLeaderboards((result, error) =>
    {
        if (error != null)
        {
            // Handle specific error types
            if (error.Code == (int)GameServicesErrorCode.NetworkNotAvailable)
            {
                Debug.Log("Network unavailable - showing offline mode");
                ShowOfflineMode();
            }
            else if (error.Code == (int)GameServicesErrorCode.UserNotAuthenticated)
            {
                Debug.Log("User not authenticated - prompting login");
                GameServices.Authenticate(interactive: true);
            }
            else
            {
                Debug.Log($"Game Services error: {error.Description}");
            }
        }
    });
}

void ShowOfflineMode()
{
    Debug.Log("Switching to offline leaderboard cache");
}
```

This snippet demonstrates proper error handling using specific error codes for different scenarios.

## Batch Operations for Performance

Efficiently loading multiple game service data in sequence:

```csharp
void LoadAllGameData()
{
    // Load leaderboards first
    GameServices.LoadLeaderboards((leaderboardResult, leaderboardError) =>
    {
        if (leaderboardError == null)
        {
            Debug.Log($"Loaded {leaderboardResult.Leaderboards.Length} leaderboards");
            
            // Then load player's achievement progress
            GameServices.LoadAchievements((achievementResult, achievementError) =>
            {
                if (achievementError == null)
                {
                    Debug.Log($"Loaded {achievementResult.Achievements.Length} player achievements");
                    OnAllGameDataLoaded();
                }
            });
        }
    });
}

void OnAllGameDataLoaded()
{
    Debug.Log("Game Services data loaded - enabling UI");
}
```

This snippet demonstrates efficient batch loading of relevant Game Services data.

📌 **Video Note**: Show Unity demo of custom leaderboard UI, achievement progress animations, and error handling scenarios in action.