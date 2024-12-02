# Nudge to come-back to the game



## Remind users to return in game  If they don't back in 24h

This can be achieved with normal local notificaitons Scheduling and Cancelling as required.

1. Once the user opens the app, set the Time trigger interval to 24hrs (in secs) or time of the day with calendar trigger and schedule it with a Id you are aware of.
2. If user opens the app before 24 hrs, just cancel the scheduled notification with CancelNotification by passing the Id.
3. If user opens the app after 24hrs, schedule another and back to step 1

