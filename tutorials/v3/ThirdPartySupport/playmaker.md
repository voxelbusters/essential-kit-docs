---
description: Use Essential Kit mobile features through PlayMaker actions (no-code).
---

# PlayMaker (Third Party Support)

Essential Kit provides a cross-platform way to access native **iOS/Android** functionality from Unity (in-app purchases, notifications, deep links, sharing, web view, cloud save, native UI, network status, and more).  
The **Essential Kit for PlayMaker** integration exposes these features as PlayMaker custom actions, so you can build flows without writing code.

## Get Started

1. Have [**Essential Kit**](https://link.voxelbusters.com/essential-kit) installed in your project.
2. Have **PlayMaker** installed in your project.
3. [Download](https://u3d.as/3LwU) and import **Essential Kit for PlayMaker** (free): 

After importing, you should see the integration under `Assets/Plugins/VoxelBusters/EssentialKit/ThirdPartySupport/PlayMaker/`.

## Enable Essential Kit Features

Enable only the features you plan to use (for example: Billing Services, Notification Services, Deep Link Services).

- Open the Essential Kit settings and enable the required feature modules.
- Refer to the settings guide for details: [Settings](../plugin-overview/settings.md)

## Finding PlayMaker Actions

In your FSM, add an action and search by **feature name** (common prefixes):

- `BillingServices*`, `NotificationServices*`, `DeepLinkServices*`, `GameServices*`, `CloudServices*`, `WebView*`, `Sharing*`, `MediaServices*`, `NativeUI*`, `NetworkServices*`, `TaskServices*`, `RateMyApp*`, `AppShortcuts*`, `AppUpdater*`, `AddressBook*`, `Utilities*`

**Common pattern**

- Add the feature’s **listener** action (for events/callbacks) in a state that stays active.
- Call the **trigger** action (to start the operation).
- On success/failure events, use the matching **Get\*** action to read cached results/errors.

## Feature Docs (Actions + Use Cases)

Each feature has PlayMaker docs under its tutorial section. Use these links to jump straight to the PlayMaker pages:

| Feature | PlayMaker Docs | Use Cases |
|---|---|---|
| Address Book | [Docs](../features/address-book/playmaker/README.md) | [Use Cases](../features/address-book/playmaker/use-cases/README.md) |
| App Shortcuts | [Docs](../features/app-shortcuts/playmaker/README.md) | [Use Cases](../features/app-shortcuts/playmaker/use-cases/README.md) |
| App Updater | [Docs](../features/app-updater/playmaker/README.md) | [Use Cases](../features/app-updater/playmaker/use-cases/README.md) |
| Billing Services | [Docs](../features/billing-services/playmaker/README.md) | [Use Cases](../features/billing-services/playmaker/use-cases/README.md) |
| Cloud Services | [Docs](../features/cloud-services/playmaker/README.md) | [Use Cases](../features/cloud-services/playmaker/use-cases/README.md) |
| Deep Link Services | [Docs](../features/deep-link-services/playmaker/README.md) | [Use Cases](../features/deep-link-services/playmaker/use-cases/README.md) |
| Game Services | [Docs](../features/game-services/playmaker/README.md) | [Use Cases](../features/game-services/playmaker/use-cases/README.md) |
| Media Services | [Docs](../features/media-services/playmaker/README.md) | [Use Cases](../features/media-services/playmaker/use-cases/README.md) |
| Native UI | [Docs](../features/native-ui/playmaker/README.md) | [Use Cases](../features/native-ui/playmaker/use-cases/README.md) |
| Network Services | [Docs](../features/network-services/playmaker/README.md) | [Use Cases](../features/network-services/playmaker/use-cases/README.md) |
| Notification Services | [Docs](../features/notification-services/playmaker/README.md) | [Use Cases](../features/notification-services/playmaker/use-cases/README.md) |
| Rate My App | [Docs](../features/rate-my-app/playmaker/README.md) | [Use Cases](../features/rate-my-app/playmaker/use-cases/README.md) |
| Sharing | [Docs](../features/sharing/playmaker/README.md) | [Use Cases](../features/sharing/playmaker/use-cases/README.md) |
| Task Services | [Docs](../features/task-services/playmaker/README.md) | [Use Cases](../features/task-services/playmaker/use-cases/README.md) |
| Utilities | [Docs](../features/utilities/playmaker/README.md) | [Use Cases](../features/utilities/playmaker/use-cases/README.md) |
| Web View | [Docs](../features/web-view/playmaker/README.md) | [Use Cases](../features/web-view/playmaker/use-cases/README.md) |

