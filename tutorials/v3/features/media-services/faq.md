# FAQ

## On Android, why the images are not getting saved?

You need to have read-write access for writing images to gallery. Make sure you request it with RequestGalleryAccess by passing GalleryAccessMode.ReadWrite mode.

Also, if you are in development mode, there is a chance to have a restricted permission set by unity for write permission. However, this isn't an issue in release mode. In future, we may overcome this issue through our post process scripts.

## Do we need to add the permissions in AndroidManifest and info.plist?

No. We automatically add the required permissions on the final builds. All you need to do is just [enable the properties](setup.md#properties) as per your usage in Essential Kit Settings.

