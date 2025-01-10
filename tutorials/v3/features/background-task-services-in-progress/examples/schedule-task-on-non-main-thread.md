# Schedule Task on Non Main Thread

Here we are scheduling TaskToRun task to run in background one time.

```csharp
private void TaskToRun()
{
    Debug.Log("Processing...");
}
```

```csharp
BackgroundServices.ScheduleTask("unique-task-id-1", TaskToRun, null);
```

We are passing null as options because, by default **ExecuteOnCallingThread** is false, so it spawns a new thread automatically internally and invoke the task from there.
