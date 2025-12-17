# Setup

Before using any of the Cloud services, we need to configure them in the [Essential Kit Settings](../../overview/settings.md) under cloud services.

## :white\_check\_mark:Enable Feature

Open [Essential Kit Settings](../../overview/settings.md) and enable Cloud Services feature in the inspector.

![Enable Cloud Services feature from Essential Kit Settings](../../.gitbook/assets/EnableCloudServices.gif)

{% hint style="warning" %}
If you are NOT planning to use Game Services along with Cloud Services, you still need to fill the **Play Services Application Id** entry in Game Services settings (and can  disable it).\
\
This is because, on Android, Cloud services is internally dependent on Google play services.
{% endhint %}

###

### Properties

| Name                | Description                                                                                                 |
| ------------------- | ----------------------------------------------------------------------------------------------------------- |
| Synchronize On Load | Enabling this lets cloud services to connect as soon as app is launched.                                    |
| Sync Interval       | Setting this value allows you to control how frequent you want your data to get in sync with cloud servers. |

{% hint style="danger" %}
Enabling Synchronize on load, on Android, may open google play services login if user isn't logged at-least once. So, it's good to call first **Synchronize** call as per your game requirements.
{% endhint %}

