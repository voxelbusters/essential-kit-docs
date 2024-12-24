# Setup

Before using any of the Cloud services, we need to configure them in the [Essential Kit Settings](../../../plugin-overview/settings.md) under cloud services.

## :white\_check\_mark:Enable Feature

Open [Essential Kit Settings](../../../plugin-overview/settings.md) and enable Cloud Services feature in the inspector.

<figure><img src="../../../.gitbook/assets/cloud-services-settings.gif" alt=""><figcaption><p>Cloud Services Settings</p></figcaption></figure>

{% hint style="warning" %}
If you are NOT planning to use Game Services along with Cloud Services, you still need to fill the **Play Services Application Id** entry in Game Services settings (and can  disable it).\
\
This is because, on Android, Cloud services is internally dependent on Google play services.
{% endhint %}

### Properties

| Name                                             | Description                                                                                         |
| ------------------------------------------------ | --------------------------------------------------------------------------------------------------- |
| <p>(Android)<br>Play Services Application Id</p> | This value gets auto filled once you set the value of Play Services Application Id in Game Services |

{% hint style="success" %}
To have similar behaviour across iOS and Android, we auto sync internally in Android on major events (when app state changes). This makes sure your data is up to date.
{% endhint %}
