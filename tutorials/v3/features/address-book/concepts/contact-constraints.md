---
description: Filtering contacts with constraints in Unity mobile games
---

# Contact Constraints

## What are Contact Constraints?

Contact constraints are filters that specify which contacts to retrieve based on available data fields. Why use them in a Unity mobile game? Constraints help you retrieve only relevant contacts - for example, contacts with email addresses for invitation features, or contacts with names for display purposes.

## Available Constraint Types

Essential Kit provides three main constraint types through the `ReadContactsConstraint` enum:

```csharp
using VoxelBusters.EssentialKit;

void ShowConstraintTypes()
{
    var nameConstraint = ReadContactsConstraint.MustIncludeName;
    var emailConstraint = ReadContactsConstraint.MustIncludeEmail;
    var phoneConstraint = ReadContactsConstraint.MustIncludePhoneNumber;
    
    Debug.Log("Available constraints configured");
}
```

This snippet demonstrates the three constraint types available for filtering contacts. Each constraint ensures contacts have specific data fields populated.

## Single Constraint Filtering

Apply a single constraint to filter contacts:

```csharp
void ReadContactsWithEmails()
{
    var options = new ReadContactsOptions.Builder()
        .WithConstraints(ReadContactsConstraint.MustIncludeEmail)
        .Build();
        
    AddressBook.ReadContacts(options, OnContactsRead);
}
```

This snippet retrieves only contacts that have email addresses. This is useful for features like sending game invitations or creating contact-based friend lists.

## Multiple Constraint Filtering

Combine multiple constraints using bitwise operations:

```csharp
void ReadContactsWithNameAndPhone()
{
    var constraints = ReadContactsConstraint.MustIncludeName | 
                     ReadContactsConstraint.MustIncludePhoneNumber;
                     
    var options = new ReadContactsOptions.Builder()
        .WithConstraints(constraints)
        .Build();
        
    AddressBook.ReadContacts(options, OnContactsRead);
}
```

This snippet retrieves contacts that have both names and phone numbers. Multiple constraints ensure higher data quality for Unity iOS and Android game features requiring complete contact information.

## Key Points

- Use constraints to filter contacts by available data fields
- `MustIncludeName` ensures contacts have first or last name
- `MustIncludeEmail` filters for contacts with email addresses  
- `MustIncludePhoneNumber` requires contacts to have phone numbers
- Combine constraints with bitwise OR (|) for multiple requirements