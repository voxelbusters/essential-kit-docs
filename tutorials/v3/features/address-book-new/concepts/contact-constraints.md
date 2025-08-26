# Contact Constraints

## Filtering Contacts for Better Game Performance

Contact constraints are filters that specify which contacts to retrieve based on available data fields. In Unity mobile games, constraints help you retrieve only relevant contacts - for example, contacts with email addresses for invitation features, or contacts with names for display purposes. This improves both performance and user experience.

## Understanding Constraint Types

Essential Kit provides three main constraint types through the `ReadContactsConstraint` enum:

```csharp
using VoxelBusters.EssentialKit;

public class ContactConstraintExample : MonoBehaviour
{
    void ShowConstraintTypes()
    {
        // Available constraint options
        var nameConstraint = ReadContactsConstraint.MustIncludeName;
        var emailConstraint = ReadContactsConstraint.MustIncludeEmail;
        var phoneConstraint = ReadContactsConstraint.MustIncludePhoneNumber;
        
        Debug.Log("Contact constraints configured for Unity mobile game");
    }
}
```

Each constraint ensures contacts have specific data fields populated, reducing empty or incomplete contact data in your game.

## Single Constraint Implementation

Apply a single constraint to filter contacts for specific game features:

### Email-Only Contacts for Invitations

```csharp
void ReadContactsForInvitations()
{
    var options = new ReadContactsOptions.Builder()
        .WithConstraints(ReadContactsConstraint.MustIncludeEmail)
        .WithLimit(20) // Reasonable limit for invitation features
        .Build();
        
    AddressBook.ReadContacts(options, OnInvitationContactsRead);
}

void OnInvitationContactsRead(AddressBookReadContactsResult result, Error error)
{
    if (error == null)
    {
        Debug.Log($"Found {result.Contacts.Length} contacts with email addresses");
        
        foreach (var contact in result.Contacts)
        {
            // All contacts are guaranteed to have email addresses
            string primaryEmail = contact.EmailAddresses[0].Value;
            Debug.Log($"Invitation candidate: {contact.FirstName} ({primaryEmail})");
        }
    }
    else
    {
        Debug.LogError("Failed to read email contacts: " + error);
    }
}
```

### Name-Only Contacts for Display

```csharp
void ReadContactsForDisplay()
{
    var options = new ReadContactsOptions.Builder()
        .WithConstraints(ReadContactsConstraint.MustIncludeName)
        .WithLimit(30)
        .Build();
        
    AddressBook.ReadContacts(options, OnDisplayContactsRead);
}

void OnDisplayContactsRead(AddressBookReadContactsResult result, Error error)
{
    if (error == null)
    {
        foreach (var contact in result.Contacts)
        {
            // All contacts are guaranteed to have names
            string displayName = $"{contact.FirstName} {contact.LastName}".Trim();
            Debug.Log($"Display contact: {displayName}");
        }
    }
}
```

## Multiple Constraint Filtering

Combine multiple constraints using bitwise operations for more specific filtering:

```csharp
public class AdvancedContactFiltering : MonoBehaviour
{
    void ReadHighQualityContacts()
    {
        // Require both name and phone number
        var constraints = ReadContactsConstraint.MustIncludeName | 
                         ReadContactsConstraint.MustIncludePhoneNumber;
                         
        var options = new ReadContactsOptions.Builder()
            .WithConstraints(constraints)
            .WithLimit(15) // Conservative limit for high-quality contacts
            .Build();
            
        AddressBook.ReadContacts(options, OnHighQualityContactsRead);
    }
    
    void ReadCompleteContacts()
    {
        // Require name, email, AND phone number
        var constraints = ReadContactsConstraint.MustIncludeName | 
                         ReadContactsConstraint.MustIncludeEmail |
                         ReadContactsConstraint.MustIncludePhoneNumber;
                         
        var options = new ReadContactsOptions.Builder()
            .WithConstraints(constraints)
            .WithLimit(10) // Very strict filtering
            .Build();
            
        AddressBook.ReadContacts(options, OnCompleteContactsRead);
    }
    
    void OnHighQualityContactsRead(AddressBookReadContactsResult result, Error error)
    {
        if (error == null)
        {
            Debug.Log($"Found {result.Contacts.Length} contacts with name and phone");
            
            foreach (var contact in result.Contacts)
            {
                string name = $"{contact.FirstName} {contact.LastName}".Trim();
                string phone = contact.PhoneNumbers[0].Value;
                Debug.Log($"Quality contact: {name} - {phone}");
            }
        }
    }
    
    void OnCompleteContactsRead(AddressBookReadContactsResult result, Error error)
    {
        if (error == null)
        {
            Debug.Log($"Found {result.Contacts.Length} complete contacts");
            
            foreach (var contact in result.Contacts)
            {
                string name = $"{contact.FirstName} {contact.LastName}".Trim();
                string email = contact.EmailAddresses[0].Value;
                string phone = contact.PhoneNumbers[0].Value;
                
                Debug.Log($"Complete contact: {name}");
                Debug.Log($"  Email: {email}");
                Debug.Log($"  Phone: {phone}");
            }
        }
    }
}
```

## Game-Specific Constraint Examples

### Social Leaderboard Contacts

```csharp
void PrepareLeaderboardContacts()
{
    // Only get contacts with names for leaderboard display
    var options = new ReadContactsOptions.Builder()
        .WithConstraints(ReadContactsConstraint.MustIncludeName)
        .WithLimit(25) // Top friends for leaderboard
        .Build();
        
    AddressBook.ReadContacts(options, ProcessLeaderboardContacts);
}

void ProcessLeaderboardContacts(AddressBookReadContactsResult result, Error error)
{
    if (error == null)
    {
        // Create leaderboard entries with guaranteed names
        foreach (var contact in result.Contacts)
        {
            string playerName = $"{contact.FirstName} {contact.LastName}".Trim();
            // Add to your game's social leaderboard system
            AddToGameLeaderboard(playerName);
        }
    }
}

void AddToGameLeaderboard(string playerName)
{
    // Your leaderboard implementation here
    Debug.Log($"Added {playerName} to social leaderboard");
}
```

### Multiplayer Invitation System

```csharp
void PrepareMultiplayerInvitations()
{
    // Get contacts with email OR phone for flexible invitations
    var constraints = ReadContactsConstraint.MustIncludeEmail | 
                     ReadContactsConstraint.MustIncludePhoneNumber;
                     
    var options = new ReadContactsOptions.Builder()
        .WithConstraints(constraints)
        .WithLimit(20)
        .Build();
        
    AddressBook.ReadContacts(options, ProcessMultiplayerContacts);
}

void ProcessMultiplayerContacts(AddressBookReadContactsResult result, Error error)
{
    if (error == null)
    {
        foreach (var contact in result.Contacts)
        {
            // Check what contact methods are available
            bool hasEmail = contact.EmailAddresses != null && contact.EmailAddresses.Length > 0;
            bool hasPhone = contact.PhoneNumbers != null && contact.PhoneNumbers.Length > 0;
            
            string name = $"{contact.FirstName} {contact.LastName}".Trim();
            Debug.Log($"Multiplayer invitation candidate: {name}");
            
            if (hasEmail)
            {
                Debug.Log($"  Can invite via email: {contact.EmailAddresses[0].Value}");
            }
            
            if (hasPhone)
            {
                Debug.Log($"  Can invite via SMS: {contact.PhoneNumbers[0].Value}");
            }
        }
    }
}
```

## Performance Benefits

Using constraints provides several performance benefits for Unity mobile games:

1. **Reduced Data Transfer**: Only relevant contact data is retrieved
2. **Faster Processing**: Fewer contacts to iterate through
3. **Better Memory Usage**: Less memory consumption with filtered results
4. **Improved User Experience**: No empty contact entries in your game UI

## Best Practices for Unity Mobile Game Development

### 1. Always Use Constraints
Don't retrieve all contacts without filtering - it impacts performance.

### 2. Combine with Limits
Use constraints together with `.WithLimit()` for optimal performance.

### 3. Match Constraints to Features
Choose constraints based on what your specific game feature needs.

### 4. Test on Real Devices
Test constraint filtering with realistic contact databases.

![Contact Constraints Flow](../../.gitbook/assets/AddressBookConstraints.png)