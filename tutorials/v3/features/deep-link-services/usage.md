---
description: "Deep Link Services allows handling custom URL schemes and universal links on mobile devices."
---

# Usage

Essential Kit wraps native iOS and Android deep link APIs into a single Unity interface. When users click deep links, Essential Kit automatically routes them to your app and fires events with the link data.

## Table of Contents

- [Deep Link Flow at a Glance](#deep-link-flow-at-a-glance)
- [Understanding Deep Link Anatomy](#understanding-deep-link-anatomy)
- [Import Namespaces](#import-namespaces)
- [Event Registration](#event-registration)
- [Check Availability](#check-availability)
- [How Deep Links Work](#how-deep-links-work)
- [Basic Implementation](#basic-implementation)
- [Parsing Deep Link Parameters](#parsing-deep-link-parameters)
- [Common Navigation Patterns](#common-navigation-patterns)
- [Core APIs Reference](#core-apis-reference)
- [Advanced: Custom Delegate Filtering](#advanced-custom-delegate-filtering)
- [Related Guides](#related-guides)

## Deep Link Flow at a Glance

```text
[Player taps deep link]
                ↓
[iOS / Android resolves scheme or domain]
                ↓
[Essential Kit DeepLinkServices]
      (queues event until handlers subscribe)
                ↓
[OnCustomSchemeUrlOpen or OnUniversalLinkOpen]
                ↓
[Your routing code → load content, grant rewards, etc.]
```

## Understanding Deep Link Anatomy

Deep links contain three main parts that you'll use for routing:

**Example 1:** `mygame://invite/player123`
- **Scheme**: `mygame` - Identifies your app
- **Host**: `invite` - Identifies the action
- **Path**: `/player123` - Contains action parameters

**Example 2:** `https://yourgame.com/level/5?mode=hard`
- **Scheme**: `https` - Universal link scheme
- **Host**: `yourgame.com` - Your domain
- **Path**: `/level/5` - Content to display
- **Query**: `?mode=hard` - Additional parameters

You'll use these components to determine what content to show when a deep link opens your app.

## Import Namespaces

```csharp
using System;
using VoxelBusters.EssentialKit;
using VoxelBusters.CoreLibrary;
using System.Collections.Generic;
```

## Event Registration

Register for deep link events in `OnEnable` and unregister in `OnDisable`:

```csharp
void OnEnable()
{
    DeepLinkServices.OnCustomSchemeUrlOpen += OnCustomSchemeUrlOpen;
    DeepLinkServices.OnUniversalLinkOpen += OnUniversalLinkOpen;
}

void OnDisable()
{
    DeepLinkServices.OnCustomSchemeUrlOpen -= OnCustomSchemeUrlOpen;
    DeepLinkServices.OnUniversalLinkOpen -= OnUniversalLinkOpen;
}
```

| Event | Trigger |
| --- | --- |
| `OnCustomSchemeUrlOpen` | When user opens a custom scheme URL (e.g., `mygame://`) |
| `OnUniversalLinkOpen` | When user opens a universal link (e.g., `https://yourgame.com/`) |

{% hint style="success" %}
Register events early in your app initialization (like in a persistent manager's `OnEnable`) to ensure no deep links are missed.
{% endhint %}

## Check Availability

Guard your handlers in case the feature is disabled on the current platform:

```csharp
if (!DeepLinkServices.IsAvailable())
{
    Debug.LogWarning("Deep Link Services is not available on this platform or build.");
    return;
}
```

The call returns `false` in editor play mode if you excluded Deep Link Services from the build configuration.

## How Deep Links Work

Essential Kit handles deep links intelligently based on your app state:

**App Already Running:**
Events fire immediately when the deep link is activated.

**App Launched by Deep Link:**
Essential Kit delays the event until you register the event handler. This ensures your app is fully initialized before processing the link.

{% hint style="info" %}
You don't need to check if the app was launched by a deep link. Just register events when ready, and Essential Kit fires them automatically if a deep link is pending.
{% endhint %}

## Basic Implementation

Handle both event types with the same logic:

```csharp
void OnCustomSchemeUrlOpen(DeepLinkServicesDynamicLinkOpenResult result)
{
    Debug.Log($"Received custom scheme deep link: {result.RawUrlString}");
    HandleDeepLink(result);
}

void OnUniversalLinkOpen(DeepLinkServicesDynamicLinkOpenResult result)
{
    Debug.Log($"Received universal link: {result.RawUrlString}");
    HandleDeepLink(result);
}

void HandleDeepLink(DeepLinkServicesDynamicLinkOpenResult result)
{
    Uri uri = result.Url;

    Debug.Log($"Scheme: {uri.Scheme}");
    Debug.Log($"Host: {uri.Host}");
    Debug.Log($"Path: {uri.AbsolutePath}");

    // Route based on host
    switch (uri.Host.ToLower())
    {
        case "invite":
            HandleInvite(uri);
            break;
        case "shop":
            HandleShop(uri);
            break;
        case "level":
            HandleLevel(uri);
            break;
        default:
            Debug.LogWarning($"Unknown deep link action: {uri.Host}");
            break;
    }
}
```

### Result Properties

| Property | Type | Description |
| --- | --- | --- |
| `Url` | `Uri` | Parsed URL with easy access to components (Scheme, Host, Path, Query) |
| `RawUrlString` | `string` | Original URL string as received from the system |

## Parsing Deep Link Parameters

Use C#'s `Uri` class to extract deep link data:

### Path Segments
```csharp
void HandleLevel(Uri uri)
{
    // mygame://level/5 or https://yourgame.com/level/5
    string[] segments = uri.Segments; // ["/", "level/", "5"]

    if (segments.Length > 2)
    {
        string levelId = segments[2].TrimEnd('/'); // "5"
        Debug.Log($"Loading level: {levelId}");
        Debug.Log($"Trigger gameplay load for level {levelId}.");
    }
}
```

### Query Parameters
```csharp
void HandleShop(Uri uri)
{
    // mygame://shop?item=sword&discount=50
    string query = uri.Query; // "?item=sword&discount=50"
    Dictionary<string, string> parameters = ParseQuery(query);

    parameters.TryGetValue("item", out string itemId); // "sword"
    parameters.TryGetValue("discount", out string discount); // "50"

    Debug.Log($"Opening shop item: {itemId} with discount: {discount}%");
    Debug.Log($"Apply discount {discount}% to item {itemId}.");
}
```

{% hint style="warning" %}
Always validate deep link parameters before using them. Users can manually create deep links with invalid data.
{% endhint %}

## Common Navigation Patterns

### Friend Invitations
```csharp
void HandleInvite(Uri uri)
{
    // mygame://invite?referrer=player123&reward=100gems
    Dictionary<string, string> parameters = ParseQuery(uri.Query);

    parameters.TryGetValue("referrer", out string referrerId);
    parameters.TryGetValue("reward", out string rewardType);

    if (string.IsNullOrEmpty(referrerId))
    {
        Debug.LogWarning("Invalid invite link: missing referrer");
        return;
    }

    Debug.Log($"Processing invite from {referrerId} with reward: {rewardType}");
    Debug.Log("Grant referral rewards and track attribution.");
}
```

### Tournament Entry
```csharp
void HandleTournament(Uri uri)
{
    // mygame://tournament/weekly_pvp?auto_join=true
    string[] segments = uri.Segments;
    string tournamentId = segments.Length > 1 ? segments[1].TrimEnd('/') : null;

    Dictionary<string, string> parameters = ParseQuery(uri.Query);
    bool autoJoin = parameters.TryGetValue("auto_join", out string flag) && flag == "true";

    if (!string.IsNullOrEmpty(tournamentId))
    {
        Debug.Log($"Opening tournament: {tournamentId}");

        if (autoJoin)
        {
            Debug.Log("Auto join the tournament.");
        }
        else
        {
            Debug.Log("Show tournament detail UI.");
        }
    }
}
```

### Content Sharing
```csharp
void HandleLevelChallenge(Uri uri)
{
    // mygame://level/25?challenge=speedrun&score=1337
    string[] segments = uri.Segments;
    string levelId = segments.Length > 1 ? segments[1].TrimEnd('/') : null;

    Dictionary<string, string> parameters = ParseQuery(uri.Query);
    parameters.TryGetValue("challenge", out string challengeType);
    parameters.TryGetValue("score", out string targetScore);

    Debug.Log($"Loading level {levelId} with challenge: {challengeType}");
    Debug.Log($"Target score for challenge: {targetScore}");
}
```

Add a lightweight helper to reuse the parsing logic:

```csharp
Dictionary<string, string> ParseQuery(string query)
{
    var values = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);

    if (string.IsNullOrEmpty(query))
    {
        return values;
    }

    foreach (string part in query.TrimStart('?').Split('&', StringSplitOptions.RemoveEmptyEntries))
    {
        string[] bits = part.Split(new[] { '=' }, 2);
        string key = Uri.UnescapeDataString(bits[0]);
        string value = (bits.Length > 1) ? Uri.UnescapeDataString(bits[1]) : string.Empty;
        values[key] = value;
    }

    return values;
}
```

## Core APIs Reference

| API | Purpose | Returns |
| --- | --- | --- |
| `DeepLinkServices.OnCustomSchemeUrlOpen` | Event fired when custom scheme URL opens app | `DeepLinkServicesDynamicLinkOpenResult` via callback |
| `DeepLinkServices.OnUniversalLinkOpen` | Event fired when universal link opens app | `DeepLinkServicesDynamicLinkOpenResult` via callback |
| `DeepLinkServices.IsAvailable()` | Check if deep link services are available | `bool` |
| `DeepLinkServices.Delegate` | **Advanced:** Set custom delegate for filtering links | `IDeepLinkServicesDelegate` |

## Advanced: Custom Delegate Filtering

{% hint style="danger" %}
Only use custom delegates for advanced scenarios like ignoring deep links during tutorials or onboarding. For normal deep link handling, use the events directly.
{% endhint %}

### Understanding Custom Delegates

**Default Behavior:**
Essential Kit processes all deep links matching your configuration and fires events automatically.

**Advanced Usage:**
Use a custom delegate to filter which deep links your app should handle:
- Ignore deep links during tutorial or onboarding
- Filter links based on user authentication status
- Prevent deep links in specific game states

### Implementation

Create a delegate class:

```csharp
public class GameDeepLinkDelegate : IDeepLinkServicesDelegate
{
    public bool CanHandleCustomSchemeUrl(Uri url)
    {
        // Don't handle deep links during tutorial
        if (GameManager.Instance.IsInTutorial)
        {
            Debug.Log($"Ignoring deep link during tutorial: {url}");
            return false;
        }

        // Don't handle premium links for non-authenticated users
        if (url.Host == "premium" && !UserManager.Instance.IsAuthenticated)
        {
            Debug.Log("Ignoring premium link - user not authenticated");
            return false;
        }

        return true; // Handle all other links
    }

    public bool CanHandleUniversalLink(Uri url)
    {
        // Apply same filtering to universal links
        return CanHandleCustomSchemeUrl(url);
    }
}
```

Set the delegate before registering events:

```csharp
void Awake()
{
    DeepLinkServices.Delegate = new GameDeepLinkDelegate();
}

void OnEnable()
{
    DeepLinkServices.OnCustomSchemeUrlOpen += OnCustomSchemeUrlOpen;
    DeepLinkServices.OnUniversalLinkOpen += OnUniversalLinkOpen;
}
```

{% hint style="warning" %}
Advanced delegate filtering is for specific scenarios only. For most games, use standard event handling without custom delegates.
{% endhint %}

### Manual Initialization (Advanced)

Essential Kit auto-initializes Deep Link Services. Only use manual initialization for runtime configuration:

```csharp
void Awake()
{
    var iosLinks = LoadIosDefinitionsFromServer();      // DeepLinkDefinition[]
    var androidLinks = LoadAndroidDefinitionsFromServer(); // DeepLinkDefinition[]

    var settings = new DeepLinkServicesUnitySettings(
        iosProperties: new DeepLinkServicesUnitySettings.IosPlatformProperties(
            customSchemeUrls: iosLinks),
        androidProperties: new DeepLinkServicesUnitySettings.AndroidPlatformProperties(
            universalLinks: androidLinks));

    DeepLinkServices.Initialize(settings);

    // Set delegate if needed
    DeepLinkServices.Delegate = new GameDeepLinkDelegate();
}
```

**Use Cases for Manual Initialization:**
- Dynamically registering URL schemes from server configuration
- Setting up deep links for white-label apps with different schemes
- Loading deep link configurations from remote JSON at runtime

{% hint style="info" %}
For standard usage, skip manual initialization. Essential Kit handles setup automatically based on your [Settings configuration](setup/).
{% endhint %}

## Related Guides

- Demo scene: `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/DeepLinkServicesDemo.unity`
- Pair with **Notification Services** to send push notifications with deep links
- Use with **Sharing Services** to let players share deep links to social media
- Combine with **Game Services** for social feature deep linking

{% hint style="success" %}
Ready to test? Head to the [Testing Guide](testing.md) to validate your implementation.
{% endhint %}
