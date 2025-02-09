# Usage

This feature allows you to continue your app in the background when app goes to background state.

On Mobile devices, there are 3 states at a higher level

* Running - App gets active processing allotment
* Background - App may(or may not) get few processing seconds during this period
* Suspended - App won't be allowed to use processing power as usual and will be paused
* Terminated - App is no more in the memory or for processing scheduling

When an app goes to Background or Suspended state from Running state, OS may pause all the activity to free up the resources (cpu or memory) for other active apps.

There are cases where you may want to finish a particular task but when user presses home button to put the app in Background and eventually to Suspended state, your task can be paused/interrupted. When app is back to running state, this task may get completed or failed due to interruption.

<mark style="color:purple;background-color:purple;">To allow an app to continue when put to Background state, the app should be given some special permission to run in background. Background Task Services helps in making this happen!</mark>

> It's not required to use Background Task Services only when app is put to background. As it's not possible to detect when app will be put to background state, you should use for any task which you see it important for your user.

{% hint style="danger" %}
How much background processing time is allowed for a task depends on the native platform. While its few minutes on Android, it lasts for seconds(15-30) on iOS.

You are responsible for handling what needs to be done if a task background time gets expired.&#x20;
{% endhint %}



#### Example

If a user is uploading a profile picture in your app, as it takes time, chances are that user may want to navigate to another screen or press the home button.

If you pass the task to Task Services, it makes sure upload task finishes even app is sent to Background state.

***



All Task Services features can be accessible from **TaskServices** static class.&#x20;

Before using any of the plugin's features, you need to import the below namespace.

```
using VoxelBusters.EssentialKit;
using VoxelBusters.CoreLibrary;
```

After importing the namespace, **TaskServices** class is available for accessing all of the **Task Services**'s features.

***

## Allow Running Application In Background Until Task Completion

Allows the app to run in background until the passed task is completed.

**AllowRunningApplicationInBackgroundUntilTaskCompletion** takes a task, an optional callback to get called when you want to get notified if background quota is exhausted.

<pre class="language-csharp"><code class="lang-csharp">using VoxelBusters.EssentialKit;
using VoxelBusters.CoreLibrary;

Task taskToRun;
//...
public async void AllowInBackground()
{
<strong>    
</strong>    Task uninterruptedTask = TaskServices.AllowRunningApplicationInBackgroundUntilTaskCompletion(taskToRun, onBackgroundProcessingQuotaWillExpireCallback: () => {
                                    Debug.Log("Callback received on background processing quota expiry");
                                });
    await uninterruptedTask;                              
}
</code></pre>

{% hint style="success" %}
Note that the complete app runs in the background until the passed task completes. This means all other tasks in your app also keep running in the background.
{% endhint %}

#### Extension method

```csharp
using VoxelBusters.EssentialKit;
using VoxelBusters.CoreLibrary;

Task taskToRun;
//...
public async void AllowInBackground()
{
    var uninterruptedTask = taskToRun.AllowRunningApplicationInBackgroundUntilTaskCompletion(); //Or pass callback for expiry notification
    await uninterruptedTask;                              
}
```



***





