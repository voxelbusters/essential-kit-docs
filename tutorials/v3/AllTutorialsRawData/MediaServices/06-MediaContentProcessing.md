# Media Services Tutorial - Media Content Processing

## What is Media Content Processing?

Media content processing involves converting `IMediaContent` objects (returned from selection and capture operations) into different formats that your Unity mobile game can work with. Essential Kit provides flexible conversion options to match your specific game requirements.

## Why Process Media Content in Unity Mobile Games?

Media processing enables:
- Converting images to Unity Texture2D for immediate rendering
- Accessing raw media data for custom processing algorithms  
- Saving media files to persistent storage locations
- Integrating media content with Unity's asset pipeline
- Creating custom media manipulation tools

## Converting to Texture2D

Use `AsTexture2D()` to convert media content for Unity rendering:

```csharp
using VoxelBusters.EssentialKit;

void ProcessSelectedImage(IMediaContent content)
{
    content.AsTexture2D((texture, error) => {
        if (error == null && texture != null)
        {
            Debug.Log($"Converted to texture: {texture.width}x{texture.height}");
            // Use texture in your game UI or 3D objects
            ApplyTextureToGameObject(texture);
        }
        else
        {
            Debug.Log($"Texture conversion failed: {error}");
        }
    });
}

void ApplyTextureToGameObject(Texture2D texture)
{
    // Apply texture to a UI Image component or material
    var renderer = GetComponent<Renderer>();
    renderer.material.mainTexture = texture;
}
```

This snippet converts selected media content to a Unity Texture2D for immediate use in your game.

## Accessing Raw Media Data

Use `AsRawMediaData()` to get the underlying media bytes and metadata:

```csharp
using VoxelBusters.EssentialKit;

void ProcessRawMediaData(IMediaContent content)
{
    content.AsRawMediaData((rawData, error) => {
        if (error == null && rawData != null)
        {
            Debug.Log($"Raw data size: {rawData.Data.Length} bytes");
            Debug.Log($"MIME type: {rawData.Mime}");
            
            // Process raw bytes for custom functionality
            ProcessCustomFormat(rawData.Data, rawData.Mime);
        }
        else
        {
            Debug.Log($"Raw data access failed: {error}");
        }
    });
}

void ProcessCustomFormat(byte[] data, string mimeType)
{
    // Custom processing based on MIME type
    switch (mimeType)
    {
        case MimeType.kPNGImage:
            Debug.Log("Processing PNG image data");
            break;
        case MimeType.kJPGImage:
            Debug.Log("Processing JPEG image data");
            break;
        default:
            Debug.Log($"Processing {mimeType} data");
            break;
    }
}
```

This example demonstrates accessing raw media bytes and MIME type information for custom processing.

## Saving to File Path

Use `AsFilePath()` to save media content to a specific location:

```csharp
using VoxelBusters.EssentialKit;

void SaveToCustomLocation(IMediaContent content)
{
    string saveDirectory = Application.persistentDataPath + "/UserMedia";
    string fileName = $"imported_media_{System.DateTime.Now:yyyyMMdd_HHmmss}";
    
    content.AsFilePath(saveDirectory, fileName, (filePath, error) => {
        if (error == null)
        {
            Debug.Log($"Media saved to: {filePath}");
            // Store file path for later access
            PlayerPrefs.SetString("LastImportedMedia", filePath);
        }
        else
        {
            Debug.Log($"File save failed: {error}");
        }
    });
}
```

This snippet saves media content to your app's persistent data directory.

## Complete Processing Workflow

Here's a comprehensive example showing different processing options:

```csharp
using VoxelBusters.EssentialKit;
using UnityEngine;

public class MediaProcessor : MonoBehaviour
{
    [SerializeField] private RawImage previewImage;
    
    public void ProcessMediaContent(IMediaContent content)
    {
        // Option 1: Convert to Texture2D for UI display
        ConvertToTexture(content);
        
        // Option 2: Save to persistent storage
        SaveToPersistentData(content);
        
        // Option 3: Access raw data for analysis
        AnalyzeRawData(content);
    }
    
    void ConvertToTexture(IMediaContent content)
    {
        content.AsTexture2D((texture, error) => {
            if (error == null && texture != null)
            {
                Debug.Log("Displaying texture in UI");
                previewImage.texture = texture;
            }
        });
    }
    
    void SaveToPersistentData(IMediaContent content)
    {
        string directory = Application.persistentDataPath + "/GameMedia";
        content.AsFilePath(directory, "processed_media", (path, error) => {
            if (error == null)
            {
                Debug.Log($"Saved for future use: {path}");
            }
        });
    }
    
    void AnalyzeRawData(IMediaContent content)
    {
        content.AsRawMediaData((rawData, error) => {
            if (error == null)
            {
                Debug.Log($"Media analysis: {rawData.Data.Length} bytes, type: {rawData.Mime}");
            }
        });
    }
}
```

This example demonstrates a complete media processing workflow for Unity cross-platform applications.

## Error Handling in Processing

Always handle processing errors appropriately:

```csharp
void HandleProcessingError(Error error)
{
    var errorCode = (MediaServicesErrorCode)error.Code;
    switch (errorCode)
    {
        case MediaServicesErrorCode.DataNotAvailable:
            Debug.Log("Media content is not available for processing");
            break;
        default:
            Debug.Log($"Processing error: {error}");
            break;
    }
}
```

This ensures robust media processing across different Unity iOS and Unity Android scenarios.

📌 **Video Note**: Show Unity demo of all three conversion types in action - displaying images in UI, saving to files, and processing raw data - demonstrating the flexibility of the media processing system.