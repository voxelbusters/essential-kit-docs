# Show Contact with Photo

## Goal
Display contact details including their profile photo by loading contact information and asynchronously fetching the contact's image.

## Actions Required
| Action | Purpose |
|--------|---------|
| AddressBookReadContacts | Fetch contacts from device |
| AddressBookGetReadContactsSuccessResult | Get contact count |
| AddressBookGetContactInfo | Extract contact details |
| AddressBookLoadContactImage | Load contact's profile photo |

## Variables Needed
- contactCount (Int)
- selectedIndex (Int) - Contact to display
- firstName (String)
- lastName (String)
- fullName (String)
- phoneNumbers (Array: String) - PlayMaker Array (set element type to String)
- emailAddresses (Array: String) - PlayMaker Array (set element type to String)
- contactImage (Texture) - Output of AddressBookLoadContactImage
- errorCode (Int)
- errorDescription (String)

## Implementation Steps

### 1. State: ReadContacts
**Action:** AddressBookReadContacts
- **Inputs:**
  - limit: 0 (read all)
  - offset: 0
  - mustIncludeName: true
- **Events:**
  - successEvent → GetCount
  - failureEvent → ShowError

### 2. State: GetCount
**Action:** AddressBookGetReadContactsSuccessResult
- **Outputs:**
  - contactCount → contactCount
- **Transition:** Display contact list, wait for user selection

### 3. State: GetContactDetails
**Action:** AddressBookGetContactInfo
- **Inputs:**
  - contactIndex: selectedIndex (user-selected contact)
- **Outputs:**
  - firstName → firstName
  - lastName → lastName
  - fullName → fullName
  - phoneNumbers → phoneNumbers array
  - emailAddresses → emailAddresses array
- **Transition:** Go to LoadImage

### 4. State: LoadImage
**Action:** AddressBookLoadContactImage
- **Inputs:**
  - contactIndex: selectedIndex (same as GetContactInfo)
- **Outputs:**
  - contactImage → contactImage (Texture2D)
  - errorCode → errorCode
  - errorDescription → errorDescription
- **Events:**
  - successEvent → DisplayContactWithImage
  - failureEvent → DisplayContactWithPlaceholder

**Note:** This is an async operation; wait for the event before proceeding.

### 5. State: DisplayContactWithImage
Display in UI:
- Image component.texture = contactImage
- Text: fullName
- Text: phoneNumbers[0] (if array Length > 0)
- Text: emailAddresses[0] (if array Length > 0)

### 6. State: DisplayContactWithPlaceholder
If image loading failed (no photo available):
- Display default avatar/placeholder image
- Show contact details normally

## Image Loading Flow
```
ReadContacts
    └─ GetCount
        └─ User selects contact (sets selectedIndex)
            └─ GetContactDetails(selectedIndex)
                └─ LoadImage(selectedIndex)
                    ├─ Success → Show photo
                    └─ Failure → Show placeholder
```

## Common Issues

- **No Image Available**: Not all contacts have photos; always handle failureEvent with a placeholder
- **Image Load Delay**: LoadContactImage is async; don't update UI until successEvent fires
- **Wrong Index**: Ensure selectedIndex matches between GetContactInfo and LoadContactImage
- **Texture Memory**: Loaded Texture2D objects use memory; dispose or cache wisely for large lists

## Performance Tips

**Lazy Loading:** Only load images when user views a contact, not for entire contact list upfront.

**Image Caching:** Cache loaded images to avoid re-loading when user revisits same contact.

**Placeholder Strategy:** Show placeholder immediately, load image in background, update UI on success.

**Memory Management:** For contact lists showing multiple photos, consider loading/unloading images as user scrolls.
