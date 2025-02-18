# Release Notes

### Features & Enhancements

* \[<mark style="color:green;">Enhancement</mark>] \[Address Book] Implemented page based access
* \[<mark style="color:green;">Enhancement</mark>] \[Address Book] Added API to access based on constraints (MustIncludeName, MustIncludePhoneNumber, MustIncludeEmail)
* \[<mark style="color:purple;">Feature</mark>] \[App Shortcuts] Add app shortcuts to your application icon
* \[<mark style="color:purple;">Feature</mark>] \[App Updater] Seamless access of app updates across supported platforms
* \[<mark style="color:purple;">Feature</mark>] \[Billing Services] Added Subscriptions
* \[<mark style="color:purple;">Feature</mark>] \[Billing Services] Added Multi-offer support and redemption (Introductory, Promotional offer types)
* \[<mark style="color:purple;">Feature</mark>] \[Billing Services] Added access to PayOut information per billing product
* \[<mark style="color:green;">Enhancement</mark>] \[Billing Services] Implemented Store Kit 2 on iOS and Google Billing Client V7 on Android
* \[<mark style="color:green;">Enhancement</mark>] \[Billing Services] Providing product access in billing transaction
* \[<mark style="color:green;">Enhancement</mark>] \[Billing Services] Providing access to both purchased quantity and requested quantity for billing transaction
* \[<mark style="color:green;">Enhancement</mark>] \[Billing Services] Added option to force refresh restore purchases (passing true for forceRefresh may trigger login prompt on iOS)
* \[<mark style="color:green;">Enhancement</mark>] \[Billing Services] Restore purchases called internally automatically at the time of initialisation
* \[<mark style="color:green;">Enhancement</mark>] \[Billing Services] Added support to mark unused billing products in-active for backward compatibility
* \[<mark style="color:green;">Enhancement</mark>] \[Billing Services] Provided access to raw transaction data via rawData property along with other details based on platform (on android additionally signature property is added)
* \[<mark style="color:green;">Enhancement</mark>] \[Billing Services] Removed dependency on OpenSSL as it's difficult to maintain security updates and binary size
* \[<mark style="color:purple;">Feature</mark>] \[Cloud Services] Added auto data sync based on app lifecycle
* \[<mark style="color:green;">Enhancement</mark>] \[Cloud Services] Syncronize call is thread safe now and allows calls in parallel
* \[<mark style="color:green;">Fix</mark>] \[Deep Link Services] Fixed deep link launch event
* \[<mark style="color:purple;">Feature</mark>] \[Game Services] Added option to add context(string) to the submitted score
* \[<mark style="color:purple;">Feature</mark>] \[Game Services] Added Friends access api
* \[<mark style="color:green;">Enhancement</mark>] \[Game Services] Upgraded to Google Play Services V2 on Android
* \[<mark style="color:green;">Enhancement</mark>] \[Game Services] Updated Game Center native calls to latest api
* \[<mark style="color:green;">Enhancement</mark>] \[Game Services] Fetch server credentials with refresh token on Android
* \[<mark style="color:green;">Enhancement</mark>] \[Game Services] Added LegacyId(for backward compatibility), GameScopeId and DeveloperScopeId
* \[<mark style="color:green;">Enhancement</mark>] \[Game Services] Added LegacyId(for backward compatibility), GameScopeId and DeveloperScopeId
* \[<mark style="color:green;">Enhancement</mark>] \[Media Services] Refactored api to have more functionality. Now Select, Capture and Save all takes additional options
* \[<mark style="color:green;">Enhancement</mark>] \[Media Services] Allowing save media content to set custom file name and album
* \[<mark style="color:green;">Enhancement</mark>] \[Media Services] Api now supports more media content types than just images
* \[<mark style="color:purple;">Feature</mark>] \[Notification Services] Added calendar trigger with repeat functionality
* \[<mark style="color:purple;">Feature</mark>] \[Notification Services] Added option to set notification priority level
* \[<mark style="color:green;">Enhancement</mark>] \[Notification Services] Past time scheduled notifications will throw error now
* \[<mark style="color:green;">Enhancement</mark>] \[Rate My App] Added option to control auto show rate dialog (Now you can just set the settings, disable auto show and check if conditions are satisfied with IsAllowedToRate method)
* \[<mark style="color:green;">Enhancement</mark>] \[Rate My App] Added option to instantly rate by optionally showing a pre-confirmation dialog
* \[<mark style="color:green;">Enhancement</mark>] \[Social Sharing] Now share more generic content with attachments (compared to only images earlier)
* \[<mark style="color:purple;">Feature</mark>] \[Task Services] Allow your app tasks to finish in background

### Breaking

* \[Billing Services] Use Product, RequestedQuantity, PurchasedQuantity properties in IBillingTransaction instead of Payment property
* \[Media Services] Permission request calls are removed for ease. Instead directly use SelectMediaContent, CaptureMediaContent and SaveMediaContent with options.
* \[Notification Services] Earlier HIGH was the priority set by default. **Now** it's configurable and **default value is Medium.**
* <mark style="color:red;background-color:red;">\[Game Services] If you are using LocalPlayer.Id to identify your account, make sure you handle it carefully as it returns gameScopeId instead of old Id. If you want to still use old id, please use legacyId.</mark>

### Misc

* Added error codes along with native descriptions for all features
* Removed and updated deprecated native methods usage
* Cleaner settings inspector display with backgrounds
* .gitignore files are added to skip tracking regenerated files

### Deprecated

* \[<mark style="color:orange;">Deprecated</mark>] \[Billing Services] Payment property in IBillingTransaction is now obsolete
* \[<mark style="color:orange;">Deprecated</mark>] \[Billing Services] Tag property in Billing Product obsolete. Use Payouts instead.
* \[<mark style="color:orange;">Deprecated</mark>] \[Billing Services] AndroidProperties in IBillingTransaction is now obsolete. Use rawData instead.
* \[<mark style="color:orange;">Deprecated</mark>] \[Game Services] IScore is is now obsolete. Use ILeaderboardScore instead.
* \[<mark style="color:orange;">Deprecated</mark>] \[Game Services] LoadPlayers is is now obsolete due to platform restrictions.

Removed

* \[<mark style="color:red;">Removed</mark>] \[Billing Services] VerifyPaymentReceipts option in settings removed as we auto verify locally by default
* \[<mark style="color:red;">Removed</mark>] \[Cloud Services] SyncInterval is now removed in settings and we auto sync based on app lifecycle
* \[<mark style="color:red;">Removed</mark>] \[Game Services] Removed idToken and emailId properties access
* \[<mark style="color:red;">Removed</mark>] \[Media Services] Removed permission api calls as we handle the permission directly in the first call of the related functionality
* \[<mark style="color:red;">Removed</mark>] \[Rate My app] Removed IRateMyAppController for better api usability. Check new methods in RateMyApp class for achieving similar functionality
* \[<mark style="color:red;">Removed</mark>] \[Notification Services] Removed location based trigger as it's not used
