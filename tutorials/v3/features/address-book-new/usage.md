---
description: Complete Address Book usage guide for Unity mobile games
---

# Address Book Usage Guide

## Getting Started

Before using Address Book features, ensure you've completed the setup:

1. **Enable Feature**: Address Book is enabled in Essential Kit Settings
2. **Configure Permissions**: Usage descriptions are set for privacy compliance
3. **Import Namespace**: Include `using VoxelBusters.EssentialKit;`

## Basic Usage Pattern

Here's the typical workflow for using Address Book in your Unity mobile game:

### 1. Check Permission Status

```csharp
using VoxelBusters.EssentialKit;

void CheckContactsAccess()
{
    var status = AddressBook.GetContactsAccessStatus();
    Debug.Log($"Contacts access status: {status}");
    
    if (status == AddressBookContactsAccessStatus.Authorized)
    {
        // Permission granted - can read contacts
        ReadContacts();
    }
    else if (status == AddressBookContactsAccessStatus.NotDetermined)
    {
        // Permission not asked yet - ReadContacts() will request it
        ReadContacts();
    }
    else
    {
        // Permission denied or restricted
        Debug.Log("Contacts access not available");
    }
}
```

### 2. Read Contacts with Options

```csharp
void ReadContacts()
{
    var options = new ReadContactsOptions.Builder()
        .WithLimit(20)  // Load 20 contacts at a time
        .WithConstraints(ReadContactsConstraint.MustIncludeName)  // Only contacts with names
        .Build();
        
    AddressBook.ReadContacts(options, OnContactsLoaded);
}

void OnContactsLoaded(AddressBookReadContactsResult result, Error error)
{
    if (error == null)
    {
        Debug.Log($"Loaded {result.Contacts.Length} contacts");
        ProcessContacts(result.Contacts);
    }
    else
    {
        Debug.LogError($"Failed to read contacts: {error}");
    }
}
```

### 3. Work with Contact Data

```csharp
void ProcessContacts(IAddressBookContact[] contacts)
{
    foreach (var contact in contacts)
    {
        // Display basic info
        string displayName = $"{contact.FirstName} {contact.LastName}";
        Debug.Log($"Contact: {displayName}");
        
        // Access communication details
        if (contact.EmailAddresses?.Length > 0)
        {
            Debug.Log($"Email: {contact.EmailAddresses[0]}");
        }
        
        if (contact.PhoneNumbers?.Length > 0)
        {
            Debug.Log($"Phone: {contact.PhoneNumbers[0]}");
        }
        
        // Load profile image (async)
        LoadContactImage(contact);
    }
}

void LoadContactImage(IAddressBookContact contact)
{
    contact.LoadImage((textureData, error) =>
    {
        if (error == null && textureData != null)
        {
            // Use textureData.Texture in your UI
            Debug.Log($"Image loaded for {contact.FirstName}");
        }
    });
}
```

## Advanced Scenarios

### Pagination for Large Contact Lists

```csharp
private int currentOffset = 0;

void LoadNextPage()
{
    var options = new ReadContactsOptions.Builder()
        .WithLimit(10)
        .WithOffset(currentOffset)
        .Build();
        
    AddressBook.ReadContacts(options, OnPageLoaded);
}

void OnPageLoaded(AddressBookReadContactsResult result, Error error)
{
    if (error == null)
    {
        currentOffset = result.NextOffset;
        // Process this page of contacts
    }
}
```

### Filter Contacts by Available Data

```csharp
void ReadContactsWithEmailsAndPhones()
{
    var constraints = ReadContactsConstraint.MustIncludeEmail | 
                     ReadContactsConstraint.MustIncludePhoneNumber;
                     
    var options = new ReadContactsOptions.Builder()
        .WithConstraints(constraints)
        .Build();
        
    AddressBook.ReadContacts(options, OnFilteredContactsLoaded);
}
```

## Complete Example

Here's a complete example for a friend invitation feature:

```csharp
using VoxelBusters.EssentialKit;
using UnityEngine;

public class FriendInvitation : MonoBehaviour
{
    void Start()
    {
        LoadContactsForInvitation();
    }
    
    void LoadContactsForInvitation()
    {
        // Only get contacts with names and emails for invitations
        var options = new ReadContactsOptions.Builder()
            .WithLimit(50)
            .WithConstraints(ReadContactsConstraint.MustIncludeName | ReadContactsConstraint.MustIncludeEmail)
            .Build();
            
        AddressBook.ReadContacts(options, OnInvitationContactsLoaded);
    }
    
    void OnInvitationContactsLoaded(AddressBookReadContactsResult result, Error error)
    {
        if (error == null)
        {
            Debug.Log($"Found {result.Contacts.Length} contacts for invitations");
            
            foreach (var contact in result.Contacts)
            {
                CreateInvitationOption(contact);
            }
        }
        else
        {
            var errorCode = (AddressBookErrorCode)error.Code;
            if (errorCode == AddressBookErrorCode.PermissionDenied)
            {
                Debug.Log("Permission denied - show manual invitation option");
            }
        }
    }
    
    void CreateInvitationOption(IAddressBookContact contact)
    {
        string displayName = $"{contact.FirstName} {contact.LastName}";
        string email = contact.EmailAddresses[0];
        
        // Create UI button for this contact invitation
        Debug.Log($"Invitation option: {displayName} ({email})");
    }
}
```

For detailed explanations of each concept, see the [Concepts](concepts/) section which provides step-by-step tutorials for all Address Book features.
