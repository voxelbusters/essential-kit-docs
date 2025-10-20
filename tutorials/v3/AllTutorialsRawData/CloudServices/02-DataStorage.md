# Working with Cloud Data

Cloud data operations form the core of Essential Kit's Cloud Services, allowing you to store and retrieve player information across all their devices.

## What is Cloud Data Management?

Cloud Services manages two copies of your data: the "Cloud Copy" (stored remotely) and the "Local Copy" (cached on device). When you store data, it goes to both locations. When you retrieve data, it comes from the local cache for speed. During synchronization, the local copy is updated with the latest cloud data.

## Why Use Cloud Data in Unity Mobile Games?

Cloud data ensures player information persists across device changes and enables multi-device gameplay. Players can start on their phone and continue on their tablet with all progress intact.

## Supported Data Types

Essential Kit supports these data types for cloud storage and retrieval:

### Primitive Types

**Boolean Operations:**
```csharp
// Store boolean values
CloudServices.SetBool("sound_enabled", true);
CloudServices.SetBool("tutorial_completed", false);

// Retrieve boolean values
bool soundEnabled = CloudServices.GetBool("sound_enabled");
bool tutorialComplete = CloudServices.GetBool("tutorial_completed");
Debug.Log($"Sound: {soundEnabled}, Tutorial: {tutorialComplete}");
```

**Integer Operations:**
```csharp
// Store integer values  
CloudServices.SetInt("player_level", 15);
CloudServices.SetLong("total_coins", 50000);

// Retrieve integer values
int playerLevel = CloudServices.GetInt("player_level");
long totalCoins = CloudServices.GetLong("total_coins");
Debug.Log($"Level: {playerLevel}, Coins: {totalCoins}");
```

**Floating Point Operations:**
```csharp
// Store floating point values
CloudServices.SetFloat("music_volume", 0.8f);
CloudServices.SetDouble("high_score", 99999.99);

// Retrieve floating point values
float musicVolume = CloudServices.GetFloat("music_volume");
double highScore = CloudServices.GetDouble("high_score");
Debug.Log($"Volume: {musicVolume}, Score: {highScore}");
```

**String Operations:**
```csharp
// Store string values
CloudServices.SetString("player_name", "CloudMaster");
CloudServices.SetString("last_level", "forest_world_3");

// Retrieve string values
string playerName = CloudServices.GetString("player_name");
string lastLevel = CloudServices.GetString("last_level");
Debug.Log($"Player: {playerName}, Last Level: {lastLevel}");
```

### Advanced Types

**Byte Array Operations:**
```csharp
// Store byte array data
string jsonData = "{\"inventory\":[\"sword\",\"shield\"]}";
byte[] gameData = System.Text.Encoding.UTF8.GetBytes(jsonData);
CloudServices.SetByteArray("save_data", gameData);

// Retrieve byte array data
byte[] retrievedData = CloudServices.GetByteArray("save_data");
if (retrievedData != null)
{
    string jsonString = System.Text.Encoding.UTF8.GetString(retrievedData);
    Debug.Log($"Retrieved game data: {jsonString}");
}
```

## Checking for Key Existence

Before retrieving data, you can check if a key exists:

```csharp
if (CloudServices.HasKey("player_level"))
{
    int level = CloudServices.GetInt("player_level");
    Debug.Log($"Found existing player level: {level}");
}
else
{
    Debug.Log("No saved player level found - using default");
}
```

## Default Values

Get methods return safe default values when keys don't exist:
- `GetBool()` returns `false`
- `GetInt()` and `GetLong()` return `0`
- `GetFloat()` and `GetDouble()` return `0.0`
- `GetString()` returns `null`
- `GetByteArray()` returns `null`

## How Cloud Data Works

When you call a `Set` method, Essential Kit:
1. Stores the value in local cache immediately
2. Sends the value to cloud storage
3. Handles network errors gracefully
4. Syncs data when connection is restored

When you call a `Get` method, Essential Kit returns data from the local cache for optimal performance.

📌 Video Note: Show Unity demo of storing and retrieving different data types, including checking for key existence.