# AddressBook Use Cases

Quick-start guides showing minimal implementations of common AddressBook tasks using PlayMaker custom actions.

## Available Use Cases

### 1. [Check Permission and Read Contacts](use-case-1-permission-and-read.md)
**What it does:** Verify contact access permission and read all contacts
**Complexity:** Basic
**Actions:** 3 (GetContactsAccessStatus, ReadContacts, GetReadContactsSuccessResult)
**Best for:** First-time setup, permission flow testing

---

### 2. [Display Contact List](use-case-2-display-contact-list.md)
**What it does:** Read contacts and display all names in a UI list
**Complexity:** Basic with iteration
**Actions:** 3 (ReadContacts, GetReadContactsSuccessResult, GetContactInfo in loop)
**Best for:** Simple contact pickers, small contact lists (<50 contacts)

---

### 3. [Paginated Contact Loading](use-case-3-paginated-loading.md)
**What it does:** Load large contact lists efficiently in pages (e.g., 20 at a time)
**Complexity:** Intermediate
**Actions:** 3 (ReadContacts with pagination, GetReadContactsSuccessResult, GetContactInfo in loop)
**Best for:** Large contact lists (50+ contacts), performance-sensitive apps

---

### 4. [Show Contact with Photo](use-case-4-contact-with-photo.md)
**What it does:** Display contact details including profile photo
**Complexity:** Intermediate
**Actions:** 4 (ReadContacts, GetReadContactsSuccessResult, GetContactInfo, LoadContactImage)
**Best for:** Contact detail views, rich contact UI

---

## Choosing the Right Use Case

**Start Here:**
- New to AddressBook? → **Use Case 1**
- Building a simple contact picker? → **Use Case 2**
- Handling many contacts (50+)? → **Use Case 3**
- Need to show contact photos? → **Use Case 4**

## Quick Action Reference

| Action | Purpose | Used In |
|--------|---------|---------|
| AddressBookGetContactsAccessStatus | Check permission | Use Case 1 |
| AddressBookReadContacts | Fetch contacts | All use cases |
| AddressBookGetReadContactsSuccessResult | Get count/metadata | All use cases |
| AddressBookGetReadContactsError | Get error details | Error handling |
| AddressBookGetContactInfo | Extract contact data | Use Cases 2, 3, 4 |
| AddressBookLoadContactImage | Load profile photo | Use Case 4 |

## Related Documentation

- **[README.md](../README.md)** - Actions + quick flow
