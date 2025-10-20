# Native UI - Date Picker

What is a Date Picker? A date picker is a native interface component that allows users to select dates and times using familiar platform-specific controls. In Unity mobile games, date pickers are essential for scheduling events, setting reminders, selecting birthdates, or any feature that requires temporal input.

## Key Features

Date pickers in Essential Kit provide:

- **Multiple Modes**: Date only, time only, or date and time selection
- **Date Range Constraints**: Set minimum and maximum selectable dates
- **Native Platform Styling**: Uses iOS wheel picker and Android material design
- **Timezone Support**: Handle local time and UTC conversions automatically
- **Callback Events**: Respond to date selection and picker closure

## Core API Methods

### Creating a Date Picker

```csharp
DatePicker picker = DatePicker.CreateInstance(DatePickerMode.DateAndTime);
Debug.Log("Date picker created with DateAndTime mode");
```

### Setting Date Constraints

```csharp
DateTime minDate = DateTime.Now;
DateTime maxDate = DateTime.Now.AddDays(30);

picker.SetMinimumDate(minDate);
picker.SetMaximumDate(maxDate);
Debug.Log("Date range constraints applied");
```

### Setting Initial Date

```csharp
DateTime initialDate = DateTime.Now.AddDays(7);
picker.SetInitialDate(initialDate);
Debug.Log("Initial date set to one week from now");
```

### Configuring Callbacks

```csharp
picker.SetOnCloseCallback((result) => {
    if (result.SelectedDate.HasValue) {
        Debug.Log("User selected: " + result.SelectedDate.Value);
    } else {
        Debug.Log("No date selected");
    }
});
```

### Displaying the Date Picker

```csharp
picker.Show();
Debug.Log("Date picker displayed to user");
```

## Date Picker Modes

The `DatePickerMode` enum provides three options:

- **Date**: Shows only date selection (year, month, day)
- **Time**: Shows only time selection (hour, minute)
- **DateAndTime**: Shows both date and time selection

```csharp
DatePicker datePicker = DatePicker.CreateInstance(DatePickerMode.Date);
DatePicker timePicker = DatePicker.CreateInstance(DatePickerMode.Time);
Debug.Log("Different picker modes created");
```

## Working with Selected Dates

```csharp
picker.SetOnValueChange((selectedDate) => {
    if (selectedDate.HasValue) {
        Debug.Log("Date changed to: " + selectedDate.Value);
    }
});
```

Date pickers automatically handle platform-specific presentation styles and provide a consistent API across iOS and Android, making them perfect for Unity cross-platform mobile game development.

📌 Video Note: Demonstrate date picker in different modes on iOS and Android devices, showing the native styling differences.