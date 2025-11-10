---
description: "Validate Address Book permissions and data flow before releasing"
---

# Testing & Validation

Use these checks to confirm your Address Book integration before release.

## Editor Simulation
- When you run in the Unity Editor, the Address Book simulator is active automatically.
- Populate simulator contacts in **Essential Kit Settings → Simulator** to test specific edge cases (no email, missing photos, etc.).
- Click **Reset Simulator** to clear granted permissions and fake contacts before re-testing onboarding flows.
- Remember: simulator responses mimic native behaviour but are not a substitute for on-device testing.

## Device Testing Checklist
- Install on both iOS and Android devices to verify system permission prompts display your configured usage descriptions.
- Test `NotDetermined`, `Authorized`, `Denied`, and iOS `Limited` flows. Confirm your UI reflects each result and offers a recovery CTA.
- Validate pagination by scrolling through large address books; monitor memory allocations when `Limit` is high or unset.
- Confirm profile images load correctly, cache as expected, and fall back to the default placeholder when unavailable.
- Exercise invites or referral flows that depend on phone numbers/emails to ensure constraint filters match real-world data sparsity.

## Pre-Submission Review
- Reset app permissions in device settings, relaunch, and verify the first-run experience (rationale screen + native prompt) still feels polished.
- Capture screenshots or screen recordings of the permission flow for compliance documentation or app review notes.
- If testers report mismatched behaviour, reproduce the case using `AddressBookDemo.unity` to determine whether the issue originates from your project or the plugin.
