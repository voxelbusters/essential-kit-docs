---
description: Example to show how to use Alert Dialog for login screen
---

# Login Dialog

```csharp
using UnityEngine;
using VoxelBusters.CoreLibrary;
using VoxelBusters.EssentialKit;


public class LoginView : MonoBehaviour
{
    public void Show()
    {
        //Construct the alert builder
        AlertDialogBuilder builder = new AlertDialogBuilder();
        builder.SetTitle("Log in");
        builder.SetMessage("To access you account need to log in");

        //Create text input field options for entering email
        var emailInputOptions = new TextInputFieldOptions.Builder()
            .SetPlaceholderText("Enter your email here")
            .SetKeyboardInputType(KeyboardInputType.EmailAddress)
            .Build();        

        //Create text input field options for entering password
        var passwordInputOptions = new TextInputFieldOptions.Builder()
            .SetPlaceholderText("Enter your password here")
            .SetIsSecured(true)
            .Build();  
                                
        builder.AddTextInputField(emailInputOptions);
        builder.AddTextInputField(passwordInputOptions);
        builder.AddButton("Log in", (string[] inputValues) => {
            Debug.Log($"Entered email address : {inputValues[0]}");                 
            Debug.Log($"Entered email password : {inputValues[1]}");                                               
        });
        builder.AddButton("Cancel", () => Debug.Log("Cancel clicked"));
    
    
        //Build the dialog from constructed builder and show
        AlertDialog dialog = builder.Build();
        dialog.Show();
    }
}
```
