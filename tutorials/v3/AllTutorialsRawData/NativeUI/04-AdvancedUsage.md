# Native UI - Advanced Usage

This section covers advanced scenarios and techniques for using Native UI components in more complex Unity mobile game implementations.

## Alert Dialog with Multiple Input Fields

Create alert dialogs with multiple text input fields for complex user forms.

```csharp
AlertDialog dialog = AlertDialog.CreateInstance();
dialog.Title = "Player Registration";
dialog.Message = "Enter your details";

// Add multiple input fields
var nameOptions = new TextInputFieldOptions.Builder()
    .SetPlaceholderText("Player Name")
    .SetKeyboardInputType(KeyboardInputType.Default)
    .Build();
dialog.AddTextInputField(nameOptions);

var emailOptions = new TextInputFieldOptions.Builder()
    .SetPlaceholderText("Email Address")
    .SetKeyboardInputType(KeyboardInputType.EmailAddress)
    .Build();
dialog.AddTextInputField(emailOptions);

dialog.AddButton("Register", (string[] values) => {
    Debug.Log("Name: " + values[0] + ", Email: " + values[1]);
});
```

## Date Picker with Timezone Handling

Handle timezone conversions for global multiplayer games or scheduled events.

```csharp
DatePicker picker = DatePicker.CreateInstance(DatePickerMode.DateAndTime);
picker.SetKind(DateTimeKind.Utc);

DateTime utcMinDate = DateTime.UtcNow;
DateTime utcMaxDate = DateTime.UtcNow.AddMonths(1);
picker.SetMinimumDate(utcMinDate);
picker.SetMaximumDate(utcMaxDate);

picker.SetOnCloseCallback((result) => {
    DateTime localTime = result.SelectedDate.Value.ToLocalTime();
    Debug.Log("UTC: " + result.SelectedDate.Value + ", Local: " + localTime);
});
```

## Chaining Alert Dialogs

Create sequential dialogs for multi-step user interactions.

```csharp
void ShowConfirmationDialog() {
    AlertDialog confirmDialog = AlertDialog.CreateInstance();
    confirmDialog.Title = "Delete Save File";
    confirmDialog.Message = "This action cannot be undone";
    
    confirmDialog.AddButton("Delete", () => {
        ShowFinalConfirmationDialog();
    });
    confirmDialog.AddCancelButton("Cancel", () => {
        Debug.Log("Deletion cancelled");
    });
    confirmDialog.Show();
}

void ShowFinalConfirmationDialog() {
    AlertDialog finalDialog = AlertDialog.CreateInstance();
    finalDialog.Title = "Final Confirmation";
    finalDialog.Message = "Type 'DELETE' to confirm";
    
    var options = new TextInputFieldOptions.Builder()
        .SetPlaceholderText("Type DELETE")
        .Build();
    finalDialog.AddTextInputField(options);
    
    finalDialog.AddButton("Confirm", (string[] values) => {
        if (values[0] == "DELETE") {
            Debug.Log("Save file deleted");
        }
    });
    finalDialog.Show();
}
```

## Error Handling for Native UI Components

Implement robust error handling for native UI operations.

```csharp
void ShowDialogWithErrorHandling() {
    try {
        AlertDialog dialog = AlertDialog.CreateInstance();
        
        if (dialog.IsAvailable()) {
            dialog.Title = "Safe Dialog";
            dialog.AddButton("OK", () => Debug.Log("Success"));
            dialog.Show();
        } else {
            Debug.LogWarning("Native UI not available, using fallback");
        }
    } catch (System.Exception e) {
        Debug.LogError("Failed to show dialog: " + e.Message);
    }
}
```

## Custom Alert Dialog Styling

Use different alert dialog styles for various game contexts.

```csharp
// Create alert with different styles
AlertDialog defaultDialog = AlertDialog.CreateInstance(AlertDialogStyle.Default);
AlertDialog plainDialog = AlertDialog.CreateInstance(AlertDialogStyle.Plain);

Debug.Log("Different styled dialogs created");
```

These advanced patterns help you create more sophisticated user interactions while maintaining the simplicity and reliability of Essential Kit's Native UI components.

📌 Video Note: Show Unity demo of each advanced usage pattern, demonstrating the multi-step dialogs and timezone handling in action.