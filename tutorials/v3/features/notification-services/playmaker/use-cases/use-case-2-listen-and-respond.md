# Listen and Respond to Notifications

## Goal
Handle notifications when they are received while the app is running or when the user taps a notification to open the app.

## Actions Required
| Action | Purpose |
|--------|---------|
| NotificationServicesOnNotificationReceived | Listen for notification events |
| NotificationServicesGetReceivedNotificationInfo | Extract notification details |

## Variables Needed
- notificationId (String)
- notificationTitle (String)
- notificationBody (String)
- wasLaunchedFromNotification (Bool)
 - userInfoKeys/userInfoValues (String arrays, optional)

## Implementation Steps

### 1. State: ListenForNotifications
**Action:** NotificationServicesOnNotificationReceived
- **Outputs:**
  - notificationId → notificationId variable
  - title → notificationTitle
  - body → notificationBody
  - wasLaunchedFromNotification → wasLaunchedFromNotification
- **Events:**
  - receivedEvent → HandleNotification

**Note:** This is a persistent listener state - it remains active and fires the event each time a notification is received.

### 2. State: HandleNotification
**Logic:** Check wasLaunchedFromNotification
- If true: User tapped notification → Navigate to relevant content
- If false: Notification received in foreground → Show in-app banner

**Optional: Extract payload**
Use `NotificationServicesGetReceivedNotificationInfo` to read `userInfoKeys` / `userInfoValues` (and other fields like subtitle/badge/sound).

### 3. State: NavigateToContent
Based on extracted payload (for example, `contentId`), navigate to the appropriate scene or UI element.

### 4. Return to ListenForNotifications
The listener continues to monitor for new notifications.

## Listener Pattern
```
State: ListenForNotifications (PERSISTENT)
  └─ Stays active, fires receivedEvent on each notification

OnEnter: Subscribe to notification events
OnExit: Unsubscribe from events
```

## Common Issues

- **Listener Not Firing**: Ensure the state with OnNotificationReceived is active when notification arrives
- **Multiple Triggers**: Each notification fires the event once; handle event properly to avoid duplicate actions
- **Background vs Foreground**: wasLaunchedFromNotification distinguishes between tapped (true) and foreground (false)
- **UserInfo Parsing**: Ensure JSON format is valid when building notifications

## Use Cases

**Foreground Notification:**
- App is open → Notification arrives → Show in-app toast/banner

**Background/Closed Tap:**
- App closed → User taps notification → App launches → Navigate directly to content

## Performance Tip
Keep the HandleNotification state logic simple and fast. Heavy operations should be deferred to avoid blocking the notification callback.
