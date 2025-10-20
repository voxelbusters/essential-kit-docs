# Best Practices

## Setup and Configuration
- **Essential Kit Settings Configuration**: Always configure URL schemes and Universal Link domains through Essential Kit Settings rather than manually editing platform files
- **Domain Verification**: Ensure proper server-side verification files are set up for Universal Links on both iOS and Android
- **Scheme Selection**: Choose unique, branded URL schemes that won't conflict with other Unity mobile games or system apps
- **Development vs Production**: Use separate URL schemes and domains for development and production builds

## Event Handling  
- **Early Subscription**: Subscribe to deep link events during game initialization to avoid missing incoming links
- **Error Handling**: Always validate incoming URLs and handle malformed links gracefully in production builds
- **Thread Safety**: Deep link events are automatically dispatched on the main thread - no additional synchronization needed
- **Event Cleanup**: Unsubscribe from events when objects are destroyed to prevent memory leaks

## Parameter Processing
- **URL Validation**: Validate all extracted parameters before using them in game logic
- **Security Considerations**: Never trust external link parameters for sensitive operations without additional verification  
- **Fallback Behavior**: Provide sensible defaults when expected parameters are missing or invalid
- **Case Sensitivity**: Handle both uppercase and lowercase parameter values consistently

## Cross-Platform Considerations
- **Unity iOS Optimization**: Test Universal Links with proper Associated Domains configuration
- **Unity Android Optimization**: Verify App Links work correctly with Digital Asset Links setup
- **Unity Editor Testing**: Use Essential Kit's simulator features for rapid development iteration
- **Platform-Specific Behavior**: Account for different link handling behaviors between iOS and Android

## Performance and User Experience
- **Quick Navigation**: Process deep links quickly to minimize user wait time when opening specific game content
- **Loading States**: Show appropriate loading indicators when deep links trigger complex game state changes
- **Graceful Degradation**: Provide alternative navigation paths when deep link targets are unavailable
- **Analytics Integration**: Track deep link usage patterns to optimize user acquisition campaigns

## Security and Compliance
- **Input Sanitization**: Sanitize all URL parameters before processing to prevent injection attacks
- **Privacy Protection**: Respect user privacy when handling shared game content through deep links
- **Link Expiration**: Consider implementing time-based link validation for sensitive operations
- **Store Compliance**: Ensure deep link behavior complies with App Store and Google Play policies

📌 **Video Note**: Present as development checklist for Unity mobile game developers

Next: [Summary](07-Summary.md)