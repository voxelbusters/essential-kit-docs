# FAQ

## Do we need to manually add the required permissions?

No. Plugin takes care of it. It automatically adds the required permissions in the AndroidManifest and info.plist files on Android and iOS respectively.

## If user deny  contacts access permission, How to proceed further?

Explain the reason why your game/app needs the permission before requesting it. If user deny it accidentally, you can let the user manually enable it from settings and you can open the application settings screen with  **Utilities.OpenApplicationSettings** method.

