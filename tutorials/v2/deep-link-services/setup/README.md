# Setup

## Overview

There are two types of deep links possible on mobile devices

1. Custom Scheme Deep Links _or_ URI Scheme Deep Links
2. Universal Deep Links

### Custom Scheme Deep Links _or_ URI Scheme Deep Links

You just need to provide a scheme of your choice for this to work. Any links pointing that scheme will be directed to your app.

These deep links aren't unique and any other app can create them like yours. If multiple apps define same URI scheme installed on the device, a dialog with list of those apps will be presented to the user.

Ex:&#x20;

1. voxelbusters://essentialkit/deep-link-services
2. voxelbusters://
3. voxelbusters://essentialkit

### Universal Deep Links

These deep links are unique and can be bounded to your app uniquely. Usually these are a bit time consuming to setup as these needs backend support as well to validate that the link belongs to your app.

Ex:&#x20;

1. &#x20;https://www.voxelbusters.com/essentialkit
2. https://www.yourgame.com/invite
3. https://www.yourgame.com/invite?referrer=brackeys

Usually universal deep links look exactly similar to the normal web links. If your app has a website too and if a page of it gets opened on mobile device, you can seamlessly redirect them to your app quickly.

There won't be any dialog to choose from (compared to URI scheme links) so it can open your app directly on clicking a registered universal deep link.

Deep links contains mainly three parts

* Scheme
* Host
* Path

Ex 1 : voxelbusters://essentialkit/deep-link-services (URI scheme deep link)

Scheme : voxelbusters\
Host : essentialkit\
Path : deep-link-services



Ex 2 : https://www.voxelbusters.com/essentialkit (Universal deep link)

\
Scheme : https\
Host : www.voxelbusters.com\
Path : essentialkit



## :white\_check\_mark: Enable Feature

Open [Essential Kit Settings](../../overview/settings.md) and enable Deep Link Services feature in the inspector.

![Enable Deep Link Services](../../.gitbook/assets/EnableDeepLinkServices.gif)

{% tabs %}
{% tab title="Settings" %}
| Name               | Description                                        |
| ------------------ | -------------------------------------------------- |
| iOS Properties     | Deep link settings for iOS platform goes here.     |
| Android Properties | Deep link settings for Android platform goes here. |
{% endtab %}

{% tab title="Deep Link Entry Properties" %}
| Name         | Description                                                                                                                                  |
| ------------ | -------------------------------------------------------------------------------------------------------------------------------------------- |
| Identifier   | An identifier for this deep link. This will be shown as a label in the chooser window if multiple applications register for the same scheme. |
| Service Type | Applicable only on iOS where you can specific the type of service being used. Leave it blank for general use.                                |
| Scheme       | Scheme part of the deep link you want to target                                                                                              |
| Host         | Host part of your deep link you want to target                                                                                               |
| Path         | Path part of your deep link you want to target                                                                                               |
{% endtab %}
{% endtabs %}





