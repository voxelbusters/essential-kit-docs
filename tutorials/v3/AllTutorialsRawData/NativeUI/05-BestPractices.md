# Native UI - Best Practices

## Alert Dialogs

- Use clear, descriptive titles that immediately convey the purpose
- Keep messages concise but informative about the consequences of actions
- Always provide a cancel option for destructive actions
- Limit input fields to essential information only
- Use appropriate keyboard input types for better user experience
- Test button text lengths on different device sizes and orientations

## Date Pickers

- Set reasonable minimum and maximum date constraints
- Use appropriate picker modes (Date, Time, or DateAndTime) based on user needs
- Handle timezone conversions properly for global applications
- Provide clear initial date values that make sense in context
- Consider local date format preferences and cultural differences

## Performance and Memory

- Create native UI components only when needed, not during initialization
- Allow components to dispose properly by not holding references after use
- Avoid creating multiple dialogs simultaneously
- Handle component lifecycle properly to prevent memory leaks

## User Experience

- Show native UI components in response to user actions, not automatically
- Provide visual feedback when processing user selections
- Ensure dialog content is accessible and readable across different screen sizes
- Follow platform-specific design guidelines for consistency
- Test thoroughly on both iOS and Android devices

## Error Handling and Availability

- Check component availability before use in production builds
- Implement fallback UI for scenarios where native components aren't available
- Handle user cancellation gracefully without showing error messages
- Provide meaningful feedback when operations fail

## Platform Optimization

- Optimize for Unity iOS and Unity Android build differences
- Respect platform-specific user interface conventions
- Test native UI appearance across different device sizes and OS versions
- Consider platform-specific limitations and capabilities

## Development Workflow

- Use Unity Editor simulation for rapid prototyping and testing
- Validate native UI flows on actual devices before release
- Keep native UI code simple and focused on user interaction
- Document complex dialog flows for team collaboration

📌 Video Note: Present as checklist with visual examples of good vs poor native UI implementations.