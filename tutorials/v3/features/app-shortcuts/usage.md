---
description: App shortcuts feature allows to add quick shortcut actions to the app icon
---

# Usage

All App Shortcuts features can be accessible from **AppShortcuts** static class.&#x20;

Before using any of the plugin's features, you need to import the namespace.

```
using VoxelBusters.EssentialKit;
using VoxelBusters.CoreLibrary;
```

## Add Shortcut

To add a shortcut, create an unique id to identify the shortcut. Along with it, it's possible to pass few more configuration options like

* **Identifier** (Required) - Unique identifier to identify this shortcut item
* **Title** (Required) - Title displayed for the shortcut item
* **SubTitle** - Subtitle to be displayed for the shortcut (May not be supported on all platforms)
* **IconFileName** - File name with extension which will be shown in the shortcut item

To pass these properties, you can **create an AppShortcutItem** with AppShortcutItem.Builder.

```csharp
using VoxelBusters.EssentialKit;
using VoxelBusters.CoreLibrary;

private AppShortcutItem CreateAppShortcutItem()
{
   AppShortcutItem dailyRewardShortcutItem = new AppShortcutItem.Builder("daily-reward-id", "Daily Reward")
                        .SetSubtitle("Your rewards are waiting!")
                        .SetIconFileName("daily-reward.png")//Make sure you refer the same icon texture in AppShortcuts settings inspector.
                        .Build();
                        
   return dailyRewardShortcutItem;
}
```

Once you create an App Shortcut Item instance, you can pass it to Add method as below.

```csharp
using VoxelBusters.EssentialKit;
using VoxelBusters.CoreLibrary;
public void AddShortcut()
{
    AppShortcutItem shortcutItem = CreateAppShortcutItem();
    AppShorcuts.Add(dailyRewardShortcutItem);
}

private AppShortcutItem CreateAppShortcutItem()
{
   AppShortcutItem dailyRewardShortcutItem = new AppShortcutItem.Builder("daily-reward-id", "Daily Reward")
                        .SetSubtitle("Your rewards are waiting!")
                        .SetIconFileName("daily-reward.png")//Make sure you refer the same icon texture in AppShortcuts settings inspector.
                        .Build();
                        
   return dailyRewardShortcutItem;
}
```

## Remove Shortcut

Once after you added a shortcut, you can remove it anytime with Remove method by passing a shortcut identifier.

```csharp
AppShortcuts.Remove("your-shortcut-identifier);
```

## Events

If any shortcut is clicked by the user, we fire an event **AppShortcuts.OnShortcutClicked** which has the identifier of the shortcut clicked.

```csharp
using VoxelBusters.EssentialKit;
using VoxelBusters.CoreLibrary;
//...
private void OnEnable()
{
    AppShortcuts.OnShortcutClicked = OnShortcutClicked;
}


private void OnDisable()
{
    AppShortcuts.OnShortcutClicked = OnShortcutClicked;
}


private void OnShortcutClicked(string shortcutIdentifier)
{
    Debug.Log("Clicked shortcut identifier: " + shortcutIdentifier);
}
```

{% hint style="success" %}
Once a user clicks on app icon shortcut, it opens the app.&#x20;

It's not required or possible to register the events at very start of your game.&#x20;

So, we do cache it and fire them as soon as you register the event. \
Cool right? 👏👏👏
{% endhint %}



