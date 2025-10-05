---
description: Address Book allows access to contacts on mobile devices.
---

# Usage

Essential Kit wraps native iOS and Android contacts APIs into a single Unity interface. The first `ReadContacts` call automatically triggers the system permission dialog.

## Table of Contents
- [Import Namespaces](#import-namespaces)
- [How Permissions Work](#how-permissions-work)
  - [Optional: Inspect Current Status](#optional-inspect-current-status)
- [Reading Contacts](#reading-contacts)
  - [Basic Read](#basic-read)
  - [Pagination](#pagination)
  - [Filtering Contacts](#filtering-contacts)
- [Contact Data Properties](#contact-data-properties)
- [Core APIs Reference](#core-apis-reference)
- [Error Handling](#error-handling)
- [Advanced: Custom Default Image](#advanced-custom-default-image)
- [Related Guides](#related-guides)

## Import Namespaces
```csharp
using VoxelBusters.EssentialKit;
using VoxelBusters.CoreLibrary;
```

## How Permissions Work
Just call `AddressBook.ReadContacts()` directly—no permission checks needed. On the first call, Essential Kit automatically shows the system permission dialog. If permission is already granted, it returns contacts immediately. If denied, the error callback tells you why.

{% hint style="success" %}
Show a custom explanation screen **before** calling `ReadContacts` to improve opt-in rates.
{% endhint %}

Handle permission issues in the error callback:
```csharp
void OnContactsLoaded(AddressBookReadContactsResult result, Error error)
{
    if (error != null)
    {
        // Check error.Code to determine next steps
        if (error.Code == (int)AddressBookErrorCode.PermissionDenied)
        {
            // Permission denied - show settings link
            Utilities.OpenApplicationSettings();
        }
        return;
    }

    // Process contacts
}
```

### Optional: Check Permission Status
Use `GetContactsAccessStatus()` only when you need to inspect the exact permission state **before** calling `ReadContacts` or to customize UI messaging based on the current status.

```csharp
var status = AddressBook.GetContactsAccessStatus();
// NotDetermined | Authorized | Limited (iOS) | Denied | Restricted
```

Permission states:
- `NotDetermined` – System dialog not yet shown
- `Authorized` – Full access granted
- `Limited` (iOS 14+) – Partial contact list shared
- `Denied` – Access declined by user
- `Restricted` – Blocked by parental/device policy

## Reading Contacts
Once permission is granted, the Address Book API returns device contacts in pages. You control how many contacts to fetch, when to request the next page, and which properties must be present.

### Basic Read
Start by constructing `ReadContactsOptions` for the page size and constraints you need. The callback receives two arguments: `AddressBookReadContactsResult`, which includes the contacts and the pagination marker, and an `Error` when something goes wrong.
```csharp
int nextOffset = 0; // Tracks pagination across calls.

void LoadContacts()
{
    var options = new ReadContactsOptions.Builder()
        .WithLimit(20) // Fetch a single page of contacts.
        .Build();

    AddressBook.ReadContacts(options, OnContactsLoaded);
}

void OnContactsLoaded(AddressBookReadContactsResult result, Error error)
{
    if (error != null)
    {
        Debug.LogError($"Address Book failed: {error}");
        return;
    }

    nextOffset = result.NextOffset; // -1 when there are no more contacts.

    foreach (var contact in result.Contacts)
    {
        var name = $"{contact.FirstName} {contact.LastName}".Trim();
        Debug.Log($"Contact: {name}");
        Debug.Log("Populate your UI with this contact's info (name, email, phone, image).");
    }
}
```

### Pagination
`AddressBookReadContactsResult.NextOffset` tells you where to resume. Keep it around and reuse the same callback so you can stitch pages together effortlessly.
```csharp
void LoadNextPage()
{
    if (nextOffset < 0)
    {
        Debug.Log("All contacts fetched");
        return;
    }

    var options = new ReadContactsOptions.Builder()
        .WithLimit(20)
        .WithOffset(nextOffset)
        .Build();

    AddressBook.ReadContacts(options, OnContactsLoaded);
}
```

### Filtering Contacts
Filter out irrelevant entries by combining `ReadContactsConstraint` flags. This keeps your UI focused on contacts that can actually take the action you provide.
```csharp
// Only contacts with email addresses
var options = new ReadContactsOptions.Builder()
    .WithConstraints(ReadContactsConstraint.MustIncludeEmail)
    .Build();

// Contacts with both email AND phone
var options = new ReadContactsOptions.Builder()
    .WithConstraints(ReadContactsConstraint.MustIncludeEmail |
                     ReadContactsConstraint.MustIncludePhoneNumber)
    .Build();
```

## Contact Data Properties
Every contact object mirrors the person’s record on the device. Handle missing fields gracefully and pick the data points that matter for your experience.
| Property | Type | Notes |
| --- | --- | --- |
| `FirstName`, `MiddleName`, `LastName` | `string` | May be empty |
| `CompanyName` | `string` | May be empty |
| `EmailAddresses` | `string[]` | Check `.Length` before access |
| `PhoneNumbers` | `string[]` | Check `.Length` before access |
| `LoadImage(callback)` | Method | Async; returns default image if unavailable |

### Loading Contact Images
Profile pictures are optional and loaded asynchronously. Use the callback to update UI elements once the texture is ready (or fall back to the default image you configured in settings).
```csharp
contact.LoadImage((textureData, error) =>
{
    if (error == null)
    {
        Texture2D photo = textureData.Texture;
        // Display photo
    }
    // Automatically falls back to default image from settings
});
```

## Core APIs Reference
| API | Purpose | Returns |
| --- | --- | --- |
| `AddressBook.ReadContacts(options, callback)` | Request permission & fetch contacts | Result via callback with contacts or error |
| `ReadContactsOptions.Builder()` | Configure filters & pagination | Chain `.WithLimit()`, `.WithOffset()`, `.WithConstraints()` → `Build()` |
| `AddressBook.GetContactsAccessStatus()` | **Optional:** Check current permission state | `AddressBookContactsAccessStatus` enum |

## Error Handling
`AddressBook.ReadContacts` passes back an `Error` object when something prevents contact access. Branch on the error code so you can show the right guidance.
| Error Code | Trigger | Recommended Action |
| --- | --- | --- |
| `PermissionDenied` | User declined access | Show rationale + link to `Utilities.OpenApplicationSettings()` |
| `Unknown` | Platform error | Retry or log for support |

## Advanced: Custom Default Image
If you want a custom placeholder for contacts without photos, you can initialise the module with your own settings before making any calls.
Override the placeholder image at runtime:
```csharp
void Start()
{
    var settings = ScriptableObject.CreateInstance<AddressBookUnitySettings>();
    settings.DefaultImage = myCustomTexture;
    AddressBook.Initialize(settings);
}
```

## Related Guides
- Demo scene: `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/AddressBookDemo.unity`
- Pair with **Sharing** to send invites via email/SMS
- Use with **Utilities.OpenApplicationSettings** for permission recovery flows
