# Contacts Permissions

## Understanding Contacts Permissions in Unity Mobile Games

Contacts permission management is essential for accessing device contact data in your Unity mobile games. Both iOS and Android require explicit user permission before apps can read contact information. Proper permission handling ensures smooth user experience while maintaining privacy compliance.

## Checking Permission Status

Essential Kit provides the `GetContactsAccessStatus()` method to check current permission state:

```csharp
using VoxelBusters.EssentialKit;

void CheckContactsPermission()
{
    var status = AddressBook.GetContactsAccessStatus();
    Debug.Log("Contacts permission status: " + status);
}
```

This code checks the current permission status and logs it to the console. The status helps determine if you can directly access contacts or need to request permission first.

## Permission Status Values

The `AddressBookContactsAccessStatus` enum provides these states:

```csharp
void HandlePermissionStatus()
{
    var status = AddressBook.GetContactsAccessStatus();
    
    switch (status)
    {
        case AddressBookContactsAccessStatus.NotDetermined:
            Debug.Log("User hasn't been asked yet");
            // First time - request permission
            RequestContactsPermission();
            break;
        case AddressBookContactsAccessStatus.Authorized:
            Debug.Log("Full access granted");
            // Proceed with contact reading
            ReadContacts();
            break;
        case AddressBookContactsAccessStatus.Limited:
            Debug.Log("Limited access granted");
            // Proceed with limited contact access
            ReadContacts();
            break;
        case AddressBookContactsAccessStatus.Denied:
            Debug.Log("User denied access");
            // Show alternative UI or guidance
            ShowPermissionDeniedDialog();
            break;
        case AddressBookContactsAccessStatus.Restricted:
            Debug.Log("Access restricted by system");
            // Handle system restrictions
            ShowRestrictedAccessDialog();
            break;
    }
}
```

## Requesting Contacts Permission

When permission is not determined, use the `RequestContactsAccess()` method:

```csharp
void RequestContactsPermission()
{
    AddressBook.RequestContactsAccess((result, error) =>
    {
        if (error == null)
        {
            Debug.Log($"Permission request result: {result.AccessStatus}");
            if (result.AccessStatus == AddressBookContactsAccessStatus.Authorized)
            {
                ReadContacts(); // Proceed with contact reading
            }
        }
        else
        {
            Debug.LogError("Permission request failed: " + error);
        }
    });
}
```

## Best Practices for Unity Mobile Game Development

### 1. Check Before Request
Always check current status before requesting permission to avoid unnecessary prompts.

### 2. Provide Context
Explain to players why your game needs contact access before requesting permission.

### 3. Handle All States
Implement proper handling for all permission states to maintain good user experience.

### 4. Graceful Degradation
Design your game to work without contact access if permission is denied.

## Common Unity Mobile Game Use Cases

- **Friend Finding**: Check if contacts are already playing your game
- **Social Features**: Enable contact-based multiplayer invitations  
- **Leaderboards**: Create social leaderboards with friends
- **Referral Systems**: Implement contact-based referral programs

![Contacts Permission Flow](../../.gitbook/assets/AddressBookPermissions.png)