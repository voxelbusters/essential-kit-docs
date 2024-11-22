# Usage

Rate app features uses Native Store Review dialogs which are system dialogs and there are limits on how many times these are shown.

{% tabs %}
{% tab title="iOS" %}
![iOS rate dialog](../../.gitbook/assets/iOSAppRating.png)
{% endtab %}

{% tab title="Android" %}
![Android In-App review dialog](../../.gitbook/assets/AndroidAppRating.jpg)
{% endtab %}
{% endtabs %}



### Confirmation Prompt (optional)

Before showing the exact store rating/review dialog, you can optionally ask if the user is really ready to rate the app. You can configure the dialog in the [settings](setup.md#properties) and also you can set this to off if you don't want to show it.

{% hint style="success" %}
Make use of confirmation dialog as there are limits on how many times a rate dialog can show up on each native platform
{% endhint %}

### Limitations

To prevent spamming the user for rating the app, each native platform has their own limitations.\
So, its wise to prompt the user only when it's the right time. For ex: Showing the prompt after 10 levels of gameplay or when player archives something big while playing the game.

{% hint style="danger" %}
On iOS, there is a max cap of 3 times per year.\
On Android limited quota do exists and the information is not publicly available.
{% endhint %}

## Workflow #1 (Default) - Auto Show Rate Dialog

Once you setup the required conditions to show in settings, on every app launch plug-in detects if conditions are met.

On app launch, If the conditions are satisfied it shows up the rate dialog automatically.

Note that rate dialog presentation is subjected to a [quota](usage.md#limitations).

## Workflow #2 - Custom Show Rate Dialog

Automatically showing a popup may not be designed in some scenarios as it may showup before the main splash or home screen. To handle this you can show the rate dialog as per your choice by doing the following

* Disable "Auto Show" in settings
* Use IsAllowedToRate and AskForReviewNow

### Is Allowed to Rate

This method returns true if the settings set in Essential Kit settings conditions are met. Now you are allowed to show the rate dialog in the game.

### Ask for Review Now

This method allows you to show the rate dialog bypassing the conditions set in the settings. This can be used along with IsAllowedToRate or directly as per your requirement.

Additionally, this offers you to show a pre-confirmation dialog before actually showing the rate dialog as it's subjected to quota.

```csharp
using VoxelBusters.EssentialKit;

//...

RateMyApp.AskForReviewNow(skipConfirmation:false);
```
