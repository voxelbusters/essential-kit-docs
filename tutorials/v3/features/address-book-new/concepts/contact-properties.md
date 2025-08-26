# Contact Properties

## Working with Contact Data in Unity Games

Contact properties are the individual data fields available for each contact, such as names, phone numbers, emails, and profile images. These properties enable rich social features in Unity mobile games like displaying contact names in leaderboards, using profile images in friend lists, or accessing communication channels for multiplayer invitations.

## Understanding Contact Data Structure

Essential Kit provides comprehensive contact data through the `IAddressBookContact` interface. Here's how to access and use contact information effectively:

### Basic Contact Information

```csharp
using VoxelBusters.EssentialKit;
using UnityEngine;

public class ContactPropertyExample : MonoBehaviour
{
    void DisplayBasicContactInfo(IAddressBookContact contact)
    {
        // Name properties
        Debug.Log($"First Name: {contact.FirstName ?? "N/A"}");
        Debug.Log($"Last Name: {contact.LastName ?? "N/A"}");
        Debug.Log($"Company: {contact.CompanyName ?? "N/A"}");
        
        // Create display name for game UI
        string displayName = CreateDisplayName(contact);
        Debug.Log($"Display Name for Game: {displayName}");
    }
    
    string CreateDisplayName(IAddressBookContact contact)
    {
        if (!string.IsNullOrEmpty(contact.FirstName) && !string.IsNullOrEmpty(contact.LastName))
        {
            return $"{contact.FirstName} {contact.LastName}";
        }
        else if (!string.IsNullOrEmpty(contact.FirstName))
        {
            return contact.FirstName;
        }
        else if (!string.IsNullOrEmpty(contact.LastName))
        {
            return contact.LastName;
        }
        else if (!string.IsNullOrEmpty(contact.CompanyName))
        {
            return contact.CompanyName;
        }
        
        return "Unknown Contact";
    }
}
```

## Communication Properties for Game Features

### Email Addresses for Invitations

```csharp
void ProcessContactEmails(IAddressBookContact contact)
{
    if (contact.EmailAddresses != null && contact.EmailAddresses.Length > 0)
    {
        Debug.Log($"Found {contact.EmailAddresses.Length} email addresses:");
        
        foreach (var email in contact.EmailAddresses)
        {
            Debug.Log($"  Email: {email.Value} (Type: {email.Label})");
            
            // Use for game invitation system
            AddToInvitationList(contact.FirstName, email.Value);
        }
        
        // Get primary email for quick access
        string primaryEmail = GetPrimaryEmail(contact);
        Debug.Log($"Primary email: {primaryEmail}");
    }
    else
    {
        Debug.Log("No email addresses available");
    }
}

string GetPrimaryEmail(IAddressBookContact contact)
{
    if (contact.EmailAddresses != null && contact.EmailAddresses.Length > 0)
    {
        // Return first email as primary
        return contact.EmailAddresses[0].Value;
    }
    return string.Empty;
}

void AddToInvitationList(string name, string email)
{
    // Your game invitation system implementation
    Debug.Log($"Added {name} ({email}) to invitation list");
}
```

### Phone Numbers for SMS Features

```csharp
void ProcessContactPhones(IAddressBookContact contact)
{
    if (contact.PhoneNumbers != null && contact.PhoneNumbers.Length > 0)
    {
        Debug.Log($"Found {contact.PhoneNumbers.Length} phone numbers:");
        
        foreach (var phone in contact.PhoneNumbers)
        {
            Debug.Log($"  Phone: {phone.Value} (Type: {phone.Label})");
            
            // Use for SMS invitation system
            AddToSMSInvitationList(contact.FirstName, phone.Value);
        }
        
        // Get primary phone for quick access
        string primaryPhone = GetPrimaryPhone(contact);
        Debug.Log($"Primary phone: {primaryPhone}");
    }
    else
    {
        Debug.Log("No phone numbers available");
    }
}

string GetPrimaryPhone(IAddressBookContact contact)
{
    if (contact.PhoneNumbers != null && contact.PhoneNumbers.Length > 0)
    {
        return contact.PhoneNumbers[0].Value;
    }
    return string.Empty;
}

void AddToSMSInvitationList(string name, string phone)
{
    // Your SMS invitation system implementation
    Debug.Log($"Added {name} ({phone}) to SMS invitation list");
}
```

## Contact Images for Rich UI

### Loading Profile Pictures

```csharp
using UnityEngine.UI;
using System.Collections.Generic;

public class ContactImageManager : MonoBehaviour
{
    [SerializeField] private Image contactImageDisplay;
    [SerializeField] private Sprite defaultContactSprite;
    
    // Cache for loaded contact images
    private Dictionary<string, Texture2D> imageCache = new Dictionary<string, Texture2D>();
    
    void LoadContactImageForUI(IAddressBookContact contact)
    {
        string contactKey = $"{contact.FirstName}_{contact.LastName}";
        
        // Check cache first
        if (imageCache.ContainsKey(contactKey))
        {
            DisplayContactImage(imageCache[contactKey]);
            return;
        }
        
        // Load image asynchronously
        contact.LoadImage((textureData, error) =>
        {
            if (error == null && textureData != null)
            {
                Debug.Log("Contact image loaded successfully");
                
                // Cache the loaded image
                imageCache[contactKey] = textureData.Texture;
                
                // Display in Unity UI
                DisplayContactImage(textureData.Texture);
            }
            else
            {
                Debug.Log("No image available or loading failed - using default");
                DisplayDefaultImage();
            }
        });
    }
    
    void DisplayContactImage(Texture2D contactTexture)
    {
        if (contactImageDisplay != null && contactTexture != null)
        {
            // Convert Texture2D to Sprite for UI Image component
            Rect rect = new Rect(0, 0, contactTexture.width, contactTexture.height);
            Vector2 pivot = new Vector2(0.5f, 0.5f);
            Sprite contactSprite = Sprite.Create(contactTexture, rect, pivot);
            
            contactImageDisplay.sprite = contactSprite;
        }
    }
    
    void DisplayDefaultImage()
    {
        if (contactImageDisplay != null && defaultContactSprite != null)
        {
            contactImageDisplay.sprite = defaultContactSprite;
        }
    }
}
```

## Complete Contact Data Processing

### Building Rich Contact Cards for Games

```csharp
public class GameContactCard : MonoBehaviour
{
    [System.Serializable]
    public class GameContactData
    {
        public string displayName;
        public string primaryEmail;
        public string primaryPhone;
        public string companyName;
        public Texture2D profileImage;
        public bool hasImage;
        public bool canInviteByEmail;
        public bool canInviteBySMS;
    }
    
    void ProcessContactForGame(IAddressBookContact contact, System.Action<GameContactData> onComplete)
    {
        var gameContact = new GameContactData
        {
            displayName = CreateDisplayName(contact),
            primaryEmail = GetPrimaryEmail(contact),
            primaryPhone = GetPrimaryPhone(contact),
            companyName = contact.CompanyName ?? string.Empty,
            canInviteByEmail = contact.EmailAddresses != null && contact.EmailAddresses.Length > 0,
            canInviteBySMS = contact.PhoneNumbers != null && contact.PhoneNumbers.Length > 0
        };
        
        // Load image asynchronously
        contact.LoadImage((textureData, error) =>
        {
            if (error == null && textureData != null)
            {
                gameContact.profileImage = textureData.Texture;
                gameContact.hasImage = true;
            }
            else
            {
                gameContact.hasImage = false;
            }
            
            // Return complete contact data
            onComplete(gameContact);
        });
    }
    
    void CreateContactListForGame(IAddressBookContact[] contacts)
    {
        int processedCount = 0;
        List<GameContactData> gameContacts = new List<GameContactData>();
        
        foreach (var contact in contacts)
        {
            ProcessContactForGame(contact, (gameContact) =>
            {
                gameContacts.Add(gameContact);
                processedCount++;
                
                // Check if all contacts are processed
                if (processedCount >= contacts.Length)
                {
                    Debug.Log($"Processed {gameContacts.Count} contacts for game UI");
                    UpdateGameContactUI(gameContacts);
                }
            });
        }
    }
    
    void UpdateGameContactUI(List<GameContactData> contacts)
    {
        // Update your game's contact UI here
        foreach (var contact in contacts)
        {
            Debug.Log($"Game Contact: {contact.displayName}");
            Debug.Log($"  Can email invite: {contact.canInviteByEmail}");
            Debug.Log($"  Can SMS invite: {contact.canInviteBySMS}");
            Debug.Log($"  Has profile image: {contact.hasImage}");
        }
    }
}
```

## Property Handling Best Practices

### 1. Always Check for Null Values
```csharp
string safeName = contact.FirstName ?? "Unknown";
```

### 2. Cache Loaded Images
Store loaded profile images to avoid repeated loading.

### 3. Provide Fallbacks
Always have default values or images when contact data is missing.

### 4. Optimize for Mobile
Load images asynchronously and use appropriate image sizes for mobile games.

![Contact Properties Structure](../../.gitbook/assets/AddressBookProperties.png)