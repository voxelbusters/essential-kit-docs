---
description: Example to add a zip file as an attachment
---

# Add Attachment Example

```csharp
public void ShareAttachment(string title, string path, string mimeType, string filename)
{
    ShareSheet shareSheet = ShareSheet.CreateInstance();
    shareSheet.AddText(title);
    StartCoroutine(GetFileAsByteArray(path, (data) =>
    {
        shareSheet.AddAttachment(data, mimeType, filename);
        shareSheet.Show();
        
    }));
}

#region Helpers
private IEnumerator GetFileAsByteArray(string filePath, Action<byte[]> callback)
{
    var sanitizedFilePath = GetSanitizedFilePath(filePath);
    UnityWebRequest request = UnityWebRequest.Get(sanitizedFilePath);
    yield return request.SendWebRequest();

    Debug.LogError("File path : " + sanitizedFilePath);
    if (request.isNetworkError || request.isHttpError)
    {
        Debug.LogError(request.error);
        callback?.Invoke(null);
    }
    else
    {
        callback?.Invoke(request.downloadHandler.data);
    }
}

private string GetSanitizedFilePath(string filePath)
{
    if (filePath == null)
        return null;

    if (filePath.StartsWith("jar:") || filePath.StartsWith("file:"))
        return filePath;

    return Path.Combine("file://", filePath);
}
#endregion
```



### Usage

```csharp
ShareAttachment("Sharing a zip file", Path.Combine(Application.streamingAssetsPath, "test.zip"), "application/zip", "test");
```



{% hint style="warning" %}
Note that the sharing content may or may not be compatible with the sharing service. Handling of the content is totally controlled by the service being used to share.\
\
Essential Kit only provides a way to share the content to the services and actual sharing is handled by the sharing service being used.
{% endhint %}

