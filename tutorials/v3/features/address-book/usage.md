---
description: "Address Book allows cross-platform contact access on mobile devices."
---

# Usage

Essential Kit wraps the native iOS Contacts framework and Android Contacts Provider into a single Unity API. The first call to `AddressBook.ReadContacts` automatically handles permissions, so you can focus on delivering contact-driven gameplay loops.

## Table of Contents
- [Permission Workflow](#permission-workflow)
- [Optional: Check Permission Status](#optional-check-permission-status)
- [Reading Contacts](#reading-contacts)
- [Filtering and Constraints](#filtering-and-constraints)
- [Paginated Reads (Advanced)](#paginated-reads-advanced)
- [Contact Data Properties](#contact-data-properties)
- [Loading Contact Images](#loading-contact-images)
- [Core APIs Reference](#core-apis-reference)
- [Error Handling](#error-handling)
- [Related Guides](#related-guides)

## Permission Workflow

Call `AddressBook.ReadContacts` directly. Essential Kit requests permission automatically on the first call and returns an error when the player denies access.

```csharp
using UnityEngine;
using VoxelBusters.CoreLibrary;
using VoxelBusters.EssentialKit;

public class ContactsLoader : MonoBehaviour
{
    private void Start()
    {
        var options = new ReadContactsOptions.Builder()
            .WithLimit(25) // Show a small preview list
            .WithConstraints(ReadContactsConstraint.MustIncludeName)
            .Build();

        AddressBook.ReadContacts(options, OnContactsRead);
    }

    private void OnContactsRead(AddressBookReadContactsResult result, Error error)
    {
        if (error != null)
        {
            if (error.Code == (int)AddressBookErrorCode.PermissionDenied)
            {
                // Let players know why contacts matter, then
                Utilities.OpenApplicationSettings();
            }
            return;
        }

        foreach (var contact in result.Contacts)
        {
            Debug.Log($"Contact: {contact.FirstName} {contact.LastName}");
        }
    }
}
```

{% hint style="success" %}
Show your own rationale screen before the first read call. Apps that explain the benefit of sharing contacts see higher opt-in rates and fewer support tickets.
{% endhint %}

## Optional: Check Permission Status

Use `AddressBook.GetContactsAccessStatus()` only when you need to customize UI copy before launching the native prompt or to detect the `Limited` state on iOS 14+.

```csharp
var status = AddressBook.GetContactsAccessStatus();
switch (status)
{
    case AddressBookContactsAccessStatus.Authorized:
    case AddressBookContactsAccessStatus.Limited:
        // Show friends list immediately
        break;
    case AddressBookContactsAccessStatus.NotDetermined:
        // Encourage user to continue so ReadContacts can request access
        break;
    case AddressBookContactsAccessStatus.Denied:
    case AddressBookContactsAccessStatus.Restricted:
        // Show recovery UI + OpenApplicationSettings button
        break;
}
```

{% hint style="warning" %}
Avoid blocking on `GetContactsAccessStatus()` before every read. The main operation already covers permission prompts and keeps platform behaviour consistent.
{% endhint %}

## Reading Contacts

`ReadContactsOptions` lets you control page size and skip counts. Set `Limit` to a reasonable number (25–100) for scrolling lists and `Offset` to zero for the first batch.

```csharp
int _nextOffset = 0;

void LoadInitialContacts()
{
    var options = new ReadContactsOptions.Builder()
        .WithLimit(50)
        .WithOffset(_nextOffset)
        .Build();

    AddressBook.ReadContacts(options, OnContactsRead);
}

void OnContactsRead(AddressBookReadContactsResult result, Error error)
{
    if (error != null)
    {
        Debug.LogError($"Contacts read failed: {error.Description}");
        return;
    }

    Debug.Log($"Loaded {result.Contacts?.Length ?? 0} contacts.");
    _nextOffset = result.NextOffset;
}
```

{% hint style="info" %}
Starting small lets you show a fast-loading list while additional contacts continue loading in the background.
{% endhint %}

## Filtering and Constraints

Combine constraints to filter out incomplete entries (e.g., require both a name and phone number before showing an invite button).

```csharp
var inviteOptions = new ReadContactsOptions.Builder()
    .WithLimit(100)
    .WithConstraints(ReadContactsConstraint.MustIncludeName | ReadContactsConstraint.MustIncludePhoneNumber)
    .Build();
```

| Constraint | Purpose |
| --- | --- |
| `ReadContactsConstraint.None` | Return every contact (default) |
| `ReadContactsConstraint.MustIncludeName` | Skip entries with no first/last name |
| `ReadContactsConstraint.MustIncludePhoneNumber` | Only contacts with at least one phone number |
| `ReadContactsConstraint.MustIncludeEmail` | Only contacts with at least one email address |

{% hint style="danger" %}
Combining all three constraints (`Name + Phone + Email`) often yields fewer contacts than expected. Start broad and tighten filters based on telemetry.
{% endhint %}

## Paginated Reads (Advanced)

Use the `NextOffset` returned in each result to load more contacts as players scroll. Essential Kit returns `-1` when you've reached the end.

```csharp
int _nextOffset = 0;
bool _isLoading;

public void LoadMoreIfNeeded()
{
    if (_isLoading || _nextOffset < 0)
        return;

    _isLoading = true;

    var options = new ReadContactsOptions.Builder()
        .WithLimit(25)
        .WithOffset(_nextOffset)
        .Build();

    AddressBook.ReadContacts(options, (result, error) =>
    {
        _isLoading = false;

        if (error == null)
        {
            Debug.Log($"Appended {result.Contacts?.Length ?? 0} contacts.");
            _nextOffset = result.NextOffset; // -1 means done
        }
    });
}
```

## Contact Data Properties

| Property | Type | Notes |
| --- | --- | --- |
| `FirstName`, `MiddleName`, `LastName` | `string` | Empty when a contact only has a company name |
| `CompanyName` | `string` | Useful for B2B apps or support forms |
| `PhoneNumbers` | `string[]` | Iterate and display type labels in your own UI |
| `EmailAddresses` | `string[]` | Often empty on phone-focused contacts |
| `LoadImage(callback)` | `EventCallback<TextureData>` | Async load; returns placeholder texture when the contact lacks a photo |

## Loading Contact Images

`LoadImage` is async and safe to call on the main thread. Provide a default sprite while the callback resolves.

```csharp
void ShowAvatar(IAddressBookContact contact, RawImage target)
{
    target.texture = _placeholder;

    contact.LoadImage((textureData, error) =>
    {
        if (error == null && textureData.Texture != null)
        {
            target.texture = textureData.Texture;
        }
    });
}
```

{% hint style="success" %}
Cache textures per contact ID in memory to avoid reloading images every time a scroll view recycles a cell.
{% endhint %}

## Core APIs Reference

| API | Purpose | Returns |
| --- | --- | --- |
| `AddressBook.ReadContacts(options, callback)` | Requests permission if needed, then returns contacts | `AddressBookReadContactsResult` via callback |
| `ReadContactsOptions.Builder()` | Configure pagination and constraints | Chain `.WithLimit()`, `.WithOffset()`, `.WithConstraints()` |
| `AddressBook.GetContactsAccessStatus()` | **Optional**: inspect current permission state | `AddressBookContactsAccessStatus` enum |
| `IAddressBookContact.LoadImage(callback)` | Load a contact's profile picture asynchronously | `TextureData` with texture or placeholder |

## Error Handling

| Error Code | Trigger | Recommended Action |
| --- | --- | --- |
| `AddressBookErrorCode.PermissionDenied` | Player denied or restricted contacts access | Show rationale, direct to `Utilities.OpenApplicationSettings()` |
| `AddressBookErrorCode.Unknown` | Platform returned an unexpected failure | Retry, log for diagnostics, or fall back to manual friend codes |

## Related Guides
- Demo scene: `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/AddressBookDemo.unity`
- Pair with **Sharing Services** to pre-fill SMS or email invites using selected contacts
- Ready to validate your flow? Head to the [Testing guide](testing.md) next
