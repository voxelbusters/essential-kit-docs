---
description: Working with contact properties in Unity mobile games
---

# Contact Properties

## What are Contact Properties?

Contact properties are the individual data fields available for each contact, such as names, phone numbers, emails, and profile images. Why use them in a Unity mobile game? These properties enable rich social features like displaying contact names in leaderboards, using profile images in friend lists, or accessing communication channels for invitations.

## Basic Contact Information

Access fundamental contact data through the `IAddressBookContact` interface:

```csharp
using VoxelBusters.EssentialKit;

void DisplayContactInfo(IAddressBookContact contact)
{
    Debug.Log($"First Name: {contact.FirstName}");
    Debug.Log($"Last Name: {contact.LastName}");
    Debug.Log($"Company: {contact.CompanyName}");
}
```

This snippet demonstrates how to access basic contact information. These properties provide the core identification data needed for most Unity cross-platform game features.

## Communication Properties

Retrieve contact communication information:

```csharp
void DisplayContactCommunication(IAddressBookContact contact)
{
    if (contact.EmailAddresses != null)
    {
        Debug.Log($"Emails: {string.Join(", ", contact.EmailAddresses)}");
    }
    
    if (contact.PhoneNumbers != null)
    {
        Debug.Log($"Phones: {string.Join(", ", contact.PhoneNumbers)}");
    }
}
```

This snippet shows how to access arrays of email addresses and phone numbers. Each contact can have multiple communication methods, making them useful for Unity mobile games with various invitation mechanisms.

## Loading Contact Images

Asynchronously load profile pictures for contacts:

```csharp
void LoadContactImage(IAddressBookContact contact)
{
    contact.LoadImage((textureData, error) =>
    {
        if (error == null && textureData != null)
        {
            Debug.Log("Contact image loaded successfully");
            // Use textureData.Texture for UI display in Unity
        }
        else
        {
            Debug.Log("No image available or loading failed");
        }
    });
}
```

This snippet demonstrates asynchronous image loading for contact profile pictures. The loaded texture can be used in Unity UI elements to create personalized game interfaces.

## Complete Contact Display

Combine all properties for comprehensive contact display:

```csharp
void ShowCompleteContactInfo(IAddressBookContact contact)
{
    Debug.Log($"Contact: {contact.FirstName} {contact.LastName}");
    
    if (!string.IsNullOrEmpty(contact.CompanyName))
        Debug.Log($"Company: {contact.CompanyName}");
        
    if (contact.EmailAddresses?.Length > 0)
        Debug.Log($"Email: {contact.EmailAddresses[0]}");
        
    if (contact.PhoneNumbers?.Length > 0)
        Debug.Log($"Phone: {contact.PhoneNumbers[0]}");
}
```

This snippet shows how to create a comprehensive contact display by checking for available properties and displaying them appropriately.

## Key Points

- Always check for null/empty values before using contact properties
- Contacts may have multiple emails and phone numbers - access via arrays
- Profile image loading is asynchronous and may fail if no image exists
- Use contact properties to create rich social features in Unity mobile games
- All properties work consistently across Unity iOS and Unity Android builds