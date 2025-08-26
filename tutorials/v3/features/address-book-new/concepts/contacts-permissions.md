---
description: Managing contacts permissions in Unity mobile games
---

# Contacts Permissions

## What is Contacts Permission Management?

Contacts permission management is the process of checking and handling user authorization to access device contact data. Why use it in a Unity mobile game? Both iOS and Android require explicit user permission before apps can read contact information, and managing these permissions properly ensures a smooth user experience while maintaining privacy compliance.

## Permission Status API

Essential Kit provides the `GetContactsAccessStatus()` method to check current permission state:

```csharp
using VoxelBusters.EssentialKit;

void CheckContactsPermission()
{
    var status = AddressBook.GetContactsAccessStatus();
    Debug.Log("Contacts permission status: " + status);
}
```

This snippet checks the current permission status and logs it to the console. The status helps determine if you can directly access contacts or need to request permission first.

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
            break;
        case AddressBookContactsAccessStatus.Authorized:
            Debug.Log("Full access granted");
            break;
        case AddressBookContactsAccessStatus.Limited:
            Debug.Log("Limited access granted");
            break;
        case AddressBookContactsAccessStatus.Denied:
            Debug.Log("User denied access");
            break;
        case AddressBookContactsAccessStatus.Restricted:
            Debug.Log("Access restricted by system");
            break;
    }
}
```

This snippet demonstrates how to handle different permission states. Each status indicates whether you can proceed with contact operations or need to guide the user accordingly.

## Key Points

- Always check permission status before attempting to read contacts
- `NotDetermined` means the user hasn't been prompted yet - calling `ReadContacts()` will automatically request permission
- `Denied` and `Restricted` states require directing users to device settings to change permissions
- Permission handling is automatically managed by Essential Kit across iOS and Android platforms