# Select Photo from Gallery

## Goal
Allow users to select one or more photos from their device gallery.

## Actions Required
| Action | Purpose |
|--------|---------|
| MediaServicesGetGalleryAccessStatus | Read current gallery permission status (Read mode) |
| MediaServicesSelectContent | Open gallery picker |
| MediaServicesGetSelectContentSuccessResult | Get selection count |
| MediaServicesGetContentTexture | Convert selected photo to Texture2D |
| MediaServicesGetSelectContentError | Read cached error after failure (optional) |

## Variables Needed
- galleryStatus (Enum: GalleryAccessStatus)
- contentCount (Int)
- selectedTexture (Texture2D)
- contentIndex (Int) = 0

## Implementation Steps

### 1. State: CheckGalleryPermission
**Action:** MediaServicesGetGalleryAccessStatus
- **Inputs:**
  - accessMode: Read
- **Outputs:**
  - status → galleryStatus
- **Next:** Use an Enum Switch/Compare on `galleryStatus`:
  - `Authorized` / `NotDetermined` / `Limited` → SelectPhoto
  - `Denied` / `Restricted` → ShowPermissionError

### 2. State: SelectPhoto
**Action:** MediaServicesSelectContent
- **Inputs:**
  - mediaType: Image
  - allowsMultipleSelection: false
  - maxCount: 1 (ignored when multiple selection is off)
- **Events:**
  - successEvent → GetSelectionResult
  - failureEvent → HandleCancellationOrError

**Note:** Opens native photo picker UI.

### 3. State: GetSelectionResult
**Action:** MediaServicesGetSelectContentSuccessResult
- **Outputs:**
  - contentCount → contentCount
  - hasContent → (bool)
- **Next:** `contentCount` is always `>= 1` here (the select action fires FAILURE when nothing is selected). Go to ConvertToTexture.

### 4. State: ConvertToTexture
**Action:** MediaServicesGetContentTexture
- **Inputs:**
  - contentIndex: contentIndex (0 for single selection)
- **Outputs:**
  - texture → selectedTexture
- **Next:** This action finishes when conversion completes. Use the state’s `FINISHED` transition → DisplayPhoto.

### 5. State: DisplayPhoto
Assign selectedTexture to UI Image component.

## Selection Flow
```
CheckGalleryPermission
    └─ SelectPhoto (allowsMultipleSelection: false)
        └─ GetSelectionResult
            └─ ConvertToTexture (index: 0)
                └─ DisplayPhoto
```

## Multi-Select Variation

For selecting multiple photos:

**SelectPhoto with:**
- allowsMultipleSelection: true
- maxCount: 5 (or desired limit)

**Loop through selections:**
```
Loop i from 0 to (contentCount - 1):
    MediaServicesGetContentTexture (contentIndex: i)
    Add texture to gallery UI
```

## Common Issues

- **No Permission**: iOS users must grant Photos access
- **User Cancelled / No selection**: this typically triggers `failureEvent`. `MediaServicesGetSelectContentError` may be empty depending on platform callback.
- **Large Images**: Selected photos can be multi-megabyte; consider compression
- **contentCount = 0**: User may have deselected all photos before confirming

## Platform Differences

**iOS:**
- Shows native Photos app picker
- "Privacy - Photo Library Usage Description" required in Info.plist
- iOS 14+: User can grant limited access to specific photos

**Android:**
- Shows system photo picker or gallery app
- READ_EXTERNAL_STORAGE permission required (older Android versions)

## Performance Tips

- **Lazy Loading**: For multi-select, load textures on-demand as user scrolls
- **Thumbnail Generation**: Create smaller thumbnails for gallery views
- **Background Loading**: Convert large images to textures off main thread if possible
