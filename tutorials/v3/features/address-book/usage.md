---
description: Learn Address Book concepts progressively through structured tutorials
---

# Address Book Usage Guide

{% hint style="info" %}
**New Structure!** Address Book documentation has been reorganized into progressive, beginner-friendly concepts. Each topic is now covered in focused, easy-to-follow sections.
{% endhint %}

## Learning Path

The Address Book functionality is now organized into clear concepts that build upon each other:

{% content-ref url="concepts/" %}
[concepts](concepts/)
{% endcontent-ref %}

## Quick Reference

For experienced developers, here's a quick overview of the main APIs:

### Basic Setup
```csharp
using VoxelBusters.EssentialKit;
using VoxelBusters.CoreLibrary;
```

### Check Permissions
```csharp
var status = AddressBook.GetContactsAccessStatus();
```

### Read Contacts
```csharp
var options = new ReadContactsOptions.Builder()
    .WithLimit(10)
    .WithConstraints(ReadContactsConstraint.MustIncludeName)
    .Build();
    
AddressBook.ReadContacts(options, OnContactsRead);
```

## Detailed Learning

For step-by-step guidance, follow the progressive concept structure:

1. **[Contacts Permissions](concepts/contacts-permissions.md)** - Managing user authorization
2. **[Reading Contacts](concepts/reading-contacts.md)** - Basic contact retrieval
3. **[Contact Constraints](concepts/contact-constraints.md)** - Filtering contacts by data fields
4. **[Contact Properties](concepts/contact-properties.md)** - Working with names, emails, phones, images
5. **[Advanced Usage](concepts/advanced-usage.md)** - Pagination, error handling, optimization

Each concept includes:
- Clear explanations written for Unity mobile game developers
- Short, focused code examples (5-10 lines)
- Game-specific use cases and context
- Progressive difficulty from beginner to advanced
```
