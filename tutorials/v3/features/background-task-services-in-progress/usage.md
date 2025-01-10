# Usage

This feature allows you to schedule tasks to continue in the background when app goes to background state.

On Mobile devices, there are 3 states at a higher level

* Running - App gets active processing allotment
* Background - App may(or may not) get few processing seconds during this period
* Suspended - App won't be allowed to use processing power as usual and will be paused
* Terminated - App is no more in the memory or for processing scheduling

When an app goes to Background or Suspended state from Running state, OS may pause all the activity to free up the resources (cpu or memory) for other active apps.

There are cases where you may want to finish a particular task but when user presses home button to put the app in Background and eventually to Suspended state, your task can be paused/interrupted. When app is back to running state, this task may get completed or failed due to interruption.

To allow a task to continue when put to Background state, the app should be given some special permission to run in background. Background Task Services helps in making this happen!

> It's not required to use Background Task Services only when app is put to background. As it's not possible to detect when app will be put to background state, you should use for any task which you see it important for your user.

{% hint style="danger" %}
How much background processing time is allowed for a task depends on the native platform. While its few minutes on Android, it lasts for seconds(15-30) on iOS.

You are responsible for handling what needs to be done if a task background time gets expired or on error.&#x20;
{% endhint %}



#### Example

If a user is uploading a profile picture in your app, as it takes time, chances are that user may want to navigate to another screen or press the home button.

If you pass the task to Background Task Services, it makes sure upload task finishes even app is sent to Background state.

***



All Background Task Services features can be accessible from **BackgroundTaskServices** static class.&#x20;

Before using any of the plugin's features, you need to import the below namespace.

```
using VoxelBusters.EssentialKit;
using VoxelBusters.CoreLibrary;
```

After importing the namespace, **BackgroundTaskServices** class is available for accessing all of the **Background Task Services**'s features.

***

## Schedule Task

Schedules a passed action/task to let it continue even if app is sent to background state.

**ScheduleTask** takes a task id, an action/method/task you want to run and BackgroundTaskOptions for additional optional configuration.

<pre class="language-csharp"><code class="lang-csharp">using VoxelBusters.EssentialKit;
using VoxelBusters.CoreLibrary;

//...
public void Schedule()
{
<strong>    string taskId = "unique-task-id";
</strong>    Action action = () => {
        Debug.Log("Task Started");
        
        for(int i=0; i &#x3C; 10 ; i++)
        {
            Debug.Log("Processing...");
            Thread.Sleep(1000);
        }
        
        Debug.Log("Task Ended");
    };
    
    BackgroundTaskServices.ScheduleTask(taskId, action, null);
}
</code></pre>

#### Background Task Options

You can pass options to configure how you want to run the task. When you pass null as options to ScheduleTask, it uses default values of options.

**BackgroundTaskOptions** provides the below options to configure.

* **ExecuteOnCallingThread** - To run the task on the same thread from where you are calling ScheduleTask.
* **RepeatUntilCancelledWithInterval** - Run task repeatedly with an interval in seconds.

Use BackgroundTaskOptions.Builder to create an instance of BackgroundTaskOptions.

```csharp
BackgroundTaskOptions.Builder builder = new BackgroundTaskOptions.Builder();
builder.SetExecuteOnCallingThread(false);

BackgroundTaskOptions options = builder.Build();
```



{% hint style="success" %}
**Pro Tip**

Always call this ScheduleTask method from your main thread (default unity thread) as we expect the calling thread is main thread. This is because, on editor we simulate repeated calling tasks considering its being called from Main thread.

\
When you call ScheduleTask from main thread and set **ExecuteOnCallingThread** to true in options,  the task is scheduled on main thread using a coroutine in editor simulator. Where as on native platforms, we schedule it from a secondary thread to make sure the interval sleep won't block the main thread. Ping us on discord if you would like to know more why so!\
\
But ideally this is not at all a problem but just a note you to be aware!
{% endhint %}

## Cancel Task

When you schedule a repeating task with **RepeatUntilCancelledWithInterval as true**, you need to cancel it manually once you are done with your work. To cancel it call CancelTask by passing the task id.

```csharp
BackgroundTaskServices.CancelTask("task-id");
```

## Cancel All Tasks

As you are allowed to schedule multiple tasks with different task ids, you can cancel all of them at once with CancelAllTasks method.

```csharp
BackgroundTaskServices.CancelAllTasks();
```

***

## Events

Register to OnScheduleTaskComplete event to know if your task gets started or fails with an error.

```csharp
private void OnEnable()
{
    BackgroundTaskServices.OnScheduleTaskComplete += OnScheduleTaskComplete;
}

private void OnDisable()
{
    BackgroundTaskServices.OnScheduleTaskComplete -= OnScheduleTaskComplete;
}

private void OnScheduleTaskComplete(string taskId, Error error)
{
    if (error == null)
    {
        Debug.Log("Successfully scheduled task with id: " + taskId);
    }
    else
    {
        Debug.Log($"Failed completing task id : {taskId} with error : {error}");
    }
}

```



{% hint style="info" %}
Note that as the tasks that are invoked can be asynchronous, it's not possible to call OnScheduleTaskComplete event after completion of your task. The event will be triggered as soon as it gets called.
{% endhint %}



