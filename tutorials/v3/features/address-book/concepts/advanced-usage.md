---
description: Advanced Address Book patterns for Unity mobile games
---

# Advanced Usage

## Pagination for Large Contact Lists

Handle large contact databases using pagination with offset and limit:

```csharp
using VoxelBusters.EssentialKit;

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
        Debug.Log($"Next offset: {currentOffset}");
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
    // Configure custom settings if needed
    AddressBook.Initialize(settings);
    Debug.Log("Address Book initialized with custom settings");
}
```

This snippet shows advanced initialization using Unity settings. This approach allows customization of default behaviors and Address Book module configuration.

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
                Debug.Log("User denied contacts permission - guide to settings");
                break;
            case AddressBookErrorCode.Unknown:
                Debug.Log($"Unknown error occurred: {error.Description}");
                break;
        }
    }
}
```

This example demonstrates proper error categorization using the actual `AddressBookErrorCode` enum. Different error types require different user feedback and recovery strategies in Unity iOS and Android applications.

## Performance Optimization

Optimize contact operations for better Unity mobile game performance:

```csharp
void OptimizedContactReading()
{
    // Read contacts with constraints and limits for performance
    var options = new ReadContactsOptions.Builder()
        .WithLimit(50)  // Reasonable batch size
        .WithConstraints(ReadContactsConstraint.MustIncludeName)  // Only contacts with names
        .Build();
        
    AddressBook.ReadContacts(options, OnOptimizedContactsRead);
}

void OnOptimizedContactsRead(AddressBookReadContactsResult result, Error error)
{
    if (error == null)
    {
        Debug.Log($"Optimized read: {result.Contacts.Length} contacts with names");
        // Process contacts efficiently without loading all at once
    }
}
```

This snippet demonstrates performance optimization techniques by using constraints and reasonable batch sizes for contact operations.

## Key Points

- Use pagination for large contact lists to maintain smooth performance
- Initialize with custom settings only when default behavior needs modification
- Implement proper error handling with specific `AddressBookErrorCode` cases
- Combine constraints with limits for optimal performance in Unity mobile games
- Always use `NextOffset` for proper pagination implementation