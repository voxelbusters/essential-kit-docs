---
description: Have your own localised text for the strings used within the plugin
---

# Localisation

There is a provision to configure the plugin to provide your own text based on the language selected by your user :tada:\
\
There are two easy steps to have the plugin localised.

### 1. Implement ILocalisationServiceProvider Interface

You need to implement ILocalisationServiceProvider which has **GetLocalisedString** method. It takes two parameters key and default value.

**key :** Key contains the value used to identify the string ([Refer here](localisation.md#key-constants-class-for-each-feature) for keys used in the plugin)

**default :** This is usually the string in english language we use internally if no localisation exists.

```
namespace YourOwnNameSpace
{
    public class MyLocalisationServiceProvider : ILocalisationServiceProvider
    {
        #region ILocalisationServiceProvider implementation

        public string GetLocalisedString(string key, string defaultValue)
        {
            string localisedValue = defaultValue;//Replace defaultValue with your own mecanism to find localised text which has the "key"
            return localisedValue;
        }

        #endregion
    }
}
```

### 2. Set the ILocalisationServiceProvider

You need to set the above implemented localisation provider to ExternalServiceProvider.LocalisationServiceProvider once your first scene is loaded

```
ExternalServiceProvider.LocalisationServiceProvider = new MyLocalisationServiceProvider();
```



## Key constants used in Rate My App feature

<table><thead><tr><th>Key Used</th><th width="312">Attribute Text Description</th></tr></thead><tbody><tr><td>RateMyAppLocalisationKey.kTitle</td><td>Rate My App Title</td></tr><tr><td>RateMyAppLocalisationKey.kDescription</td><td>Rate My App Description</td></tr><tr><td>RateMyAppLocalisationKey.kOkButton</td><td>Rate My App Ok Button</td></tr><tr><td>RateMyAppLocalisationKey.kCancelButton</td><td>Rate My App Cancel Button</td></tr><tr><td>RateMyAppLocalisationKey.kRemindLaterButton</td><td>Rate My App Remind Later Button</td></tr></tbody></table>
