# Change Notifications

Change notifications alert your Unity mobile game when cloud data changes due to synchronization from other devices or external updates.

## What are Change Notifications?

Change notifications are events triggered when cloud data changes outside of your current game session. This happens when the same player modifies data on another device, or when cloud storage resolves conflicts between devices.

## Why Handle Change Notifications?

Change notifications enable:
- Real-time updates when players use multiple devices
- Conflict resolution feedback in your Unity cross-platform game
- Responsive UI updates when data changes
- Preventing stale data in your game interface

## OnSavedDataChange Event

**Monitoring Data Changes:**
```csharp
CloudServices.OnSavedDataChange += (result) =>
{
    Debug.Log($"Data changed. Reason: {result.ChangeReason}");
    Debug.Log($"Changed keys count: {result.ChangedKeys.Length}");
    
    foreach (string key in result.ChangedKeys)
    {
        Debug.Log($"Key changed: {key}");
    }
};
```

## Change Reasons

Essential Kit provides specific reasons for data changes:

- **ServerChange**: Data updated from cloud server
- **InitialSyncChange**: Changes detected during first sync
- **AccountChange**: User account switched
- **QuotaViolation**: Storage quota exceeded (iOS only)

## Handling Individual Key Changes

```csharp
private void HandleSavedDataChange(CloudServicesSavedDataChangeResult result)
{
    foreach (string changedKey in result.ChangedKeys)
    {
        // Handle specific keys your game cares about
        switch (changedKey)
        {
            case "player_level":
                int newLevel = CloudServices.GetInt("player_level");
                Debug.Log($"Player level updated to: {newLevel}");
                break;
                
            case "high_score":
                double newScore = CloudServices.GetDouble("high_score");
                Debug.Log($"High score updated to: {newScore}");
                break;
        }
    }
}
```

## Using CloudServicesUtility for Conflict Resolution

The `CloudServicesUtility` class helps you compare local cache and cloud values when conflicts occur. This is essential for understanding what data changed and why.

### Basic Conflict Resolution

```csharp
private void CompareValues(string key)
{
    string cloudValue, localValue;
    bool success = CloudServicesUtility.TryGetCloudAndLocalCacheValues(
        key, out cloudValue, out localValue, "default");
        
    if (success)
    {
        Debug.Log($"Cloud value: {cloudValue}");
        Debug.Log($"Local value: {localValue}");
        
        if (cloudValue != localValue)
        {
            Debug.Log("Conflict detected - cloud value will be used");
        }
    }
}
```

### Type-Specific Conflict Resolution

```csharp
// Compare different data types
private void ResolvePlayerLevelConflict(string key)
{
    int cloudLevel, localLevel;
    bool success = CloudServicesUtility.TryGetCloudAndLocalCacheValues(
        key, out cloudLevel, out localLevel, 1);
        
    if (success && cloudLevel != localLevel)
    {
        Debug.Log($"Level conflict: Local={localLevel}, Cloud={cloudLevel}");
        // Cloud value is automatically used - inform player
        ShowPlayerLevelUpdate(cloudLevel);
    }
}

// Compare boolean settings
private void ResolveSoundSettingConflict(string key)
{
    bool cloudSetting, localSetting;
    bool success = CloudServicesUtility.TryGetCloudAndLocalCacheValues(
        key, out cloudSetting, out localSetting, false);
        
    if (success && cloudSetting != localSetting)
    {
        Debug.Log($"Sound setting conflict resolved to: {cloudSetting}");
        UpdateSoundSettings(cloudSetting);
    }
}
```

## Complete Change Handler with Conflict Resolution

```csharp
private void OnSavedDataChange(CloudServicesSavedDataChangeResult result)
{
    Debug.Log($"Received {result.ChangedKeys.Length} data changes");
    Debug.Log($"Change reason: {result.ChangeReason}");
    
    foreach (string key in result.ChangedKeys)
    {
        // Handle each key based on expected data type
        switch (key)
        {
            case "player_level":
                ResolvePlayerLevelConflict(key);
                break;
                
            case "sound_enabled":
                ResolveSoundSettingConflict(key);
                break;
                
            default:
                // Generic string handling
                string cloudVal, localVal;
                CloudServicesUtility.TryGetCloudAndLocalCacheValues(
                    key, out cloudVal, out localVal, "");
                Debug.Log($"Key '{key}' - Cloud: {cloudVal}, Local: {localVal}");
                break;
        }
        
        // Update your game UI or state based on the new values
        RefreshGameDataForKey(key);
    }
}
```

## Conflict Resolution Strategy

Essential Kit uses a "cloud wins" strategy for conflict resolution:
- When data differs between local cache and cloud, the cloud value is used
- Local cache is updated with the cloud value automatically
- `OnSavedDataChange` is triggered so you can update your game UI
- Use `CloudServicesUtility` to understand what changed and respond appropriately

Change notifications ensure your Unity iOS and Unity Android games stay responsive to multi-device player behavior.

📌 Video Note: Show Unity demo of data changing on one device and notifications appearing on another.