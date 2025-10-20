# Game Services Tutorial - Player Management

## What is Player Management?

Player Management involves accessing local player information and managing social connections within the game service ecosystem. Why use player management in a Unity mobile game? It enables personalized experiences, social gameplay features, and friend-based competition systems that increase engagement and retention.

## Key Player Management APIs

### Accessing Local Player

```csharp
ILocalPlayer localPlayer = GameServices.LocalPlayer;
Debug.Log("Player name: " + localPlayer.DisplayName);
Debug.Log("Player ID: " + localPlayer.Identifier);
Debug.Log("Is authenticated: " + localPlayer.IsAuthenticated);
```

This snippet accesses the current local player's profile information and authentication status.

### Loading Player Avatar

```csharp
ILocalPlayer localPlayer = GameServices.LocalPlayer;
localPlayer.LoadImage((result, error) =>
{
    if (error == null)
    {
        Texture2D avatarTexture = result.GetTexture();
        Debug.Log("Loaded player avatar");
        // Apply texture to UI Image component
    }
});
```

This snippet loads the player's profile picture from their game service account.

### Loading Friends List

```csharp
GameServices.LoadFriends((result, error) =>
{
    if (error == null)
    {
        Debug.Log("Friend count: " + result.Players.Length);
        foreach (var friend in result.Players)
        {
            Debug.Log("Friend: " + friend.DisplayName);
        }
    }
    else
    {
        Debug.Log("Failed to load friends: " + error.Description);
    }
});
```

This snippet loads the player's friends list from their game service account.

### Adding Friends

```csharp
string friendPlayerId = "friend_player_id";
GameServices.AddFriend(friendPlayerId, (success, error) =>
{
    if (success)
    {
        Debug.Log("Friend request sent successfully");
    }
    else
    {
        Debug.Log("Friend request failed: " + error.Description);
    }
});
```

This snippet sends a friend request to another player using their player ID.

### Checking Player Availability

```csharp
bool isAvailable = GameServices.IsAvailable();
Debug.Log("Game Services available: " + isAvailable);

if (isAvailable && GameServices.IsAuthenticated)
{
    Debug.Log("Ready for social features");
}
```

This snippet checks if Game Services are available and the player is authenticated before accessing social features.

📌 **Video Note**: Show Unity demo of player information display, friend list loading, and social feature interaction in the game interface.