# Usage

Once you have [enabled the required features](../game-services/setup/#properties) that you are going to use in Media Services, you can start using the API by importing the namespace.

```csharp
Using VoxelBusters.EssentialKit;
```

Once after importing the namespace, all features within Media Services can be accessed through **MediaServices** class.

Before accessing any gallery features, you need to check if your app have access to gallery.

#### Get read status

```
GalleryAccessStatus readAccessStatus   = MediaServices.GetGalleryAccessStatus(GalleryAccessMode.Read);
```

#### Get read/write status

```
GalleryAccessStatus readWriteAccessStatus   = MediaServices.GetGalleryAccessStatus(GalleryAccessMode.ReadWrite);
```

Once you know the [status](https://voxel-busters-interactive.github.io/cross-platform-essential-kit/api/VoxelBusters.EssentialKit.GalleryAccessStatus.html?q=GalleryAccessStatus) and you don't have the permission, you can request the access. This request will popup a dialog to let user allow the permission.

#### Request  gallery access for Read mode

```csharp
MediaServices.RequestGalleryAccess(GalleryAccessMode.Read, callback: (result, error) =>
{
    Debug.Log("Request for gallery access finished.");
    Debug.Log("Gallery access status: " + result.AccessStatus);
});
```

#### Request  gallery access for ReadWrite mode

```csharp
MediaServices.RequestGalleryAccess(GalleryAccessMode.ReadWrite, callback: (result, error) =>
{
    Debug.Log("Request for gallery access finished.");
    Debug.Log("Gallery access status: " + result.AccessStatus);
});
```

#### Read camera access

```csharp
MediaServices.RequestCameraAccess(callback: (result, error) =>
{
    Debug.Log("Request for camera access finished.");
    Debug.Log("Camera access status: " + result.AccessStatus);
});
```

#### Get images from Gallery or Camera

For getting the images from gallery, you need read access(**GalleryAccessmode.Read)** to gallery. Once you have the access, you can call **SelectImageFromGallery** which can return the texture data in the callback.

```csharp
MediaServices.SelectImageFromGallery(canEdit: true, (textureData, error) =>
{
    if (error == null)
    {
        Debug.Log("Select image from gallery finished successfully.");
        //textureData.GetTexture() // This returns the texture
    }
    else
    {
        Debug.Log("Select image from gallery failed with error. Error: " + error);
    }
});
```

{% hint style="warning" %}
**canEdit** flag will be ignored on Android where as on iOS it opens up an option to edit the image allowing it to crop.
{% endhint %}

For capturing an image from device camera, you need camera permission which can be gained with **RequestCameraAccess** method. Once you have the permission, you can call CaptureImageFromCamera method.

```csharp
MediaServices.CaptureImageFromCamera(true, (textureData, error) =>
{
    if (error == null)
    {
        Debug.Log("Capture image using camera finished successfully.");
    }
    else
    {
        Debug.Log("Capture image using camera failed with error. Error: " + error);
    }
});
```

{% hint style="success" %}
For fetching the images with permission, you can use utility methods **SelectImageFromGalleryWithUserPermision** and **CaptureImageFromCameraWithUserPermision**.
{% endhint %}

### Save image to gallery

You need to have read-write access for saving images to gallery. For requesting access you need to call  RequestGalleryAccess with **GalleryAccessmode.Read** mode. Once you have the permission, you need to call SaveImageToGallery by passing the image texture.

```csharp
Texture2D texture; // Set the texture before calling
MediaServices.SaveImageToGallery(texture, (result, error) =>
{
    if (error == null)
    {
        Debug.Log("Save image to gallery finished successfully.");
    }
    else
    {
        Debug.Log("Save image to gallery failed with error. Error: " + error);
    }
});
```



