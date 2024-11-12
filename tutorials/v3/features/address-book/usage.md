---
description: Address Book allows access to contacts on mobile devices.
---

# Usage

This feature allows you to read the contacts saved on the mobile devices. All Address Book features can be accessible from **AddressBook** static class.&#x20;

Before using any of the plugin's features, you need to import the namespace.

```
using VoxelBusters.EssentialKit;
```

After importing the namespace, AddressBook class is available for accessing all of the Address Book's features.

## Get Contacts Access Status

Get the contacts access status to see if it's allowed to access or denied by the user.\
\
**GetContactAccessStatus** method returns **AddressBookContactsAccessStatus** to identify if the status is NotDetermined/Restricted/Denied/Authorized.

```
AddressBookContactsAccessStatus status = AddressBook.GetContactsAccessStatus();
```

## Request Contact Access

Request the permission if the contact access is not determined yet. Calling RequestContactsAccess might show up a permission dialog on the mobile devices allowing the user to take an action.

You need to pass a callback method to get the status of the user action.

```csharp
AddressBook.RequestContactsAccess(callback: OnRequestContactsAccessFinish);
```

```csharp
private void OnRequestContactsAccessFinish(AddressBookRequestContactsAccessResult result, Error error)
{
    Debug.Log("Request for contacts access finished.");
    Debug.Log("Address book contacts access status: " + result.AccessStatus);
}
```

## Read Contacts

Fetch the contacts available for the user by calling ReadContacts method. You need to pass a callback to get the list of **IAddressBookContact** instances.

```
AddressBook.ReadContacts(OnReadContactsFinish);
```

```csharp
private void OnReadContactsFinish(AddressBookReadContactsResult result, Error error)
{
    if (error == null)
    {
        var     contacts    = result.Contacts;
        Debug.Log("Request to read contacts finished successfully.");
        Debug.Log("Total contacts fetched: " + contacts.Length);
        Debug.Log("Below are the contact details (capped to first 10 results only):");
        for (int iter = 0; iter < contacts.Length && iter < 10; iter++)
        {
            Debug.Log(string.Format("[{0}]: {1}", iter, contacts[iter]));
        }
    }
    else
    {
        Debug.Log("Request to read contacts failed with error. Error: " + error);
    }
}
```

## Read Contacts with User Permission

If you don't need much control on the permission access status but just want to go ahead with reading the contacts, you can call **ReadContactsWithUserPermission**. \
\
This call requests the permission internally and returns the contacts details if authorized or an error if user deny the permission.

```
AddressBook.ReadContactsWithUserPermission(OnReadContactsFinish);
```

```csharp
private void OnReadContactsFinish(AddressBookReadContactsResult result, Error error)
{
    if (error == null)
    {
        var     contacts    = result.Contacts;
        Debug.Log("Request to read contacts finished successfully.");
        Debug.Log("Total contacts fetched: " + contacts.Length);
        Debug.Log("Below are the contact details (capped to first 10 results only):");
        for (int iter = 0; iter < contacts.Length && iter < 10; iter++)
        {
            Debug.Log(string.Format("[{0}]: {1}", iter, contacts[iter]));
        }
    }
    else
    {
        Debug.Log("Request to read contacts failed with error. Error: " + error);
    }
}
```
