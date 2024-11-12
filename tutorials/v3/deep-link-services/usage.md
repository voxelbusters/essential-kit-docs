# Usage

Once after you configure the deep links in the [settings](setup/#enable-feature), your app is ready to accept the deep links.\
Your app gets opened if the deep link matches the settings and you can redirect the user to the required page as per the data in the deep link.

### Listening to events

You can listen to both Custom Scheme deep links or Universal Deep links from your app by registering to following events

**DeepLinkServices.OnCustomSchemeUrlOpen**\
**DeepLinkServices.OnUniversalLinkOpen**

**OnCustomSchemeUrlOpen** event will be fired when user clicks on custom scheme deep link.\
**OnUniversalLinkOpen** event will be fired when user clicks on a universal deep link.

For the above events you get a [uri](https://docs.microsoft.com/en-us/dotnet/api/system.uri?view=netcore-3.1) instance in the result and a raw url string. From [uri](https://docs.microsoft.com/en-us/dotnet/api/system.uri?view=netcore-3.1) you can get the scheme, host and path for taking the action as required.

```
private void OnEnable ()
{
    DeepLinkServices.OnCustomSchemeUrlOpen     += OnCustomSchemeUrlOpen;
    DeepLinkServices.OnUniversalLinkOpen       += OnUniversalLinkOpen;
}

private void OnDisable ()
{
    DeepLinkServices.OnCustomSchemeUrlOpen    -= OnCustomSchemeUrlOpen;
    DeepLinkServices.OnUniversalLinkOpen      -= OnUniversalLinkOpen;
}
```

```
private void OnCustomSchemeUrlOpen (DeepLinkServicesDynamicLinkOpenResult result)
{
    Debug.Log("Handle deep link : " + result.Url);
}

private void OnUniversalLinkOpen (DeepLinkServicesDynamicLinkOpenResult result)
{
    Debug.Log("Handle deep link : " + result.Url);
}
```

{% hint style="success" %}
### Once you get the deep link the user clicked, you need to take the user to the exact content defined in the deep link.
{% endhint %}

