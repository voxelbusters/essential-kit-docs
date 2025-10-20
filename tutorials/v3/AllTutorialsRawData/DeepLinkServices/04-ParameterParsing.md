# Parameter Parsing

## What is Parameter Parsing?

Parameter parsing extracts meaningful data from incoming deep links to navigate users to specific content in your Unity mobile game. This enables features like level sharing, friend invitations, and campaign tracking.

Why use it in Unity mobile games? Transform generic links into specific game actions like "open level 5" or "join multiplayer room ABC123".

## Parsing URL Path Components

Extract path segments from incoming links:

```csharp
void HandleDeepLink(DeepLinkServicesDynamicLinkOpenResult result)
{
    string[] pathSegments = result.Url.AbsolutePath.Split('/');
    
    if (pathSegments.Length >= 3 && pathSegments[1] == "level")
    {
        string levelId = pathSegments[2];
        Debug.Log($"Navigate to level: {levelId}");
    }
}
```

This snippet parses URLs like `mygame://level/5` or `https://mygame.com/level/5` to extract the level ID.

## Parsing Query Parameters

Extract URL query parameters for additional data:

```csharp
void HandleDeepLink(DeepLinkServicesDynamicLinkOpenResult result)
{
    string query = result.Url.Query;
    var parameters = ParseQueryString(query);
    
    if (parameters.ContainsKey("player"))
    {
        string playerId = parameters["player"];
        Debug.Log($"Challenge from player: {playerId}");
    }
}

Dictionary<string, string> ParseQueryString(string query)
{
    var dict = new Dictionary<string, string>();
    if (query.StartsWith("?")) query = query.Substring(1);
    
    foreach (string pair in query.Split('&'))
    {
        string[] keyValue = pair.Split('=');
        if (keyValue.Length == 2)
            dict[keyValue[0]] = keyValue[1];
    }
    return dict;
}
```

This snippet handles URLs like `mygame://invite?player=john123&room=abc` to extract player and room information.

## Game Navigation Examples

Route parsed parameters to specific game features:

```csharp
void ProcessGameNavigation(System.Uri url)
{
    string[] path = url.AbsolutePath.Split('/');
    
    switch (path[1])
    {
        case "level":
            int levelId = int.Parse(path[2]);
            Debug.Log($"Loading level {levelId}");
            break;
            
        case "multiplayer":
            string roomCode = path[2]; 
            Debug.Log($"Joining room {roomCode}");
            break;
            
        case "shop":
            string itemId = path[2];
            Debug.Log($"Opening shop item {itemId}");
            break;
    }
}
```

This snippet demonstrates routing different URL patterns to appropriate game systems.

## Essential Kit Settings for Parameter Testing

📌 **Video Note**: Show testing deep links with parameters

Create test links in Essential Kit Settings documentation:

**Racing Game Examples:**
```
Custom Scheme: racegame://track/silverstone?mode=timeattack
Universal Link: https://racegame.com/track/silverstone?mode=timeattack

Custom Scheme: racegame://garage?car=ferrari&upgrade=true  
Universal Link: https://racegame.com/garage?car=ferrari&upgrade=true
```

**RPG Game Examples:**
```
Custom Scheme: rpggame://quest/dragon?difficulty=hard
Universal Link: https://rpggame.com/quest/dragon?difficulty=hard

Custom Scheme: rpggame://character/123?equip=sword
Universal Link: https://rpggame.com/character/123?equip=sword
```

📌 **Video Note**: Demo parameter parsing in Unity console logs

Next: [Advanced Usage](05-AdvancedUsage.md)