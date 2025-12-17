# Push Notification Registration

## Goal
Register the device for remote push notifications and obtain the device token to send to your server.

## Actions Required
| Action | Purpose |
|--------|---------|
| NotificationServicesRequestPermission | Request notification permissions |
| NotificationServicesGetRequestPermissionError | Read cached error after permission failure (optional) |
| NotificationServicesOnRegisterForPushNotificationsComplete | Listen for device token |

## Variables Needed
- deviceToken (String)
- errorCode (Int)
- errorDescription (String)
- serverUrl (String) - Your backend URL

## Implementation Steps

### 1. State: RequestPermission
**Action:** NotificationServicesRequestPermission
- **Inputs:**
  - requestAlert: true
  - requestBadge: true
  - requestSound: true
- **Events:**
  - grantedEvent → ListenForToken
  - deniedEvent → ShowError
  - failureEvent → ShowError

**Optional:** On `failureEvent`, call `NotificationServicesGetRequestPermissionError` to read `errorCode` + `errorDescription`.

### 2. State: ListenForToken
**Action:** NotificationServicesOnRegisterForPushNotificationsComplete
- **Outputs:**
  - deviceToken → deviceToken variable
  - errorCode → errorCode
  - errorDescription → errorDescription
- **Events:**
  - successEvent → SendTokenToServer
  - failureEvent → ShowError

**Note:** This is a persistent listener - it waits for the registration callback from the OS.

### 3. State: SendTokenToServer
Send deviceToken to your backend server via HTTP POST:
- Endpoint: serverUrl/register-device
- Payload: {"token": deviceToken, "platform": "iOS/Android"}

**Transition:** Go to Complete

### 4. State: Complete
- Store deviceToken locally for reference
- Display success message
- Ready to receive push notifications from server

## Server Integration Flow
```
Request Permission
    └─ Listen for Token
        └─ Success → Send to Server
            └─ Server uses token for APNs (iOS) or FCM (Android)
```

## Common Issues

- **No Token Received**: Check internet connection, verify platform push setup (APNs/FCM certificates)
- **Token Changes**: Device token can change on app reinstall; always update server with latest token
- **Simulator Limitation**: Push notifications don't work on iOS Simulator; test on real devices
- **Permission Denied**: Cannot register for push without notification permissions

## Server Requirements

**iOS (APNs):**
- Valid APNs certificate or auth key
- Server sends notifications to Apple Push Notification service

**Android (FCM):**
- Firebase Cloud Messaging project setup
- Server API key configured

## Platform Differences

**iOS:**
- Returns 64-character hex string token
- Requires APNs setup in Apple Developer

**Android:**
- Returns FCM registration token
- Requires google-services.json configuration

## Security Note
Treat device tokens as sensitive data. Always transmit via HTTPS to your server and store securely.
