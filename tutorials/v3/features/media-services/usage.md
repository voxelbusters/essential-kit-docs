# Usage

Once you have [enabled the required features](../game-services/setup/#properties) that you are going to use in Media Services, you can start using the API by importing the namespaces.

```csharp
using VoxelBusters.EssentialKit;
using VoxelBusters.CoreLibrary;
```

Once after importing the namespace, all features within Media Services can be accessed through **MediaServices** class.

### Overview

Media Services provides mainly three functionalities

* Select media
* Capture media
* Save media

All the functionality api methods have below similarities designed for ease of use.

* All methods takes options to configure the functionality further.
* If there is a data thats returned in the callback, it will be of IMediaContent.
* If the action needs a permission, the permission is displayed as required to the user.

{% hint style="info" %}
IMediaContent is an interface to wrap the media content thats received from an api call. Once you have IMediaContent instance you can do any of the below

* Fetch the content as a Texture2D (if it's an image)
* Fetch the content as a file (you can even provide the save directory and file name)
* Fetch the content as a raw data for further processing (RawMediaData)
{% endhint %}



***

### Select Media Content

For selected any media from device, we need to pass MediaContentSelectOptions instance SelectMediaContent method call.&#x20;

Through options you can&#x20;

1. Set the title that needs to be displayed(if any) when selecting the content
2. Set mime type of the content that needs to be selected
3. Set max allowed images to select

Options can be created as follows

```csharp
  MediaContentSelectOptions options = new MediaContentSelectOptions(title: "Select Images", allowedMimeType: MimeType.kPNGImage, maxAllowed: 1);
```

You can make use of MediaContentSelectOptions utility methods if you have a direct use-case for image or video or audio

```csharp
//For images
MediaContentSelectOptions options = MediaContentSelectOptions.CreateForImage();

//For videos
MediaContentSelectOptions options = MediaContentSelectOptions.CreateForVideo();

//For audio
MediaContentSelectOptions options = MediaContentSelectOptions.CreateForAudio();

//For any
MediaContentSelectOptions options = MediaContentSelectOptions.CreateForAny();
```

Once after creating MediaContentSelectOptions instance, call MediaServices.SelectMediaContent with the options and a callback which gets called after the action is complete.

```csharp
MediaServices.SelectMediaContent(options, (IMediaContent[] contents, Error error) =>
    {
        if (error == null)
        {
            Debug.Log($"Selected media content: {contents.Length}");

            foreach (var each in contents)
            {
                //If the content that is selected is an image
                each.AsTexture2D((texture, error) => {
                    if (error == null) {
                        Debug.Log($"Successfully loaded the texture.");
                    }
                    else {
                        Debug.Log($"Error loading as texture:{error}");
                    }
                });
            }
        }
        else
        {
            Debug.Log("Select image from gallery failed with error. Error: " + error);
        }
    });
```

{% hint style="info" %}
If a permission is required to select media of the user, the first call presents the permission request as required.
{% endhint %}



### Capture Media Content

To capture content from camera whether it could be image or video, MediaContentCaptureOptions instance need to be passed to CaptureMediaContent.

Through options you can&#x20;

1. Set the title that needs to be displayed(if any) when selecting the content
2. Set file name(without extension) of the captured file
3. Set capture content type is image or video

Options can be created as follows

```csharp
MediaContentCaptureOptions captureOptions = new MediaContentCaptureOptions(title: "Capture Image", fileName: "image", captureType: MediaContentCaptureType.Image);
```

You can make use of MediaContentCaptureOptions utility methods if you have a direct use-case for image or video

```csharp
//For image capture
MediaContentCaptureOptions options = MediaContentSelectOptions.CreateForImage();

//For video capture
MediaContentCaptureOptions options = MediaContentSelectOptions.CreateForVideo();
```

Once after creating MediaContentCaptureOptions instance, call MediaServices.CaptureMediaContent with the options and a callback which gets called after the action is complete.

```csharp
MediaServices.CaptureMediaContent(captureOptions, (IMediaContent content, Error error) =>
    {
        if (error == null)
        {
            content.AsTexture2D(onComplete: (Texture2D texture, Error error) => {

                if(error == null)
                {
                    Debug.Log("Capture content complete." + ((texture != null) ? $" Received texture size : [{texture.width} {texture.height}]" : $"Video data can't be converted to a texture2d. Please use AsFilePath for accessing the video file."));
                }
                else
                {
                    Debug.Log($"Captured media content failed with error: {error}");
                }
                
            });

            /* //Or if you want to save content as a file
            content.AsFilePath(Application.persistentDataPath + "/" + "Save Dir", "captured_file", (string path, Error error) =>
            {
                if (error == null)
                {
                    Debug.Log($"Captured media content at path " + path);
                }
                else
                {
                    Debug.Log($"Captured media content failed to get as file path: " + error);
                }
            });*/
        }
        else
        {
            Log("Capture image using camera failed with error. Error: " + error);
        }
    });
```

### Save Media Content

To save media content to device whether it could be image or video or any other media, MediaContentSaveOptions instance need to be passed to SaveMediaContent.

Through options you can&#x20;

1. Set directory or album name for target
2. Set file name(without extension) of the file being saved

Options can be created as follows

```csharp
MediaContentSaveOptions saveOptions = new MediaContentSaveOptions(directoryName: "Essential Kit Album", fileName: "image");
```

Once after creating MediaContentSaveOptions instance, call MediaServices.SaveMediaContent with the options and a callback which gets called after the action is complete.

```csharp
MediaServices.SaveMediaContent(image.EncodeToPNG(), MimeType.kPNGImage, saveOptions, 
(bool result, Error error) =>
    {
        if (error == null)
        {
            Debug.Log("Save media to gallery finished successfully.");
        }
        else
        {
            Debug.Log("Save media to gallery failed with error. Error: " + error);
        }
    });
```

{% hint style="success" %}
Plugin handles the permissions as required automatically and selects the platform recommended ways to implement the functionality.&#x20;

For ex: Photo Picker is considered for images on Android as it avoids permissions and recommended way by google.

Similarly on iOS PHPhotoPicker is preferred for images and  document picker as a fallback for other contents.
{% endhint %}



