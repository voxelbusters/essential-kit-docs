# Synchronization

Synchronization ensures your local data cache stays in sync with cloud storage, providing consistent player data across devices.

## What is Synchronization?

Synchronization is the process of comparing and merging local cached data with cloud storage. Essential Kit handles most synchronization automatically, but you can also trigger manual syncs when needed for your Unity mobile game.

## Why Use Manual Synchronization?

Manual synchronization is useful for:
- Ensuring latest data before critical game moments
- Refreshing data after the player returns from being offline
- Preparing for important game state changes
- Providing "refresh" functionality in your Unity cross-platform game

## Triggering Synchronization

**Basic Synchronization:**
```csharp
CloudServices.Synchronize();
Debug.Log("Synchronization requested");
```

**Synchronization with Callback:**
```csharp
CloudServices.Synchronize((result) => 
{
    Debug.Log($"Sync completed. Success: {result.Success}");
});
```

## Synchronization Events

Essential Kit provides events to monitor synchronization:

**OnSynchronizeComplete Event:**
```csharp
CloudServices.OnSynchronizeComplete += (result) =>
{
    Debug.Log($"Synchronization finished. Success: {result.Success}");
    
    // Get updated snapshot of all data
    var snapshot = CloudServices.GetSnapshot();
    Debug.Log($"Total keys in snapshot: {snapshot.Count}");
};
```

## Getting Data Snapshots

After synchronization, you can retrieve all stored data:

```csharp
var allData = CloudServices.GetSnapshot();
foreach (var key in allData.Keys)
{
    string keyName = key.ToString();
    object value = allData[keyName];
    Debug.Log($"Key: {keyName}, Value: {value}");
}
```

## How Synchronization Works

When you call `Synchronize()`, Essential Kit:

1. **Compares** local cache with cloud storage
2. **Resolves conflicts** using platform-specific rules
3. **Updates local cache** with merged data
4. **Triggers events** to notify your game of changes
5. **Returns success/failure** status

## Automatic Synchronization

Essential Kit also performs automatic synchronization:
- When the app becomes active
- When network connectivity is restored  
- When cloud user account changes
- At regular intervals during gameplay

This ensures your Unity iOS and Unity Android games stay synchronized without manual intervention.

📌 Video Note: Show Unity demo of manual sync, callback handling, and viewing snapshot data.