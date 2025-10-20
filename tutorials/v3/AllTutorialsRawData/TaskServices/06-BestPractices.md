# Best Practices

## Task Protection Guidelines
- Only protect genuinely critical operations that must complete
- Use quota expiration callbacks for cleanup and resource management
- Prefer extension methods for cleaner, more readable code
- Keep protected tasks focused and time-bounded when possible

## Resource Management
- Always implement quota expiration callbacks for long-running tasks
- Clean up network connections and file handles before suspension
- Save partial progress to prevent data loss during interruption
- Cancel unnecessary background operations when quota expires

## Platform Optimization
- Test background behavior on both Unity iOS and Unity Android builds
- Consider platform-specific quota limitations in your task design
- Use availability checks in production code for robustness
- Implement fallback strategies for when Task Services are unavailable

## Error Handling
- Wrap Task Services calls in try-catch blocks for production use
- Provide user feedback about operations that may pause and resume
- Implement retry mechanisms for operations interrupted by suspension
- Log quota expiration events for debugging and optimization

## Performance Considerations  
- Avoid protecting trivial or instant operations
- Group related operations to maximize background processing efficiency
- Monitor background processing usage to optimize battery life
- Use cancellation tokens to gracefully abort operations when needed

📌 Video Note: Present as checklist with key reminders for Unity mobile game developers.