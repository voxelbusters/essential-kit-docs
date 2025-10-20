# Rate My App Best Practices

## Timing and User Experience

- **Prompt at positive moments** - Show rating requests after achievements, level completions, or successful interactions
- **Respect platform quotas** - Use confirmation dialogs to avoid wasting limited native prompts (iOS: 3 per year, Android: limited)
- **Avoid interrupting gameplay** - Never show rating prompts during intense gameplay or loading screens
- **Wait for user engagement** - Set appropriate minimum hours and launch counts before first prompt

## Implementation Guidelines

- **Check conditions first** - Always use `IsAllowedToRate()` before showing prompts
- **Handle all response types** - Implement event handlers for Ok, Cancel, and RemindLater actions
- **Use confirmation dialogs strategically** - Enable them to preserve native quota while gauging user sentiment
- **Test thoroughly** - Verify behavior on both Unity iOS and Unity Android builds

## Configuration Recommendations

- **Initial prompt constraints** - Start with 2+ hours and multiple launches to ensure user familiarity
- **Repeat prompt timing** - Space subsequent prompts appropriately (6+ hours, 5+ launches)
- **Version-aware prompting** - Consider re-rating options for major updates
- **Custom messaging** - Personalize confirmation dialog text to match your game's tone

## Unity Cross-Platform Considerations

- **Platform-specific testing** - Test on actual devices since development builds behave differently
- **Store compliance** - Ensure rating requests comply with App Store and Google Play guidelines
- **Analytics integration** - Track rating prompt effectiveness for optimization
- **Graceful fallbacks** - Handle cases where native rating dialogs aren't available

📌 **Video Note**: Present these guidelines as an on-screen checklist with visual examples of good vs. poor timing.