# URL Scheme Handling

## What is URL Scheme Handling?

URL schemes are custom protocols like `mygame://` that allow external apps and websites to open your Unity mobile game with specific parameters. This is essential for Unity iOS and Unity Android games that need deep linking functionality.

Why use it in Unity mobile games? Enable players to share game content, join multiplayer sessions, or navigate directly to specific levels from external sources.

## OnCustomSchemeUrlOpen Event

The primary API for handling custom URL schemes:

```csharp
using VoxelBusters.EssentialKit;

void Start()
{
    DeepLinkServices.OnCustomSchemeUrlOpen += HandleCustomSchemeUrl;
}

void HandleCustomSchemeUrl(DeepLinkServicesDynamicLinkOpenResult result)
{
    Debug.Log($"Received URL scheme: {result.Url}");
    Debug.Log($"Raw URL string: {result.RawUrlString}");
}
```

This snippet subscribes to URL scheme events and logs the incoming link data when your Unity game is opened via a custom scheme.

## Essential Kit Settings for URL Schemes

📌 **Video Note**: Show Essential Kit Settings configuration

Configure custom schemes in Essential Kit Settings:

1. **Window > Essential Kit > Settings > Services**
2. **Deep Link Services section**
3. **Add URL Schemes**:
   - `mygame://` for general game links
   - `puzzlegame://` for puzzle-specific content
   - `rpggame://` for RPG character/quest links

**Example Configurations:**

For a racing game:
```
URL Scheme: "racegame://"
Example links: 
- racegame://track/nurburgring
- racegame://tournament/summer2024
- racegame://garage/car123
```

For a social game:
```  
URL Scheme: "socialgame://"
Example links:
- socialgame://friend/invite/abc123
- socialgame://event/holiday
- socialgame://leaderboard/weekly
```

## Handling Multiple Schemes

```csharp
void HandleCustomSchemeUrl(DeepLinkServicesDynamicLinkOpenResult result)
{
    string scheme = result.Url.Scheme;
    
    if (scheme == "mygame")
    {
        Debug.Log("Main game scheme detected");
    }
    else if (scheme == "mygame-dev")  
    {
        Debug.Log("Development scheme detected");
    }
}
```

This snippet demonstrates handling multiple custom schemes for different app variants (production vs development builds).

📌 **Video Note**: Demo opening Unity game via custom URL scheme from browser

Next: [Universal Links](03-UniversalLinks.md)