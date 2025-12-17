# Usage

Once you are done with [setup](setup/) by configuring leaderboards and achievements, you can start implementing the feature with **GameServices** class and you can use this by importing the namespace.

```csharp
using VoxelBusters.CoreLibrary;
using VoxelBusters.EssentialKit;
```

## Overview

For accessing and managing leaderboards, achievements we need to let user authenticate first. Once user tries to login, the status updates will be posted in the form of events (OnAuthStatusChange).

Have the list of leaderboard and achievement id's ready (you set in setup) as these are required to refer them from code.

For submitting a score, you can either create a Leaderboard instance or use utility method of GameServices.

For reporting progress, create an achievement instance or use utility method of Game Services.

## Register for Events

You need to register for **GameServices.OnAuthStatusChange** event for getting the updates on auth status once you attempt logging in.

```csharp
private void OnEnable()
{
    // register for events
    GameServices.OnAuthStatusChange += OnAuthStatusChange;
}

private void OnDisable()
{
    base.OnDisable();

    // unregister from events
    GameServices.OnAuthStatusChange -= OnAuthStatusChange;
}
```

## Check Availability

First thing, we need to do is to check if game services are enabled in settings. If available we can proceed with sign in.

```csharp
bool isAvailable = GameServices.IsAvailable();
```

This returns true if feature is enabled in essential kit settings.

## Authenticate Player

If service is available, we can move on to Authenticating user.

```csharp
GameServices.Authenticate();
```

Authenticate method may open a dialog to let user enter the credentials for logging in.&#x20;

> #### On iOS, it may open Game Center login dialog and on Android, it can open a dialog for Game Play Services login.

{% hint style="success" %}
On Android, we try first with the silent login and if it fails, it opens a login dialog. If silent login is successful, it won't show up any login dialog.
{% endhint %}

You can listen to the status of the login through the event **GameServices.OnAuthStatusChange** and on successful login, you get an instance of **ILocalPlayer** or an error on failure.

```csharp
private void OnAuthStatusChange(GameServicesAuthStatusChangeResult result, Error error)
{
    if(error == null)
    {
        Debug.Log("Received auth status change event");
        Debug.Log("Auth status: " + result.AuthStatus);
        
        if(result.AuthStatus == LocalPlayerAuthStatus.Authenticated)
            Debug.Log("Local player: " + result.LocalPlayer);
        
    }
    else
    {
        Debug.LogError("Failed login with error : " + error);   
    }
}
```

You can access **ILocalUser** Instance any time through GameServices. However, you will get it null if the authentication is not successful.

```csharp
ILocalPlayer localPlayer = GameServices.LocalUser;
```

Incase if you want to know if the player is authenticated or not, you can check with IsAuthenticated

```csharp
bool loggedIn = GameServices.IsAuthenticated
```

![Game Center login view for iOS](../.gitbook/assets/GameCenterLogin.png)

![Google Play Services login view for Android](../.gitbook/assets/GooglePlayServicesLogin.png)

## Achievements

Achievements can be a great way to increase your users' engagement within your game. Achievements can also be a fun way for players to compare their progress with each other and engage in light-hearted competition.

### Get all Achievement Details

If you are planning for having your own custom achievements UI, you can get details of all achievements with LoadAchievementDescriptions call.

```csharp
GameServices.LoadAchievementDescriptions((result, error) =>
{
    if (error == null)
    {
        IAchievementDescription[] descriptions    = result.AchievementDescriptions;
        Debug.Log("Request to load achievement descriptions finished successfully.");
        Debug.Log("Total achievement descriptions fetched: " + descriptions.Length);
        Debug.Log("Below are the available achievement descriptions:");
        for (int iter = 0; iter < descriptions.Length; iter++)
        {
            IAchievementDescription description1    = descriptions[iter];
            Debug.Log(string.Format("[{0}]: {1}", iter, description1));
        }
    }
    else
    {
        Debug.Log("Request to load achievement descriptions failed with error. Error: " + error);
    }
});
```

> _**Achievement Description**_ : This holds description and images used to describe an achievement.

### Get achievements reported

You can get the list of achievements which got reported till date with LoadAchievements.&#x20;

```csharp
GameServices.LoadAchievements((result, error) =>
{
    if (error == null)
    {
        // show console messages
        IAchievement[] achievements    = result.Achievements;
        Debug.Log("Request to load achievements finished successfully.");
        Debug.Log("Total achievements fetched: " + achievements.Length);
        Debug.Log("Below are the available achievements:");
        for (int iter = 0; iter < achievements.Length; iter++)
        {
            IAchievement achievement1    = achievements[iter];
            Debug.Log(string.Format("[{0}]: {1}", iter, achievement1));
        }
    }
    else
    {
        Debug.Log("Request to load achievements failed with error. Error: " + error);
    }
});
```

> Difference between LoadAchievementDescriptions and LoadAchievements is the later only returns the achievements which are reported with  progress (check ReportProgress below).  Where as LoadAchievementDescriptions returns all the available achievements created on store dashboards.

### Report Achievement Progress

{% hint style="success" %}
_Achievement Progress_  denotes how much part of achievement is achieved.
{% endhint %}

* 100 % progress denotes Achievement is Unlocked and revealed to the player.
* One shot/Instant achievements unlock instantly and needs to be set 100% while reporting.
* Incremental achievements (which takes many steps to get unlocked) can be set with 0-100% range based on steps completed by the player.

{% tabs %}
{% tab title="Report With Achievement Id" %}
{% code title="Report a one-shot Achivement (This reveals and unlocks an achievemet)" %}
```csharp
string achievementId; //This is the Id set in Setup for each achievement
double percentageCompleted = 100;// This is in the range [0 - 100]
GameServices.ReportAchievementProgress(achievementId, percentageCompleted, (success, error) =>
{
    if (success)
    {
        Debug.Log("Request to submit progress finished successfully.");
    }
    else
    {
        Debug.Log("Request to submit progress failed with error. Error: " + error);
    }
});
```
{% endcode %}

{% hint style="success" %}
Report with 0 progress value if you just want to reveal a hidden achievement!
{% endhint %}

{% code title="Report an incremental Achivement" %}
```csharp
string achievementId; //This is the Id set in Setup for each achievement
int stepsCompleted     = 4; //Steps completed by user until now
int totalSteps         = 10; //This value you can get from AchievementDescription (NumberOfStepsRequiredToUnlockAchievement)
double percentageCompleted = (stepsCompleted/(totalSteps * 1.0)) * 100.0;// This is in the range [0 - 100]
GameServices.ReportAchievementProgress(achievementId, percentageCompleted, (error) =>
{
    if (error == null)
    {
        Debug.Log("Request to submit progress finished successfully.");
    }
    else
    {
        Debug.Log("Request to submit progress failed with error. Error: " + error);
    }
});
```
{% endcode %}
{% endtab %}

{% tab title="Report with Achievement Description Instance" %}
You can get the achievement description instance from LoadAchievementDescriptions callback method.

```csharp
IAchievementDescription achievementDescription; //This is the Id set in Setup for each achievement
double percentageCompleted = 100;// This is in the range [0 - 100]
GameServices.ReportAchievementProgress(achievementDescription, percentageCompleted, (success, error) =>
{
    if (success)
    {
        Debug.Log("Request to submit progress finished successfully.");
    }
    else
    {
        Debug.Log("Request to submit progress failed with error. Error: " + error);
    }
});
```
{% endtab %}

{% tab title="Report with Achievement Instance" %}
You can get the achievement description instance from LoadAchievement callback method.

```csharp
IAchievement achievement; //This is the Id set in Setup for each achievement
double percentageCompleted = 100;// This is in the range [0 - 100]
GameServices.ReportAchievementProgress(achievement, percentageCompleted, (success, error) =>
{
    if (error == null)
    {
        Debug.Log("Request to submit progress finished successfully.");
    }
    else
    {
        Debug.Log("Request to submit progress failed with error. Error: " + error);
    }
});
```
{% endtab %}
{% endtabs %}

### Show Achievements

You can display the default UI provided by native platform. If you are looking for displaying your own UI, you can make use of details form Achievements and Achievement Descriptions.

```csharp
GameServices.ShowAchievements((result, error) =>
{
    Debug.Log("Achievements view closed");
});
```

## Leaderboards

Leaderboards let your players to compete socially by sharing their scores to the world. Three actions can be done from Leaderboards API.&#x20;

* Load details of Leaderboards
* Loading Scores from a leaderboard(can give a User Scope and Time Scope).
* Reporting score to a  leaderboard
* Show Leaderboards

### Load details of Leaderboards

If you want to display the list of leaderboards configured on native platforms (Game Center and Google Play Services), you can get all the available leaderboards with **LoadLeaderboards**. This returns a list of ILeaderboard(doc) which has details regarding title, local player score and option to load icon image set for the leaderboard etc.

```csharp
GameServices.LoadLeaderboards((result, error) =>
{
    if (error == null)
    {
        // show console messages
        ILeaderboard[] leaderboards    = result.Leaderboards;
        Debug.Log("Request to load leaderboards finished successfully.");
        Debug.Log("Total leaderboards fetched: " + leaderboards.Length);
        Debug.Log("Below are the available leaderboards:");
        for (int iter = 0; iter < leaderboards.Length; iter++)
        {
            ILeaderboard leaderboard1    = leaderboards[iter];
            Debug.Log(string.Format("[{0}]: {1}", iter, leaderboard1));
        }
    }
    else
    {
        Debug.Log("Request to load leaderboards failed with error. Error: " + error);
    }
});
```

### Load Scores of a Leaderboard

Scores submitted to a leaderboard can be fetched  with ILeaderboard instance.

You can get ILeaderboard instance either by calling **LoadLeaderboards** or by creating an instance of Leaderboard.

```csharp
string leaderboardId; // This is the Id you set in Essential Kit Settings for the leaderboard entry
ILeaderboard leaderboard = GameServices.CreateLeaderboard(leaderboardId);
```

Now you have an instance of ILeaderboard.

> Leaderboards data will be fetched in terms of pages. This is because there can be lot of results reported by many and pagination will help not to load complete data at once.

You can set max scores that needs to be fetched by setting LoadScoresQuerySize property of ILeaderboard.

```csharp
leaderboard.LoadScoresQuerySize = 10; //leaderboard is ILeaderboard instance
```

{% hint style="warning" %}
Scores query size has a limit on Android where it caps to max of 25 scores.
{% endhint %}

You can set time scope to the scores that needs to be fetched. Time scope defines the time when the scores were submitted. This can be any of Today/Week/AllTime.

```csharp
leaderboard.TimeScope = LeaderboardTimeScope.Week;// For fetching submitted scores past week.
```

#### Loading Top Scores

```csharp
leaderboard.LoadTopScores((result, error) => {
    if (error == null)
    {
         Debug.Log("Scores loaded : " + result.Scores);
         for (int iter = 0; iter < result.Scores.Length; iter++)
         {
              IScore score = result.Scores[iter];
              Debug.Log(string.Format("Player {0} Rank : {1} Score : {2}", score.Player.DisplayName, score.Rank, score.Value);
         }
    }
    else
    {
         Debug.LogError("Failed loading top scores with error : " + error.Description);
    }
});
```

#### Loading Player centered scores

```csharp
leaderboard.LoadPlayerCenteredScores((result, error) => {
    if (error == null)
    {
         Debug.Log("Scores loaded : " + result.Scores);
         for (int iter = 0; iter < result.Scores.Length; iter++)
         {
              IScore score = result.Scores[iter];
              Debug.Log(string.Format("Player {0} Rank : {1} Score : {2}", score.Player.DisplayName, score.Rank, score.Value);
         }
    }
    else
    {
         Debug.LogError("Failed loading top scores with error : " + error.Description);
    }
});
```

{% hint style="info" %}
As the results returned by **LoadTopScores** and **LoadPlayerCenteredScores** are limited by **LoadScoresQuerySize** value, you can fetch the rest of the pages with **LoadPrevious** and **LoadNext** methods.
{% endhint %}

### Report Score to a leaderboard <a href="#report-score" id="report-score"></a>

For reporting a score to leaderboard, you need to have a **ILeaderboard**(doc) instance or [Id of the leaderboard set in Essential Kit Settings](setup/#properties) or an **IScore(doc)** instance created from CreateScore.

There are multiple ways to report a score

{% tabs %}
{% tab title="With Leaderboard Id" %}
```csharp
long        score       = 57;
string      leaderboardId = "leaderboardId";// Value from setup done in inspector
GameServices.ReportScore(leaderboardId, score, (success, error) =>
{
    if (success)
    {
        Debug.Log("Request to submit score finished successfully.");
    }
    else
    {
        Debug.Log("Request to submit score failed with error: " + error.Description);
    }
});
```
{% endtab %}

{% tab title="With ILeaderboard instance" %}
{% code title="Reporting with leaderboard id" %}
```csharp
long        score       = 57;
ILeaderboard      leaderboardInstance;// This you can get from either LoadLeaderboards or CreateLeaderboard
GameServices.ReportScore(leaderboardInstance, score, (success, error) =>
{
    if (success)
    {
        Debug.Log("Request to submit score finished successfully.");
    }
    else
    {
        Debug.Log("Request to submit score failed with error: " + error.Description);
    }
});
```
{% endcode %}
{% endtab %}

{% tab title="With IScore instance" %}
{% code title="Reporting with IScore instance" %}
```csharp
long        score       = 57;
string      leaderboardId = "leaderboardId";// Value from setup done in inspector
IScore      scoreInstance = GameServices.CreateScore(leaderboardId);
scoreInstance.ReportScore((success, error) =>
{
    if (success)
    {
        Debug.Log("Request to submit score finished successfully.");
    }
    else
    {
        Debug.Log("Request to submit score failed with error: " + error.Description);
    }
});
```
{% endcode %}
{% endtab %}
{% endtabs %}

### Show Leaderboards <a href="#show-leaderboards-ui" id="show-leaderboards-ui"></a>

By default, native platforms provide a way to show the leaderboards with their own UI.&#x20;

#### Showing All Leaderboards

```csharp
GameServices.ShowLeaderboards(callback: (result, error) =>
{
    Debug.Log("Leaderboards UI closed");
});
```

#### Showing a specific Leaderboard with Time Scope

```csharp
string leaderboardId = "leaderboardId";// Id you set for settings in Essential Kit Settings
GameServices.ShowLeaderboard(leaderboardId, LeaderboardTimeScope.AllTime, callback: (result, error) =>
{
    Debug.Log("Leaderboard UI closed");
});
```

