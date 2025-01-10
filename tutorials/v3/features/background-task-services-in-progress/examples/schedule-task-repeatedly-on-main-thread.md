# Schedule Task Repeatedly on Main Thread

Here we are scheduling a task returned from GetRepeatingTaskOnNonMainThread method. Notice it returns the action taskToRun which is passed to ScheduleTask as action task and called repeatedly.

```csharp
private Action GetRepeatingTaskForMainThread(string taskId)
{
    UnityWebRequest request = UnityWebRequest.Get("https://onlinetestcase.com/wp-content/uploads/2023/06/15MB.mp4");
    request.SendWebRequest();
    
    
    //Grouping the code which needs to wait or run indfinitely is placed inside the actionToRun. This will be passed to the scheduler.
    Action taskToRun = () =>
    {
        if (!request.isDone)
        {
            Debug.Log("Waiting for request to finish...");
            return;
        }

        if (request.result == UnityWebRequest.Result.ConnectionError ||
            request.result == UnityWebRequest.Result.ProtocolError)
        {
            Debug.LogError($"Request failed: {request.error}");
            Log("Failed fetching data from request... " + request.downloadHandler.text);
        }
        else
        {
            // Successfully received response
            Debug.Log($"Response: {request.downloadHandler.text}");
            Log("Received data length... " + request.downloadHandler.text.Length);
        }
                
                
        //Cancelling the task as we are done with this.
        BackgroundTaskServices.CancelTask(taskId);
    };

    return taskToRun;
}
```

Create options to set **RepeatUntilCancelledWithInterval.** Notice SetExecuteOnCallingThread is set to true as we call ScheduleTask from main thread, it continues on the same thread instead of spawning a new one to call the action.

```
BackgroundTaskOptions options = new BackgroundTaskOptions.Builder()
                                .SetExecuteOnCallingThread(true)
                                .SetRepeatUntilCancelledWithInterval(1f)
                                .Build();
```

```csharp
string taskId = "unique-task-id-1";
BackgroundServices.ScheduleTask(taskId, GetRepeatingTaskForMainThread(taskId), options);
```

We are passing options with repeat interval as 1 second which means after every invocation of the task, it sleeps for 1 second and calls the task again.

Once the task is finished, we call CancelTask with the same task id to cancel the task.

