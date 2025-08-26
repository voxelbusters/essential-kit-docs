# Advanced Usage

## Performance Optimization for Unity Mobile Games

Once you've mastered the basics of contact reading, these advanced techniques will help you build production-ready Unity mobile games with optimal performance and user experience.

## Pagination for Large Contact Lists

Handle large contact databases efficiently using pagination:

```csharp
using VoxelBusters.EssentialKit;
using UnityEngine;
using System.Collections.Generic;

public class ContactPagination : MonoBehaviour
{
    private int currentOffset = 0;
    private const int PAGE_SIZE = 20; // Optimal size for mobile games
    private List<IAddressBookContact> allLoadedContacts = new List<IAddressBookContact>();
    
    [SerializeField] private bool isLoading = false;
    [SerializeField] private bool hasMoreContacts = true;
    
    void Start()
    {
        LoadFirstPage();
    }
    
    void LoadFirstPage()
    {
        currentOffset = 0;
        allLoadedContacts.Clear();
        LoadNextContactsPage();
    }
    
    public void LoadNextContactsPage()
    {
        if (isLoading || !hasMoreContacts)
        {
            Debug.Log("Already loading or no more contacts to load");
            return;
        }
        
        isLoading = true;
        
        var options = new ReadContactsOptions.Builder()
            .WithLimit(PAGE_SIZE)
            .WithOffset(currentOffset)
            .WithConstraints(ReadContactsConstraint.MustIncludeName) // Only get contacts with names
            .Build();
            
        AddressBook.ReadContacts(options, OnPageLoaded);
    }
    
    void OnPageLoaded(AddressBookReadContactsResult result, Error error)
    {
        isLoading = false;
        
        if (error == null)
        {
            Debug.Log($"Loaded page with {result.Contacts.Length} contacts");
            
            // Add contacts to our collection
            allLoadedContacts.AddRange(result.Contacts);
            
            // Update pagination state
            currentOffset = result.NextOffset;
            hasMoreContacts = result.Contacts.Length == PAGE_SIZE; // Assume no more if less than full page
            
            Debug.Log($"Total contacts loaded: {allLoadedContacts.Count}\");
            Debug.Log($"Has more contacts: {hasMoreContacts}\");
            
            // Update your game UI
            UpdateContactListUI();
        }
        else
        {
            Debug.LogError($\"Failed to load contacts page: {error}\");
            HandlePaginationError(error);
        }
    }
    
    void UpdateContactListUI()
    {
        // Update your Unity UI here
        // This is where you'd populate ScrollRect or other UI elements
        foreach (var contact in allLoadedContacts)
        {
            Debug.Log($\"Contact in list: {contact.FirstName} {contact.LastName}\");
        }
    }
    
    void HandlePaginationError(Error error)
    {
        // Implement error recovery - maybe retry or show user message
        Debug.LogError(\"Pagination failed - implement retry logic here\");
    }
    
    // Call this from UI button or scroll view
    public void RequestMoreContacts()
    {
        LoadNextContactsPage();
    }
}
```

## Custom Initialization and Configuration

Initialize the Address Book module with optimized settings for your Unity mobile game:

```csharp
public class AddressBookGameInitializer : MonoBehaviour
{
    void Awake()
    {
        InitializeAddressBookForGame();
    }
    
    void InitializeAddressBookForGame()
    {
        // Check if Address Book is available on this platform
        if (!AddressBook.IsAvailable)
        {
            Debug.LogWarning(\"Address Book not available on this platform\");
            return;
        }
        
        try 
        {
            var settings = AddressBookUnitySettings.CreateInstance();
            
            // Configure settings for your game's needs
            // settings.DefaultContactImagePath = \"path/to/default/image\"; // If available
            
            AddressBook.Initialize(settings);
            Debug.Log(\"Address Book initialized successfully for Unity mobile game\");
            
            // Verify initialization
            VerifyAddressBookSetup();
        }
        catch (System.Exception ex)
        {
            Debug.LogError($\"Failed to initialize Address Book: {ex.Message}\");
        }
    }
    
    void VerifyAddressBookSetup()
    {
        // Check current permission status after initialization
        var status = AddressBook.GetContactsAccessStatus();
        Debug.Log($\"Current contacts access status: {status}\");
        
        // Log configuration info
        Debug.Log(\"Address Book ready for Unity mobile game features\");
    }
}
```

## Comprehensive Error Handling

Implement robust error handling for production Unity mobile games:

```csharp
public class ContactErrorHandler : MonoBehaviour
{
    public enum ContactErrorType
    {
        PermissionDenied,
        NetworkError,
        UnknownError,
        PlatformNotSupported
    }
    
    void HandleContactOperationResult(AddressBookReadContactsResult result, Error error)
    {
        if (error != null)
        {
            var errorType = CategorizeError(error);
            HandleSpecificError(errorType, error);
        }
        else
        {
            // Success case
            Debug.Log($\"Successfully retrieved {result.Contacts.Length} contacts\");
        }
    }
    
    ContactErrorType CategorizeError(Error error)
    {
        // Check if we can cast to AddressBookErrorCode
        if (System.Enum.IsDefined(typeof(AddressBookErrorCode), error.Code))
        {
            var errorCode = (AddressBookErrorCode)error.Code;
            
            switch (errorCode)
            {
                case AddressBookErrorCode.PermissionDenied:
                    return ContactErrorType.PermissionDenied;
                    
                case AddressBookErrorCode.Unknown:
                default:
                    return ContactErrorType.UnknownError;
            }
        }
        
        return ContactErrorType.UnknownError;
    }
    
    void HandleSpecificError(ContactErrorType errorType, Error error)
    {
        switch (errorType)
        {
            case ContactErrorType.PermissionDenied:\n                HandlePermissionDenied();\n                break;\n                \n            case ContactErrorType.NetworkError:\n                HandleNetworkError();\n                break;\n                \n            case ContactErrorType.UnknownError:\n                HandleUnknownError(error);\n                break;\n                \n            case ContactErrorType.PlatformNotSupported:\n                HandlePlatformNotSupported();\n                break;\n        }\n    }\n    \n    void HandlePermissionDenied()\n    {\n        Debug.LogWarning(\"Contacts permission denied by user\");\n        \n        // Show user-friendly message in your game\n        ShowPermissionDeniedDialog();\n        \n        // Offer alternative game features\n        EnableNonContactFeatures();\n    }\n    \n    void HandleNetworkError()\n    {\n        Debug.LogWarning(\"Network error during contact operation\");\n        \n        // Implement retry logic\n        ShowRetryDialog();\n    }\n    \n    void HandleUnknownError(Error error)\n    {\n        Debug.LogError($\"Unknown error in contact operation: {error.LocalizedDescription}\");\n        \n        // Log for debugging\n        Debug.LogError($\"Error code: {error.Code}\");\n        Debug.LogError($\"Error domain: {error.Domain}\");\n        \n        // Show generic error message to user\n        ShowGenericErrorDialog();\n    }\n    \n    void HandlePlatformNotSupported()\n    {\n        Debug.LogWarning(\"Address Book not supported on this platform\");\n        \n        // Disable contact-related features\n        DisableContactFeatures();\n    }\n    \n    // UI Methods (implement based on your game's UI system)\n    void ShowPermissionDeniedDialog()\n    {\n        // Show dialog explaining why contacts are needed\n        // Provide button to open device settings\n    }\n    \n    void ShowRetryDialog()\n    {\n        // Show retry button for network errors\n    }\n    \n    void ShowGenericErrorDialog()\n    {\n        // Show general error message\n    }\n    \n    void EnableNonContactFeatures()\n    {\n        // Enable game features that don't require contacts\n    }\n    \n    void DisableContactFeatures()\n    {\n        // Disable contact-related UI elements\n    }\n}\n```\n\n## Memory Management for Contact Data\n\n```csharp\npublic class ContactMemoryManager : MonoBehaviour\n{\n    private Dictionary<string, WeakReference> contactImageCache = new Dictionary<string, WeakReference>();\n    \n    void LoadContactWithMemoryOptimization(IAddressBookContact contact)\n    {\n        string contactKey = $\"{contact.FirstName}_{contact.LastName}\";\n        \n        // Check if image is already in memory\n        if (contactImageCache.ContainsKey(contactKey))\n        {\n            var weakRef = contactImageCache[contactKey];\n            if (weakRef.IsAlive)\n            {\n                var cachedTexture = weakRef.Target as Texture2D;\n                if (cachedTexture != null)\n                {\n                    // Use cached texture\n                    return;\n                }\n            }\n        }\n        \n        // Load image with memory management\n        contact.LoadImage((textureData, error) =>\n        {\n            if (error == null && textureData != null)\n            {\n                // Store in weak reference cache\n                contactImageCache[contactKey] = new WeakReference(textureData.Texture);\n            }\n        });\n    }\n    \n    void OnDestroy()\n    {\n        // Clean up cache\n        contactImageCache.Clear();\n    }\n}\n```\n\n## Production-Ready Integration Tips\n\n### 1. Always Use Pagination\nNever load all contacts at once - it will crash on devices with large contact lists.\n\n### 2. Implement Proper Error Recovery\nHandle all error cases gracefully with user-friendly messages and recovery options.\n\n### 3. Cache Strategically\nCache frequently accessed data but be mindful of memory usage on mobile devices.\n\n### 4. Test on Real Devices\nTest with realistic contact databases (1000+ contacts) to ensure performance.\n\n### 5. Provide Fallback Features\nAlways offer alternative game features when contacts are not available.\n\n![Advanced Usage Architecture](../../.gitbook/assets/AddressBookAdvanced.png)