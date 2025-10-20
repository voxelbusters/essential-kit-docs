# Game Services Tutorial - Authentication

## What is Authentication?

Authentication is the process of verifying a player's identity through their platform-specific gaming account (Game Center on iOS, Google Play Games on Android). Why use authentication in a Unity mobile game? It enables cloud saves, social features, leaderboards, and achievements while providing a seamless cross-device gaming experience.

## Key Authentication APIs

### Checking Authentication Status

```csharp
bool isAuthenticated = GameServices.IsAuthenticated;
Debug.Log("Player authenticated: " + isAuthenticated);
```

This snippet checks if the current player is signed in to their gaming service account.

### Getting Local Player Information

```csharp
ILocalPlayer localPlayer = GameServices.LocalPlayer;
Debug.Log("Local player: " + localPlayer.DisplayName);
Debug.Log("Player ID: " + localPlayer.Identifier);
```

This snippet retrieves the authenticated player's information, including display name and unique identifier.

### Authenticating Players

```csharp
// Interactive authentication (shows login dialog if needed)
GameServices.Authenticate(interactive: true);

// Silent authentication (no UI, works if already logged in)
GameServices.Authenticate(interactive: false);
```

This snippet initiates the authentication process. Interactive mode shows login UI when needed, while silent mode only succeeds if already authenticated.

### Signing Out Players

```csharp
GameServices.Signout();
Debug.Log("Player signed out");
```

This snippet signs out the current player from their gaming service account.

### Monitoring Authentication Changes

```csharp
void OnEnable()
{
    GameServices.OnAuthStatusChange += OnAuthStatusChange;
}

void OnAuthStatusChange(GameServicesAuthStatusChangeResult result, Error error)
{
    Debug.Log("Auth status changed: " + result.AuthStatus);
    if (result.AuthStatus == LocalPlayerAuthStatus.Authenticated)
    {
        Debug.Log("Player authenticated: " + result.LocalPlayer.DisplayName);
    }
}
```

This snippet monitors authentication status changes and responds accordingly when players sign in or out.

📌 **Video Note**: Show Unity demo of authentication flow, including login dialog appearance and authentication status changes in the console.