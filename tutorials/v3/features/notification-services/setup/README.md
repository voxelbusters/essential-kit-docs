# Setup

## :white\_check\_mark: Enable Feature

Open [Essential Kit Settings](../../../plugin-overview/settings.md) and enable Notification Services feature in the inspector.

<figure><img src="../../../.gitbook/assets/notification-services-settings.gif" alt=""><figcaption></figcaption></figure>

### Properties

| Name                                       | Description                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| ------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Presentation Options                       | <p>Setting for how to present the notification</p><p><strong>None</strong> : On receiving a notification, there won't be any display or badge or sound</p><p><strong>Alert</strong> : On receiving a notification, it's displayed with UI</p><p><strong>Badge</strong> : On receiving a notification, badge will be displayed on the app icon</p><p><strong>Sound</strong> : On receiving a notification, sound will be played</p>             |
| Push Notification Service Type             | <p>Enable which service you want to use for Push/Remote Notifications.<br><strong>None</strong> : No Remote notification service will be enabled. You can still use Local notifications though.<br><strong>Custom</strong> : This activates the client side of receiving the remote notifications. You can send a data message payload via your server/service and the plugin captures the notification, sends an event via our callbacks.</p> |
| **Android Properties**                     |                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| Allow Vibration                            | Enable this if vibration needs to be played on receiving a notification                                                                                                                                                                                                                                                                                                                                                                        |
| White Small Icon                           | Set the texture that needs to be used as small icon on devices >= Lollipop. <mark style="color:green;">The icon needs to be white transparent icon something like</mark> [<mark style="color:purple;">this</mark>](https://romannurik.github.io/AndroidAssetStudio/icons-notification.html#source.type=clipart\&source.clipart=ac_unit\&source.space.trim=1\&source.space.pad=0\&name=ic_stat_ac_unit)<mark style="color:green;">.</mark>      |
| Coloured Small Icon                        | Set the texture that needs to be used as small icon for devices < Lollipop                                                                                                                                                                                                                                                                                                                                                                     |
| Allow Notification Display when Foreground | <p>Enabling this will show the notification even when device is foreground</p><p><br></p>                                                                                                                                                                                                                                                                                                                                                      |
| Accent Color                               | Accent color for the small icon                                                                                                                                                                                                                                                                                                                                                                                                                |
| Payload Keys                               | Payload keys that you can configure if your backend uses different keys                                                                                                                                                                                                                                                                                                                                                                        |
| **Advanced Settings**                      | <p><strong>Exact Timing Settings</strong> - Allows the app to schedule at "exact time" specified when scheduling the notification. This is only allowed for very specific set of apps like alarm apps.<br><br><strong>Can Ignore Doze Mode</strong> -<br>When exact timing is on, if the notification even wants to interrupt in Doze mode(Sleep mode), enable this.</p>                                                                       |



![Details of an Android Notification](<../../../.gitbook/assets/AndroidNotification Details.png>)

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







