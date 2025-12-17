# Paginated Contact Loading

## Goal
Load large contact lists efficiently by fetching contacts in pages (e.g., 20 contacts at a time) to prevent UI freezing.

## Actions Required
| Action | Purpose |
|--------|---------|
| AddressBookReadContacts | Fetch one page of contacts |
| AddressBookGetReadContactsSuccessResult | Get page count and next offset |
| AddressBookGetContactInfo | Extract contact details from current page |

## Variables Needed
- pageSize (Int) = 20
- currentOffset (Int) = 0
- nextOffset (Int)
- contactCount (Int)
- contactIndex (Int) = 0
- fullName (String)
- totalContactsLoaded (Int) = 0

## Implementation Steps

### 1. State: ReadPage
**Action:** AddressBookReadContacts
- **Inputs:**
  - limit: pageSize (20)
  - offset: currentOffset
  - mustIncludeName: true
  - mustIncludePhoneNumber: false
  - mustIncludeEmail: false
- **Events:**
  - successEvent → ExtractPageInfo
  - failureEvent → ShowError

**Note:** First call uses offset: 0; subsequent calls use the nextOffset value from previous page.

### 2. State: ExtractPageInfo
**Action:** AddressBookGetReadContactsSuccessResult
- **Outputs:**
  - contactCount → contactCount (contacts in this page)
  - nextOffset → nextOffset (-1 if no more pages)
- **Transition:** Set contactIndex = 0, go to ProcessPageLoop

### 3. State: ProcessPageLoop
**Logic:** Int Compare
- If contactIndex < contactCount → GetContactFromPage
- If contactIndex >= contactCount → CheckForMorePages

### 4. State: GetContactFromPage
**Action:** AddressBookGetContactInfo
- **Inputs:**
  - contactIndex → contactIndex variable
- **Outputs:**
  - fullName → fullName
- **Transitions:**
  - Add fullName to UI list
  - Increment contactIndex
  - Increment totalContactsLoaded
  - Return to ProcessPageLoop

### 5. State: CheckForMorePages
**Logic:** Int Compare
- If nextOffset > -1:
  - Set currentOffset = nextOffset
  - Go to ReadPage (load next page)
- If nextOffset == -1:
  - All contacts loaded, go to Complete

### 6. State: Complete
Display total: "Loaded [totalContactsLoaded] contacts"

## Pagination Flow
```
Page 1: offset=0, limit=20  → contactCount=20, nextOffset=20
Page 2: offset=20, limit=20 → contactCount=20, nextOffset=40
Page 3: offset=40, limit=20 → contactCount=15, nextOffset=-1 (done)

Total: 55 contacts loaded across 3 pages
```

## Common Issues

- **nextOffset Confusion**: nextOffset = -1 means "no more pages", NOT an error
- **First Page Empty**: If contactCount = 0 on first page, check permission and filters
- **Infinite Loop**: Always check nextOffset > -1 before reading next page
- **UI Updates**: Update UI after each page or batch pages for smoother experience

## Performance Tips

**Optimal Page Sizes:**
- Small devices: 10-15 contacts per page
- Standard devices: 20-30 contacts per page
- Tablets: 50 contacts per page

**When to Use Pagination:**
- Contact lists with 50+ expected contacts
- Slow devices or limited memory
- Real-time search/filter features

**Alternative:** For small lists (<50 contacts), use UseCase2 (load all at once) for simpler implementation.
