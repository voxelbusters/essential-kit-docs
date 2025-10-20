# Best Practices

## Store and Product Setup
- Initialize the store early during game loading screens
- Cache product information locally after successful initialization
- Use meaningful, descriptive product IDs consistent across platforms
- Always check `CanMakePayments()` before displaying purchase options

## Purchase Flow and User Experience
- Handle purchase cancellations gracefully without penalizing users
- Show clear pricing using localized product prices from stores
- Implement proper loading indicators during purchase processes
- Provide restore purchases functionality for non-consumable items
- Cache purchase states locally for immediate UI updates
- Handle network interruptions with appropriate retry logic

## Security and Transaction Management
- Implement receipt verification for all purchase transactions
- Use server-side validation for critical or high-value purchases
- Monitor transaction states and handle all possible outcomes
- Finish transactions promptly after content delivery
- Maintain transaction logs for audit and debugging purposes

## Platform and Production Considerations
- Optimize for Unity iOS and Unity Android platform-specific behaviors
- Test thoroughly in sandbox environments before production release
- Follow platform guidelines for consumable vs non-consumable products
- Monitor purchase failure rates and common error patterns
- Respect user privacy when implementing purchase tracking

📌 **Video Note**: Present as checklist with visual emphasis on critical security and user experience points.