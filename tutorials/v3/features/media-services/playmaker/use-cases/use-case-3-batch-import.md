# Batch Import Multiple Images

## Goal
Allow users to select multiple photos from gallery and get file paths for processing or uploading.

## Actions Required
| Action | Purpose |
|--------|---------|
| MediaServicesSelectContent | Select multiple images |
| MediaServicesGetSelectContentSuccessResult | Get selection count |
| MediaServicesGetContentFilePath | Get file path for each image |
| MediaServicesGetSelectContentError | Read cached error after failure (optional) |

## Variables Needed
- contentCount (Int)
- currentIndex (Int) = 0
- filePath (String)
- tempDirectory (String) = "ImportedMedia" (optional)
- tempBaseFileName (String) = "photo" (optional)

## Implementation Steps

### 1. State: SelectMultiplePhotos
**Action:** MediaServicesSelectContent
- **Inputs:**
  - mediaType: Image
  - allowsMultipleSelection: true
  - maxCount: 5 (limit to 5 photos)
- **Events:**
  - successEvent → GetSelectionCount
  - failureEvent → HandleCancellationOrError

### 2. State: GetSelectionCount
**Action:** MediaServicesGetSelectContentSuccessResult
- **Outputs:**
  - contentCount → contentCount
- **Transition:**
  - Set currentIndex = 0
  - Go to LoopStart

### 3. State: LoopStart
**Logic:** Int Compare
- If currentIndex < contentCount → GetFilePath
- If currentIndex >= contentCount → ProcessComplete

### 4. State: GetFilePath
**Action:** MediaServicesGetContentFilePath
- **Inputs:**
  - contentIndex: currentIndex
  - tempDirectory: tempDirectory
  - tempFileName: tempBaseFileName
- **Outputs:**
  - filePath → filePath variable
- **Next:** This action finishes when the file path is ready. Use the state’s `FINISHED` transition → ProcessFilePath (or StoreFilePath).

### 5. State: ProcessFilePath
Use `filePath` immediately (upload/process/move to persistent storage), then:
- Increment currentIndex
- Return to LoopStart

### 6. State: ProcessComplete
All selected items processed.

## Batch Import Flow
```
SelectMultiplePhotos (maxCount: 5)
    └─ GetSelectionCount
        └─ Loop (0 to contentCount-1)
            └─ GetFilePath(currentIndex)
                └─ ProcessFilePath
        └─ ProcessComplete
```

## File Path Usage

**Local Processing:**
```
For each filePath in filePathsList:
    Read file from path
    Compress/resize image
    Save to persistent storage
```

**Server Upload:**
```
For each filePath in filePathsList:
    Read file as bytes
    POST to server: /upload-photo
    Track upload progress
```

## Common Issues

- **Temporary Files**: Paths point to a temp cache; copy/move to `Application.persistentDataPath` if you need them long-term
- **Copy to Persistent**: Move files to Application.persistentDataPath if needed long-term
- **Large Batches**: Limit maxCount to prevent memory issues (recommend 5-10 max)
- **File Format**: Images may be in various formats (JPG, PNG, HEIC); handle accordingly

## Platform Differences

**iOS:**
- Files are copied to app's temp directory
- HEIC format common on newer devices (may need conversion)

**Android:**
- Files may reference original gallery locations
- Permissions required to read external storage

## Performance Tips

**Background Processing:**
- Process files off main thread to prevent UI freezing
- Show progress bar for large batches

**Progressive Upload:**
- Upload files one at a time with progress feedback
- Allow cancellation during upload

**Memory Management:**
- Don't load all images into memory simultaneously
- Process and release one at a time

## Use Cases

**Photo Album Creation:**
- User selects 5 photos
- App creates collage or album
- Saves result to gallery

**Batch Upload:**
- User selects multiple photos
- Upload to cloud storage
- Track upload status per file

## Optional (upload bytes instead of files)
If you don’t want file paths, use `MediaServicesGetContentRawMediaData` per index to get `rawBytes` + `mimeType` and upload directly.
