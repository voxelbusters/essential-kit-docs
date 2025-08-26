---
description: Step-by-step guide to Address Book concepts in Unity mobile games
---

# Address Book Concepts

## How Address Book Works

The Essential Kit Address Book module provides a unified cross-platform API that abstracts the complexity of iOS and Android contact access. The architecture follows a simple request-response pattern with callback-based operations.

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

Essential Kit's Address Book provides Unity cross-platform development advantages:

- **Unified Permission Model**: Single API handles both iOS privacy permissions and Android runtime permissions
- **Consistent Data Structure**: Contact properties are standardized across platforms
- **Automatic Framework Integration**: No manual native SDK integration required
- **Built-in Error Handling**: Platform-specific errors abstracted into common error types

## Tutorial Progression

This section covers core Address Book concepts in logical progression. Each concept builds on the previous one:

📌 **Video Note**: Use visual overview diagram showing the flow from Unity → Essential Kit → Native platforms.

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