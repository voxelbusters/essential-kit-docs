# CloudServices Use Cases

Quick-start guides for cloud save/sync using PlayMaker custom actions.

## Available Use Cases

### 1. [Save Player Progress](use-case-1-save-progress.md)
**What it does:** Save level, score, and progress to cloud
**Actions:** 2 (SetValue, Synchronize)
**Best for:** Progress backup, cross-device play

### 2. [Multi-Device Sync](use-case-2-multi-device-sync.md)
**What it does:** Load progress and handle remote updates
**Actions:** 2 (GetValue, OnSavedDataChange)
**Best for:** Cross-device continuity, conflict resolution

### 3. [Settings Cloud Backup](use-case-3-settings-backup.md)
**What it does:** Backup and restore player preferences
**Actions:** 4 (SetValue, HasKey, GetValue, RemoveKey)
**Best for:** Settings sync, user preferences

### 4. [User Account Change Handling](use-case-4-user-account-change.md)
**What it does:** React to cloud user account status changes
**Actions:** 1 (OnUserChange)
**Best for:** Disabling cloud UI when signed out/restricted

### 5. [Reset Cloud Data](use-case-5-reset-cloud-data.md)
**What it does:** Remove specific keys or all keys from cloud
**Actions:** 2 (RemoveKey/RemoveAllKeys, Synchronize)
**Best for:** “Reset cloud save” settings actions

## Quick Action Reference

| Action | Purpose |
|--------|---------|
| CloudServicesSetValue | Save data to cloud |
| CloudServicesGetValue | Load data from cloud |
| CloudServicesHasKey | Check if a key exists in the snapshot |
| CloudServicesSynchronize | Trigger manual sync |
| CloudServicesOnSavedDataChange | Listen for remote updates |
| CloudServicesGetChangedKeyInfo | Read changed key name by index |
| CloudServicesGetCloudAndLocalCacheValues | Read cloud + local cache values for a key (conflict handling) |
| CloudServicesOnUserChange | Listen for user account changes |
| CloudServicesRemoveKey | Delete specific key |
| CloudServicesRemoveAllKeys | Clear all cloud data |

## Related Documentation
- **[README.md](../README.md)** - Actions + key patterns + use-cases
