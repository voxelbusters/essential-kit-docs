# Address Book Tutorial - Overview

## High-Level Architecture

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

## Concepts Covered in This Tutorial

This tutorial covers five core concepts, each explained in dedicated sections:

1. **Contacts Permissions** - Managing user authorization for contact access
2. **Reading Contacts** - Basic contact retrieval functionality  
3. **Contact Constraints** - Filtering contacts based on available data
4. **Contact Properties** - Working with names, emails, phone numbers, and images
5. **Advanced Usage** - Pagination, custom initialization, and error handling

## Cross-Platform Considerations

Essential Kit's Address Book API provides Unity cross-platform development for iOS and Android with:

- **Unified Permission Model**: Single API handles both iOS privacy permissions and Android runtime permissions
- **Consistent Data Structure**: Contact properties are standardized across platforms
- **Automatic Framework Integration**: No manual native SDK integration required
- **Built-in Error Handling**: Platform-specific errors are abstracted into common error types

The Unity mobile games SDK integration ensures your contact features work identically on both platforms with minimal platform-specific code.

📌 **Video Note**: Use visual overview diagram showing the flow from Unity → Essential Kit → Native platforms.