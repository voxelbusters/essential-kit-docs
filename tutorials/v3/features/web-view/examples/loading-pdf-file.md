# Loading Pdf File

Android natively doesn't have option to render pdf file. So rendering it is a bit tricky but solutions exist.



## Loading web pdf

To load a pdf file, we can make use of google drive's embedded url utility to achieve similar functionality on both iOS and Android.

Just prefix your url with "[http://docs.google.com/gview?embedded=true\&url=](http://docs.google.com/gview?embedded=true\&url=)"  and call LoadUrl of web view.



```csharp
string yourPdfUrl  = "https://yourwebsite.com/sample.pdf
string urlPath     = "http://docs.google.com/gview?embedded=true&url=" + yourPdfUrl

//...

webView.LoadUrl(URLString.URLWithPath(urlPath));
```



## Loading local pdf&#x20;

Here we will make use of Mozilla's pdf.js project for rendering the pdf locally.

{% file src="../../../.gitbook/assets/mozilla.zip" %}

1. Place the above mozilla.zip folder in Assets/StreamingAssets folder
2. Unzip its contents and delete mozilla.zip
3. Prefix your local pdf file path with below string (PDF\_VIEWER\_PATH)

```
string PDF_VIEWER_PATH = "file:///android_asset/mozilla/pdfjs/pdf_viewer.html?file=";
```



```csharp
string PDF_VIEWER_PATH = "file:///android_asset/mozilla/pdfjs/pdf_viewer.html?file=";
string yourFilePersistentDataPath  = "/storage/0/emulated/.../sample.pdf";
string finalPath = PDF_VIEWER_PATH + "file://" + yourFilePersistentDataPath;

//...

webView.LoadUrl(URLString.URLWithPath(finalPath));
```



{% code title="Load Local Pdf File" %}
```csharp
//Example to load sample.pdf placed in StreamingAssets 
private void LoadLocalFile()
{
    string PDF_VIEWER_PATH = "file:///android_asset/mozilla/pdfjs/pdf_viewer.html?file=";
    string fileName = "sample.pdf"; // Change to your file
    StartCoroutine(CopyToPersistentPath(Application.streamingAssetsPath, fileName, (string copiedFilePath) =>
    {
        m_activeWebView.LoadURL(URLString.FileURLWithPath(PDF_VIEWER_PATH+ "file://" + copiedFilePath));

        //If you want to directly load file from streaming assets instead of copying to persistent path
        //m_activeWebView.LoadURL(URLString.FileURLWithPath(PDF_VIEWER_PATH+ "file://android_asset/" + "sample.pdf"));
    }));
}

private IEnumerator CopyToPersistentPath(string sourceFolder, string fileName, Action<string> onComplete)
{
    string sourcePath = Path.Combine(sourceFolder, fileName);
    string destinationPath = Path.Combine(Application.persistentDataPath, fileName);

    using (UnityWebRequest request = UnityWebRequest.Get(sourcePath))
    {
        yield return request.SendWebRequest();

        if (request.result != UnityWebRequest.Result.Success)
        {
            Debug.LogError("Error loading file: " + request.error);
            onComplete?.Invoke(null);
            yield break;
        }

        try
        {
            File.WriteAllBytes(destinationPath, request.downloadHandler.data);
            Debug.Log("File copied to: " + destinationPath);
            onComplete?.Invoke(destinationPath);
        }
        catch (IOException e)
        {
            Debug.LogError("Failed to write file: " + e.Message);
        }
    }
    
    
}
```
{% endcode %}





