# Advanced Usage

## Pagination for Large Contact Lists

Handle large contact databases using pagination with offset and limit:

```csharp
private int currentOffset = 0;

void LoadNextContactsPage()
{
    var options = new ReadContactsOptions.Builder()
        .WithLimit(10)
        .WithOffset(currentOffset)
        .Build();
        
    AddressBook.ReadContacts(options, OnPageLoaded);
}

void OnPageLoaded(AddressBookReadContactsResult result, Error error)
{
    if (error == null)
    {
        currentOffset = result.NextOffset;
        Debug.Log($"Loaded page with {result.Contacts.Length} contacts");
    }
}
```

This example demonstrates progressive contact loading. Use `NextOffset` from the result to load subsequent pages, enabling smooth performance with large contact lists in Unity mobile games.

## Custom Initialization with Settings

Initialize the Address Book module with custom settings for advanced scenarios:

```csharp
void InitializeWithCustomSettings()
{
    var settings = AddressBookUnitySettings.CreateInstance();
    // Configure custom default image for contacts
    AddressBook.Initialize(settings);
    Debug.Log("Address Book initialized with custom settings");
}
```

This snippet shows advanced initialization using Unity settings. This approach allows customization of default images and other Address Book module behaviors.

## Error Handling Strategies

Implement comprehensive error handling for robust Unity cross-platform applications:

```csharp
void HandleContactErrors(AddressBookReadContactsResult result, Error error)
{
    if (error != null)
    {
        var errorCode = (AddressBookErrorCode)error.Code;
        switch (errorCode)
        {
            case AddressBookErrorCode.PermissionDenied:
                Debug.Log("User denied contacts permission");
                break;
            case AddressBookErrorCode.Unknown:
                Debug.Log($"Unknown error occurred: {error.Description}");
                break;
        }
    }
}
```

This example demonstrates proper error categorization using the actual `AddressBookErrorCode` enum. Different error types require different user feedback and recovery strategies in Unity iOS and Android applications.

📌 **Video Note**: Show Unity demo of each advanced case - pagination loading, initialization process, and error handling scenarios.