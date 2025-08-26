# Address Book FAQ

## Setup and Permissions

### Do we need to manually add the required permissions?

No. Essential Kit automatically handles all required permissions:
- **iOS**: Adds NSContactsUsageDescription to Info.plist
- **Android**: Adds READ_CONTACTS permission to AndroidManifest.xml

You only need to provide the usage description text in Essential Kit Settings for privacy compliance.

### What should I put in the usage description?

Write a clear explanation of why your game needs contact access:
- Good: "Find friends who are already playing the game"
- Good: "Invite contacts to join multiplayer matches"
- Bad: "This app needs access to contacts"

### If user denies contacts access permission, how do I proceed?

1. **Explain the benefit** before requesting permission
2. **Handle denial gracefully** - provide alternative features
3. **Guide to settings** if needed: Use `Utilities.OpenApplicationSettings()` to help users change permissions manually

```csharp
if (status == AddressBookContactsAccessStatus.Denied)
{
    // Show explanation and option to open settings
    Debug.Log("Contact access denied. Opening settings...");
    Utilities.OpenApplicationSettings();
}
```

## Reading Contacts

### Why am I getting zero contacts returned?

Common causes:
1. **No permission granted** - Check `GetContactsAccessStatus()` first
2. **Device has no contacts** - Test with contacts added to device
3. **Constraints too restrictive** - Try reading without constraints first
4. **Limit set too low** - Increase the limit or remove it

### How do I handle large contact lists efficiently?

Use pagination to load contacts in smaller batches:

```csharp
var options = new ReadContactsOptions.Builder()
    .WithLimit(50)  // Load 50 at a time
    .WithOffset(currentOffset)
    .Build();
```

### Can I search for specific contacts by name?

Essential Kit doesn't provide search functionality. Read contacts and filter them in your code:

```csharp
var matchingContacts = contacts.Where(c => 
    c.FirstName?.Contains("John") == true || 
    c.LastName?.Contains("John") == true
).ToArray();
```

### Why are some contacts missing names or emails?

Not all contacts have complete information. Always check for null/empty values:

```csharp
if (!string.IsNullOrEmpty(contact.FirstName) || !string.IsNullOrEmpty(contact.LastName))
{
    // Contact has at least one name
}

if (contact.EmailAddresses?.Length > 0)
{
    // Contact has email addresses
}
```

## Contact Properties

### How do I display contact names properly?

Handle various name scenarios:

```csharp
string GetDisplayName(IAddressBookContact contact)
{
    if (!string.IsNullOrEmpty(contact.FirstName) && !string.IsNullOrEmpty(contact.LastName))
        return $"{contact.FirstName} {contact.LastName}";
    else if (!string.IsNullOrEmpty(contact.FirstName))
        return contact.FirstName;
    else if (!string.IsNullOrEmpty(contact.LastName))
        return contact.LastName;
    else if (!string.IsNullOrEmpty(contact.CompanyName))
        return contact.CompanyName;
    else
        return "Unknown Contact";
}
```

### Why aren't contact images loading?

Contact images are optional and may not exist:
1. **Not all contacts have profile photos**
2. **Loading is asynchronous** - use the callback properly
3. **Permission issues** - ensure contacts permission is granted

```csharp
contact.LoadImage((textureData, error) =>
{
    if (error == null && textureData != null)
    {
        // Successfully loaded - use textureData.Texture
    }
    else
    {
        // No image or loading failed - use default image
    }
});
```

### Can I get contact photos from social media?

No. Essential Kit only accesses device contact data. It doesn't integrate with social media platforms for additional photos.

## Platform Differences

### Are there differences between iOS and Android?

The API is unified, but there are some platform behaviors:

**iOS**:
- Permission dialog appears first time you call `ReadContacts()`
- Users can grant "Limited" access in iOS 14+
- Contact data includes more detailed information

**Android**:
- Runtime permission request on Android 6.0+
- May require multiple permission grants on some devices
- Contact data varies by device manufacturer

### Does this work on Unity Editor?

Yes! Essential Kit provides editor simulation:
1. Go to Window → Voxel Busters → Essential Kit → Simulator Database
2. Configure permission status and add test contacts
3. Test your implementation without deploying to device

## Performance and Optimization

### How do I optimize contact loading for better performance?

1. **Use appropriate limits**: Don't load all contacts at once
2. **Apply constraints**: Filter by required data fields
3. **Load images selectively**: Only load images when needed
4. **Cache results**: Store contacts locally to avoid repeated API calls

```csharp
// Optimized approach
var options = new ReadContactsOptions.Builder()
    .WithLimit(25)  // Reasonable batch size
    .WithConstraints(ReadContactsConstraint.MustIncludeName)  // Only contacts with names
    .Build();
```

### Should I cache contact data?

**Considerations**:
- **Pro**: Faster subsequent access
- **Con**: Contact data can become outdated
- **Pro**: Reduces permission requests
- **Con**: Privacy concerns with storing personal data

**Recommendation**: Cache only essential data (names, IDs) and refresh periodically.

## Troubleshooting

### ReadContacts callback never gets called

**Check these issues**:
1. **Permission denied silently** - Verify permission status first
2. **Device has no contacts** - Test with contacts added
3. **Threading issues** - Ensure callback is handled properly

### Getting "Unknown error" from Address Book

**Common solutions**:
1. **Restart app** after changing permissions
2. **Check device storage** - Low storage can cause issues
3. **Test on different device** - Some devices have contact access restrictions
4. **Verify Essential Kit setup** - Ensure feature is enabled in settings

### Address Book works in editor but not on device

**Verification steps**:
1. **Check build settings** - Ensure target platform is set correctly  
2. **Verify permissions** - Usage descriptions must be set in Essential Kit Settings
3. **Test permission flow** - Ensure user grants permission on device
4. **Check device contacts** - Ensure target device has contacts to read

## Best Practices

### When should I request contact access?

**Good timing**:
- When user taps "Invite Friends" button
- During social feature onboarding
- When setting up multiplayer matching

**Bad timing**:
- Immediately on app launch
- Before explaining the benefit
- Without user action triggering it

### How do I make contact access feel natural?

1. **Explain the benefit clearly** before requesting
2. **Provide alternative options** if access is denied
3. **Show progress** while loading contacts
4. **Handle errors gracefully** with helpful messages
5. **Respect user privacy** - only access what you need
