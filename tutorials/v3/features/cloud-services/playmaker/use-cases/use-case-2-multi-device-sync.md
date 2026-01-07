# Multi-Device Progress Sync

## Goal
Load saved data when app starts and listen for changes from other devices.

## Actions Required
| Action | Purpose |
|--------|---------|
| CloudServicesGetValue | Load saved data |
| CloudServicesOnSavedDataChange | Listen for remote updates |
| CloudServicesGetChangedKeyInfo | Read key name by index (optional) |

## Variables Needed
- playerLevel (Int)
- totalScore (Int)
- changedKeys (Array: String) - PlayMaker Array (set element type to String)
- changeReason (Enum: CloudSavedDataChangeReasonCode)

## Implementation Steps

### 1. State: LoadProgress (On App Start)
**Action:** CloudServicesGetValue
- **Inputs:**
  - key: "player_level"
  - valueType: Int
- **Outputs:**
  - value → playerLevel

Repeat for each key you want to load.

### 2. State: ListenForChanges
**Action:** CloudServicesOnSavedDataChange
- **Outputs:**
  - changedKeys → changedKeys array
  - changeReason → changeReason
- **Events:**
  - dataChangedEvent → HandleRemoteChange

### 3. State: HandleRemoteChange
Loop `keyIndex = 0..changedKeys.Length-1` and for each key:
1. (Optional) `CloudServicesGetChangedKeyInfo(keyIndex)` → `keyName`
2. If you need conflict handling, call `CloudServicesGetCloudAndLocalCacheValues(keyName)` to get both values:
   - decide your policy (cloud wins / local wins / max wins / prompt user)
3. Otherwise, just reload from cloud:
   - If keyName == "player_level" → `CloudServicesGetValue("player_level", valueType:Int)` and update `playerLevel`
   - If keyName == "total_score" → `CloudServicesGetValue("total_score", valueType:Int)` and update `totalScore`

If you don’t want a loop, you can also directly use PlayMaker Array actions (Array Get / Array Contains) on `changedKeys`.

## Conflict Resolution Strategies

**Last Write Wins:** Use remote value always
**Highest Wins:** Compare local vs remote, keep higher value
**Manual Merge:** Prompt user to choose
