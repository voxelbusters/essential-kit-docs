# Check Permission and Read Contacts

## Goal
Verify that your app has permission to access device contacts and read all contacts from the address book.

## Actions Required
| Action | Purpose |
|--------|---------|
| AddressBookGetContactsAccessStatus | Check current permission status |
| AddressBookReadContacts | Fetch contacts from device |
| AddressBookGetReadContactsSuccessResult | Get contact count and metadata |
| AddressBookGetReadContactsError | Get error details when read fails |

## Variables Needed
- accessStatus (Enum: AddressBookContactsAccessStatus)
- contactCount (Int)
- nextOffset (Int)
- errorCode (Int)
- errorDescription (String)

## Implementation Steps

### 1. State: CheckPermission
**Action:** AddressBookGetContactsAccessStatus
- **Outputs:**
  - accessStatus → accessStatus variable
- **Events:**
  - authorizedEvent → ReadContacts
  - notDeterminedEvent → ReadContacts (will auto-prompt)
  - deniedEvent → ShowError
  - limitedEvent → ReadContacts (iOS 14+ partial access)

### 2. State: ReadContacts
**Action:** AddressBookReadContacts
- **Inputs:**
  - limit: 10 (read 10 contacts - Pass -1 to read all contacts)
  - offset: 0 (start from beginning)
  - mustIncludeName: true
  - mustIncludePhoneNumber: false
  - mustIncludeEmail: false
- **Events:**
  - successEvent → ExtractResult
  - failureEvent → ExtractError

**Note:** This action waits for the callback internally and caches results in AddressBookUtils.

### 3. State: ExtractResult
**Action:** AddressBookGetReadContactsSuccessResult
- **Outputs:**
  - contactCount → contactCount variable
  - nextOffset → nextOffset variable
- **Transition:** Go to DisplayCount

### 4. State: ExtractError
**Action:** AddressBookGetReadContactsError
- **Outputs:**
  - errorCode → errorCode variable (Int)
  - errorDescription → errorDescription variable (String)
- **Transition:** Go to ShowError

### 5. State: DisplayCount
Display the contactCount value in your UI (e.g., "Found 150 contacts").

## Common Issues

- **Permission Denied**: If accessStatus is Denied, guide users to device Settings to enable contacts permission
- **No Contacts**: contactCount may be 0 if device has no contacts or filters are too restrictive
- **nextOffset = -1**: Indicates all contacts were loaded (no more pages available)

## Flow Diagram
```
CheckPermission
    ├─ Authorized → ReadContacts
    ├─ NotDetermined → ReadContacts (prompts user)
    └─ Denied → ShowError

ReadContacts (waits for callback)
    ├─ Success → ExtractResult
    └─ Failure → ExtractError

ExtractResult
    └─ DisplayCount

ExtractError
    └─ ShowError
```
