---
description: Upgrade guide from 2.0.0
---

# Version 2.0.1

1. Uninstall existing version from Window -> Voxel Busters -> Essential Kit -> Uninstall
2. Import the new update
3. Run once Window -> Voxel Busters -> Essential Kit -> Force Update Library Dependencies
4. Please cross check **Play Services Application Id** value once and enter if it got reset (we renamed from ID to Id to maintain consistency)

### `New`

* Renamed Build folder name with TargetBuild to avoid gitignore exclusions&#x20;
* Removed "Fix Now" button to update stripping mode and limited to warning

### Misc

* Fixed media Services save to gallery for Android 10&#x20;
* Fixed sharing services screenshot sharing&#x20;
* Fixed export issues on iOS&#x20;
* Fixed billing services bugs on Android when used in advanced mode (disabling auto finish transactions option)&#x20;
* Fixed score reporting in game serivices on Android&#x20;
* Fixed paths in xcode project when exporting from windows

### Fixes

* Added Date Picker in native mode for iOS&#x20;
* Added signout feature for Android in Game Services&#x20;
* Added access to server credentials for external authentication for iOS and Android&#x20;
* Added inclusion of dependencies based on features selected&#x20;
* Added support for feature selection in low stripping mode&#x20;
* Added PriceCurrencyCode to BillingProduct properties

### New

\
