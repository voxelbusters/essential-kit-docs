# Address Book (Contacts) - PlayMaker

Read device contacts using Essential Kit’s AddressBook feature via PlayMaker custom actions.

## Actions (6)
- `AddressBookGetContactsAccessStatus` (sync): get current permission status (fires `authorizedEvent`, `deniedEvent`, `notDeterminedEvent`, `limitedEvent`).
- `AddressBookReadContacts` (async): reads contacts using `limit`, `offset`, and `mustInclude*` filters; fires `successEvent`/`failureEvent` and caches the result.
- `AddressBookGetReadContactsSuccessResult` (sync): reads cached `contactCount` and `nextOffset` after a successful read.
- `AddressBookGetReadContactsError` (sync): reads cached `errorCode` and `errorDescription` after a failed read.
- `AddressBookGetContactInfo` (sync): reads one contact by `contactIndex` from the cached result (includes `phoneNumbers` and `emailAddresses` arrays).
- `AddressBookLoadContactImage` (async): loads a contact image by `contactIndex` (fires `successEvent`/`failureEvent`).

## Quick flow
1. (Optional) `AddressBookGetContactsAccessStatus` → route denied/restricted to your “permission help” UI.
2. `AddressBookReadContacts`
   - `successEvent` → `AddressBookGetReadContactsSuccessResult` → loop `contactIndex = 0..contactCount-1` with `AddressBookGetContactInfo`.
   - `failureEvent` → `AddressBookGetReadContactsError`.
3. For phone/email arrays returned by `AddressBookGetContactInfo`, use PlayMaker Array actions (get length, get element, etc.).

## Pagination
Use `limit` + `offset` on `AddressBookReadContacts`. After each page, read `nextOffset` from `AddressBookGetReadContactsSuccessResult`. When `nextOffset == -1`, you’re done.

## Use cases
Start here: `use-cases/README.md`

## Platform notes
- iOS: provide “Contacts Usage Description” in the Essential Kit settings / Info.plist.
- Android: ensure contacts permission is declared and granted before reading contacts.

