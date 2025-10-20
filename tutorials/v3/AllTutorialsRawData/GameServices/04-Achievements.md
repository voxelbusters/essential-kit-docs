# Game Services Tutorial - Achievements

## What are Achievements?

Achievements are milestone rewards that players unlock by completing specific tasks or reaching certain goals. Why use achievements in a Unity mobile game? They provide clear progression goals, increase player engagement through completion rewards, and create additional retention by encouraging players to complete all available challenges.

## Key Achievement APIs

### Creating Achievements

```csharp
string achievementId = "your_achievement_id";
IAchievement achievement = GameServices.CreateAchievement(achievementId);
Debug.Log("Created achievement: " + achievement.Id);
```

This snippet creates an achievement instance using your configured achievement identifier.

### Loading Achievement Descriptions (Metadata)

```csharp
GameServices.LoadAchievementDescriptions((result, error) =>
{
    if (error == null)
    {
        Debug.Log("Loaded achievement definitions: " + result.AchievementDescriptions.Length);
        foreach (var desc in result.AchievementDescriptions)
        {
            Debug.Log($"Achievement: {desc.Title} - {desc.UnachievedDescription}");
            Debug.Log($"Points: {desc.Points}");
        }
    }
});
```

This snippet loads all achievement metadata including titles, descriptions, icons, and point values - the same for all players.

### Loading Player Achievement Progress

```csharp
GameServices.LoadAchievements((result, error) =>
{
    if (error == null)
    {
        Debug.Log("Loaded player's achievements: " + result.Achievements.Length);
        foreach (var achievement in result.Achievements)
        {
            Debug.Log($"{achievement.Id}: {achievement.PercentageCompleted}% complete");
            Debug.Log($"Completed: {achievement.IsCompleted}");
        }
    }
});
```

This snippet loads the current local player's actual progress and completion status for achievements they've worked on.

### Reporting Achievement Progress

```csharp
string achievementId = "your_achievement_id";
double progressPercentage = 75.0; // 75% complete

GameServices.ReportAchievementProgress(achievementId, progressPercentage, (success, error) =>
{
    if (success)
    {
        Debug.Log("Achievement progress updated successfully");
    }
    else
    {
        Debug.Log("Progress update failed: " + error.Description);
    }
});
```

This snippet reports player progress toward an achievement (0-100% completion).

### Unlocking Achievements

```csharp
string achievementId = "first_victory";
GameServices.ReportAchievementProgress(achievementId, 100.0, (success, error) =>
{
    if (success)
    {
        Debug.Log("Achievement unlocked!");
    }
});
```

This snippet unlocks an achievement by setting progress to 100%.

### Showing Native Achievement UI

```csharp
GameServices.ShowAchievements((result, error) =>
{
    Debug.Log("Achievement UI closed");
});
```

This snippet displays the platform's native achievement interface to players.

📌 **Video Note**: Show Unity demo of achievement progress reporting, achievement unlock notifications, and the native achievement UI display.