# Testing Address Book Features

Testing Address Book functionality is essential to ensure your Unity mobile game handles contact access properly across different scenarios.

## Unity Editor Testing

Essential Kit provides built-in editor simulation to test your Address Book implementation without requiring a physical device.

### Configure Simulator Settings

1. **Open Simulator Database**: In Unity, go to Window → Voxel Busters → Essential Kit → Simulator Database
2. **Set Permission Status**: Configure the Access Status to simulate different permission scenarios
3. **Add Test Contacts**: Add sample contacts to test your reading functionality

![Update the simulator database to simulate the address book access status](../../.gitbook/assets/AddressBookSimulator.gif)

### Permission Status Testing

Test all permission scenarios in the Unity Editor:

```csharp
// Test different permission states
public void TestPermissionScenarios()
{
    var status = AddressBook.GetContactsAccessStatus();
    
    switch (status)
    {
        case AddressBookContactsAccessStatus.NotDetermined:
            Debug.Log("Testing: Permission not asked yet");
            break;
        case AddressBookContactsAccessStatus.Authorized:
            Debug.Log("Testing: Permission granted");
            break;
        case AddressBookContactsAccessStatus.Denied:
            Debug.Log("Testing: Permission denied");
            break;
        case AddressBookContactsAccessStatus.Limited:
            Debug.Log("Testing: Limited access granted");
            break;
        case AddressBookContactsAccessStatus.Restricted:
            Debug.Log("Testing: System restricted access");
            break;
    }
}
```

## Device Testing

### iOS Testing

1. **Development Build**: Create a development build and install on your iOS device
2. **Permission Dialog**: First contact access will trigger the system permission dialog
3. **Settings Integration**: Test changing permissions through iOS Settings → Privacy → Contacts
4. **Background Return**: Test that permissions persist when returning from Settings

### Android Testing

1. **Debug Build**: Install your APK on Android device for testing
2. **Runtime Permissions**: On Android 6.0+, permissions are requested at runtime
3. **Settings Access**: Test changing permissions through Android Settings → Apps → Your App → Permissions
4. **Permission Recovery**: Verify graceful handling when permissions are revoked

## Testing Scenarios

### Essential Test Cases

1. **First Launch**:
   - Verify permission request appears on first contact access
   - Test user granting permission
   - Test user denying permission

2. **Permission States**:
   - Test app behavior when permission is denied
   - Test app behavior when permission is granted
   - Test app behavior when permission is restricted (iOS)

3. **Data Handling**:
   - Test reading contacts with different constraints
   - Test pagination with large contact lists
   - Test loading contact images
   - Test error handling for contacts without required data

4. **Edge Cases**:
   - Test with empty contact list
   - Test with contacts that have no names
   - Test with contacts that have no profile images
   - Test network connectivity issues (if applicable)

### Sample Test Script

```csharp
using VoxelBusters.EssentialKit;
using UnityEngine;

public class AddressBookTester : MonoBehaviour
{
    [Header("Test Configuration")]
    public int testContactLimit = 10;
    public bool testWithConstraints = true;
    
    void Start()
    {
        // Run comprehensive tests
        StartCoroutine(RunTestSuite());
    }
    
    System.Collections.IEnumerator RunTestSuite()
    {
        Debug.Log("=== Starting Address Book Test Suite ===");
        
        // Test 1: Permission Status
        TestPermissionStatus();
        yield return new WaitForSeconds(1);
        
        // Test 2: Basic Contact Reading
        TestBasicContactReading();
        yield return new WaitForSeconds(2);
        
        // Test 3: Constraint Filtering
        if (testWithConstraints)
        {
            TestConstraintFiltering();
            yield return new WaitForSeconds(2);
        }
        
        Debug.Log("=== Address Book Test Suite Complete ===");
    }
    
    void TestPermissionStatus()
    {
        Debug.Log("--- Testing Permission Status ---");
        var status = AddressBook.GetContactsAccessStatus();
        Debug.Log($"Current permission status: {status}");
    }
    
    void TestBasicContactReading()
    {
        Debug.Log("--- Testing Basic Contact Reading ---");
        var options = new ReadContactsOptions.Builder()
            .WithLimit(testContactLimit)
            .Build();
            
        AddressBook.ReadContacts(options, OnTestContactsRead);
    }
    
    void TestConstraintFiltering()
    {
        Debug.Log("--- Testing Constraint Filtering ---");
        var options = new ReadContactsOptions.Builder()
            .WithLimit(testContactLimit)
            .WithConstraints(ReadContactsConstraint.MustIncludeName)
            .Build();
            
        AddressBook.ReadContacts(options, OnConstrainedContactsRead);
    }
    
    void OnTestContactsRead(AddressBookReadContactsResult result, Error error)
    {
        if (error == null)
        {
            Debug.Log($"✓ Basic reading: {result.Contacts.Length} contacts loaded");
            TestContactProperties(result.Contacts);
        }
        else
        {
            Debug.LogError($"✗ Basic reading failed: {error}");
        }
    }
    
    void OnConstrainedContactsRead(AddressBookReadContactsResult result, Error error)
    {
        if (error == null)
        {
            Debug.Log($"✓ Constrained reading: {result.Contacts.Length} contacts with names");
        }
        else
        {
            Debug.LogError($"✗ Constrained reading failed: {error}");
        }
    }
    
    void TestContactProperties(IAddressBookContact[] contacts)
    {
        if (contacts.Length > 0)
        {
            var testContact = contacts[0];
            Debug.Log($"Testing properties for: {testContact.FirstName} {testContact.LastName}");
            
            // Test image loading
            testContact.LoadImage((textureData, error) =>
            {
                if (error == null && textureData != null)
                {
                    Debug.Log("✓ Contact image loaded successfully");
                }
                else
                {
                    Debug.Log("- No image available (this is normal)");
                }
            });
        }
    }
}
```

## Troubleshooting Testing Issues

### Common Issues

1. **Permission Dialog Not Appearing**: 
   - Ensure Essential Kit Settings has proper usage descriptions
   - Reset simulator database permissions to "NotDetermined"

2. **No Contacts Returned**:
   - Check device/simulator has contacts added
   - Verify constraints aren't too restrictive
   - Test without constraints first

3. **Images Not Loading**:
   - Not all contacts have profile images
   - Test with contacts that have photos set
   - Handle null/error cases gracefully

### Best Practices

- Always test on both Unity Editor and actual devices
- Test with various contact list sizes (empty, small, large)
- Verify graceful handling of permission denial
- Test app behavior when switching between permission states
- Ensure UI remains responsive during contact loading operations

