---
description: "<Primary keyword-rich summary for the feature tutorial>"
---

<!--
TUTORIAL FILE STRUCTURE
=======================
Essential Kit feature tutorials consist of 4 files:

1. README.md    - Overview, roadmap, key use cases, navigation links
2. setup.md     - Prerequisites, settings configuration, platform requirements
3. usage.md     - Progressive learning: concepts merged with implementation
4. testing.md   - Editor simulation + device testing checklist
5. faq.md       - Common issues with actionable solutions

CORE PRINCIPLE: Progressive learning with immediate code examples.
Explain concepts right before showing how to use them. No separate architecture docs.
-->

# README.md Template

---
description: "<One-sentence feature summary optimized for search>"
---

Note: Don't use — kind of characters as it sounds like AI generated.

# <Feature Name> for Unity

Essential Kit's <Feature Name> feature lets Unity teams <primary benefit> without maintaining platform-specific code. This tutorial walks you through setup, key APIs, testing, and troubleshooting so you can add <player-facing outcome> with confidence.

{% hint style="info" %}
Looking for a working reference? Open the demo scene at `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/<Feature>Demo.unity` and the companion script at `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scripts/<Feature>Demo.cs` to see the full API in action.
{% endhint %}

## What You'll Learn
- <Concrete skill 1: "Check permissions and request access gracefully">
- <Concrete skill 2: "Read and filter data with Essential Kit APIs">
- <Concrete skill 3: "Handle edge cases and common error scenarios">

## Why <Feature Name> Matters
- <Business impact: "Power invite-a-friend loops and referral campaigns">
- <UX impact: "Personalise onboarding flows with real user data">
- <Technical impact: "Build social features without custom native code">

## Tutorial Roadmap
1. [Setup](setup.md) – Enable the feature and configure required assets.
2. [Usage](usage.md) – Permissions, core APIs, filtering, and error handling.
3. [Testing](testing.md) – Simulate in editor and verify on devices.
4. [FAQ](faq.md) – Troubleshoot common issues.

## Key Use Cases
- <Use case 1 with measurable outcome: "Send in-game friend invites via verified device contacts">
- <Use case 2 with player benefit: "Surface customer-support shortcuts in onboarding screens">
- <Use case 3 with business angle: "Sync contacts into CRM for retention campaigns">

## Prerequisites
- Unity project with Essential Kit v3 installed and <Feature> feature included in the build.
- <Platform requirements: "iOS or Android targets with required permission descriptions configured">
- Test device or Essential Kit simulator to validate permission prompts before release.

{% content-ref url="setup.md" %}
[Setup](setup.md)
{% endcontent-ref %}

{% content-ref url="usage.md" %}
[Usage](usage.md)
{% endcontent-ref %}

{% content-ref url="testing.md" %}
[Testing](testing.md)
{% endcontent-ref %}

{% content-ref url="faq.md" %}
[FAQ](faq.md)
{% endcontent-ref %}

---

# setup.md Template

---
description: "Configuring <Feature Name>"
---

# Setup

## Prerequisites
- Essential Kit imported into the project from My Assets section of Package Manager.
- <Platform-specific requirement: "iOS builds require a `NSContactsUsageDescription` entry">
- <Platform limitation: "Android uses system-provided permission dialog copy">

## Setup Checklist
1. Open **Essential Kit Settings** (`Window > Voxel Busters > Essential Kit > Open Settings`), switch to the **Services** tab, and enable **<Feature Name>**.
2. Assign required assets: <Example: "Default Image placeholder for contacts without profile photos">
3. Provide platform-specific descriptions: <Example: "iOS usage description for App Store reviewers">
4. Changes to the settings asset are saved automatically. If you use source control, commit the updated `Resources/EssentialKitSettings.asset` file.

### Configuration Reference
| Setting | Platform | Required? | Notes |
| --- | --- | --- | --- |
| Enable <Feature> | All | Yes | Toggles the feature in builds; disabling strips related native code. |
| <Setting 1> | <iOS/Android/All> | <Yes/Optional> | <When and why to change it> |
| <iOS Usage Description> | iOS | Yes | Appears in permission alert; must clearly state benefit. |
| <Android Permission> | Android | N/A | Android displays system-managed text; customise messaging in your own UI. |

{% hint style="info" %}
Need a working baseline? Run the sample at `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/<Feature>Demo.unity` to confirm your settings before wiring the feature into production screens.
{% endhint %}

---

# usage.md Template

---
description: "<Feature> allows <what it does> on mobile devices."
---

# Usage

Essential Kit wraps native iOS and Android <system> APIs into a single Unity interface. <Brief architecture note if needed: "The first X call automatically triggers the system permission dialog.">

## Table of Contents
<For longer usage documents, add a table of contents for easy navigation>

- [Understanding Core Concepts](#understanding-core-concepts)
- [Import Namespaces](#import-namespaces)
- [Event Registration](#event-registration) (if applicable)
- [Core Operation](#core-operation)
- [Advanced Features](#advanced-features)
- [Core APIs Reference](#core-apis-reference)
- [Error Handling](#error-handling)
- [Related Guides](#related-guides)

## Understanding Core Concepts
<For features with domain-specific terminology or concepts>

Before diving into implementation, explain key concepts specific to this feature:

### Concept 1
Brief explanation of what this concept means and why it matters.

**Examples:**
- Real-world example 1
- Real-world example 2

**Key characteristics:**
- Important detail 1
- Important detail 2
- Important detail 3

<Repeat for each major concept>

{% hint style="info" %}
Cross-reference to related concepts or setup documentation where helpful.
{% endhint %}

## Import Namespaces
```csharp
using System;
using System.Collections;
using System.Collections.Generic;
using VoxelBusters.EssentialKit;
using VoxelBusters.CoreLibrary;
```

<Include System namespaces if the feature uses common C# types like Guid, DateTime, Dictionary, etc.>

## Event Registration
<For features that use event-driven callbacks>

Register for events in `OnEnable` and unregister in `OnDisable`:

```csharp
void OnEnable()
{
    Feature.OnOperationComplete += OnOperationComplete;
    Feature.OnStateChange += OnStateChange;
}

void OnDisable()
{
    Feature.OnOperationComplete -= OnOperationComplete;
    Feature.OnStateChange -= OnStateChange;
}
```

| Event | Trigger |
| --- | --- |
| `OnOperationComplete` | After operation finishes |
| `OnStateChange` | When state changes |

<Explain event lifecycle and when they fire>

## How <Permissions/Core Concept> Works
<For permission-based features: Emphasize that the primary API call handles everything>

Just call `Feature.DoOperation()` directly—no permission checks needed. On the first call, Essential Kit automatically shows the system permission dialog. If permission is already granted, it executes immediately. If denied, the error callback tells you why.

{% hint style="success" %}
<UX best practice: "Show a custom explanation screen before calling X to improve opt-in rates.">
{% endhint %}

Handle permission issues in the error callback:
```csharp
void OnComplete(FeatureResult result, Error error)
{
    if (error != null)
    {
        if (error.Code == (int)FeatureErrorCode.PermissionDenied)
        {
            // Guide user to settings
            Utilities.OpenApplicationSettings();
        }
        return;
    }
    // Process result
}
```

### Optional: Check Permission Status
Use `GetStatus()` only when you need to inspect the exact state **before** calling the main operation or to customize UI messaging.

```csharp
var status = Feature.GetStatus();
// PossibleValue1 | PossibleValue2 | PossibleValue3
```

## <Core Operation>

### Why <Operation> is Needed
<1-2 paragraphs explaining the purpose and benefits of this operation>

This ensures:
- Benefit 1
- Benefit 2
- Benefit 3

### Implementation

### Basic Usage
```csharp
void DoOperation()
{
    var options = new FeatureOptions.Builder()
        .WithParameter(value)
        .Build();

    Feature.DoOperation(options, OnComplete);
}

void OnComplete(FeatureResult result, Error error)
{
    if (error != null)
    {
        Debug.LogError($"Feature operation failed: {error}");
        return;
    }

    foreach (var item in result.Items)
    {
        // Process items
    }
}
```

### <Advanced Operation Pattern>
<If feature supports pagination, filtering, batching, etc.>

Use `NextToken` to continue:
```csharp
int nextToken = 0;

void LoadMore()
{
    if (nextToken < 0) return; // All loaded

    var options = new FeatureOptions.Builder()
        .WithLimit(20)
        .WithToken(nextToken)
        .Build();

    Feature.DoOperation(options, OnComplete);
}

void OnComplete(FeatureResult result, Error error)
{
    if (error == null)
    {
        nextToken = result.NextToken; // -1 when done
    }
}
```

### Filtering/Customization
Combine options to match your use case:
```csharp
// Example 1: Filter by type
var options = new FeatureOptions.Builder()
    .WithConstraints(FeatureConstraint.MustIncludeX)
    .Build();

// Example 2: Combine multiple filters
var options = new FeatureOptions.Builder()
    .WithConstraints(FeatureConstraint.TypeA | FeatureConstraint.TypeB)
    .Build();
```

## Data Properties
| Property | Type | Notes |
| --- | --- | --- |
| `Property1`, `Property2` | `string` | May be empty |
| `ArrayProperty` | `ItemType[]` | Check `.Length` before access |
| `LoadAsset(callback)` | Method | Async; returns default if unavailable |

### <Subsection for Related Operation>
<If feature has async operations like loading images>

```csharp
item.LoadAsset((assetData, error) =>
{
    if (error == null)
    {
        Texture2D asset = assetData.Texture;
        // Use asset
    }
    // Automatically falls back to default from settings
});
```

## Core APIs Reference
| API | Purpose | Returns |
| --- | --- | --- |
| `Feature.DoOperation(options, callback)` | Request permission & execute operation | Result via callback with data or error |
| `FeatureOptions.Builder()` | Configure operation | Chain `.WithX()` methods → `Build()` |
| `Feature.GetStatus()` | **Optional:** Check current permission/state | `FeatureStatus` enum |

**Note:** For permission-based features, list the main operation first. `GetStatus()` is optional and should be marked as such.

## Error Handling
| Error Code | Trigger | Recommended Action |
| --- | --- | --- |
| `PermissionDenied` | User declined access | Show rationale + link to `Utilities.OpenApplicationSettings()` |
| `InvalidParameter` | Missing required option | Validate options before calling |
| `Unknown` | Platform error | Retry or log for support |

## Advanced: <Advanced Feature>

{% hint style="danger" %}
<Warning about when NOT to use this advanced feature>
{% endhint %}

### Understanding <Advanced Concept>
<Explain what this advanced feature does and the problem it solves>

**Default Behavior:**
<Explain what happens normally>

**Advanced Usage:**
<Explain when and why to use manual/custom approach>
- Use case 1
- Use case 2
- Use case 3

### Implementation

<Only include if feature supports Initialize(settings)>

Override default settings at runtime:
```csharp
void Awake()
{
    var settings = new FeatureSettings
    {
        DefaultAsset = myCustomAsset
    };
    Feature.Initialize(settings);
}
```

{% hint style="warning" %}
Advanced configuration is for specific scenarios only. For most games, use [standard setup](setup/).
{% endhint %}

## Related Guides
- Demo scene: `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/<Feature>Demo.unity`
- Pair with **<Related Feature>** to <combined use case>
- Use with **Utilities.OpenApplicationSettings** for permission recovery flows

---

# testing.md Template

# Testing & Validation

Use these checks to confirm your <Feature> integration before release.

## Editor Simulation
- When you run in the Unity Editor, the <Feature> simulator is active automatically.
- To clear test data, click **Reset Simulator** in the same settings pane.
- Remember: simulator responses mimic native behaviour but are not a substitute for on-device testing.

## Device Testing Checklist
- Install on both iOS and Android devices to verify system permission prompts display your configured usage descriptions.
- Test <edge case 1>, <edge case 2>, ensuring your UI reflects each result.
- Validate <operation> by <action>; watch for performance issues when <condition>.
- Confirm <async operations> load correctly and fall back to defaults when unavailable.

## Pre-Submission Review
- Reset app permissions in device settings and reinstall to confirm the first-run experience remains polished.
- Capture screenshots or screen recordings of the <critical flow> for compliance documentation.
- If testers report mismatched behaviour, reproduce the case using the demo scene to determine whether the issue originates from your project or the plugin.

---

# faq.md Template

# FAQ & Troubleshooting

### Do I need to add <permissions> manually in my project settings?
No. Essential Kit injects the required entries into `AndroidManifest.xml` and `info.plist` during the build. You only need to supply the usage descriptions in Essential Kit Settings so the platform prompts display the correct copy.

### <Users took action>—how do I let them <recover>?
Use `Utilities.OpenApplicationSettings()` to deep link into the platform settings screen. Pair it with in-app messaging that explains why <feature> access powers your feature.

### How can I test <edge case> on <platform>?
<Platform-specific testing guidance with steps>

### My <result> is empty even though <condition>—what should I check?
Confirm your `FeatureOptions` constraints do not filter out every item. For example, requiring both <constraint A> and <constraint B> can result in zero matches. Test with `FeatureConstraint.None` in `<Feature>Demo.cs` to verify the plugin returns items as expected.

### Where can I confirm plugin behaviour versus my implementation?
Run `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/<Feature>Demo.unity`. If the sample works but your scene does not, compare the configuration, constraints, and error handling paths to narrow down the difference.

---

# WRITING GUIDELINES

## Permission-Based Features
✅ **DO:**
- Teach developers to call the main operation directly (e.g., `ReadContacts()`)
- Handle permission denial in the error callback
- Mark `GetStatus()` as **Optional** in documentation
- Emphasize: "The first call automatically requests permission"

❌ **DON'T:**
- Make developers check `GetStatus()` before every operation
- Suggest checking status first as the primary workflow
- Imply that permission checks are required before calling the main API

**Why:** Essential Kit's main operations handle permission requests automatically. Checking status first adds unnecessary complexity and code. Use `GetStatus()` only for custom UI messaging or edge cases.

## Code Examples
✅ **DO:**
- Show complete, runnable examples
- Use minimal inline comments ("// Process items")
- Include error handling in every callback
- Demonstrate real implementation patterns

❌ **DON'T:**
- Add TODO comments in production examples
- Over-explain obvious code
- Use placeholder method names like `DoSomething()`
- Show incomplete "skeleton" code

## Structure Rules
✅ **DO:**
- Introduce concepts 1-2 sentences before showing code
- Use tables for APIs, properties, error codes
- Group related operations under subsections
- Keep advanced section minimal (1-2 examples max)

❌ **DON'T:**
- Write separate architecture documents
- Use bullet lists for scannable reference data
- Explain "what you can do" without showing how
- List every possible scenario in advanced section

## Language Style
✅ **DO:**
- "Check status before reading" (direct)
- "Returns -1 when done" (concrete)
- `settings.Timeout = 30` (specific values)

❌ **DON'T:**
- "You can check the status if you want" (wishy-washy)
- "Basically you should probably..." (filler words)
- "Customize settings as needed" (vague)

## Hint Usage
- **info**: Point to demo scenes, additional resources
- **success**: UX best practices (soft prompts, loading states)
- **warning**: Gotchas, common mistakes, platform limitations
- **danger**: Data loss risks, breaking changes

## Strategic Hint Placement

Use hints to guide users at decision points and link related documentation:

**Configuration Warnings:**
- After initialization code: Link to FAQ for common setup issues
- Before advanced sections: Warn users and link to standard setup approach

**Cross-Reference Hints:**
- Before major sections: Link to prerequisite setup steps
- After feature-specific code: Link to testing guides
- Near error handling: Link to FAQ troubleshooting

**Best Practice Hints:**
- After state transitions: Remind about data persistence
- Before permission checks: Explain restrictions and user experience
- At document end: Link to next logical step (testing)

**Example Pattern:**
```markdown
{% hint style="warning" %}
<Feature> initialization can fail if <condition>. See [FAQ](faq.md#anchor) for common issues.
{% endhint %}

{% hint style="info" %}
Before implementing <feature>, ensure you've completed the [platform setup](setup/ios.md).
{% endhint %}

{% hint style="success" %}
Ready to test? Head to the [Testing Guide](testing/) to validate your implementation.
{% endhint %}
```

---

# CHECKLIST FOR NEW FEATURE TUTORIALS

Before publishing, verify:
- [ ] README.md lists 3 concrete outcomes in "What You'll Learn"
- [ ] setup.md includes Configuration Reference table
- [ ] usage.md merges concepts progressively (no separate concepts.md)
- [ ] usage.md includes "Understanding Core Concepts" section if feature has domain-specific terminology
- [ ] usage.md includes Table of Contents for documents >300 lines
- [ ] usage.md includes Core APIs Reference table
- [ ] usage.md includes Data Properties table
- [ ] usage.md includes Error Handling table
- [ ] All code examples are complete and runnable
- [ ] Zero TODO comments in examples
- [ ] Platform-specific code examples avoid unnecessary #if macros
- [ ] System namespaces included in imports when needed (Guid, DateTime, etc.)
- [ ] "Why This is Needed" explanations for non-obvious operations
- [ ] Advanced section shows concrete code (if applicable)
- [ ] Strategic hints placed at decision points with cross-references
- [ ] All hints link to relevant sections (setup, testing, FAQ)
- [ ] testing.md covers both editor simulation and device testing
- [ ] faq.md uses question-style headings
- [ ] All navigation blocks (content-ref) are present in README.md
