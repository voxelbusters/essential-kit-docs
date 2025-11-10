---
description: "Solve common Address Book permission and data issues quickly"
---

# FAQ & Troubleshooting

## Permissions & Setup

### Do I need to add contacts permissions manually in my project settings?
No. Essential Kit injects the required entries into `AndroidManifest.xml` and `Info.plist` during the build. You only need to supply the usage descriptions in Essential Kit Settings so the platform prompts display the correct copy.

On **iOS**, you provide the custom message via the "iOS Usage Description" field in Address Book settings.
On **Android**, the system displays a standard permission dialog that cannot be customized.

### The permission dialog never appears—what's wrong?
Check that Address Book is enabled in Essential Kit Settings under the Services tab. If it's disabled, the feature is excluded from the build and no permission prompt will show.

Also verify you're testing on a real device or iOS Simulator—permissions work differently in the Unity Editor (it uses the simulator).

### Players denied access—how do I let them enable it later?
Handle the error in your `ReadContacts` callback and guide users to settings:

```csharp
void OnContactsLoaded(AddressBookReadContactsResult result, Error error)
{
    if (error != null && error.Code == (int)AddressBookErrorCode.PermissionDenied)
    {
        // Show UI explaining the benefit, then:
        Utilities.OpenApplicationSettings();
        return;
    }
    // Process contacts
}
```

You can also check `AddressBook.GetContactsAccessStatus()` if you need to show status-specific UI before attempting another read.

### How can I test Limited access on iOS?
In iOS 14 or newer, the permission dialog offers "Select Contacts..." instead of full access. Tap that option and choose specific contacts.

After granting limited access, call `AddressBook.GetContactsAccessStatus()`—it returns `Limited`. Your UI should explain that only selected contacts are visible and offer a way to request full access.

## Reading Contacts

### My contact list is empty even though permission is granted—what should I check?
Confirm your `ReadContactsOptions` constraints aren't too restrictive. For example, requiring both `MustIncludeEmail` and `MustIncludePhoneNumber` will exclude any contact missing either field.

Test with `ReadContactsConstraint.None` to verify the plugin returns contacts:
```csharp
var options = new ReadContactsOptions.Builder()
    .WithConstraints(ReadContactsConstraint.None)
    .Build();
```

If this returns contacts but your filtered query doesn't, your constraints are eliminating valid entries.

### Contact images aren't loading—what's the issue?
Contact images load asynchronously via `contact.LoadImage(callback)`. If a contact has no photo, the callback receives your default placeholder image from Essential Kit Settings (under Address Book → Default Image).

Verify you assigned a default image in settings. If that field is empty, missing photos will return null textures.

### Can I read contacts synchronously instead of using callbacks?
No. Reading contacts always requires a callback because it involves permission checks and native API calls that run asynchronously. This design prevents blocking the main thread.

### How do I handle pagination for large contact lists?
Use `AddressBookReadContactsResult.NextOffset` to track your position:
```csharp
void OnContactsLoaded(AddressBookReadContactsResult result, Error error)
{
    if (error == null && result.NextOffset >= 0)
    {
        // More contacts available—call ReadContacts with .WithOffset(result.NextOffset)
    }
}
```

When `NextOffset` is `-1`, you've reached the end of the contact list.

## Testing & Debugging

### Where can I confirm plugin behaviour versus my implementation?
Run `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/AddressBookDemo.unity`. If the sample works but your scene does not, compare:
- Essential Kit Settings configuration
- ReadContactsOptions constraints
- Error handling in your callback

### How do I reset test data in the simulator?
Open Essential Kit Settings (`Window > Voxel Busters > Essential Kit > Open Settings`), go to the Simulator section, and click **Reset Simulator**. This clears simulated contacts and resets permission states.

### Does Address Book work in the Unity Editor?
Yes, via the simulator. The Editor uses fake contact data you can configure in Essential Kit Settings. Always test on real devices before release to verify actual permission flows and contact data handling.
