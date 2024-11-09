# Mail Composer

Once after importing the name space, you can send a mail with MailComposer class.

You can set the following to the MailComposer.

* To Recipients
* Cc Recipients
* Bcc Recipients
* Subject
* Body
* Screenshot/Image
* Attachment (any file)

Before accessing any of the MailComposer features you need to check if it's allowed to send mails through mail client apps on the user's device.&#x20;

```csharp
bool canSendMail = MailComposer.CanSendMail();
```

Once you get the results from above methods, you need to add content to the mail composer based on the above status.

### Send a text mail

```csharp
MailComposer composer = MailComposer.CreateInstance();
composer.SetToRecipients(new string[1]{"to@gmail.com"});
composer.SetCcRecipients(new string[1]{"cc@gmail.com"});
composer.SetBccRecipients(new string[1]{"bcc@gmail.com"});

composer.SetSubject("Subject");
composer.SetBody("Body", false);//Pass true if string is html content
composer.SetCompletionCallback((result, error) => {
    Debug.Log("Mail composer was closed. Result code: " + result.ResultCode);
});
composer.Show();
```

### Send a mail with screenshot

```csharp
MailComposer composer = MailComposer.CreateInstance();
composer.SetToRecipients(new string[1]{"to@gmail.com"});
composer.SetCcRecipients(new string[1]{"cc@gmail.com"});
composer.SetBccRecipients(new string[1]{"bcc@gmail.com"});

composer.SetSubject("Subject");
composer.SetBody("Body", false);//Pass true if string is html content
composer.AddScreenshot("screenshot file name");
composer.SetCompletionCallback((result, error) => {
    Debug.Log("Mail composer was closed. Result code: " + result.ResultCode);
});
composer.Show();
```

### Send a mail with an attachment

```csharp
MailComposer composer = MailComposer.CreateInstance();
composer.SetToRecipients(new string[1]{"to@gmail.com"});
composer.SetCcRecipients(new string[1]{"cc@gmail.com"});
composer.SetBccRecipients(new string[1]{"bcc@gmail.com"});

composer.SetSubject("Subject");
composer.SetBody("Body", false);//Pass true if string is html content
composer.AddAttachment(fileByteData, mimeType, "file name");//fileByteData => file data bytes
composer.SetCompletionCallback((result, error) => {
    Debug.Log("Mail composer was closed. Result code: " + result.ResultCode);
});
composer.Show();
```

{% hint style="success" %}
It's allowed to add multiple attachments!
{% endhint %}

