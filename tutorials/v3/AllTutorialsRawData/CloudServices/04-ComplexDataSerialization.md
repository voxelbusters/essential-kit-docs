# Complex Data Serialization

While Essential Kit handles primitive data types directly, you can store complex game objects by using JSON serialization with byte arrays.

## What is Complex Data Serialization?

Complex data serialization converts your custom game objects, arrays, and collections into a format that can be stored in cloud storage. Essential Kit uses JSON serialization combined with byte array storage for this purpose.

## Why Store Complex Data in Cloud?

Complex data storage enables:
- Complete player save game data
- Inventory and equipment systems
- Game configuration objects
- Achievement progress structures
- Custom player statistics

## Serializing Game Objects

### Basic Object Serialization

```csharp
[System.Serializable]
public class PlayerData
{
    public string playerName;
    public int level;
    public float experience;
    public bool[] unlockedLevels;
}

// Store complex object
PlayerData data = new PlayerData 
{ 
    playerName = "Hero", 
    level = 10, 
    experience = 2500.5f,
    unlockedLevels = new bool[] { true, true, false, false }
};

string json = JsonUtility.ToJson(data);
byte[] bytes = System.Text.Encoding.UTF8.GetBytes(json);
CloudServices.SetByteArray("player_save", bytes);
Debug.Log("Player data saved to cloud");
```

### Retrieving Complex Objects

```csharp
// Retrieve and deserialize complex object
byte[] savedData = CloudServices.GetByteArray("player_save");
if (savedData != null)
{
    string json = System.Text.Encoding.UTF8.GetString(savedData);
    PlayerData playerData = JsonUtility.FromJson<PlayerData>(json);
    Debug.Log($"Loaded: {playerData.playerName}, Level: {playerData.level}");
}
else
{
    Debug.Log("No save data found");
}
```

## Working with Collections

### List Serialization

```csharp
[System.Serializable]
public class InventoryData
{
    public List<string> items;
    public List<int> quantities;
}

// Store inventory
InventoryData inventory = new InventoryData
{
    items = new List<string> { "sword", "potion", "key" },
    quantities = new List<int> { 1, 5, 3 }
};

string json = JsonUtility.ToJson(inventory);
CloudServices.SetByteArray("inventory", System.Text.Encoding.UTF8.GetBytes(json));
Debug.Log("Inventory saved to cloud");
```

### Dictionary-like Data

```csharp
[System.Serializable]
public class SettingsData
{
    public string[] keys;
    public string[] values;
}

// Convert Dictionary to serializable format
Dictionary<string, string> settings = new Dictionary<string, string>
{
    { "difficulty", "hard" },
    { "graphics", "high" },
    { "language", "english" }
};

SettingsData data = new SettingsData
{
    keys = settings.Keys.ToArray(),
    values = settings.Values.ToArray()
};

string json = JsonUtility.ToJson(data);
CloudServices.SetByteArray("settings", System.Text.Encoding.UTF8.GetBytes(json));
Debug.Log("Settings saved to cloud");
```

## Error-Safe Serialization

```csharp
public static void SaveGameData<T>(string key, T data) where T : class
{
    try
    {
        string json = JsonUtility.ToJson(data);
        byte[] bytes = System.Text.Encoding.UTF8.GetBytes(json);
        CloudServices.SetByteArray(key, bytes);
        Debug.Log($"Successfully saved {key}");
    }
    catch (System.Exception e)
    {
        Debug.LogError($"Failed to save {key}: {e.Message}");
    }
}

public static T LoadGameData<T>(string key) where T : class
{
    try
    {
        byte[] data = CloudServices.GetByteArray(key);
        if (data == null) return null;
        
        string json = System.Text.Encoding.UTF8.GetString(data);
        return JsonUtility.FromJson<T>(json);
    }
    catch (System.Exception e)
    {
        Debug.LogError($"Failed to load {key}: {e.Message}");
        return null;
    }
}
```

## Handling User Account Changes

When cloud users change accounts, Essential Kit automatically handles data isolation. You can monitor account status in your serialization logic:

```csharp
private void SaveComplexData()
{
    var user = CloudServices.ActiveUser;
    if (user.AccountStatus == CloudUserAccountStatus.Available)
    {
        SaveGameData("player_save", currentPlayerData);
        Debug.Log("Complex data saved to cloud");
    }
    else
    {
        Debug.Log("Cloud unavailable - data saved locally only");
        // Implement local fallback storage
    }
}
```

Complex data serialization enables your Unity mobile games to store rich, structured player data that seamlessly syncs across all their devices.

📌 Video Note: Show Unity demo of storing and retrieving complex game objects, including inventory and player data examples.