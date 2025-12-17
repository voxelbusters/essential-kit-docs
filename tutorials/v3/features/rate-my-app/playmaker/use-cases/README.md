# RateMyApp Use Cases

Quick-start guides for in-app rating prompts and review requests using PlayMaker custom actions.

## Available Use Cases

### 1. [Gate And Ask For Review](use-case-1-gate-and-ask-for-review.md)

- **What it does:** Gate by `RateMyAppIsAllowed` and request the native prompt
- **Actions:** 2 (IsAllowed, AskForReview)

### 2. [Manual Ask For Review](use-case-2-manual-ask-for-review.md)

- **What it does:** User-initiated “Rate Us” button
- **Actions:** 1 (AskForReview)

### 3. [Confirmation Prompt Handler](use-case-3-confirmation-prompt-handler.md)

- **What it does:** React to confirmation dialog choices (Rate Now / Remind Later / Cancel)
- **Actions:** 1 (OnConfirmationPrompt)

## Quick Action Reference
| Action | Purpose |
|--------|---------|
| RateMyAppIsAllowed | Check if the prompt is allowed (cooldowns, limits, etc.) |
| RateMyAppAskForReview | Request the native prompt (optionally via confirmation dialog) |
| RateMyAppOnConfirmationPrompt | Listen for confirmation dialog actions |

## Configuration (Essential Kit Settings)
Navigate to: Window → Essential Kit → Settings → Rate My App

| Setting | Default | Description |
|---------|---------|-------------|
| Min Events Count | 5 | Positive events before prompt |
| Min Days Since Install | 3 | Days to wait after install |
| Min Days Since Last Prompt | 14 | Cooldown between prompts |
| Custom Events | [] | Define trackable event names |

## Platform Behavior
- **iOS**: SKStoreReviewController (limited to 3 prompts/year)
- **Android**: Play In-App Review API (no hard limits)
- **Native dialogs**: Cannot be customized, platform-controlled

## Best Practices
- Ask at a “good moment” (success screen), not after errors or friction.
- Always provide a manual option in Settings/About.
- Expect OS throttling (especially iOS); a request does not guarantee a dialog.

## Related Documentation
- Feature overview: `../README.md`
