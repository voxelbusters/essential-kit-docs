# FAQ

## What is Local Copy?

Local copy is the latest downloaded cloud data available on the device.

## What is Cloud Copy?

Cloud copy is the data that is stored on the cloud servers

## Does using Cloud Services costs any for storage?

Plugin uses iCloud on iOS and Google Play Services Saved games on Android. These services are free to use on these platforms.

## How much data I can store?

On iOS, you can store a max of **1 MB** and on Android you can store a max of **3 MB**.

## What is the use of [Sync Interval](setup/#properties) in settings?

On  iOS, iCloud libraries by default sync with the cloud servers multiple times automatically. Where as on Android, thats not the case. So, Plugin uses the sync timer to schedule a sync so that you don't need to do it in your code frequently.

## Why I can't see the data I set when [OnSavedDataChange](usage.md#register-for-events) event is triggered?

Always, Local copy will be always overwritten with the latest downloaded cloud copy. If there are any key value changes locally compared to the latest downloaded copy, those keys will be passed in the event callback.

You always need to maintain a copy of your own to solve this problem. In the callback, when you call getters (CloudServices.GetBool, CloudServices.GetLong), it will return only the latest cloud copy details as it got overwritten before triggering the callback. You need to set the correct data with setters in this callback so that the data will be synced in the next cloud sync.

> ### Note that you won't get any OnSavedDataChange event if you have cloud copy and local copy key-values on same version. As this means we are already in sync with cloud server before actually modifying locally.

## How plugin identifies changed keys passed in [OnSavedDataChange](usage.md#register-for-events)?

Cloud Copy and Local Copy has tags attached to them. This tag is more like a version tag for the whole copy. If data sync is finished, both local and cloud copies will have same tag.

On every data update written to cloud servers, tag changes. So if local copy tag doesn't match with Cloud copy's tag it means local doesn't have the latest valid data and this is the point where the differences in the key-values are calculated and the complete list of changed keys are passed in the callback for resolution.

