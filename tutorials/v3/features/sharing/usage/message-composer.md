# Message Composer

Once after importing the name space, you can share a message with MessageComposer class.

You can set the following to the MessageComposer.

* Recipients
* Subject
* Body
* Screenshot/Image
* Attachment (any file)

Before accessing any of the MessageComposer features you need to check if it's allowed to share messages through messaging apps on the user's device.&#x20;

```csharp
bool canSendText = MessageComposer.CanSendText();
bool canSendAttachments = MessageComposer.CanSendAttachments();
bool canSendSubject = MessageComposer.CanSendSubject();
```

Once you get the results from above methods, you need to add content to the message composer based on the above status.

### Share a screenshot

```csharp
MessageComposer composer = MessageComposer.CreateInstance();
composer.SetRecipients(new string[2]{"abc@gmail.com", 9138393x03});
composer.SetSubject("Subject");
composer.SetBody("Body");
composer.AddScreenshot("screenshot file name");
composer.SetCompletionCallback((result, error) => {
    Debug.Log("Message composer was closed. Result code: " + result.ResultCode);
});
composer.Show();
```

### Share a text message

```csharp
MessageComposer composer = MessageComposer.CreateInstance();
composer.SetRecipients(new string[2]{"abc@gmail.com", 9138393x03});
composer.SetSubject("Subject");
composer.SetBody("Body");
composer.SetCompletionCallback((result, error) => {
    Debug.Log("Message composer was closed. Result code: " + result.ResultCode);
});
composer.Show();
```

### Share an image

```csharp
MessageComposer composer = MessageComposer.CreateInstance();
composer.SetRecipients(new string[2]{"abc@gmail.com", 9138393x03});
composer.AddImage(image, "name");
composer.SetCompletionCallback((result, error) => {
    Debug.Log("Message composer was closed. Result code: " + result.ResultCode);
});
composer.Show();
```
