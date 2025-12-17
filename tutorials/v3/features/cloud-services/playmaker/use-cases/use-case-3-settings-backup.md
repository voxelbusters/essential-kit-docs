# Cloud Settings Backup

## Goal
Backup and restore player settings (volume, graphics quality, preferences) across devices.

## Actions Required
| Action | Purpose |
|--------|---------|
| CloudServicesSetValue | Save settings |
| CloudServicesGetValue | Load settings |
| CloudServicesHasKey | Check if a key exists (optional, recommended for defaults) |
| CloudServicesRemoveKey | Delete setting |

## Variables Needed
- musicVolume (Float) = 0.8
- graphicsQuality (Int) = 2 (0=Low, 1=Medium, 2=High)
- language (String) = "en"

## Implementation Steps

### 1. State: SaveSettings (When Changed)
**Action:** CloudServicesSetValue
- Save multiple settings:
  - key: "music_volume", value: musicVolume
  - key: "graphics_quality", value: graphicsQuality
  - key: "language", value: language

### 2. State: LoadSettings (On App Start)
Load each setting:
1. (Optional) `CloudServicesHasKey("music_volume")`
2. If exists → `CloudServicesGetValue("music_volume", valueType:Float)` → `musicVolume`
3. If not exists → keep your local default (for example 0.8)

### 3. State: ResetToDefaults (Optional)
**Action:** CloudServicesRemoveKey
- Remove keys to restore defaults:
  - RemoveKey("music_volume")
  - RemoveKey("graphics_quality")

Or use: CloudServicesRemoveAllKeys to clear all cloud data

## Best Practices
- Save settings incrementally (one at a time on change)
- Load all settings once at startup
- Provide "Reset Cloud Data" option in settings
