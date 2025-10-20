# Game Services Tutorial - Server Integration

## What is Server Integration?

Server Integration provides authenticated credentials that your backend servers can use to verify player identity and access game service APIs. Why use server integration in a Unity mobile game? It enables secure player authentication on your backend, prevents cheating through server-side validation, and allows advanced features like cross-platform data synchronization.

## Key Server Integration APIs

### Loading Basic Server Credentials

```csharp
GameServices.LoadServerCredentials((result, error) =>
{
    if (error == null)
    {
        ServerCredentials credentials = result.ServerCredentials;
        Debug.Log("Server credentials loaded successfully");
        // Send credentials to your backend server
    }
    else
    {
        Debug.Log("Failed to load credentials: " + error.Description);
    }
});
```

This snippet loads server authentication credentials that your backend can use to verify the player's identity.

### Loading Credentials with Additional Scopes

```csharp
var additionalScopes = new List<ServerCredentialAdditionalScope>
{
    ServerCredentialAdditionalScope.Email
};

GameServices.LoadServerCredentials(additionalScopes, (result, error) =>
{
    if (error == null)
    {
        Debug.Log("Server credentials with email scope loaded");
        var grantedScopes = result.AdditionalGrantedScopes;
        Debug.Log("Granted scopes count: " + grantedScopes.Count);
    }
});
```

This snippet loads server credentials with additional permission scopes, such as email access.

### Handling iOS Server Credentials

```csharp
GameServices.LoadServerCredentials((result, error) =>
{
    if (error == null && result.ServerCredentials.IosProperties != null)
    {
        var ios = result.ServerCredentials.IosProperties;
        Debug.Log("iOS Public Key URL: " + ios.PublicKeyUrl);
        Debug.Log("Signature length: " + ios.Signature.Length);
        Debug.Log("Timestamp: " + ios.Timestamp);
        
        // Send to your backend for Game Center verification
    }
});
```

This snippet handles iOS-specific server credentials for Game Center authentication.

### Handling Android Server Credentials

```csharp
GameServices.LoadServerCredentials((result, error) =>
{
    if (error == null && result.ServerCredentials.AndroidProperties != null)
    {
        var android = result.ServerCredentials.AndroidProperties;
        Debug.Log("Server Auth Code: " + android.ServerAuthCode);
        
        // Send to your backend for Play Games verification
    }
});
```

This snippet handles Android-specific server credentials for Play Games Services authentication.

### Server Authentication Flow

```csharp
void AuthenticateWithBackend()
{
    GameServices.LoadServerCredentials((result, error) =>
    {
        if (error == null)
        {
            string playerId = GameServices.LocalPlayer.Identifier;
            SendCredentialsToBackend(result.ServerCredentials, playerId);
        }
    });
}

void SendCredentialsToBackend(ServerCredentials credentials, string playerId)
{
    Debug.Log("Sending credentials to backend for player: " + playerId);
    // Implement your backend communication here
}
```

This snippet demonstrates a complete flow for authenticating players with your backend server.

📌 **Video Note**: Show Unity demo of server credential loading and explain the backend authentication workflow with visual diagrams.