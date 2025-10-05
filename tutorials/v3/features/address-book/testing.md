# Testing & Validation

Use these checks to confirm your Address Book integration before release.

## Editor Simulation
- When you run in the Unity Editor, the Address Book simulator is active automatically.
- To clear test data, click **Reset Simulator** in the same settings pane.
- Remember: simulator responses mimic native behaviour but are not a substitute for on-device testing.

## Device Testing Checklist
- Install on both iOS and Android devices to verify system permission prompts display your configured usage descriptions.
- Test decline, accept, and Limited (iOS 14+) flows, ensuring your UI reflects each result.
- Validate pagination by scrolling through large contact lists; watch for performance issues when `Limit` is high or unset.
- Confirm profile images load correctly and fall back to the default placeholder when unavailable.

## Pre-Submission Review
- Reset app permissions in device settings and reinstall to confirm the first-run experience remains polished.
- Capture screenshots or screen recordings of the permission flow for compliance documentation.
- If testers report mismatched behaviour, reproduce the case using the demo scene to determine whether the issue originates from your project or the plugin.
