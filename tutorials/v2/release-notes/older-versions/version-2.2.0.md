# Version 2.2.0

{% hint style="warning" %}
If you are upgrading from 2.0.x, make sure you follow the upgrade steps from [2.1.0](version-2.1.0.md), else you can directly import this package.
{% endhint %}

#### New

* \[Android] Android 12 support (Api 31)
* \[iOS] iOS 15 support

#### Fixes

* \[Android] Fixed loading big size images when opening from gallery in MediaLibrary&#x20;
* \[Android] Fixed issue where permission is not sent as NotDetermined&#x20;
* \[Android] Fixed address book contact picture loading when null&#x20;
* \[Android] Wrapped exif interface dependency into media library feature&#x20;
* \[Android] Android 12 fix where it failed earlier to share to social sharing services
* \[iOS] Fixed cloud services to be backward compatible with v1&#x20;
* \[iOS] Fixed display of leaderboards and achievements to be in full screen (concern from iOS 15)&#x20;
* \[iOS] Fixed data picker display in light and dark modes&#x20;
* \[iOS] Fixed opening of target \_blank links and itms links in webview&#x20;
* \[iOS] Fixed NSLayoutConstaint warnings for webview&#x20;
* \[iOS] Fixed crash when saving to gallery from share sheet by adding the required photo library permission
