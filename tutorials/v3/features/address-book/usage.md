---
description: Address Book allows access to contacts on mobile devices.
---

# Usage

This feature allows you to read the contacts saved on the mobile devices. All Address Book features can be accessible from **AddressBook** static class.&#x20;

Before using any of the plugin's features, you need to import the namespace.

```
using VoxelBusters.EssentialKit;
using VoxelBusters.CoreLibrary;
```

After importing the namespace, AddressBook class is available for accessing all of the Address Book's features.

## Get Contacts Access Status

Get the contacts access status to see if it's allowed to access or denied by the user.\
\
**GetContactAccessStatus** method returns **AddressBookContactsAccessStatus** to identify if the status is NotDetermined/Restricted/Denied/Authorized.

```
AddressBookContactsAccessStatus status = AddressBook.GetContactsAccessStatus();
```

## Read Contacts

Fetch the contacts available for the user by calling ReadContacts method.&#x20;

{% hint style="info" %}
This method automatically handles the permission on first call. If user denies the permission, corresponding error with error code is returned in the callback.
{% endhint %}

ReadContacts take ReadContactsOptions where you can configure on the what and how to fetch. It provides the following options

* Limit - How many contacts to fetch from the provided offset
* Offset - Offset from which contacts need to be read
* Constraints - If you want to fetch contacts only with name or email or phone number or any combination of those

```csharp
//For implementing paging
ReadContactsOptions options = new ReadContactsOptions.Builder()
                                                .WithLimit(10)
                                                .WithOffset(0)
                                                .WithConstraints(ReadContactsConstraint.Name | ReadContactsConstraint.MustIncludeEmail) //Or ReadContactsConstraint.None to retrieve all or ReadContactsConstraint.Name to retrieve contacts which have name
                                                .Build();

//For retrieving all contacts
ReadContactsOptions options = new ReadContactsOptions.Builder()
                                                .Build();
                                                                                                .Build();
```

Along with options, you need to pass a callback to get the list of **IAddressBookContact** instances.

```csharp
ReadContactsOptions options;
//...
//Build options with ReadContactsOptions.Builder()
//...
AddressBook.ReadContacts(options, OnReadContactsFinish);
```

```csharp
private void OnReadContactsFinish(AddressBookReadContactsResult result, Error error)
{
    if (error == null)
    {
        var     contacts    = result.Contacts;
        Debug.Log("Request to read contacts finished successfully.");
        Debug.Log("Total contacts fetched: " + contacts.Length);
        Debug.Log("Next offset : " + result.NextOffset);
        for (int iter = 0; iter < contacts.Length && iter < 10; iter++)
        {
            Debug.Log(string.Format("[{0}]: {1}", iter, contacts[iter]));
            /*
                IAddressBookContact contact = contacts[iter];
                Debug.Log($"Name: {contact.Name}, Email: {contact.Email});
            */
        }
    }
    else
    {
        Debug.Log("Request to read contacts failed with error. Error: " + error);
    }
}
```
