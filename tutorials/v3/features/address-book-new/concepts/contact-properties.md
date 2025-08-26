# Contact Properties

## What are Contact Properties?

Contact properties are the individual data fields available for each contact, such as names, phone numbers, emails, and profile images. Why use them in a Unity mobile game? These properties enable rich social features like displaying contact names in leaderboards, using profile images in friend lists, or accessing communication channels for invitations.

## Basic Contact Information

Access fundamental contact data through the `IAddressBookContact` interface:

```csharp
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
            // Use textureData.Texture for UI display
        }
        else
        {
            Debug.Log("No image available or loading failed");
        }
    });
}
```

This snippet demonstrates asynchronous image loading for contact profile pictures. The loaded texture can be used in Unity UI elements to create personalized game interfaces.

📌 **Video Note**: Show Unity demo of contact properties in action, displaying names, emails, phones, and profile images in the game interface.