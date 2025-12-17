# Save Player Progress to Cloud

## Goal
Save player progress (level, score, settings) to iCloud or Google Play Games cloud storage for cross-device sync.

## Actions Required
| Action | Purpose |
|--------|---------|
| CloudServicesSetValue | Save data to cloud |
| CloudServicesSynchronize | Trigger sync with cloud |

## Variables Needed
- currentLevel (Int)
- totalScore (Long)
- playerName (String)

## Implementation Steps

### 1. State: SaveData
**Action:** CloudServicesSetValue (call multiple times for different keys)
- **Save Level:**
  - key: "player_level"
  - value: currentLevel (Int)
- **Save Score:**
  - key: "total_score"
  - value: totalScore (Long)
- **Save Name:**
  - key: "player_name"
  - value: playerName (String)

**Transition:** Go to Synchronize

### 2. State: Synchronize
**Action:** CloudServicesSynchronize
- **Events:**
  - successEvent → ShowSaveSuccess
  - failureEvent → ShowSyncError

## Save Flow
```
SaveData
    ├─ SetValue("player_level", 10)
    ├─ SetValue("total_score", 5000)
    └─ SetValue("player_name", "Player1")
└─ Synchronize
    ├─ successEvent → ShowSaveSuccess
    └─ failureEvent → ShowSyncError
```

## Common Issues

- **Cloud Not Available**: User not signed into iCloud/Google account
- **Sync Delays**: Changes may take seconds to propagate
- **Data Conflicts**: Handle OnSavedDataChange for conflicts
- **Storage Limits**: iCloud limited to ~1MB per key

## Platform Differences

**iOS (iCloud):**
- Requires iCloud capability enabled
- User must be signed into iCloud
- Automatic sync when online

**Android (Google Play Games):**
- Saved Games API
- User must be signed into Google Play
- Manual sync trigger recommended

## Best Practices

1. **Save on Events**: Save after meaningful progress (level complete, achievement)
2. **Don't Over-Sync**: Batch changes, sync once per session or on pause
3. **Handle Conflicts**: Listen to OnSavedDataChange for remote updates
4. **Test Offline**: Verify data queues for sync when back online
