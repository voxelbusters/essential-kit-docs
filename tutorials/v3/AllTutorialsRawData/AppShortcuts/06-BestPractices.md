# Best Practices

Follow these guidelines to implement App Shortcuts effectively in your Unity mobile games:

## Shortcut Design and Content

- **Limit shortcut count**: Keep shortcuts to 3-4 maximum to avoid overwhelming players and maintain visual clarity
- **Use clear, action-oriented titles**: Choose concise titles like "Claim Reward" rather than vague terms like "Rewards"
- **Provide meaningful subtitles**: Add context that motivates action, such as "Your daily bonus awaits!"
- **Design consistent icons**: Use recognizable icons that match your game's visual style and branding
- **Keep shortcuts current**: Remove outdated shortcuts immediately when content becomes unavailable

## Dynamic Management Strategy

- **Update shortcuts contextually**: Add shortcuts for available actions, remove them when actions are completed
- **Respond to game state changes**: Refresh shortcuts when player progress, events, or available content changes
- **Clean up on app exit**: Remove temporary or session-specific shortcuts when appropriate
- **Handle shortcut conflicts**: Ensure shortcut identifiers are unique and manage overlapping functionality gracefully

## User Experience Optimization

- **Prioritize high-value actions**: Feature shortcuts for frequently used or monetization-relevant features
- **Test shortcut navigation flow**: Verify shortcuts lead directly to expected content without additional steps
- **Handle unavailable content gracefully**: If shortcut content becomes unavailable, redirect to appropriate alternative screens
- **Respect platform conventions**: Follow iOS Quick Actions and Android App Shortcuts design guidelines

## Technical Implementation

- **Subscribe to events properly**: Always unsubscribe from OnShortcutClicked events in OnDisable to prevent memory leaks
- **Check availability when needed**: Use IsAvailable() for platform-specific implementations or when reliability is critical
- **Handle errors gracefully**: Implement fallback behaviors for shortcut failures or unsupported devices
- **Optimize for Unity iOS and Unity Android builds**: Test shortcut behavior thoroughly on both platforms

## Performance and Resource Management

- **Cache shortcut objects**: Reuse AppShortcutItem objects when possible to reduce garbage collection
- **Batch shortcut operations**: Group multiple Add/Remove operations together when updating shortcuts
- **Monitor shortcut icon resources**: Ensure referenced icon files are properly included in builds and optimized for size
- **Profile shortcut impact**: Monitor performance impact of frequent shortcut updates on game startup time

📌 **Video Note**: Present as checklist format with visual examples of good vs. poor shortcut implementations on actual device home screens.