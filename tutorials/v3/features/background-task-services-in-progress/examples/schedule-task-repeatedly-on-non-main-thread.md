# Schedule Task Repeatedly on Non Main Thread

Here we are scheduling returing the task that needs to run repeatedly from GetRepeatingTaskOnNonMainThread method. Notice it returns the action taskToRun which is passed to ScheduleTask as action task.

```csharp
private Action GetRepeatingTaskOnNonMainThread(string taskId)
{
    int i = 0;
    DateTime start = DateTime.Now;
    
    Debug.Log("Started task to run in background");

    Action taskToRun = () =>
    {
        
        if(i < 10)
        {
            Debug.Log("Elapsed seconds since launch of this task: " + (DateTime.Now - start).Seconds);
            i++;
        }
        else
        {
            BackgroundTaskServices.CancelTask(taskId);
            Debug.Log("Finished RepeatingOnNonMainThread task : " + (DateTime.Now - start).Seconds);
        }
    };

    return taskToRun;
}
```

Create options to set **RepeatUntilCancelledWithInterval**

```
BackgroundTaskOptions options = new BackgroundTaskOptions.Builder()
                                .SetRepeatUntilCancelledWithInterval(1f)
                                .Build();
```

```csharp
string taskId = "unique-task-id-1";
BackgroundServices.ScheduleTask(taskId, GetRepeatingTaskOnNonMainThread(taskId), options);
```

We are passing options with repeat interval as 1 second which means after every invocation of the task, it sleeps for 1 second and calls the task again.

Once the task is finished, we call CancelTask with the same task id to cancel the task.

