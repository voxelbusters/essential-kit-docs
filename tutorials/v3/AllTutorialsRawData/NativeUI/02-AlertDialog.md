# Native UI - Alert Dialog

What is an Alert Dialog? An alert dialog is a native popup window that displays important information to the user and waits for their response. In Unity mobile games, alert dialogs are perfect for confirmation prompts, user input forms, and important notifications that require immediate attention.

## Key Features

Alert dialogs in Essential Kit provide:

- **Custom Titles and Messages**: Set descriptive text that explains the action or request
- **Multiple Button Types**: Add regular action buttons and cancel buttons with different styling
- **Text Input Fields**: Include input fields for collecting user data like names, passwords, or feedback
- **Native Appearance**: Automatically matches iOS and Android platform design guidelines

## Core API Methods

### Creating an Alert Dialog

```csharp
AlertDialog dialog = AlertDialog.CreateInstance();
Debug.Log("Alert dialog created");
```

### Setting Title and Message

```csharp
dialog.Title = "Confirm Action";
dialog.Message = "Are you sure you want to delete this save file?";
Debug.Log("Title and message configured");
```

### Adding Buttons

```csharp
// Add a regular action button
dialog.AddButton("Delete", () => {
    Debug.Log("User confirmed deletion");
});

// Add a cancel button
dialog.AddCancelButton("Cancel", () => {
    Debug.Log("User cancelled action");
});
```

### Adding Text Input Fields

```csharp
var options = new TextInputFieldOptions.Builder()
    .SetPlaceholderText("Enter your name")
    .SetKeyboardInputType(KeyboardInputType.Default)
    .Build();
    
dialog.AddTextInputField(options);
Debug.Log("Text input field added");
```

### Displaying the Dialog

```csharp
dialog.Show();
Debug.Log("Alert dialog displayed to user");
```

## Button Callbacks with Input Values

When using text input fields, your button callbacks can receive the entered values:

```csharp
dialog.AddButton("Submit", (string[] inputValues) => {
    foreach (string value in inputValues) {
        Debug.Log("User entered: " + value);
    }
});
```

Alert dialogs automatically handle platform differences, memory management, and proper threading, making them ideal for Unity mobile game development across iOS and Android platforms.

📌 Video Note: Show Unity demo of creating and displaying different alert dialog configurations on both iOS and Android devices.