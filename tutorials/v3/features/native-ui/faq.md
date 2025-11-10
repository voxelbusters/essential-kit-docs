---
description: "Common questions and troubleshooting for Native UI"
---

# FAQ & Troubleshooting

### Do I need to configure native UI frameworks manually in build settings?
No. Essential Kit automatically configures UIKit (iOS) and required Android components during the build process. Just enable Native UI in Essential Kit Settings.

### Why do my dialogs look different on iOS vs Android?
This is expected and correct. Essential Kit uses native platform components, so dialogs follow iOS Human Interface Guidelines on iOS and Material Design on Android. This ensures users get familiar, platform-appropriate experiences.

### Can I add more than 3 buttons to an alert dialog?
Yes. Essential Kit supports multiple buttons. However, consider UX - too many buttons can overwhelm users. For complex choices, consider using an action sheet style on iOS or breaking into multiple dialogs.

### How do I get the text from an input field in an alert dialog?
Use the callback signature that accepts `string[]` parameter when adding buttons:
```csharp
dialog.AddButton("Submit", (inputTexts) =>
{
    string userInput = inputTexts[0]; // First input field
    string secondInput = inputTexts[1]; // Second input field (if exists)
});
```

### Why isn't my date picker showing the date I set with SetInitialDate?
Ensure you call `SetInitialDate()` before calling `Show()`. Also verify the date is within any min/max constraints you've set. The picker uses the initial date as the starting position when displayed.

### Can I customize the appearance of native dialogs (colors, fonts)?
Native dialogs use system styling to match platform conventions. Custom styling isn't supported because it would break platform consistency. If you need custom UI, consider using Unity UI components instead.

### What's the difference between AddButton and AddCancelButton?
- `AddButton()` creates a normal action button
- `AddCancelButton()` creates a cancel-style button that appears differently on some platforms (e.g., bold on iOS)
Both work the same functionally, but AddCancelButton signals to the platform that this is the cancel action.

### How do I validate text input from alert dialogs?
Perform validation in your button callback:
```csharp
dialog.AddButton("OK", (inputTexts) =>
{
    if (string.IsNullOrEmpty(inputTexts[0]))
    {
        Debug.LogWarning("Input required.");
        return;
    }
    Debug.Log($"Process input: {inputTexts[0]}");
});
```

### Why doesn't my date picker enforce the minimum date?
Ensure you're calling `SetMinimumDate()` before `Show()`. Also check that your minimum date is not null and is properly formatted. The picker will respect the constraint once properly set.

### Can I show multiple dialogs at the same time?
No. Native platforms only support one modal dialog at a time. If you need to show another dialog, dismiss the current one first or wait for the user to close it via button press.

### How do I localize dialog button text?
Use Unity's localization system to provide translated strings:
```csharp
dialog.AddButton(LocalizationManager.GetText("button_ok"), callback);
```

### Are there any example use cases for DatePicker?
Yes, common use cases include:
- **Date mode**: Birthday selection, event dates, year of birth
- **Time mode**: Alarm settings, reminder times, notification schedules
- **DateAndTime mode**: Tournament scheduling, appointment booking, deadline setting

### Where can I see all Native UI features in action?
Run the demo scene at `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/NativeUIDemo.unity`. It demonstrates all alert dialog types, text input, and date picker modes with complete implementation examples.

### Do dialogs work in landscape and portrait modes?
Yes. Native dialogs automatically adapt to device orientation. Test both orientations on devices to verify the behavior matches your expectations.
