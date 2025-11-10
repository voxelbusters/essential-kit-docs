---
description: "Native UI provides platform-native alert dialogs and date/time pickers for Unity games"
---

# Usage

Essential Kit wraps native iOS (UIKit) and Android UI components into a unified Unity interface. Essential Kit automatically initializes Native UI - no manual setup needed.

## Table of Contents

- [Understanding Core Concepts](#understanding-core-concepts)
- [Import Namespaces](#import-namespaces)
- [Alert Dialogs](#alert-dialogs)
- [Date and Time Pickers](#date-and-time-pickers)
- [Core APIs Reference](#core-apis-reference)
- [Data Properties](#data-properties)
- [Common Patterns](#common-patterns)
- [Error Handling](#error-handling)
- [Advanced Configuration](#advanced-configuration)

## Understanding Core Concepts

Native UI wraps a small set of platform widgets. Map each widget to the user journey before you start wiring code:

- **AlertDialog** surfaces blocking decisions or confirmations. Use it for urgent notices, desructive actions, or short forms that need one or two data points.
- **AlertDialogStyle.ActionSheet** provides iOS-style menus; it feels natural for secondary actions like sharing, saving, or discarding.
- **TextInputFieldOptions** lets you request the appropriate keyboard, secure entry, and placeholder to guide the player.
- **DatePicker** (and its `Date`, `Time`, `DateAndTime` modes) handles locale-aware scheduling tasks without reinventing spinners or calendars.
- **Dialog lifecycle**: Alerts and pickers suspend interaction with your scene. Always resume gameplay, timers, or animations once callbacks fire.

## Import Namespaces

```csharp
using VoxelBusters.EssentialKit;
```

## Alert Dialogs

Alert dialogs are modal windows that prompt users for decisions or display important information. Use `AlertDialog.CreateInstance()` to create dialogs with custom titles, messages, buttons, and text input fields.

### Basic Alert Dialog

Create a simple dialog with title, message, and buttons:

```csharp
public void ShowSimpleAlert()
{
    AlertDialog dialog = AlertDialog.CreateInstance();
    dialog.Title = "Confirmation";
    dialog.Message = "Are you sure you want to continue?";
    dialog.AddButton("Yes", () =>
    {
        Debug.Log("User confirmed");
    });
    dialog.AddCancelButton("No", () =>
    {
        Debug.Log("User cancelled");
    });
    dialog.Show();
}
```

### Multi-Button Dialog

Add multiple action buttons for complex choices:

```csharp
public void ShowMultiButtonDialog()
{
    AlertDialog dialog = AlertDialog.CreateInstance();
    dialog.Title = "Choose Difficulty";
    dialog.Message = "Select your preferred game difficulty:";

    dialog.AddButton("Easy", () =>
    {
        Debug.Log("Easy mode selected");
    });

    dialog.AddButton("Normal", () =>
    {
        Debug.Log("Normal mode selected");
    });

    dialog.AddButton("Hard", () =>
    {
        Debug.Log("Hard mode selected");
    });

    dialog.AddCancelButton("Cancel", () =>
    {
        Debug.Log("Selection cancelled");
    });

    dialog.Show();
}
```

### Text Input Dialog

Collect user input through native text fields:

```csharp
public void ShowTextInputDialog()
{
    AlertDialog dialog = AlertDialog.CreateInstance();
    dialog.Title = "Enter Name";
    dialog.Message = "Please enter your player name:";

    // Add text input field
    dialog.AddTextInputField();

    // Button callback receives input values
    dialog.AddButton("Submit", (inputTexts) =>
    {
        string playerName = inputTexts[0];
        Debug.Log("Player name: " + playerName);
    });

    dialog.AddCancelButton("Cancel", (inputTexts) =>
    {
        Debug.Log("Input cancelled");
    });

    dialog.Show();
}
```

### Text Input with Options

Configure text input field behavior:

```csharp
public void ShowCustomTextInput()
{
    AlertDialog dialog = AlertDialog.CreateInstance();
    dialog.Title = "Login";
    dialog.Message = "Enter your credentials:";

    // Username field with placeholder
    var usernameOptions = new TextInputFieldOptions.Builder()
        .SetPlaceholder("Username")
        .Build();
    dialog.AddTextInputField(usernameOptions);

    // Password field (secure entry)
    var passwordOptions = new TextInputFieldOptions.Builder()
        .SetPlaceholder("Password")
        .SetSecureTextEntry(true)
        .Build();
    dialog.AddTextInputField(passwordOptions);

    dialog.AddButton("Login", (inputTexts) =>
    {
        string username = inputTexts[0];
        string password = inputTexts[1];
        Debug.Log($"Login attempt: {username}");
    });

    dialog.AddCancelButton("Cancel", (inputTexts) => { });

    dialog.Show();
}
```

### Alert Dialog Styles

Create action sheets on iOS for menu-style choices:

```csharp
public void ShowActionSheet()
{
    AlertDialog dialog = AlertDialog.CreateInstance(AlertDialogStyle.ActionSheet);
    dialog.Title = "Actions";
    dialog.Message = "Choose an action:";

    dialog.AddButton("Share", () => Debug.Log("Share selected"));
    dialog.AddButton("Save", () => Debug.Log("Save selected"));
    dialog.AddButton("Delete", () => Debug.Log("Delete selected"));
    dialog.AddCancelButton("Cancel", () => { });

    dialog.Show();
}
```

## Date and Time Pickers

Date pickers provide native interfaces for selecting dates and times. Use `DatePicker.CreateInstance()` with different modes for date-only, time-only, or combined pickers.

### Understanding Picker Modes

DatePicker supports three modes for different use cases:

**DatePickerMode.Date:**
- Shows day, month, and year selection
- Perfect for birthdays, event dates, and deadlines

**DatePickerMode.Time:**
- Shows hours and minutes selection
- Ideal for alarm settings and notification times

**DatePickerMode.DateAndTime:**
- Shows both date and time selection
- Best for scheduling specific moments (appointments, reminders)

### Date Picker

Let users select a specific date:

```csharp
public void ShowDatePicker()
{
    DatePicker datePicker = DatePicker.CreateInstance(DatePickerMode.Date);

    datePicker.SetOnCloseCallback((result) =>
    {
        if (result.ResultCode == DatePickerResultCode.Done)
        {
            DateTime selectedDate = result.Date;
            Debug.Log("Selected date: " + selectedDate.ToString("yyyy-MM-dd"));
        }
        else
        {
            Debug.Log("Date selection cancelled");
        }
    });

    datePicker.Show();
}
```

### Time Picker

Collect time input for alarms or reminders:

```csharp
public void ShowTimePicker()
{
    DatePicker timePicker = DatePicker.CreateInstance(DatePickerMode.Time);

    timePicker.SetOnCloseCallback((result) =>
    {
        if (result.ResultCode == DatePickerResultCode.Done)
        {
            DateTime selectedTime = result.Date;
            Debug.Log("Selected time: " + selectedTime.ToString("HH:mm"));
        }
    });

    timePicker.Show();
}
```

### Date and Time Picker

Combined picker for precise scheduling:

```csharp
public void ShowDateTimePicker()
{
    DatePicker picker = DatePicker.CreateInstance(DatePickerMode.DateAndTime);

    // Set initial date (optional)
    picker.SetInitialDate(DateTime.Now.AddDays(1));

    // Set date range constraints (optional)
    picker.SetMinimumDate(DateTime.Now);
    picker.SetMaximumDate(DateTime.Now.AddMonths(3));

    picker.SetOnCloseCallback((result) =>
    {
        if (result.ResultCode == DatePickerResultCode.Done)
        {
            Debug.Log("Scheduled for: " + result.Date.ToString("yyyy-MM-dd HH:mm"));
        }
    });

    picker.Show();
}
```

### Date Picker with Constraints

Restrict selectable date ranges:

```csharp
public void ShowConstrainedDatePicker()
{
    DatePicker datePicker = DatePicker.CreateInstance(DatePickerMode.Date);

    // Only allow future dates
    datePicker.SetMinimumDate(DateTime.Now);
    datePicker.SetMaximumDate(DateTime.Now.AddYears(1));

    // Set initial date to tomorrow
    datePicker.SetInitialDate(DateTime.Now.AddDays(1));

    datePicker.SetOnCloseCallback((result) =>
    {
        if (result.ResultCode == DatePickerResultCode.Done)
        {
            Debug.Log("Tournament date: " + result.Date.ToString("MMM dd, yyyy"));
        }
    });

    datePicker.Show();
}
```

## Core APIs Reference

### AlertDialog APIs

| API | Purpose | Returns |
| --- | --- | --- |
| `AlertDialog.CreateInstance(style)` | Create new alert dialog instance | AlertDialog object |
| `dialog.Title` | Set or get dialog title | string property |
| `dialog.Message` | Set or get dialog message | string property |
| `dialog.AddButton(title, callback)` | Add action button | Void |
| `dialog.AddButton(title, inputCallback)` | Add button with text input callback | Void |
| `dialog.AddCancelButton(title, callback)` | Add cancel-style button | Void |
| `dialog.AddTextInputField(options)` | Add text input field | Void |
| `dialog.Show()` | Display the dialog | Void |
| `dialog.Dismiss()` | Programmatically close dialog | Void |

### DatePicker APIs

| API | Purpose | Returns |
| --- | --- | --- |
| `DatePicker.CreateInstance(mode)` | Create new date picker instance | DatePicker object |
| `picker.SetInitialDate(date)` | Set initial displayed date | DatePicker (for chaining) |
| `picker.SetMinimumDate(date)` | Set earliest selectable date | DatePicker (for chaining) |
| `picker.SetMaximumDate(date)` | Set latest selectable date | DatePicker (for chaining) |
| `picker.SetOnCloseCallback(callback)` | Set result callback | DatePicker (for chaining) |
| `picker.Show()` | Display the picker | Void |

### Data Properties

| Property | Type | Notes |
| --- | --- | --- |
| `DatePickerResult.Date` | `DateTime` | Selected date/time value |
| `DatePickerResult.ResultCode` | `DatePickerResultCode` | `Done` or `Cancelled` |
| `TextInputFieldOptions` | Class | Configure placeholder, keyboard, secure entry |

## Common Patterns

### Pattern 1: Confirmation Dialog

Standard Yes/No confirmation:

```csharp
public void ConfirmPurchase(string itemName, int cost)
{
    AlertDialog dialog = AlertDialog.CreateInstance();
    dialog.Title = "Confirm Purchase";
    dialog.Message = $"Buy {itemName} for {cost} coins?";

    dialog.AddButton("Buy", () =>
    {
        ProcessPurchase(itemName, cost);
    });

    dialog.AddCancelButton("Cancel", () =>
    {
        Debug.Log("Purchase cancelled");
    });

    dialog.Show();
}

void ProcessPurchase(string item, int cost)
{
    Debug.Log($"Purchased {item} for {cost} coins");
}
```

### Pattern 2: User Input Collection

Collect and validate user input:

```csharp
public void ShowNameInput()
{
    AlertDialog dialog = AlertDialog.CreateInstance();
    dialog.Title = "Player Name";
    dialog.Message = "Enter your name (3-15 characters):";

    var options = new TextInputFieldOptions.Builder()
        .SetPlaceholder("Your name")
        .Build();
    dialog.AddTextInputField(options);

    dialog.AddButton("OK", (inputTexts) =>
    {
        string name = inputTexts[0];

        if (name.Length >= 3 && name.Length <= 15)
        {
            SavePlayerName(name);
        }
        else
        {
            ShowError("Name must be 3-15 characters");
        }
    });

    dialog.AddCancelButton("Cancel", (inputTexts) => { });

    dialog.Show();
}

void SavePlayerName(string name)
{
    Debug.Log("Player name saved: " + name);
}

void ShowError(string message)
{
    AlertDialog errorDialog = AlertDialog.CreateInstance();
    errorDialog.Title = "Error";
    errorDialog.Message = message;
    errorDialog.AddButton("OK", () => { });
    errorDialog.Show();
}
```

### Pattern 3: Tournament Scheduling

Date picker for event scheduling:

```csharp
public void ScheduleTournament()
{
    DatePicker datePicker = DatePicker.CreateInstance(DatePickerMode.DateAndTime);

    // Tournament must be at least 24 hours in future
    datePicker.SetMinimumDate(DateTime.Now.AddDays(1));
    datePicker.SetMaximumDate(DateTime.Now.AddMonths(1));
    datePicker.SetInitialDate(DateTime.Now.AddDays(7));

    datePicker.SetOnCloseCallback((result) =>
    {
        if (result.ResultCode == DatePickerResultCode.Done)
        {
            ShowConfirmation(result.Date);
        }
    });

    datePicker.Show();
}

void ShowConfirmation(DateTime tournamentDate)
{
    AlertDialog dialog = AlertDialog.CreateInstance();
    dialog.Title = "Confirm Tournament";
    dialog.Message = $"Schedule tournament for {tournamentDate:MMM dd 'at' HH:mm}?";

    dialog.AddButton("Confirm", () =>
    {
        Debug.Log("Tournament scheduled for: " + tournamentDate);
    });

    dialog.AddCancelButton("Cancel", () => { });

    dialog.Show();
}
```

### Pattern 4: Reminder Time Selection

Time picker for notifications:

```csharp
public void SetDailyReminder()
{
    DatePicker timePicker = DatePicker.CreateInstance(DatePickerMode.Time);

    timePicker.SetOnCloseCallback((result) =>
    {
        if (result.ResultCode == DatePickerResultCode.Done)
        {
            TimeSpan reminderTime = result.Date.TimeOfDay;
            Debug.Log($"Daily reminder set for {reminderTime.Hours:00}:{reminderTime.Minutes:00}");
            ScheduleDailyNotification(reminderTime);
        }
    });

    timePicker.Show();
}

void ScheduleDailyNotification(TimeSpan time)
{
    Debug.Log($"Scheduling daily notification at {time}");
}
```

## Error Handling

| Scenario | Trigger | Recommended Action |
| --- | --- | --- |
| Dialog dismissed without confirmation | Player taps outside the alert or presses system back | Treat `OnCloseCallback` with `DatePickerResultCode.Cancelled` (or cancel button callbacks) as a no-op and keep the previous state intact. |
| Input validation fails | Text field callback receives empty or invalid data | Re-open a lightweight alert explaining the requirement and focus the relevant field again. |
| Dialogs invoked while another is active | Multiple modals launched simultaneously | Track outstanding dialogs; dismiss the existing one before showing the next to avoid stacking errors. |
| App backgrounded while dialog open | OS hides the alert/picker | In `OnApplicationPause(false)` re-check pending work and show the dialog again if the action is critical. |

## Advanced Configuration

{% hint style="danger" %}
Manual initialization is for advanced scenarios only. Essential Kit auto-initializes Native UI using the Essential Kit Settings asset. Only use `Initialize()` for runtime-generated settings.
{% endhint %}

Override settings at runtime if needed:

```csharp
void Awake()
{
    var settings = new NativeUIUnitySettings(isEnabled: true);
    // Configure advanced settings if needed (custom UI collection, etc.)
    NativeUI.Initialize(settings);
}
```

**Use cases for manual initialization:**
- Custom dialog themes based on app branding
- Runtime configuration from server
- Environment-specific UI behaviors

{% hint style="warning" %}
For most games, configure settings in the ScriptableObject instead of manual initialization.
{% endhint %}

## Related Guides
- Demo scene: `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/NativeUIDemo.unity`
- Use with **Utilities.OpenApplicationSettings()** for permission recovery flows
- Combine with **Notification Services** for reminder and alarm date selection
- See [Testing Guide](testing.md) to validate dialogs across platforms
