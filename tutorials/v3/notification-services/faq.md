# FAQ

## As there are some extra options for notifications on each platform, Is there any option to set them?

When creating INotification instance with NotificationBuilder (via CreateNotification), you can set iOS properties with **SetIosProperties**  and android properties with **SetAndroidProperties** methods.

## On Android, How to make sure the notifications get a new entry for each delivered notification in the notification center dashboard?

You can make use of Tag property while setting the android specific properties when creating the notification.

## On Android, Is it possible to show the notification even when the app is in foreground?

Yes. Just enable "**Allow Notification Display when Foreground"** property in [Settings](setup/#properties) under Android section.

## On Android, our server has different custom payload keys for title, tag and other standard keys. How to make the plugin work with the existing server setup?

It's possible to configure the payload keys of your choice in the plugin. Go to settings and set the payload keys as per your server setup.&#x20;

## What are some payload formats for reference?

```
// Android FCM payload example
{
      "to": "APA91bE38IGujnSN5..",
      "data":{
        "content_title" : "Title here"
        "content_text":"Content text here...."
        "ticker_text" : "Ticker text shown in status bar goes here"
        "tag" : "OptionalTag -  This needs to be diff if you want to overwrite previous notification"

        "custom_sound" : "notification.mp3"
        "large_icon":"NativePlugins.png"

        "badge": 5 - Set a number over here to display badge on the app icon
        "user_info":
        {
            "key1"  : "value1"
            "key2"  : "value2"
        }

      }
}

```

```
//Payload format for iOS  with default user_info key.

    {
				"aps": {
					"alert": {
						"body": "message goes here",
						"action - loc - key": "VIEW",
						"actions": [{
								"id": "delete",
								"title": "Delete"
							},
							{
			
								"id": "reply-to",
								"loc-key": "REPLYTO",
								"loc-args": ["Jane "]
							}
						]
					},
					"badge": 3,
					"sound": "notification.mp3"
				},
				"user_info": {
					"key1": "value1",
					"key2": "value2"
				}
	}
```

### I'm currently using Unity's Mobile Notifications package and how difficult it is to migrate to your plugin?

The plugin offers much simple unified api for both iOS and Android platforms. It's straight forward to integrate and anytime you can contact our support team for help.



