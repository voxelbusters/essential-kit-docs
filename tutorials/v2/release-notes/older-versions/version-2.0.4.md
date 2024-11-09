# Version 2.0.4

1. Uninstall existing version from Window -> Voxel Busters -> Essential Kit -> Uninstall
2. Delete Assets/External Dependency Manager folder
3. Import the new update
4. Run once Window -> Voxel Busters -> Essential Kit -> Force Update Library Dependencies
5. Run Assets -> External Dependency Manager -> Android -> Force Resolve from "top menu bar"

**Fixes**

* Fixed a rare crash when no earlier purchases on Android&#x20;
* Fixed saving to cloud when non-ascii chars exist while setting byte array on Android&#x20;
* Fixed notification event when not fired while app is foreground and notifications are allowed in foreground on Android&#x20;
* Fixed notification event trigger when not fired when clicked on notification other than at launch time&#x20;
* Fixed notification event trigger to fire after at-least one event registration after launch&#x20;
* Fixed launch notification event crash issue on iOS&#x20;
* Fixed unexposed web view message event&#x20;
* Fixed layout of toolbar items when safe areas exist on ios&#x20;
* Fixed issue when callback is not firing when pick gallery is triggered on iOS(iPhone)&#x20;

**Changes**

* Disabling RateMyApp by default (as it popups unexpectedly - based on feedback)

