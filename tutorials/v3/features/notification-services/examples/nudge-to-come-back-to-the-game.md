# Nudge to come-back to the game



## Remind users to return in game  If they don't back in 24h

This can be achieved with normal local notifications scheduling and cancelling as required.

1. Once the user opens the app, set the time trigger interval to 24 hours (in seconds) or time of the day with a calendar trigger and schedule it with an ID you are aware of.
2. If user opens the app before 24 hours, cancel the scheduled notification with `NotificationServices.CancelScheduledNotification(id)` by passing the ID.
3. If user opens the app after 24hrs, schedule another and back to step 1
