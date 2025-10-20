# Game Services Tutorial - Leaderboards

## What are Leaderboards?

Leaderboards are competitive ranking systems that display player scores in descending order. Why use leaderboards in a Unity mobile game? They create natural competition, encourage replay value, and provide social validation for player achievements through comparative scoring systems.

## Key Leaderboard APIs

### Creating Leaderboards

```csharp
string leaderboardId = "your_leaderboard_id";
ILeaderboard leaderboard = GameServices.CreateLeaderboard(leaderboardId);
Debug.Log("Created leaderboard: " + leaderboard.Id);
```

This snippet creates a leaderboard instance using your configured leaderboard identifier.

### Loading Available Leaderboards

```csharp
GameServices.LoadLeaderboards((result, error) =>
{
    if (error == null)
    {
        Debug.Log("Loaded leaderboards: " + result.Leaderboards.Length);
        foreach (var board in result.Leaderboards)
        {
            Debug.Log("Leaderboard: " + board.Title);
        }
    }
});
```

This snippet loads all configured leaderboards from the game service and displays their information.

### Reporting Scores

```csharp
string leaderboardId = "your_leaderboard_id";
long score = 1500;

GameServices.ReportScore(leaderboardId, score, (success, error) =>
{
    if (success)
    {
        Debug.Log("Score reported successfully");
    }
    else
    {
        Debug.Log("Score report failed: " + error.Description);
    }
});
```

This snippet submits a player's score to the specified leaderboard.

### Loading Top Scores

```csharp
ILeaderboard leaderboard = GameServices.CreateLeaderboard("your_leaderboard_id");
leaderboard.LoadScoresQuerySize = 10; // Load top 10 scores
leaderboard.LoadTopScores((result, error) =>
{
    if (error == null)
    {
        foreach (var score in result.Scores)
        {
            Debug.Log($"Rank {score.Rank}: {score.Player.DisplayName} - {score.Value}");
        }
    }
});
```

This snippet loads the top scores from a leaderboard and displays player rankings.

### Showing Native Leaderboard UI

```csharp
// Show all leaderboards
GameServices.ShowLeaderboards();

// Show specific leaderboard
string leaderboardId = "your_leaderboard_id";
GameServices.ShowLeaderboard(leaderboardId);
```

This snippet displays the platform's native leaderboard interface to players.

📌 **Video Note**: Show Unity demo of leaderboard creation, score submission, and the native leaderboard UI appearing on device.