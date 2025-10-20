# Best Practices

## Permission Management

- Request contacts permission only when the feature is actually needed by the user
- Check permission status before attempting to read contacts to provide appropriate UI feedback
- Handle all permission states gracefully, including denied and restricted access
- Provide clear explanations to users about why your Unity mobile game needs contact access

## Performance Optimization

- Use pagination with appropriate limits for large contact databases to maintain smooth gameplay
- Cache contact data locally when appropriate to reduce repeated API calls
- Load contact images asynchronously to prevent UI blocking in Unity iOS and Android builds
- Apply constraints to retrieve only contacts with necessary data fields

## Data Handling

- Validate contact data before using it in your game features, as some fields may be empty
- Respect user privacy by only accessing and storing contact information relevant to your game
- Handle multiple email addresses and phone numbers per contact appropriately
- Implement fallback display options for contacts without profile images

## Error Management

- Implement comprehensive error handling using the AddressBookErrorCode enum
- Provide meaningful feedback to users when contact operations fail
- Design graceful degradation when Address Book features are unavailable
- Log errors appropriately for debugging while respecting user privacy

## Cross-Platform Considerations

- Test contact functionality thoroughly on both Unity iOS and Unity Android platforms
- Ensure your Unity cross-platform implementation handles platform-specific behaviors
- Verify that contact data formats are consistent across different devices and OS versions
- Consider platform-specific UI guidelines when displaying contact information

## Privacy and Compliance

- Follow platform-specific privacy guidelines for contact data usage
- Include appropriate privacy policy sections covering contact access
- Ensure compliance with app store requirements for contact-accessing applications
- Implement data retention policies appropriate for your Unity mobile games

📌 **Video Note**: Present as checklist format with visual examples of good and poor implementation practices.