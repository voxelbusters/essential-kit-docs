# Display Contact List

## Goal
Read contacts from the device and display all contact names in a UI list.

## Actions Required
| Action | Purpose |
|--------|---------|
| AddressBookReadContacts | Fetch contacts from device |
| AddressBookGetReadContactsSuccessResult | Get contact count for loop |
| AddressBookGetContactInfo | Extract individual contact details |

## Variables Needed
- contactCount (Int)
- contactIndex (Int) = 0
- firstName (String)
- lastName (String)
- fullName (String)
- phoneNumbers (Array: String) - PlayMaker Array (set element type to String)
- emailAddresses (Array: String) - PlayMaker Array (set element type to String)

## Implementation Steps

### 1. State: ReadAllContacts
**Action:** AddressBookReadContacts
- **Inputs:**
  - limit: 0 (read all)
  - offset: 0
  - mustIncludeName: true
  - mustIncludePhoneNumber: false
  - mustIncludeEmail: false
- **Events:**
  - successEvent → GetCount
  - failureEvent → ShowError

### 2. State: GetCount
**Action:** AddressBookGetReadContactsSuccessResult
- **Outputs:**
  - contactCount → contactCount variable
- **Transition:** Set contactIndex = 0, go to LoopStart

### 3. State: LoopStart
**Logic:** Int Compare
- If contactIndex < contactCount → GetContactDetails
- If contactIndex >= contactCount → Complete

### 4. State: GetContactDetails
**Action:** AddressBookGetContactInfo
- **Inputs:**
  - contactIndex → contactIndex variable
- **Outputs:**
  - firstName → firstName
  - lastName → lastName
  - fullName → fullName
  - phoneNumbers → phoneNumbers array
  - emailAddresses → emailAddresses array
- **Transition:** Go to AddToList

### 5. State: AddToList
Add fullName (or firstName + lastName) to your UI list component.
- Increment contactIndex by 1
- Return to LoopStart

## Loop Pattern
```
contactIndex = 0

While (contactIndex < contactCount):
    GetContactInfo(contactIndex)
    AddToList(fullName)
    contactIndex++
```

## Common Issues

- **Index Out of Range**: Ensure loop condition is `contactIndex < contactCount` (not <=)
- **Empty Names**: Some contacts may have empty firstName/lastName; use fullName as fallback
- **Large Lists**: For >50 contacts, consider pagination (see UseCase3)
- **Array Access**: phoneNumbers and emailAddresses are arrays; check Length before accessing

## Performance Tip
For large contact lists (100+), use pagination instead of loading all contacts at once to prevent UI freezing.
