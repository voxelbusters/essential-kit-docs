# Universal Links

## What are Universal Links?

Universal Links (iOS) and App Links (Android) are HTTP/HTTPS URLs that open your Unity mobile game when it's installed, or fallback to a website when it's not. This provides seamless user experience for Unity cross-platform games.

Why use them in Unity mobile games? They work better with social media sharing, email campaigns, and web-to-app user acquisition flows compared to custom URL schemes.

## OnUniversalLinkOpen Event  

The primary API for handling Universal Links and App Links:

```csharp
using VoxelBusters.EssentialKit;

void Start()
{
    DeepLinkServices.OnUniversalLinkOpen += HandleUniversalLink;
}

void HandleUniversalLink(DeepLinkServicesDynamicLinkOpenResult result)
{
    Debug.Log($"Received Universal Link: {result.Url}");
    Debug.Log($"Host: {result.Url.Host}");
    Debug.Log($"Path: {result.Url.AbsolutePath}");
}
```

This snippet handles incoming Universal Links and extracts key URL components for navigation within your Unity game.

## Essential Kit Settings for Universal Links

📌 **Video Note**: Show Universal Link domain configuration

Configure domains in Essential Kit Settings:

1. **Window > Essential Kit > Settings > Services**
2. **Deep Link Services section** 
3. **Universal Link Domains**:
   - Add your website domain (e.g., `mygame.com`)
   - Add subdomains if needed (e.g., `share.mygame.com`)

**Example Configurations:**

For a strategy game website:
```
Domain: "strategygame.com"
Example links:
- https://strategygame.com/battle/123
- https://strategygame.com/clan/invite/abc
- https://strategygame.com/tournament/spring
```

For a puzzle game with sharing:
```
Domain: "puzzlemaster.com" 
Example links:
- https://puzzlemaster.com/level/hard/50
- https://puzzlemaster.com/challenge/daily
- https://puzzlemaster.com/scores/global
```

## Domain Verification Requirements

Universal Links require server-side verification:

- **iOS**: Apple App Site Association (AASA) file at `/.well-known/apple-app-site-association`
- **Android**: Digital Asset Links file at `/.well-known/assetlinks.json`

Essential Kit Settings provides guidance links for setting up these verification files correctly.

## Handling Both Link Types

```csharp
void Start()
{
    DeepLinkServices.OnCustomSchemeUrlOpen += HandleCustomScheme;
    DeepLinkServices.OnUniversalLinkOpen += HandleUniversalLink;
}

void HandleCustomScheme(DeepLinkServicesDynamicLinkOpenResult result)
{
    Debug.Log($"Custom scheme: {result.RawUrlString}");
    ProcessGameNavigation(result.Url);
}

void HandleUniversalLink(DeepLinkServicesDynamicLinkOpenResult result)  
{
    Debug.Log($"Universal link: {result.RawUrlString}");
    ProcessGameNavigation(result.Url);
}
```

This snippet shows how to handle both URL schemes and Universal Links with a common navigation method.

📌 **Video Note**: Demo Universal Link opening Unity game from web browser

Next: [Parameter Parsing](04-ParameterParsing.md)