# Media Services - PlayMaker

Capture media from camera, select from gallery, and save images to the device gallery.

## Actions (12)
- Permission status (sync): `MediaServicesGetCameraAccessStatus`, `MediaServicesGetGalleryAccessStatus`
- Capture (async): `MediaServicesCaptureContent`, `MediaServicesGetCaptureContentError`
- Select (async): `MediaServicesSelectContent`, `MediaServicesGetSelectContentSuccessResult`, `MediaServicesGetSelectContentError`
- Save (async): `MediaServicesSaveContent`, `MediaServicesGetSaveContentError`
- Content converters (async; run in their own state and use `FINISHED`):
  - `MediaServicesGetContentTexture` (images → Texture2D)
  - `MediaServicesGetContentFilePath` (temp file path)
  - `MediaServicesGetContentRawMediaData` (bytes + MIME type)

## Key patterns
- **Permission checks are status-only**: the access status actions do not fire events. Branch using Enum Compare/Switch on the returned `status`.
- **Trigger actions fire events**: `CaptureContent`, `SelectContent`, `SaveContent` fire `successEvent` / `failureEvent`.
- **Converter actions have no success/failure events**: they finish when the async conversion completes (or log an error). Put them alone in a state and transition on `FINISHED`.
- **Cached content index**: after SUCCESS, use `contentIndex = 0..contentCount-1`. Converters fall back to the last captured content when no selection is cached.

## Use cases
Start here: `use-cases/README.md`
