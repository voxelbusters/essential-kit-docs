# Resolving Android Gradle Build Errors

### How to resolve "**AAPT: error: unexpected element \<queries> found in \<manifest>"** error?

**queries** tag in Android Manifest is a requirement when you use  Target API 30. To let gradle(Build system on Android) process the manifest files with queries tag, the project needs to atleast use 5.6.4+ gradle version. All Unity versions from 2020.x support 5.6.4+ gradle version. So, you don't see this error on those unity versions.

For supporting queries tag(which is required for Android 11 support/Target API 30), Gradle Version needs to be 5.6.4+. To assure this, your unity's Android Gradle Version needs to be atleast nearest of 3.3.3/3.4.3/3.5.4/3.6.4/4.0.1 versions.

You need to edit the Android Plugin Version to any of the closest in above versions.

![Update Android Gradle Version to nearest of 3.3.3/3.4.3/3.5.4/4.0.1](../.gitbook/assets/ResolvingQueriesTagAndroid.gif)

> Android Gradle Plugin Version and Gradle Version are two different values and not the same.

{% hint style="info" %}
If you are latest versions, you may see "Custom Base Gradle Template" option. Just enable it in Player Settings and edit baseProjectTemplate file to include above version.
{% endhint %}



### How to resolve "Failed to install the following Android SDK packages as some licences have not been accepted"?

You may see the following error when building on Android.

```
Could not determine the dependencies of task ':unityLibrary:com.voxelbusters.essentialkit.androidlib:compileReleaseAidl'.
> Failed to install the following Android SDK packages as some licences have not been accepted.
     platforms;android-31 Android SDK Platform 31
     build-tools;29.0.2 Android SDK Build-Tools 29.0.2
  To build this project, accept the SDK license agreements and install the missing components using the Android Studio SDK Manager.
```

The above error is actually weird as Unity needs to pick the latest build-tools which ever is installed. In the above scenario I have 30.0.2 but still its complaining about 29.0.2 build tools.

To solve this, you need to do the following.

1. Click on File -> Build Settings -> **Player Settings**
2. Select **Android** Platform
3. Expand **Other Settings** section
4. Set **Target API** Level to **API 31**
5. **Make a build** by clicking Build Settings -> Build/Build & Run
6. It may prompt for updating the SDK, **proceed updating**
7. After making the build, reset **Target API** back to **Automatic**

{% hint style="info" %}
Here actually we are forcing Unity to update to latest SDK (in this context API 31) to avoid the error.
{% endhint %}

{% embed url="https://www.loom.com/share/a5194c0d29074997b480d601a7a15438" %}
Set Target API
{% endembed %}

