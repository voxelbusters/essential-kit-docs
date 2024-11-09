# Setup

## :white\_check\_mark: Enable Feature

Open [Essential Kit Settings](../../overview/settings.md) and enable Notification Services feature in the inspector.

![Enable Notification Services](../../.gitbook/assets/EnableNotificationServices.gif)

### Properties

| Name                              | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| --------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Presentation Options              | <p>Setting for how to present the notification</p><p><strong>None</strong> : On receiving a notification, there won't be any display or badge or sound</p><p><strong>Alert</strong> : On receiving a notification, it's displayed with UI</p><p><strong>Badge</strong> : On receiving a notification, badge will be displayed on the app icon</p><p><strong>Sound</strong> : On receiving a notification, sound will be played</p>                                                                                                                                                                          |
| Push Notification Service Type    | <p>Enable which service you want to use for Push/Remote Notifications.<br><strong>None</strong> : No Remote notification service will be enabled. You can still use Local notifications though.<br><strong>Custom</strong> : This activates the client side of receiving the remote notifications. You can send a data message payload via your server/service and the plugin captures the notification, sends an event via our callbacks.<br><strong>OneSignal</strong> : Not Available Currently in V2.</p>                                                                                               |
|                                   |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| Uses Location Based Notifications | Enabling this will add the required permissions for location usage                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| Android Properties                | <p>Android specific properties</p><p><strong>Allow Vibration</strong> : Enable this if vibration needs to be played on receiving a notification<br><strong>White Small Icon</strong> : Set the texture that needs to be used as small icon on devices >= Lollipop<br><strong>Coloured Small Icon :</strong> Set the texture that needs to be used as small icon for devices &#x3C; Lollipop<br><strong>Allow Notification Display when Foreground :</strong> Enabling this will show the notification even when device is foreground<br><strong>Accent Color :</strong> Accent color for the small icon</p> |
| Payload Keys                      | Payload keys that you can configure if your backend uses different keys                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |

![Details of an Android Notification](<../../.gitbook/assets/AndroidNotification Details.png>)

## Setting custom resources

When creating a notification, you may want to set your own custom sounds or icons. For ex: SoundFileName or LargeIcon or BigPicture variables of INotification.

You need to place these files under **Assets/StreamingAssets** folder.

{% hint style="danger" %}
If you are upgrading from 1.x version, please move your files from **PluginResources** folder to **Assets/StreamingAssets** folder.
{% endhint %}

## Platform specific setup

{% content-ref url="ios.md" %}
[ios.md](ios.md)
{% endcontent-ref %}

{% content-ref url="android.md" %}
[android.md](android.md)
{% endcontent-ref %}







