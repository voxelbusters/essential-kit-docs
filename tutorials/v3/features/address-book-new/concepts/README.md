---
description: Step-by-step guide to Address Book concepts in Unity mobile games
---

# Address Book Concepts

## Overview

The Address Book module provides a unified cross-platform API for accessing device contacts in Unity mobile games. The architecture follows a simple request-response pattern with callback-based operations, abstracting iOS and Android contact access complexity.

```
Unity Game Layer
       ↓
Essential Kit Address Book API
       ↓
Platform Abstraction Layer
    ↙         ↘
iOS Contacts    Android Contacts
Framework       Provider
```

## Progressive Learning Path

This section covers core Address Book concepts in a logical progression:

1. **Contacts Permissions** - Managing user authorization for contact access
2. **Reading Contacts** - Basic contact retrieval functionality  
3. **Contact Constraints** - Filtering contacts based on available data
4. **Contact Properties** - Working with names, emails, phone numbers, and images
5. **Advanced Usage** - Pagination, error handling, and optimization

## Cross-Platform Benefits

Essential Kit's Address Book provides Unity cross-platform development advantages:

- **Unified Permission Model**: Single API handles both iOS privacy permissions and Android runtime permissions
- **Consistent Data Structure**: Contact properties are standardized across platforms
- **Automatic Framework Integration**: No manual native SDK integration required
- **Built-in Error Handling**: Platform-specific errors abstracted into common error types

{% content-ref url="contacts-permissions.md" %}
[contacts-permissions.md](contacts-permissions.md)
{% endcontent-ref %}

{% content-ref url="reading-contacts.md" %}
[reading-contacts.md](reading-contacts.md)
{% endcontent-ref %}

{% content-ref url="contact-constraints.md" %}
[contact-constraints.md](contact-constraints.md)
{% endcontent-ref %}

{% content-ref url="contact-properties.md" %}
[contact-properties.md](contact-properties.md)
{% endcontent-ref %}

{% content-ref url="advanced-usage.md" %}
[advanced-usage.md](advanced-usage.md)
{% endcontent-ref %}