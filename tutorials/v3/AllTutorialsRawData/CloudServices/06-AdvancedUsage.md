# Advanced Usage

This section covers advanced Cloud Services scenarios for experienced Unity developers working on complex cross-platform mobile games.

## Custom Initialization with Settings

For advanced control, you can initialize Cloud Services with custom settings:

```csharp
CloudServicesUnitySettings customSettings = ScriptableObject.CreateInstance<CloudServicesUnitySettings>();
CloudServices.Initialize(customSettings);
Debug.Log("Cloud Services initialized with custom settings");
```

## Checking Service Availability

Before using Cloud Services, check if it's available on the current platform:

```csharp
if (CloudServices.IsAvailable())
{
    Debug.Log("Cloud Services is available on this platform");
    // Proceed with cloud operations
}
else
{
    Debug.Log("Cloud Services not available - use local storage fallback");
    // Implement fallback strategy
}
```

## Batch Data Operations

For better performance, batch multiple operations together:

```csharp
// Store multiple related values
CloudServices.SetString("game_mode", "adventure");
CloudServices.SetInt("difficulty", 3);
CloudServices.SetBool("hardcore_mode", true);

// Then synchronize once
CloudServices.Synchronize((result) => 
{
    Debug.Log("Batch operation synchronized");
});
```

## Complex Data Serialization

Store complex game objects using JSON serialization:

```csharp
[System.Serializable]
public class PlayerData
{
    public string name;
    public int level;
    public float[] position;
    public List<string> inventory;
}

// Serialize and store
PlayerData data = new PlayerData { name = "Hero", level = 5 };
string json = JsonUtility.ToJson(data);
byte[] bytes = System.Text.Encoding.UTF8.GetBytes(json);
CloudServices.SetByteArray("player_data", bytes);
Debug.Log("Complex player data stored");
```

## Error-Safe Data Retrieval

Implement robust error handling for data retrieval:

```csharp
public T GetCloudData<T>(string key, T defaultValue)
{
    try
    {
        if (!CloudServices.HasKey(key)) 
            return defaultValue;
            
        // Type-specific retrieval logic
        if (typeof(T) == typeof(string))
            return (T)(object)CloudServices.GetString(key);
        else if (typeof(T) == typeof(int))
            return (T)(object)CloudServices.GetInt(key);
            
        return defaultValue;
    }
    catch (System.Exception e)
    {
        Debug.LogError($"Failed to retrieve {key}: {e.Message}");
        return defaultValue;
    }
}
```

## Monitoring Cloud Storage Quota

Handle storage quota violations (primarily on iOS):

```csharp
CloudServices.OnSavedDataChange += (result) =>
{
    if (result.ChangeReason == CloudSavedDataChangeReasonCode.QuotaViolation)
    {
        Debug.LogWarning("Cloud storage quota exceeded!");
        // Clean up old or less important data
        RemoveOldCloudData();
    }
};
```

## Key Management Strategy

Implement a systematic approach to key naming:

```csharp
public static class CloudKeys
{
    public const string PLAYER_LEVEL = "player.level";
    public const string GAME_SETTINGS = "settings.game";
    public const string SAVE_DATA = "save.primary";
    
    public static string GetUserKey(string userId, string key) =>
        $"user.{userId}.{key}";
}

// Usage
CloudServices.SetInt(CloudKeys.PLAYER_LEVEL, 10);
```

## Conditional Cloud Operations

Execute operations based on user account status:

```csharp
private void SavePlayerProgress(int level)
{
    if (CloudServices.ActiveUser.AccountStatus == CloudUserAccountStatus.Available)
    {
        CloudServices.SetInt("player_level", level);
        CloudServices.Synchronize();
        Debug.Log("Progress saved to cloud");
    }
    else
    {
        PlayerPrefs.SetInt("player_level", level);
        Debug.Log("Progress saved locally only");
    }
}
```

These advanced patterns help you build robust, scalable Unity cross-platform mobile games with sophisticated cloud data management.

📌 Video Note: Show Unity demo of each advanced usage pattern with practical examples.