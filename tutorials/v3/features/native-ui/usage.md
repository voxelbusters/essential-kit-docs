# Usage

Once you are done enabling the feature in Essential Kit Settings, you can access the feature classes once you import the required namespace.

```
using VoxelBusters.EssentialKit;
```

### Alert Dialog

A dialog is a small window that prompts the user to make a decision. A dialog does not fill the screen and is normally used for modal events that require users to take an action before they can proceed.

You can have the following for an Alert Dialog

* Title
* Message
* Add buttons

```csharp
AlertDialog dialog = AlertDialog.CreateInstance();
dialog.Title = "Title";
dialog.Message = "Message";
dialog.AddButton("Yes", () => {
    Debug.Log("Yes button clicked");
});
dialog.AddCancelButton("No", () => {
    Debug.Log("Cancel button clicked");
});
dialog.Show(); //Show the dialog
```

### Date Picker

Date picker will be useful for capturing the time as an input from the user. This can be operated in three modes.

* Date : For allowing to pick Date alone (Day, Month, Year)
* Time : For allowing to pick time alone (Hours, Minutes)
* Date and Time : For allowing to pick both date and time

```csharp
DatePicker datePicker = DatePicker.CreateInstance(DatePickerMode.Date);
datePicker.SetOnCloseCallback((result) => {
    Debug.Log("Dismissed the picker with selected date : " + result.SelectedDate);
});
datePicker.Show();
```

