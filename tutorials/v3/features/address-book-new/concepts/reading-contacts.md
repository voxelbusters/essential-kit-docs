# Reading Contacts

## Getting Started with Contact Reading

Contact reading is the core functionality for retrieving contact information from the device's address book in Unity mobile games. This enables powerful social features like finding friends already playing your game, importing contact lists for multiplayer invitations, or creating personalized gaming experiences based on user connections.

## Your First Contact Reading Implementation

The `ReadContacts()` method retrieves contacts from the device with customizable options:

```csharp
using VoxelBusters.EssentialKit;

public class ContactManager : MonoBehaviour
{
    void Start()
    {
        ReadAllContacts();
    }
    
    void ReadAllContacts()
    {
        var options = new ReadContactsOptions.Builder().Build();
        AddressBook.ReadContacts(options, OnContactsRead);
    }
}
```

This code creates default options and requests all contacts from the device. The callback method will receive the results when the operation completes.

## Handling Contact Results

Process the retrieved contacts in your callback method:

```csharp
void OnContactsRead(AddressBookReadContactsResult result, Error error)
{
    if (error == null)
    {
        Debug.Log($"Successfully retrieved {result.Contacts.Length} contacts");
        
        foreach (var contact in result.Contacts)
        {
            // Basic contact information
            string displayName = $"{contact.FirstName} {contact.LastName}";
            Debug.Log($"Contact: {displayName}");
            
            // Check if contact has phone numbers
            if (contact.PhoneNumbers != null && contact.PhoneNumbers.Length > 0)
            {
                Debug.Log($"  Phone: {contact.PhoneNumbers[0].Value}");
            }
            
            // Check if contact has email addresses
            if (contact.EmailAddresses != null && contact.EmailAddresses.Length > 0)
            {
                Debug.Log($"  Email: {contact.EmailAddresses[0].Value}");
            }
        }
    }
    else
    {
        Debug.LogError("Failed to read contacts: " + error.LocalizedDescription);
        // Handle different error types
        HandleContactReadingError(error);
    }
}

void HandleContactReadingError(Error error)
{
    // Implement error handling based on your game's needs
    // Show user-friendly messages or fallback UI
}
```

## Performance-Optimized Contact Reading

For Unity mobile games, it's important to optimize contact reading for better performance:

```csharp
void ReadLimitedContacts()
{
    var options = new ReadContactsOptions.Builder()
        .WithLimit(10)  // Only read first 10 contacts
        .Build();
    AddressBook.ReadContacts(options, OnContactsRead);
}
```

This approach is useful for:
- **Performance optimization** in games with limited resources
- **Pagination scenarios** when displaying contacts in UI
- **Testing implementations** without loading thousands of contacts

## Building Contact Lists for Games

Here's a practical example for building a friend list in your Unity mobile game:

```csharp
public class GameFriendList : MonoBehaviour
{
    [System.Serializable]
    public class GameContact
    {
        public string displayName;
        public string primaryPhone;
        public string primaryEmail;
        public bool isGamePlayer; // Check if they play your game
    }
    
    public List<GameContact> gameFriends = new List<GameContact>();
    
    void BuildFriendList()
    {
        var options = new ReadContactsOptions.Builder()
            .WithLimit(50)  // Reasonable limit for mobile games
            .Build();
            
        AddressBook.ReadContacts(options, ProcessContactsForGame);
    }
    
    void ProcessContactsForGame(AddressBookReadContactsResult result, Error error)
    {
        if (error == null)
        {
            gameFriends.Clear();
            
            foreach (var contact in result.Contacts)
            {
                var gameContact = new GameContact
                {
                    displayName = $"{contact.FirstName} {contact.LastName}".Trim(),
                    primaryPhone = GetPrimaryPhone(contact),
                    primaryEmail = GetPrimaryEmail(contact)
                };
                
                // Add logic to check if contact is already a game player
                gameContact.isGamePlayer = CheckIfContactPlaysGame(gameContact);
                
                gameFriends.Add(gameContact);
            }
            
            // Update your game UI with the friend list
            UpdateGameFriendUI();
        }
    }
    
    string GetPrimaryPhone(AddressBookContact contact)
    {
        return (contact.PhoneNumbers != null && contact.PhoneNumbers.Length > 0) 
            ? contact.PhoneNumbers[0].Value 
            : string.Empty;
    }
    
    string GetPrimaryEmail(AddressBookContact contact)
    {
        return (contact.EmailAddresses != null && contact.EmailAddresses.Length > 0) 
            ? contact.EmailAddresses[0].Value 
            : string.Empty;
    }
    
    bool CheckIfContactPlaysGame(GameContact contact)
    {
        // Implement your game's logic to check if contact is already a player
        // This might involve checking against your game's user database
        return false; // Placeholder
    }
    
    void UpdateGameFriendUI()
    {
        // Update your Unity UI to show the friend list
        Debug.Log($"Friend list updated with {gameFriends.Count} contacts");
    }
}
```

## Unity Mobile Game Integration Tips

### 1. Always Check Permissions First
```csharp
void SafeReadContacts()
{
    var status = AddressBook.GetContactsAccessStatus();
    if (status == AddressBookContactsAccessStatus.Authorized)
    {
        ReadAllContacts();
    }
    else
    {
        // Request permission first
        AddressBook.RequestContactsAccess((result, error) =>
        {
            if (result.AccessStatus == AddressBookContactsAccessStatus.Authorized)
            {
                ReadAllContacts();
            }
        });
    }
}
```

### 2. Use Reasonable Limits
Don't load thousands of contacts at once - it can impact game performance.

### 3. Cache Results
Store contact data locally to avoid repeated API calls during gameplay.

![Contact Reading Flow](../../.gitbook/assets/AddressBookReading.png)