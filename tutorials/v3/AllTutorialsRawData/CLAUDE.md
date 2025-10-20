
# Essential Kit Tutorial Creation Guidelines (v8)

This document provides comprehensive guidelines for creating high-quality, structured tutorial series for Essential Kit features.  
The tutorials will serve both as **written documentation** and as **scripts for video tutorials**, so they must be **simple, progressive, and easy for Unity mobile game developers** to follow.

Whenever a section benefits from a demo, screenshot, or visual aid, include a **📌 Video Note**.

----------

## Core Rules

-   Don’t include classes not exposed publicly.
    
-   Keep tutorials **simple, not overly complex**.
    
-   Focus only on **Runtime/Core** folders.
    
-   Ignore internal classes like `Null*.cs`, `Native*.cs`, `Internal*.cs`, `*Delegates*.cs`.
    
-   Tutorials must always **progress logically** from beginner-friendly to slightly advanced.
    
-   **Concepts (02–0X)** → Show all relevant public APIs, each explained in its own Concept file.
    
-   **AdvancedUsage (last before BestPractices)** → Explain advanced scenarios one at a time, with short examples.
    
-   `IsAvailable` checks are **not mandatory** — only include when they add real value.
    
-   Avoid unnecessary native platform details (Essential Kit abstracts them).
    
-   Use `Debug.Log` in code snippets (easier for devs to copy).
    
-   Keep explanations short and **always explain what the snippet does** before/after showing it.
    
-   Best Practices = descriptive **bullet points**, no code.
    
-   Summary = descriptive recap, **no code**.
    
-   Incorporate **Unity mobile game development SEO keywords** naturally (Unity iOS, Unity Android, Unity SDK, Unity cross-platform, Unity plugin).
    

----------

## Tutorial Structure Template

`Tutorials/[FeatureName]/
├── 00-Introduction.md ├── 01-Overview.md ├── 02-[ConceptA].md ├── 03-[ConceptB].md ├── 04-[ConceptC].md ├── 0X-[ConceptN].md ├── 0Y-AdvancedUsage.md ├── 0Z-BestPractices.md └── 0Z+1-Summary.md` 

**Notes:**

-   Concept count (`02–0X`) is flexible.
    
-   AdvancedUsage always comes **after all concepts**.
    
-   BestPractices and Summary are always the last two.
    

----------

## Content Guidelines by File Type

### 00-Introduction.md

-   **Must mention:** “This tutorial is part of the Essential Kit tutorial series from Voxel Busters.”
    
-   Welcome & context.
    
-   What you’ll learn (3–5 points).
    
-   Why this feature matters for **Unity mobile game developers** - keep this section **concise and focused**. Avoid extensive subsections or marketing language. A brief paragraph plus essential use cases is sufficient.
    
-   Prerequisites (Unity version, Essential Kit setup).
    
-   **Platform setup section** → **Emphasize that Essential Kit handles most native setup automatically** (frameworks, permissions, manifest entries). This is a major value proposition! Only mention what developers still need to do (privacy policies, store compliance). Use this as a "wow factor" to highlight Essential Kit's convenience.
    
-   📌 Video Note: Show Essential Kit Settings in Unity Editor.
    

----------

### 01-Overview.md

-   High-level architecture (simple diagram).
    
-   List all **concepts covered in this tutorial**.
    
-   Cross-platform considerations (minimal details).
    
-   SEO phrasing like:
    
    -   “Unity cross-platform development for iOS and Android”
        
    -   “Unity mobile games SDK integration”
        
-   📌 Video Note: Use visual overview diagram.
    

----------

### 02–0X Concept Files

-   Each file covers **one concept**.
    
-   Start with: “What is this concept? Why use it in a Unity mobile game?”
    
-   Show **only related public APIs**.
    
-   Provide **short code snippets** (5–10 lines, using `Debug.Log`).
    
-   Explain briefly what the snippet does.
    
-   Avoid advanced usage or setup (belongs in AdvancedUsage/Introduction).
    
-   📌 Video Note: Optionally show Unity demo clip of snippet in action.
    

----------

### AdvancedUsage.md

-   Purpose: Cover advanced concepts one at a time.
    
-   Each advanced concept should have:
    
    -   A short explanation.
        
    -   A **simple snippet (5–10 lines)**.
        
-   Examples:
    
    -   Using pagination when reading contacts.
        
    -   Error handling strategies.
        
    -   Combining multiple feature calls.
        
    -   **Initialize methods that take the feature’s Unity settings file** (advanced use case, not beginner).
        
-   Keep it approachable, not a deep dive.
    
-   📌 Video Note: Show Unity demo of each advanced case.
    

----------

### BestPractices.md

-   Descriptive **bullet-point guidelines** only.
-   Very Quick overview of everything covered - at a very higher level but categorized and **not lengthy**
    
-   No code examples.
    
-   Examples:
    
    -   Request permissions only when necessary.
        
    -   Cache results for performance.
        
    -   Handle errors gracefully.
        
    -   Respect user privacy and compliance.
        
    -   Optimize for Unity iOS and Unity Android builds.
        
-   📌 Video Note: Present as checklist.
    

----------

### Summary.md

-   Super short overview recap of the tutorial series.
-   Very Quick overview of everything covered - at a very higher level and **not lengthy**
    
-   No code.
    
-   Cover:
    
    -   What was learned (all concepts).
        
    -   Why it’s useful for Unity mobile games.
        
    -   Platform notes.
        
    -   Common game use cases.
        
    -   Next steps for Unity developers.
        
-   📌 Video Note: End with recap bullets + “Next Steps” overlay.
    

----------

## Code Example Guidelines

-   Use **Debug.Log** for clarity.
    
-   Keep snippets short (5–10 lines).
    
-   Always explain what the snippet does.
    
-   Avoid overusing `IsAvailable`.
    
-   `Initialize` methods → show only in **AdvancedUsage.md**.
    
-   **Error handling** → Always use the actual `*ErrorCode` enum from the feature's ErrorCode.cs file (e.g., `AddressBookErrorCode`, `GameServicesErrorCode`). Don't use generic string error codes.
    

----------

## Writing Style Guidelines

-   Professional but approachable.
    
-   Always explain in **Unity mobile game development context**.
    
-   Use SEO keywords naturally: Unity SDK, Unity iOS, Unity Android, Unity cross-platform, Unity mobile games, Unity plugin.
    
-   Keep concept files short, clear, and focused.
    

----------

## Additional QA Rules

-   Don’t miss any **concepts the feature offers**.
    
-   One concept per file for clarity.
    
-   AdvancedUsage → one advanced concept at a time (including Initialize methods).
    
-   BestPractices & Summary → descriptive, no code.
    
-   Avoid unnecessary platform-specific detail unless setup is required.
    
-   Verify all code compiles in Unity.
    
-   📌 Video Note: Ensure every snippet shown in docs is demonstrated in the video.