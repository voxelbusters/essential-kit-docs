# Notification Triggers

## What are Notification Triggers?

Notification triggers define when and how notifications are delivered to players. Essential Kit supports three types of triggers: time intervals, calendar dates, and location-based triggers. These provide precise control over notification timing in your Unity mobile game.

Why use notification triggers in a Unity mobile game? Different game events need different timing - energy refills need regular intervals, daily bonuses need specific times, and location-based games need geographic triggers for immersive gameplay.

## Essential Kit Notification Trigger APIs

### Time Interval Triggers
Schedule notifications based on time intervals from the current moment:

```csharp
using VoxelBusters.EssentialKit;

// Schedule a notification 30 minutes from now
var energyRefill = NotificationServices.CreateNotificationWithId("energy_refill")
    .SetTitle("Energy Restored!")
    .SetBody("Your energy is full. Time to play!")
    .SetTimeIntervalNotificationTrigger(30 * 60, repeats: false) // 30 minutes, no repeat
    .Create();
    
NotificationServices.ScheduleNotification(energyRefill);
```

This snippet creates a non-repeating notification that triggers in 30 minutes.

### Repeating Time Interval Triggers
Create recurring notifications with time intervals:

```csharp
// Daily reward notification that repeats every 24 hours
var dailyReward = NotificationServices.CreateNotificationWithId("daily_reward")
    .SetTitle("Daily Reward Available!")
    .SetBody("Collect your daily coins and gems!")
    .SetTimeIntervalNotificationTrigger(24 * 60 * 60, repeats: true) // 24 hours, repeating
    .Create();
    
NotificationServices.ScheduleNotification(dailyReward);
```

This snippet creates a repeating daily notification that triggers every 24 hours.

### Calendar-Based Triggers
Schedule notifications for specific dates and times:

```csharp
using VoxelBusters.CoreLibrary.NativePlugins;

// Schedule notification for a specific date and time
var dateComponents = new DateComponents()
{
    Hour = 18,    // 6 PM
    Minute = 0    // Exact hour
};

var dailyReminder = NotificationServices.CreateNotificationWithId("daily_login")
    .SetTitle("Daily Login Bonus!")
    .SetBody("Don't miss your daily login streak!")
    .SetCalendarNotificationTrigger(dateComponents, repeats: true) // Every day at 6 PM
    .Create();
    
NotificationServices.ScheduleNotification(dailyReminder);
```

This snippet creates a notification that triggers every day at 6:00 PM.

### Specific Date Calendar Triggers
Schedule notifications for exact dates:

```csharp
// Schedule for a specific date (tournament start)
var tournamentDate = new DateComponents()
{
    Year = 2024,
    Month = 12,
    Day = 25,
    Hour = 10,
    Minute = 0
};

var tournament = NotificationServices.CreateNotificationWithId("tournament_start")
    .SetTitle("Tournament Begins!")
    .SetBody("The holiday tournament has started. Join now!")
    .SetCalendarNotificationTrigger(tournamentDate, repeats: false)
    .Create();
    
NotificationServices.ScheduleNotification(tournament);
```

This snippet schedules a one-time notification for a specific date and time.

### Location-Based Triggers
Trigger notifications when players enter or exit geographic regions:

```csharp
using VoxelBusters.CoreLibrary.NativePlugins;

// Create a circular region around a point of interest  
var region = new CircularRegion()
{
    Center = new Coordinate(37.7749, -122.4194), // San Francisco coordinates
    Radius = 100.0 // 100 meters
};

var locationNotification = NotificationServices.CreateNotificationWithId("location_event")
    .SetTitle("You're Near a Special Location!")
    .SetBody("Check your map for nearby treasures!")
    .SetLocationNotificationTrigger(
        region: region,
        notifyOnEntry: true,    // Trigger when entering the region
        notifyOnExit: false,    // Don't trigger when leaving
        repeats: true)          // Can trigger multiple times
    .Create();
    
NotificationServices.ScheduleNotification(locationNotification);
```

This snippet creates a location-based notification that triggers when players enter a 100-meter radius around specified coordinates.

### Trigger Information Access
Access trigger information from scheduled notifications:

```csharp
NotificationServices.GetScheduledNotifications((result, error) =>
{
    foreach (var notification in result.Notifications)
    {
        if (notification.Trigger is TimeIntervalNotificationTrigger timeInterval)
        {
            Debug.Log($"Time interval: {timeInterval.TimeInterval} seconds");
            Debug.Log($"Repeats: {timeInterval.Repeats}");
            Debug.Log($"Next trigger: {timeInterval.NextTriggerDate}");
        }
        else if (notification.Trigger is CalendarNotificationTrigger calendar)
        {
            Debug.Log($"Calendar trigger repeats: {calendar.Repeats}");
            Debug.Log($"Date components: {calendar.DateComponents}");
        }
    }
});
```

This snippet examines trigger information from existing scheduled notifications.

📌 **Video Note**: Show Unity demo of each trigger type in action - time interval notification appearing after countdown, calendar notification at specific time, and location notification when entering a defined area.