# Version 2.0.2



1. Uninstall existing version from Window -> Voxel Busters -> Essential Kit -> Uninstall
2. Delete Assets/External Dependency Manager folder
3. Import the new update
4. Run once Window -> Voxel Busters -> Essential Kit -> Force Update Library Dependencies

**New**

* Added Date Picker demo
* Added IdToken in server credentials of GameServices for Android
* Added LoadServerCredentials in Game Services
* Added PriceCurrencyCode to billing product properties
* Added Signout in Game Services
* Added backward compatibility for cloud services on Android
* Added date picker on iOS&#x20;
* Added option for disabling back navigation key in webview on Android&#x20;
* Added option to force resolve libraries on Android from menu&#x20;
* Added scope(profile and email) selection for Game Services on Android&#x20;
* Added signature and purchase data for Billing Transaction on Android (used for receipt verification on servers)
* Added support for Android 11 (beta - Will be using queries tag once unity supports latest gradle)
* Added utility method for Application badge icon in Notification Services
* Adding firebase messaging libraries only when push notification service type is set to other than none
* Adding library dependencies as per features selected on Android
* Allowing feature selection in low stripping mode (This allows to select features but code is not stripped)
* Dynamic generation of dependency libraries based on feature usage

**Fixes**

* Enabling native ui native library by default on Android as its used in many other features
* Fixed Achivement image loading on Android
* Fixed Capture Image functionality in Media Services
* Fixed TimeTrigger Notification callback on Android
* Fixed alert demo screen layout issue
* Fixed alert display in Silent login for Game Services on Android
* Fixed broken image sharing on Android
* Fixed crash in finishBillingTransaction call if transaction is empty or failed
* Fixed exif check error in Media Services on Android
* Fixed exporter when only deep links or notifications are enabled for iO**S**
* Fixed infinite loop in cloud services login when user cancels the login or network failure on Andriod
* Fixed loadServerCredentials when no email is provided
* Fixed loading leaderboards and score reporting in OnAuthenticationChanged callback on Android
* Fixed local verification in Billing for iOS
* Fixed methods which need to be called from main thread when triggering callbacks
* Fixed missing callbacks which are not dispatched on unity thread
* Fixed missing meta files
* Fixed path while using unity screenshot api
* Fixed paths in xcode project when exporting from windows
* Fixed warnings for un-assigned variables
* Handled price value to string conversion to be culture invariant
* Profile scope setting
* Set Leaderboad query size to 10 by default on Android
* Setting null for local player when user signout
* Sharing show now waits till end of the frame to finish any screenshot capturing
* Update tutorial page links • Updated export scripts with 2019.3+ changes
* Using bytes instead of sbytes on Unity version less than 2019
* Using culture invariant in JsonWriter when storing primitives
* Using purchaseToken for receipt in BillingTransaction on Android

\
