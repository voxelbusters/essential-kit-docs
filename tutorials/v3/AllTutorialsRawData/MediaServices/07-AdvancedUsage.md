# Media Services Tutorial - Advanced Usage

## Custom Initialization with Settings

For advanced scenarios, you can initialize Media Services with custom settings:

```csharp
using VoxelBusters.EssentialKit;

public void InitializeWithCustomSettings()
{
    var settings = MediaServicesUnitySettings.CreateInstance();
    // Configure custom settings as needed
    MediaServices.Initialize(settings);
    
    Debug.Log("Media Services initialized with custom settings");
}
```

This advanced initialization method allows you to pass custom Unity settings for specialized configurations.

## Checking Service Availability

Verify Media Services availability before making calls:

```csharp
using VoxelBusters.EssentialKit;

public void CheckServiceAvailability()
{
    if (MediaServices.IsAvailable())
    {
        Debug.Log("Media Services is available on this platform");
        // Proceed with media operations
    }
    else
    {
        Debug.Log("Media Services not available - using fallback");
        // Handle unavailable state gracefully
    }
}
```

This check ensures your Unity cross-platform game handles platforms where Media Services might not be supported.

## Advanced Error Handling Strategy

Implement comprehensive error handling for production apps:

```csharp
using VoxelBusters.EssentialKit;

public class AdvancedMediaHandler
{
    public void HandleMediaOperation()
    {
        var options = MediaContentSelectOptions.CreateForImage();
        MediaServices.SelectMediaContent(options, OnMediaResult);
    }
    
    void OnMediaResult(IMediaContent[] contents, Error error)
    {
        if (error != null)
        {
            HandleMediaError(error);
            return;
        }
        
        ProcessMediaWithRetry(contents[0], maxRetries: 3);
    }
    
    void ProcessMediaWithRetry(IMediaContent content, int maxRetries)
    {
        content.AsTexture2D((texture, error) => {
            if (error != null && maxRetries > 0)
            {
                Debug.Log($"Retrying texture conversion, {maxRetries} attempts left");
                ProcessMediaWithRetry(content, maxRetries - 1);
            }
            else if (error == null)
            {
                Debug.Log("Texture conversion successful");
                // Use texture in game
            }
            else
            {
                Debug.Log("Texture conversion failed after all retries");
            }
        });
    }
    
    void HandleMediaError(Error error)
    {
        var errorCode = (MediaServicesErrorCode)error.Code;
        
        switch (errorCode)
        {
            case MediaServicesErrorCode.UserCancelled:
                // User cancelled - no action needed
                break;
                
            case MediaServicesErrorCode.PermissionNotAvailable:
                ShowPermissionDialog();
                break;
                
            case MediaServicesErrorCode.DataNotAvailable:
                ShowDataUnavailableMessage();
                break;
                
            default:
                LogErrorForAnalytics(error);
                break;
        }
    }
    
    void ShowPermissionDialog()
    {
        Debug.Log("Please grant media permissions in device settings");
        // Show custom UI explaining how to enable permissions
    }
    
    void ShowDataUnavailableMessage()
    {
        Debug.Log("Selected media is no longer available");
        // Handle case where media was deleted after selection
    }
    
    void LogErrorForAnalytics(Error error)
    {
        Debug.Log($"Media error for analytics: {error.Code} - {error.Description}");
        // Log to your analytics service for debugging
    }
}
```

This example demonstrates production-level error handling with retry logic and user-friendly messaging.

## Batch Media Processing

Handle multiple media selections efficiently:

```csharp
using VoxelBusters.EssentialKit;
using System.Collections;

public class BatchMediaProcessor : MonoBehaviour
{
    public void ProcessMultipleImages()
    {
        var options = MediaContentSelectOptions.CreateForImage(maxAllowed: 10);
        MediaServices.SelectMediaContent(options, OnMultipleImagesSelected);
    }
    
    void OnMultipleImagesSelected(IMediaContent[] contents, Error error)
    {
        if (error != null)
        {
            Debug.Log($"Selection failed: {error}");
            return;
        }
        
        StartCoroutine(ProcessBatchImages(contents));
    }
    
    IEnumerator ProcessBatchImages(IMediaContent[] contents)
    {
        Debug.Log($"Processing {contents.Length} images...");
        
        for (int i = 0; i < contents.Length; i++)
        {
            var content = contents[i];
            bool processed = false;
            
            content.AsTexture2D((texture, error) => {
                if (error == null)
                {
                    Debug.Log($"Processed image {i + 1}/{contents.Length}");
                    // Store or use texture
                }
                processed = true;
            });
            
            // Wait for processing to complete
            yield return new WaitUntil(() => processed);
            
            // Optional delay between processing
            yield return new WaitForSeconds(0.1f);
        }
        
        Debug.Log("Batch processing complete");
    }
}
```

This approach efficiently processes multiple media selections without overwhelming the system.

## Custom Media Content Validation

Validate media content before processing:

```csharp
using VoxelBusters.EssentialKit;

public class MediaValidator
{
    public void ValidateAndProcess(IMediaContent content)
    {
        // First check raw data to validate before conversion
        content.AsRawMediaData((rawData, error) => {
            if (error != null)
            {
                Debug.Log("Raw data access failed");
                return;
            }
            
            if (ValidateMediaData(rawData))
            {
                ProcessValidatedMedia(content);
            }
            else
            {
                Debug.Log("Media validation failed - skipping");
            }
        });
    }
    
    bool ValidateMediaData(RawMediaData rawData)
    {
        // Check file size limits
        if (rawData.Data.Length > 10 * 1024 * 1024) // 10MB limit
        {
            Debug.Log("File too large for processing");
            return false;
        }
        
        // Check supported formats
        if (!IsSupportedFormat(rawData.Mime))
        {
            Debug.Log($"Unsupported format: {rawData.Mime}");
            return false;
        }
        
        return true;
    }
    
    bool IsSupportedFormat(string mimeType)
    {
        return mimeType == MimeType.kPNGImage || 
               mimeType == MimeType.kJPGImage;
    }
    
    void ProcessValidatedMedia(IMediaContent content)
    {
        content.AsTexture2D((texture, error) => {
            if (error == null)
            {
                Debug.Log("Validated media processed successfully");
            }
        });
    }
}
```

This validation approach ensures only suitable media content is processed by your Unity mobile game.

📌 **Video Note**: Show Unity demo of each advanced concept - custom initialization, batch processing with progress indication, and error handling scenarios with user-friendly messaging.