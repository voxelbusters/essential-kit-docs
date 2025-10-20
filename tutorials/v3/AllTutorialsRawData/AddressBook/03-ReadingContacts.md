# Reading Contacts

## What is Contact Reading?

Contact reading is the core functionality for retrieving contact information from the device's address book. Why use it in a Unity mobile game? It enables social features like finding friends, importing contact lists for multiplayer invitations, or creating personalized experiences based on user connections.

## Basic Contact Reading

The `ReadContacts()` method retrieves contacts from the device with customizable options:

```csharp
using VoxelBusters.EssentialKit;

void ReadAllContacts()
{
    var options = new ReadContactsOptions.Builder().Build();
    AddressBook.ReadContacts(options, OnContactsRead);
}
```

This snippet creates default options and requests all contacts from the device. The callback method will receive the results when the operation completes.

## Handling Contact Results

Process the retrieved contacts in your callback method:

```csharp
void OnContactsRead(AddressBookReadContactsResult result, Error error)
{
    if (error == null)
    {
        Debug.Log($"Retrieved {result.Contacts.Length} contacts");
        foreach (var contact in result.Contacts)
        {
            Debug.Log($"Contact: {contact.FirstName} {contact.LastName}");
        }
    }
    else
    {
        Debug.Log("Failed to read contacts: " + error);
    }
}
```

This snippet demonstrates how to handle successful contact retrieval and error cases. It logs the contact count and iterates through each contact to display basic information.

## Limited Contact Reading

You can specify a limit to retrieve only a subset of contacts:

```csharp
void ReadLimitedContacts()
{
    var options = new ReadContactsOptions.Builder()
        .WithLimit(10)
        .Build();
    AddressBook.ReadContacts(options, OnContactsRead);
}
```

This snippet requests only the first 10 contacts from the address book. This approach is useful for performance optimization and pagination scenarios in Unity mobile games.

📌 **Video Note**: Show Unity demo clip of contact reading in action, displaying the contact list output in the console.