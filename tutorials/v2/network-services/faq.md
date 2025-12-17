# FAQ

## Why network status events are not triggered?

Please make sure you call NetworkServices.StartNotifier() for starting the status detection.



## Why network status is getting detected before I call StartNotifier?

This can happen if you have enabled "Auto Start Notifier" in the [settings](setup.md#properties). Disable if you want to start notifier manually.
